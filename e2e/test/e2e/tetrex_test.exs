defmodule E2e.TetrexTest do
  use ExUnit.Case, async: true

  alias E2e.Tetrex

  test "new/0 spawns a playing game with a piece" do
    game = Tetrex.new()
    assert game.status == :playing
    assert game.piece != nil
    assert game.score == 0
    assert game.lines == 0
    assert game.level == 1
  end

  test "level rises every ten lines and speeds up gravity" do
    assert Tetrex.level_for_lines(0) == 1
    assert Tetrex.level_for_lines(10) == 2
    assert Tetrex.tick_ms_for_level(1) > Tetrex.tick_ms_for_level(5)
  end

  test "command left moves piece when possible" do
    game = Tetrex.new()
    x = game.piece.x
    game = Tetrex.command(game, :left)
    assert game.piece.x == x - 1
  end

  test "tick moves piece down" do
    game = Tetrex.new()
    y = game.piece.y
    game = Tetrex.tick(game)
    assert game.piece.y == y + 1
  end

  test "cells_for_render has one entry per board cell" do
    game = Tetrex.new()
    cells = Tetrex.cells_for_render(game)
    assert length(cells) == Tetrex.cols() * Tetrex.rows()
  end

  test "diff_cells returns only changed ids" do
    prev = [
      %{id: "game-0-0", checked: false, theme: nil, col: 0, row: 0},
      %{id: "game-1-0", checked: false, theme: nil, col: 1, row: 0}
    ]

    next = [
      %{id: "game-0-0", checked: true, theme: "accent", col: 0, row: 0},
      %{id: "game-1-0", checked: false, theme: nil, col: 1, row: 0}
    ]

    diff = Tetrex.diff_cells(prev, next)
    assert diff == [%{id: "game-0-0", checked: true, theme: "accent"}]
  end

  test "preview_cells/1 centers piece in 4x4 grid" do
    cells = Tetrex.preview_cells(:t)
    filled = Enum.count(cells, & &1.filled)
    assert filled == 4
    assert Enum.all?(Enum.filter(cells, & &1.filled), &(&1.theme == :alert))
  end

  test "from_client/1 decodes locked board cell themes from client sync" do
    game = Tetrex.new() |> Tetrex.command(:hard_drop)
    client = Tetrex.to_client(game)

    decoded = Tetrex.from_client(client)

    assert [%Tetrex.Cell{theme: _} | _] =
             decoded.board
             |> List.flatten()
             |> Enum.reject(&is_nil/1)
  end

  test "hard drop locks piece and spawns the next one at the top" do
    game = Tetrex.new()

    game = Tetrex.command(game, :hard_drop)

    assert game.status == :playing
    assert game.piece.y == 0
    assert locked_cells?(game.board)
  end

  test "completing a full row clears it, shifts rows down, and increases score" do
    empty = List.duplicate(nil, Tetrex.cols())

    bottom =
      List.duplicate(%Tetrex.Cell{theme: :accent}, 6) ++ List.duplicate(nil, Tetrex.cols() - 6)

    board = List.duplicate(empty, Tetrex.rows() - 1) ++ [bottom]

    game = %Tetrex{
      board: board,
      piece: %Tetrex.Piece{type: :i, rotation: 0, x: 6, y: Tetrex.rows() - 1},
      next_type: :o,
      status: :playing,
      score: 0
    }

    game = Tetrex.tick(game)
    assert Tetrex.clear_locked?(game)
    assert game.pending_clear == [Tetrex.rows() - 1]

    game = Tetrex.commit_clear(game)

    assert game.score == Tetrex.score_for_clears(1, 1)
    assert game.lines == 1
    assert game.level == 1
    [bottom_row | _] = Enum.reverse(game.board)
    assert Enum.all?(bottom_row, &is_nil/1)
    assert game.piece != nil
    assert game.status == :playing
  end

  test "clearing multiple full rows at once" do
    full = List.duplicate(%Tetrex.Cell{theme: :accent}, Tetrex.cols())
    empty = List.duplicate(nil, Tetrex.cols())
    board = [full, full | List.duplicate(empty, Tetrex.rows() - 2)]

    game = %Tetrex{
      board: board,
      piece: %Tetrex.Piece{type: :i, rotation: 0, x: 0, y: 2},
      next_type: :o,
      status: :playing,
      score: 0
    }

    game = Tetrex.command(game, :hard_drop)
    assert Tetrex.clear_locked?(game)
    game = Tetrex.commit_clear(game)

    assert game.score == Tetrex.score_for_clears(2, 1)
    assert game.lines == 2

    assert Enum.all?(Enum.take(game.board, 2), fn row ->
             Enum.all?(row, &is_nil/1)
           end)
  end

  defp locked_cells?(board) do
    Enum.any?(board, fn row -> Enum.any?(row, &(&1 != nil)) end)
  end
end
