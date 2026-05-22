defmodule E2e.Tetrex.SessionStopTest do
  use E2e.DataCase, async: false

  alias E2e.Tetrex
  alias E2e.Tetrex.Registry
  alias E2e.Tetrex.Session
  alias E2e.Tetrex.Store

  setup do
    {:ok, _} = Application.ensure_all_started(:corex_web)

    for %{id: id} <- Registry.list_active() do
      Session.kill(id)
      Registry.unregister(id)
    end

    :ok
  end

  test "stop/1 removes session from registry" do
    id = "stop-test-#{System.unique_integer([:positive])}"
    :ok = Session.ensure_started(id)
    :ok = Registry.track_player(id, self())
    assert Enum.any?(Registry.list_active(), &(&1.id == id))

    :ok = Session.stop(id)

    refute Enum.any?(Registry.list_active(), &(&1.id == id))
  end

  test "stop/1 is idempotent when session already gone" do
    assert Session.stop("missing-id") == :ok
  end

  test "stop/1 abandons game to game_over in store when score qualifies" do
    id = "abandon-#{System.unique_integer([:positive])}"
    :ok = Session.ensure_started(id)
    Ecto.Adapters.SQL.Sandbox.allow(E2e.Repo, self(), Session.whereis(id))

    game = %{Tetrex.new() | score: 9000}
    :ok = Session.sync(id, Tetrex.to_client(game))

    :ok = Session.stop(id)

    record = Store.get(id)
    assert record.status == "game_over"
    refute Enum.any?(Registry.list_active(), &(&1.id == id))
  end
end
