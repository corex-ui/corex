defmodule PalaverDemoTest do
  @moduledoc """
  The reference mind against the provider-shaped server, over real HTTP.

  Palaver's own tests never touch a socket, which is the point of them. This one
  does, because the adapter it covers is the piece anyone copying this code will
  have to get right: server-sent events split across chunks, tool calls arriving
  as deltas, and a loop that ends.
  """

  use ExUnit.Case, async: false

  alias PalaverDemo.FakeProvider
  alias PalaverDemo.Tools

  setup do
    port = free_port()

    {:ok, server} =
      Bandit.start_link(
        plug: {FakeProvider, token_delay: 0},
        scheme: :http,
        port: port,
        startup_log: false
      )

    {:ok, talk} =
      Palaver.open(
        mind: {PalaverDemo.Mind.Http, base_url: "http://localhost:#{port}"},
        plugins: [Tools.Greeting, Tools.WhichNode]
      )

    on_exit(fn ->
      Palaver.close(talk)
      Process.exit(server, :normal)
    end)

    {:ok, _info} = Palaver.subscribe(talk)
    %{talk: talk}
  end

  defp free_port do
    {:ok, socket} = :gen_tcp.listen(0, [:binary, active: false])
    {:ok, port} = :inet.port(socket)
    :gen_tcp.close(socket)
    port
  end

  defp collect(acc \\ []) do
    receive do
      {:palaver, %Palaver.Event{type: type} = event} when type in [:turn_done, :turn_halted] ->
        Enum.reverse([event | acc])

      {:palaver, event} ->
        collect([event | acc])
    after
      15_000 -> flunk("the turn never ended")
    end
  end

  test "a whole turn over HTTP: streamed tokens, a tool call, then an answer", %{talk: talk} do
    :ok = Palaver.prompt(talk, "please use greeting to say hi")
    events = collect()
    types = Enum.map(events, & &1.type)

    assert List.last(types) == :turn_done, "the loop must terminate like a real provider's does"
    assert :tool_call in types
    assert :tool_result in types

    assert Enum.count(types, &(&1 == :token)) > 1,
           "tokens should arrive as deltas, not in one lump"

    result = Enum.find(events, &(&1.type == :tool_result))
    assert {:ok, "hello (v1): please use greeting to say hi"} = result.payload.result

    assert Enum.map(Palaver.history(talk), & &1.role) == [:user, :assistant, :tool, :assistant]
  end

  test "the provider stops asking for tools once it has a result", %{talk: talk} do
    :ok = Palaver.prompt(talk, "please use which_node")
    events = collect()

    assert Enum.count(events, &(&1.type == :tool_call)) == 1
    assert List.last(events).type == :turn_done
  end

  test "a provider that is not there is an error, not a crash" do
    {:ok, talk} =
      Palaver.open(mind: {PalaverDemo.Mind.Http, base_url: "http://localhost:1"})

    on_exit(fn -> Palaver.close(talk) end)
    {:ok, _info} = Palaver.subscribe(talk)

    :ok = Palaver.prompt(talk, "anyone there")
    events = collect()

    assert Enum.any?(events, &(&1.type == :mind_error))
    assert List.last(events).type == :turn_halted
    assert Process.alive?(talk)
  end
end
