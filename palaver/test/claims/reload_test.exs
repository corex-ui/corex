defmodule Palaver.Claims.ReloadTest do
  @moduledoc """
  Claim: a tool can be replaced, and the conversation's own state can be
  migrated, without the talk stopping.

  Two strengths of the same claim. The cheap one is that a tool module can be
  recompiled underneath a live conversation, which works because the session
  holds nothing but the module name. The expensive one is that the shape of the
  session's own state can change while it is running, through the OTP upgrade
  hook, with the history and the listening clients surviving.

  This is in-node reload driven by `:sys`, not an appup release upgrade.

  Not async: redefining a module is global.
  """

  use ExUnit.Case, async: false

  import Palaver.Test.Events

  alias Palaver.Test.Mind.Spy

  @script [
    [{:tool_calls, [%{id: "c1", name: "reloadable", args: %{}}]}],
    [{:token, "ok"}]
  ]

  setup do
    previous = Code.get_compiler_option(:ignore_module_conflict)
    Code.put_compiler_option(:ignore_module_conflict, true)

    on_exit(fn ->
      Code.put_compiler_option(:ignore_module_conflict, previous || false)
      :code.purge(Palaver.Reloadable)
      :code.delete(Palaver.Reloadable)
    end)

    :ok
  end

  defp compile_plugin(version) do
    Code.compile_string("""
    defmodule Palaver.Reloadable do
      @behaviour Palaver.Plugin
      def name, do: "reloadable"
      def schema, do: %{"version" => #{version}}
      def call(_args, _context), do: {:ok, "v#{version}"}
    end
    """)

    :ok
  end

  defp open_talk do
    {:ok, talk} =
      Palaver.open(
        mind: {Spy, owner: self(), script: @script},
        plugins: [Palaver.Reloadable]
      )

    on_exit(fn -> Palaver.close(talk) end)
    talk
  end

  test "a tool is recompiled mid-talk and the next turn uses it" do
    compile_plugin(1)
    talk = open_talk()
    {:ok, _info} = Palaver.subscribe(talk)

    :ok = Palaver.prompt(talk, "first")
    assert_receive {:mind_request, %{tools: [%{name: "reloadable", schema: %{"version" => 1}}]}}
    assert await(:tool_result).payload.result == {:ok, "v1"}
    assert await(:turn_done)

    before = Palaver.info(talk)
    history_before = Palaver.history(talk)

    # Swap the tool underneath the running conversation.
    compile_plugin(2)
    :ok = Palaver.load_plugin(talk, Palaver.Reloadable)
    assert await(:plugin_changed).payload.schema == %{"version" => 2}

    :ok = Palaver.prompt(talk, "second")
    assert_receive {:mind_request, %{tools: [%{name: "reloadable", schema: %{"version" => 2}}]}}
    assert await(:tool_result).payload.result == {:ok, "v2"}
    assert await(:turn_done)

    later = Palaver.info(talk)

    assert later.session_id == before.session_id
    assert Process.alive?(talk)
    assert later.history_length > before.history_length
    assert List.starts_with?(Palaver.history(talk), history_before)
  end

  test "the session's own state is migrated in place, and the talk carries on" do
    compile_plugin(1)
    talk = open_talk()
    {:ok, _info} = Palaver.subscribe(talk)

    :ok = Palaver.prompt(talk, "first")
    assert :turn_done in types(collect_until([:turn_done]))

    history_before = Palaver.history(talk)
    seq_before = Palaver.info(talk).seq
    assert Palaver.info(talk).state_vsn == 2

    # Put the process back into the shape version 1 used: history newest-first,
    # no journal at all.
    :sys.replace_state(talk, fn state ->
      state
      |> Map.put(:state_vsn, 1)
      |> Map.update!(:history, &Enum.reverse/1)
      |> Map.delete(:journal)
      |> Map.delete(:journal_limit)
    end)

    :ok = :sys.suspend(talk)
    :ok = :sys.change_code(talk, Palaver.Session, 1, nil)
    :ok = :sys.resume(talk)

    info = Palaver.info(talk)
    assert info.state_vsn == 2
    assert Palaver.history(talk) == history_before
    assert info.seq == seq_before
    assert Process.alive?(talk)

    # The client that was listening before the upgrade is still listening after.
    assert info.subscribers == 1

    :ok = Palaver.prompt(talk, "second")
    assert await(:turn_started).seq == seq_before + 1
    assert await(:turn_done)
    assert Palaver.info(talk).history_length > info.history_length
  end

  test "migration rebuilds the journal empty, so replay only covers what came after" do
    compile_plugin(1)
    talk = open_talk()
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "first")
    assert :turn_done in types(collect_until([:turn_done]))

    :sys.replace_state(talk, fn state ->
      state
      |> Map.put(:state_vsn, 1)
      |> Map.update!(:history, &Enum.reverse/1)
      |> Map.delete(:journal)
      |> Map.delete(:journal_limit)
    end)

    :ok = :sys.suspend(talk)
    :ok = :sys.change_code(talk, Palaver.Session, 1, nil)
    :ok = :sys.resume(talk)
    :ok = Palaver.unsubscribe(talk)

    {:ok, _info} = Palaver.subscribe(talk, from_seq: 0)
    assert drain() == []
  end
end
