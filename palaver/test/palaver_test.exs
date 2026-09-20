defmodule PalaverTest do
  @moduledoc """
  The ordinary case: a conversation that streams, calls a tool, and answers.

  Everything the four claims assert is a departure from this baseline, so this
  file is what "working" looks like before anything is taken away.
  """

  use ExUnit.Case, async: true

  import Palaver.Test.Events

  alias Palaver.Test.Plugins

  defp open(opts) do
    {:ok, talk} = Palaver.open(opts)
    on_exit(fn -> Palaver.close(talk) end)
    talk
  end

  test "mind, then tool, then mind again, and the history reads like a transcript" do
    script = [
      [{:token, "checking"}, {:tool_calls, [%{id: "c1", name: "fast", args: %{}}]}],
      [{:token, "it said fast"}]
    ]

    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Fast])
    {:ok, info} = Palaver.subscribe(talk)
    assert info.tools == ["fast"]
    assert info.hands == :local

    assert :ok = Palaver.prompt(talk, "go")
    events = collect_until([:turn_done])

    assert types(events) == [
             :turn_started,
             :token,
             :tool_call,
             :tool_result,
             :token,
             :turn_done
           ]

    assert [
             %{role: :user, content: "go"},
             %{role: :assistant, content: "checking", tool_calls: [%{name: "fast"}]},
             %{role: :tool, content: "fast", tool_call_id: "c1"},
             %{role: :assistant, content: "it said fast"}
           ] = Palaver.history(talk)
  end

  test "every event carries a monotonic sequence number" do
    talk = open(mind: {Palaver.Mind.Stub, script: [[{:token, "a"}, {:token, "b"}]]})
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    seqs = collect_until([:turn_done]) |> Enum.map(& &1.seq)
    assert seqs == Enum.sort(seqs)
    assert seqs == Enum.uniq(seqs)
    assert Palaver.info(talk).seq == List.last(seqs)
  end

  test "a second prompt while a turn is in flight is refused, not queued" do
    script = [[{:tool_calls, [%{name: "burn", args: %{"ms" => 200}}]}], [{:token, "done"}]]
    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Burn])
    {:ok, _info} = Palaver.subscribe(talk)

    :ok = Palaver.prompt(talk, "first")
    await(:tool_call)
    assert {:error, :busy} = Palaver.prompt(talk, "second")

    assert await(:turn_done, 3_000)
  end

  test "a tool that raises costs the turn a step, not the conversation" do
    script = [
      [{:tool_calls, [%{id: "c1", name: "boom", args: %{}}]}],
      [{:token, "recovered"}]
    ]

    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Boom])
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    result = await(:tool_result)
    assert {:error, {:exception, "boom"}} = result.payload.result
    assert await(:turn_done)

    assert Process.alive?(talk)
    assert Enum.any?(Palaver.history(talk), &(&1.role == :tool and &1.content =~ "exception"))
  end

  test "a mind that fails halts the turn and says why" do
    talk = open(mind: {Palaver.Mind.Stub, script: [{:error, :provider_down}]})
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    assert await(:mind_error).payload.reason == :provider_down
    assert await(:turn_halted).payload.reason == {:mind_error, :provider_down}
    assert Process.alive?(talk)
  end

  test "a mind that only ever asks for tools is stopped by max_turns" do
    script = [[{:tool_calls, [%{name: "fast", args: %{}}]}]]

    talk =
      open(
        mind: {Palaver.Mind.Stub, script: script, repeat_last: true},
        plugins: [Plugins.Fast],
        max_turns: 3
      )

    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    assert await(:turn_halted, 3_000).payload == %{reason: :max_turns, steps: 3}
  end

  test "an unknown tool is an error result, not a crash" do
    script = [[{:tool_calls, [%{id: "c1", name: "nope", args: %{}}]}], [{:token, "ok"}]]
    talk = open(mind: {Palaver.Mind.Stub, script: script})
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    assert await(:tool_result).payload.result == {:error, {:unknown_tool, "nope"}}
    assert await(:turn_done)
  end

  test "a conversation can be found by its session id" do
    talk = open(session_id: "fixed-id-#{System.unique_integer([:positive])}")
    id = Palaver.info(talk).session_id

    assert Palaver.whereis(id) == talk
    assert Palaver.info(id).session_id == id
  end
end
