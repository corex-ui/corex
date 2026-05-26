defmodule E2e.Tetrex.SessionTest do
  use E2e.DataCase, async: false

  alias E2e.Tetrex
  alias E2e.Tetrex.Session
  alias E2e.Tetrex.Store

  setup do
    id = "sess-#{System.unique_integer([:positive])}"
    :ok = Session.ensure_started(id)
    on_exit(fn -> stop_session(id) end)
    %{id: id}
  end

  test "sync updates game state", %{id: id} do
    {:ok, %{game: before}} = Session.get_state(id)
    moved = Tetrex.command(before, :left)
    :ok = Session.sync(id, Tetrex.to_client(moved))
    {:ok, %{game: after_game}} = Session.get_state(id)
    assert after_game != before
  end

  test "game over finalizes with frames for top score", %{id: id} do
    for i <- 1..10 do
      client = Tetrex.to_client(%{Tetrex.new() | score: 1000 + i, status: :game_over})
      Store.finalize("bench-#{i}", 1000 + i, [client], client)
    end

    {:ok, %{game: game}} = Session.get_state(id)

    over = %{game | status: :game_over, score: 50_000}
    assert Session.sync(id, Tetrex.to_client(over)) == :saved
    Process.sleep(50)

    record = Store.get(id)
    assert record
    assert record.score == 50_000
    assert length(record.frames) >= 2
  end

  defp stop_session(id) do
    case Session.whereis(id) do
      nil -> :ok
      pid -> GenServer.stop(pid, :normal, :infinity)
    end
  catch
    :exit, _ -> :ok
  end
end
