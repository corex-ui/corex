defmodule E2e.TetrexReplaySeedTest do
  use ExUnit.Case, async: true

  alias E2e.Tetrex
  alias E2e.Tetrex.ReplaySeed

  test "build returns many frames and reaches target score" do
    %{frames: frames, client: client, score: score} = ReplaySeed.build(12_000, 3)

    assert score >= 12_000
    assert length(frames) >= 20
    assert client["status"] == "game_over"
    assert is_list(client["board"])

    for frame <- frames do
      game = Tetrex.from_client(frame)
      assert Tetrex.cols() * Tetrex.rows() == length(Tetrex.cells_for_render(game))
    end
  end

  test "final frame matches client state" do
    %{frames: frames, client: client} = ReplaySeed.build(5_000, 1)
    assert List.last(frames) == client
  end
end
