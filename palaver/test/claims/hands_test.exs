defmodule Palaver.Claims.HandsTest do
  @moduledoc """
  Claim: the conversation and the work can live on different machines, and
  losing the machine does not lose the conversation.

  The weak version of this claim is "the session process is still alive", which
  is true of any `GenServer` that runs work somewhere else. The claim worth
  making is that the conversation keeps talking: a machine disappearing mid-turn
  becomes an error result and an event, the turn still reaches an end, and a
  replacement machine picks up the next tool call.

  Tests tagged `:distributed` need working Erlang distribution. When it cannot
  start, `test_helper.exs` excludes them and says so loudly rather than
  pretending this claim was checked.
  """

  use ExUnit.Case, async: false

  import Palaver.Test.Events

  alias Palaver.Test.Cluster
  alias Palaver.Test.Mind.Scripted
  alias Palaver.Test.Plugins

  setup context do
    if context[:distributed] do
      {:ok, peer, peer_node} = Cluster.start_peer(Cluster.unique_name("hands"))
      on_exit(fn -> Cluster.stop_peer(peer) end)
      %{peer: peer, peer_node: peer_node}
    else
      :ok
    end
  end

  defp open(opts) do
    {:ok, talk} = Palaver.open(opts)
    on_exit(fn -> Palaver.close(talk) end)
    talk
  end

  defp which_node_script do
    [
      [{:tool_calls, [%{id: "c1", name: "which_node", args: %{}}]}],
      [{:token, "that is where it ran"}]
    ]
  end

  test "local hands run the tool on the node holding the conversation" do
    talk =
      open(
        mind: {Palaver.Mind.Stub, script: which_node_script()},
        plugins: [Plugins.WhichNode]
      )

    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "where are you")

    assert await(:tool_result).payload.result == {:ok, to_string(node())}
  end

  test "hands can be changed while the conversation is open" do
    talk = open(mind: {Palaver.Mind.Stub, script: [[{:token, "hi"}]]})
    {:ok, _info} = Palaver.subscribe(talk)

    assert :ok = Palaver.set_hands(talk, {:node, :"nowhere@127.0.0.1"})
    event = await(:hands_changed)
    assert event.payload == %{status: :up, hands: {:node, :"nowhere@127.0.0.1"}, reason: nil}
    assert Palaver.info(talk).hands == {:node, :"nowhere@127.0.0.1"}

    assert {:error, {:invalid_hands, :elsewhere}} = Palaver.set_hands(talk, :elsewhere)
  end

  test "a tool call to a node that was never there is an error, not a crash" do
    talk =
      open(
        mind: {Palaver.Mind.Stub, script: which_node_script()},
        plugins: [Plugins.WhichNode],
        hands: {:node, :"missing@127.0.0.1"},
        tool_timeout: 2_000
      )

    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "where are you")

    assert {:error, {:hands_unreachable, :noconnection}} = await(:tool_result).payload.result
    assert await(:turn_done)
    assert Process.alive?(talk)
  end

  @tag :distributed
  test "the tool runs on the other machine, and the conversation stays here", %{
    peer_node: peer_node
  } do
    talk =
      open(
        mind: {Palaver.Mind.Stub, script: which_node_script()},
        plugins: [Plugins.WhichNode],
        hands: {:node, peer_node}
      )

    {:ok, _info} = Palaver.subscribe(talk)
    :ok = Palaver.prompt(talk, "where are you")

    result = await(:tool_result, 5_000)
    assert result.payload.result == {:ok, to_string(peer_node)}
    refute result.payload.result == {:ok, to_string(node())}
    assert await(:turn_done, 5_000)

    # The history is here, on the node that never ran the tool.
    assert node(talk) == node()
    assert Enum.any?(Palaver.history(talk), &(&1.content == to_string(peer_node)))
  end

  @tag :distributed
  test "killing the machine mid-turn does not kill the talk, and a replacement takes over",
       %{peer: peer, peer_node: peer_node} do
    routes = [
      {"slow",
       [
         [{:tool_calls, [%{id: "c1", name: "burn", args: %{"ms" => 4_000}}]}],
         [{:token, "carrying on"}]
       ]},
      {"where", which_node_script()}
    ]

    talk =
      open(
        mind: {Scripted, routes: routes},
        plugins: [Plugins.Burn, Plugins.WhichNode],
        hands: {:node, peer_node},
        tool_timeout: 30_000
      )

    {:ok, _info} = Palaver.subscribe(talk)
    history_before = Palaver.history(talk)
    session_id = Palaver.info(talk).session_id

    :ok = Palaver.prompt(talk, "do the slow thing")
    assert await(:tool_call, 5_000).payload.hands == {:node, peer_node}

    # Take the machine away while it is working.
    Cluster.stop_peer(peer)

    events = collect_until([:turn_done, :turn_halted], 15_000)

    failure = Enum.find(events, &(&1.type == :tool_result))
    assert {:error, {:hands_unreachable, _reason}} = failure.payload.result

    went_down = Enum.find(events, &(&1.type == :hands_changed))
    assert went_down.payload == %{status: :down, hands: {:node, peer_node}, reason: :nodedown}

    # The turn ended, the conversation did not.
    assert List.last(events).type == :turn_done
    assert Process.alive?(talk)
    assert Palaver.info(talk).session_id == session_id
    assert List.starts_with?(Palaver.history(talk), history_before)

    # Give it new hands and keep talking.
    {:ok, replacement, replacement_node} = Cluster.start_peer(Cluster.unique_name("hands_again"))
    on_exit(fn -> Cluster.stop_peer(replacement) end)

    :ok = Palaver.set_hands(talk, {:node, replacement_node})
    assert await(:hands_changed).payload.status == :up

    :ok = Palaver.prompt(talk, "where are you now")
    result = await(:tool_result, 10_000)

    assert result.payload.result == {:ok, to_string(replacement_node)}
    refute result.payload.result == {:ok, to_string(peer_node)}
    assert Palaver.info(talk).session_id == session_id
  end
end
