defmodule Palaver.Claims.ConcurrencyTest do
  @moduledoc """
  Claim: the conversation keeps talking while the work happens.

  This is the half of the client-server argument that usually goes unmentioned.
  Streaming from a provider is IO-bound, running a tool is often CPU-bound, and
  a conversation has to do both at once without one starving the other or
  blocking the process that answers its clients.

  The tool here burns real CPU rather than sleeping, because a sleeping process
  proves nothing about scheduling.
  """

  use ExUnit.Case, async: true

  import Palaver.Test.Events

  alias Palaver.Test.Plugins

  defp open(opts) do
    {:ok, talk} = Palaver.open(opts)
    on_exit(fn -> Palaver.close(talk) end)
    talk
  end

  defp elapsed_ms(fun) do
    started = System.monotonic_time(:millisecond)
    result = fun.()
    {System.monotonic_time(:millisecond) - started, result}
  end

  test "two tools asked for at once burn at once, not one after the other" do
    script = [
      [
        {:tool_calls,
         [
           %{id: "a", name: "burn", args: %{"ms" => 300}},
           %{id: "b", name: "burn", args: %{"ms" => 300}}
         ]}
      ],
      [{:token, "both done"}]
    ]

    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Burn])
    {:ok, _info} = Palaver.subscribe(talk)

    {elapsed, events} =
      elapsed_ms(fn ->
        :ok = Palaver.prompt(talk, "go")
        collect_until([:turn_done], 10_000)
      end)

    results = Enum.filter(events, &(&1.type == :tool_result))
    assert length(results) == 2
    assert Enum.all?(results, &match?({:ok, "burned 300ms"}, &1.payload.result))

    # Sequentially this would be at least 600ms.
    assert elapsed < 500, "two 300ms tools took #{elapsed}ms, which looks sequential"
  end

  test "the quick tool answers first even though the slow one was asked for first" do
    script = [
      [
        {:tool_calls,
         [
           %{id: "slow", name: "burn", args: %{"ms" => 300}},
           %{id: "quick", name: "fast", args: %{}}
         ]}
      ],
      [{:token, "done"}]
    ]

    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Burn, Plugins.Fast])
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    events = collect_until([:turn_done], 10_000)
    order = events |> Enum.filter(&(&1.type == :tool_result)) |> Enum.map(& &1.payload.id)

    assert order == ["quick", "slow"]

    # The transcript still reads in the order the mind asked, whatever order the
    # answers arrived in.
    assert Enum.map(Palaver.history(talk), & &1.tool_call_id) == [
             nil,
             nil,
             "slow",
             "quick",
             nil
           ]
  end

  test "tokens keep arriving while a tool burns CPU" do
    script = [
      [
        {:token, "working"},
        {:tool_calls, [%{id: "slow", name: "burn", args: %{"ms" => 400}}]},
        {:token, " on"},
        {:token, " it"}
      ],
      [{:token, "finished"}]
    ]

    talk =
      open(mind: {Palaver.Mind.Stub, script: script, delay: 5}, plugins: [Plugins.Burn])

    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")

    events = collect_until([:turn_done], 10_000)
    types = types(events)

    tool_call_at = Enum.find_index(types, &(&1 == :tool_call))
    tool_result_at = Enum.find_index(types, &(&1 == :tool_result))
    tokens_between = Enum.slice(types, (tool_call_at + 1)..(tool_result_at - 1))

    assert tokens_between == [:token, :token],
           "expected tokens to stream while the tool was still burning, got #{inspect(types)}"

    streamed = Enum.filter(events, &(&1.type == :token))
    result = Enum.find(events, &(&1.type == :tool_result))
    assert Enum.any?(streamed, &(&1.at < result.at))
  end

  test "the conversation answers its clients while a turn is in flight" do
    script = [
      [{:tool_calls, [%{id: "slow", name: "burn", args: %{"ms" => 500}}]}],
      [{:token, "done"}]
    ]

    talk = open(mind: {Palaver.Mind.Stub, script: script}, plugins: [Plugins.Burn])
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")
    await(:tool_call)

    {elapsed, info} = elapsed_ms(fn -> Palaver.info(talk) end)

    assert info.turn == %{step: 1, pending: 1}
    assert elapsed < 100, "info/1 took #{elapsed}ms while a tool was burning"

    assert Palaver.history(talk) != []
    assert await(:turn_done, 10_000)
  end
end
