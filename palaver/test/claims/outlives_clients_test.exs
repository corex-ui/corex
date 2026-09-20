defmodule Palaver.Claims.OutlivesClientsTest do
  @moduledoc """
  Claim: the talk outlives its clients.

  The weak version of this claim is "two subscribers receive the same events",
  which is a property of any pub-sub library and proves nothing about a
  conversation. The claim worth making is that the conversation is not a view
  onto a client: every client can walk out mid-turn, the turn carries on in an
  empty room, and a new client can join later and find out everything it missed.
  """

  use ExUnit.Case, async: true

  import Palaver.Test.Events

  alias Palaver.Test.Client
  alias Palaver.Test.Plugins
  alias Palaver.Test.Wait

  @script [
    [
      {:token, "looking"},
      {:tool_calls, [%{id: "c1", name: "burn", args: %{"ms" => 150}}]},
      {:token, " it"},
      {:token, " up"}
    ],
    [{:token, "found it"}]
  ]

  defp open(opts \\ []) do
    defaults = [
      mind: {Palaver.Mind.Stub, script: @script, delay: 10},
      plugins: [Plugins.Burn]
    ]

    {:ok, talk} = Palaver.open(Keyword.merge(defaults, opts))
    on_exit(fn -> Palaver.close(talk) end)
    talk
  end

  defp collect_client(label, acc \\ []) do
    receive do
      {:client, ^label, %Palaver.Event{type: :turn_done} = event} ->
        Enum.reverse([event | acc])

      {:client, ^label, %Palaver.Event{} = event} ->
        collect_client(label, [event | acc])
    after
      5_000 -> flunk("client #{inspect(label)} never saw the turn finish")
    end
  end

  test "two seats, one talk: both clients see the same events in the same order" do
    talk = open()

    Client.start(talk, self(), :left)
    Client.start(talk, self(), :right)
    assert_receive {:subscribed, :left, _info}
    assert_receive {:subscribed, :right, _info}

    :ok = Palaver.prompt(talk, "go")

    left = collect_client(:left)
    right = collect_client(:right)

    assert Enum.map(left, & &1.seq) == Enum.map(right, & &1.seq)
    assert types(left) == types(right)
    assert :turn_done in types(left)
  end

  test "the turn keeps going in an empty room, and a late client is told everything" do
    talk = open()

    left = Client.start(talk, self(), :left)
    right = Client.start(talk, self(), :right)
    assert_receive {:subscribed, :left, _info}
    assert_receive {:subscribed, :right, _info}
    assert Palaver.info(talk).subscribers == 2

    :ok = Palaver.prompt(talk, "go")

    # Leave mid-turn, while a tool is still running.
    assert_receive {:client, :left, %Palaver.Event{type: :tool_call}}, 2_000
    seq_at_departure = Palaver.info(talk).seq
    Process.exit(left, :kill)
    Process.exit(right, :kill)

    Wait.until(fn -> Palaver.info(talk).subscribers == 0 end)
    assert Palaver.info(talk).turn, "the turn should still be in flight with nobody listening"

    # Nobody is in the room. The talk finishes anyway.
    Wait.until(fn -> Palaver.info(talk).turn == nil end)
    info = Palaver.info(talk)
    assert info.seq > seq_at_departure
    assert info.subscribers == 0

    # Come back and ask what happened.
    {:ok, rejoined} = Palaver.subscribe(talk, from_seq: 0)
    assert rejoined.seq == info.seq
    assert rejoined.history_length == info.history_length
    replayed = drain()

    assert types(replayed) == [
             :turn_started,
             :token,
             :tool_call,
             :token,
             :token,
             :tool_result,
             :token,
             :turn_done
           ]

    assert Enum.map(replayed, & &1.seq) == Enum.to_list(1..info.seq)

    # Including the part that happened while the room was empty.
    assert Enum.any?(replayed, &(&1.seq > seq_at_departure and &1.type == :tool_result))
  end

  test "a late client can ask for only what it missed" do
    talk = open()
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")
    first = await(:turn_started)
    _rest = collect_until([:turn_done])
    :ok = Palaver.unsubscribe(talk)

    {:ok, info} = Palaver.subscribe(talk, from_seq: first.seq)
    caught_up = drain()

    assert Enum.map(caught_up, & &1.seq) == Enum.to_list((first.seq + 1)..info.seq)
    refute :turn_started in types(caught_up)
  end

  test "the journal is bounded, so a long talk cannot grow without limit" do
    talk = open(journal_limit: 3)
    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "go")
    _events = collect_until([:turn_done])
    :ok = Palaver.unsubscribe(talk)

    {:ok, info} = Palaver.subscribe(talk, from_seq: 0)
    replayed = drain()

    assert length(replayed) == 3
    assert Enum.map(replayed, & &1.seq) == Enum.to_list((info.seq - 2)..info.seq)
  end
end
