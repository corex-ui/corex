defmodule E2e.Tetrex.StoreTest do
  use E2e.DataCase, async: true

  alias E2e.Tetrex
  alias E2e.Tetrex.Store

  defp finalize_game(id, score, extra_frames \\ []) do
    client = Tetrex.to_client(%{Tetrex.new() | score: score, status: :game_over})
    frames = extra_frames ++ [client]
    Store.finalize(id, score, frames, client)
  end

  test "get_first_frame and get_frames load replay data selectively" do
    first = Tetrex.to_client(Tetrex.new())
    last = Tetrex.to_client(%{Tetrex.new() | score: 12_000, status: :game_over})
    frames = List.duplicate(first, 50) ++ [last]

    assert Store.finalize("replay1", 12_000, frames, last) == :saved

    assert Store.get_first_frame("replay1") == first
    assert length(Store.get_frames("replay1")) == 51
    assert Store.get_client_state("replay1") == last
    assert Store.get_player_name("replay1") != nil
  end

  test "list_top does not load frames or client_state" do
    client = Tetrex.to_client(%{Tetrex.new() | score: 99_000, status: :game_over})
    huge_frames = List.duplicate(client, 1200)

    assert Store.finalize("huge", 99_000, huge_frames, client) == :saved

    full = Store.get("huge")
    [entry] = Store.list_top(1)

    assert entry.id == "huge"
    assert entry.frames == []
    assert is_nil(entry.client_state)
    assert length(full.frames) == 1200
    assert is_map(full.client_state)
  end

  test "finalize keeps only top 10 scores" do
    for i <- 1..12 do
      finalize_game("game-#{i}", i * 100)
    end

    top = Store.list_top(10)
    assert length(top) == 10
    assert Enum.all?(top, &(&1.score >= 300))
    refute Enum.any?(top, &(&1.id == "game-1"))
    refute Enum.any?(top, &(&1.id == "game-2"))
  end

  test "on_leaderboard? reflects current top 10" do
    for i <- 1..10, do: finalize_game("top-#{i}", 5000 + i)

    assert Store.on_leaderboard?("top-1")
    refute Store.on_leaderboard?("missing")
    refute Store.on_leaderboard?("low")
  end

  test "finalize skips scores below leaderboard cutoff" do
    for i <- 1..10 do
      finalize_game("top-#{i}", 5000 + i)
    end

    assert Store.finalize(
             "low",
             100,
             [Tetrex.to_client(Tetrex.new())],
             Tetrex.to_client(Tetrex.new())
           ) ==
             :skipped

    assert Store.get("low") == nil
  end

  test "finalize stores frames" do
    first = Tetrex.to_client(Tetrex.new())
    last = Tetrex.to_client(%{Tetrex.new() | score: 12_000, status: :game_over})

    assert Store.finalize("abc123", 12_000, [first, last], last) == :saved

    record = Store.get("abc123")
    assert record.score == 12_000
    assert record.status == "game_over"
    assert length(record.frames) == 2
    assert record.client_state["score"] == 12_000
  end

  test "finalize assigns player_name" do
    client = Tetrex.to_client(%{Tetrex.new() | score: 9000, status: :game_over})
    assert Store.finalize("named", 9000, [client], client) == :saved
    assert Store.get("named").player_name != nil
  end

  test "finalize preserves player_name on replace" do
    client = Tetrex.to_client(%{Tetrex.new() | score: 9000, status: :game_over})
    Store.finalize("keep", 9000, [client], client)
    Store.update_player_name("keep", "Custom")
    Store.finalize("keep", 9500, [client], client)
    assert Store.get("keep").player_name == "Custom"
  end

  test "finalize uses pending player name" do
    E2e.Tetrex.OwnershipStore.set_pending_name("pending1", "CustomName")
    client = Tetrex.to_client(%{Tetrex.new() | score: 9000, status: :game_over})
    assert Store.finalize("pending1", 9000, [client], client) == :saved
    assert Store.get("pending1").player_name == "CustomName"
  end

  test "update_player_name persists" do
    client = Tetrex.to_client(%{Tetrex.new() | score: 9000, status: :game_over})
    Store.finalize("edit", 9000, [client], client)
    assert Store.update_player_name("edit", "  Pixel  ") == :ok
    assert Store.get("edit").player_name == "Pixel"
  end
end
