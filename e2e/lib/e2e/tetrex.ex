defmodule E2e.Tetrex do
  @moduledoc false

  @cols 10
  @rows 18
  @piece_types [:i, :o, :t, :l]

  defmodule Cell do
    @moduledoc false
    defstruct [:theme]
  end

  defmodule Piece do
    @moduledoc false
    defstruct [:type, :rotation, :x, :y]
  end

  @max_level 29
  @base_tick_ms 700
  @min_tick_ms 90
  @line_score %{1 => 40, 2 => 100, 3 => 300, 4 => 1200}

  defstruct board: nil,
            piece: nil,
            next_type: nil,
            status: :playing,
            score: 0,
            lines: 0,
            level: 1,
            pending_clear: nil

  def cols, do: @cols
  def rows, do: @rows

  def abandon(%__MODULE__{} = game) do
    %{game | piece: nil, status: :game_over}
  end

  def empty_board_state do
    %__MODULE__{
      board: empty_board(),
      piece: nil,
      next_type: nil,
      status: :playing,
      score: 0,
      lines: 0,
      level: 1,
      pending_clear: nil
    }
  end

  def new do
    board = empty_board()
    next = random_type()

    %__MODULE__{
      board: board,
      next_type: random_type(),
      status: :playing,
      score: 0,
      lines: 0,
      level: 1,
      pending_clear: nil
    }
    |> spawn_piece(next)
  end

  def level_for_lines(lines) when is_integer(lines) do
    min(@max_level, div(lines, 10) + 1)
  end

  def tick_ms_for_level(level) when is_integer(level) do
    lv = max(1, level)

    max(
      @min_tick_ms,
      round(@base_tick_ms * :math.pow(0.88, lv - 1))
    )
  end

  def score_for_clears(count, level) when is_integer(count) and is_integer(level) do
    base = Map.get(@line_score, count, count * 40)
    base * max(1, level)
  end

  def clear_locked?(%__MODULE__{pending_clear: rows}) when is_list(rows) and rows != [],
    do: true

  def clear_locked?(_), do: false

  def playing?(%__MODULE__{status: :playing}), do: true
  def playing?(_), do: false

  def command(%__MODULE__{pending_clear: rows} = game, _)
      when is_list(rows) and rows != [],
      do: game

  def command(game, cmd) when game.status == :playing do
    case cmd do
      :left -> move(game, -1, 0)
      :right -> move(game, 1, 0)
      :down -> soft_drop(game)
      :rotate -> rotate(game)
      :hard_drop -> hard_drop(game)
      _ -> game
    end
  end

  def command(game, _), do: game

  def tick(%__MODULE__{pending_clear: rows} = game) when is_list(rows) and rows != [], do: game

  def tick(%__MODULE__{status: :playing} = game) do
    case try_move(game, 0, 1) do
      {:ok, g} -> g
      :blocked -> lock_piece(game)
    end
  end

  def tick(game), do: game

  def cells_for_render(%__MODULE__{} = game) do
    merged = merged_board(game)
    clearing_rows = MapSet.new(List.wrap(game.pending_clear))

    for row <- 0..(@rows - 1),
        col <- 0..(@cols - 1) do
      cell = at(merged, col, row)
      checked = cell != nil
      theme = if cell, do: theme_name(cell.theme), else: nil
      id = cell_id(col, row)

      %{
        id: id,
        col: col,
        row: row,
        checked: checked,
        theme: theme,
        clearing: MapSet.member?(clearing_rows, row)
      }
    end
  end

  def commit_clear(%__MODULE__{} = game) do
    if clear_locked?(game) do
      {board, cleared} = clear_lines_for_rows(game.board, game.pending_clear)
      lines = game.lines + cleared
      level = level_for_lines(lines)
      score = game.score + score_for_clears(cleared, level)

      %{game | board: board, pending_clear: nil, lines: lines, level: level, score: score}
      |> spawn_piece(game.next_type)
    else
      game
    end
  end

  def cell_id(col, row), do: "game-#{col}-#{row}"

  def diff_cells(prev_cells, next_cells) when is_list(prev_cells) and is_list(next_cells) do
    prev = Map.new(prev_cells, &{&1.id, &1})
    next = Map.new(next_cells, &{&1.id, &1})

    ids = (Map.keys(prev) ++ Map.keys(next)) |> Enum.uniq()

    Enum.flat_map(ids, fn id ->
      a = Map.get(prev, id)
      b = Map.get(next, id)

      cond do
        a == b -> []
        is_nil(b) -> []
        true -> [%{id: id, checked: b.checked, theme: b.theme}]
      end
    end)
  end

  def theme_for_type(:i), do: :accent
  def theme_for_type(:o), do: :brand
  def theme_for_type(:t), do: :alert
  def theme_for_type(:l), do: :success
  def theme_for_type("i"), do: :accent
  def theme_for_type("o"), do: :brand
  def theme_for_type("t"), do: :alert
  def theme_for_type("l"), do: :success

  def theme_name(nil), do: nil

  def theme_name(theme) when is_atom(theme) do
    theme |> Atom.to_string() |> strip_ink_prefix()
  end

  def theme_name(theme) when is_binary(theme), do: strip_ink_prefix(theme)

  defp strip_ink_prefix("ink_" <> name), do: String.replace(name, "_", "-")
  defp strip_ink_prefix("ink-" <> name), do: name
  defp strip_ink_prefix(name), do: String.replace(name, "_", "-")

  @preview_cols 4
  @preview_rows 4

  def piece_label(nil), do: "—"
  def piece_label(:i), do: "I"
  def piece_label(:o), do: "O"
  def piece_label(:t), do: "T"
  def piece_label(:l), do: "L"
  def piece_label(type) when is_binary(type), do: piece_label(type_to_atom(type))

  def preview_cells(nil) do
    for row <- 0..(@preview_rows - 1), col <- 0..(@preview_cols - 1) do
      %{col: col, row: row, filled: false, theme: nil}
    end
  end

  def preview_cells(type) do
    type = normalize_piece_type(type)
    coords = shape(type, 0) |> MapSet.new()

    min_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.min()
    max_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.max()
    min_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.max()

    w = max_x - min_x + 1
    h = max_y - min_y + 1
    pad_x = div(@preview_cols - w, 2) - min_x
    pad_y = div(@preview_rows - h, 2) - min_y
    theme = theme_for_type(type)

    for row <- 0..(@preview_rows - 1), col <- 0..(@preview_cols - 1) do
      filled = MapSet.member?(coords, {col - pad_x, row - pad_y})

      %{col: col, row: row, filled: filled, theme: if(filled, do: theme, else: nil)}
    end
  end

  def normalize_piece_type(nil), do: nil
  def normalize_piece_type(type) when is_atom(type), do: type
  def normalize_piece_type(type) when is_binary(type), do: type_to_atom(type)

  def to_client(%__MODULE__{} = game) do
    %{
      "board" => encode_board(game.board),
      "piece" => encode_piece(game.piece),
      "next_type" => encode_type(game.next_type),
      "status" => Atom.to_string(game.status),
      "score" => game.score,
      "lines" => game.lines,
      "level" => game.level,
      "pending_clear" => game.pending_clear
    }
  end

  def from_client(%{} = data) do
    lines = data["lines"] || 0

    %__MODULE__{
      board: decode_board(data["board"]),
      piece: decode_piece(data["piece"]),
      next_type: decode_type(data["next_type"]),
      status: decode_status(data["status"]),
      score: data["score"] || 0,
      lines: lines,
      level: data["level"] || level_for_lines(lines),
      pending_clear: decode_pending_clear(data["pending_clear"])
    }
  end

  defp decode_pending_clear(nil), do: nil
  defp decode_pending_clear(rows) when is_list(rows), do: rows
  defp decode_pending_clear(_), do: nil

  defp encode_board(board) do
    Enum.map(board, fn row ->
      Enum.map(row, fn
        nil -> nil
        %Cell{theme: theme} -> %{"theme" => Atom.to_string(theme)}
      end)
    end)
  end

  defp decode_board(rows) when is_list(rows) do
    Enum.map(rows, fn row ->
      Enum.map(row, fn
        nil -> nil
        %{"theme" => theme} -> %Cell{theme: decode_theme(theme)}
      end)
    end)
  end

  defp decode_theme(theme) when is_atom(theme), do: decode_theme(Atom.to_string(theme))

  defp decode_theme("ink-accent"), do: :accent
  defp decode_theme("ink_accent"), do: :accent
  defp decode_theme("ink-brand"), do: :brand
  defp decode_theme("ink_brand"), do: :brand
  defp decode_theme("ink-alert"), do: :alert
  defp decode_theme("ink_alert"), do: :alert
  defp decode_theme("ink-success"), do: :success
  defp decode_theme("ink_success"), do: :success
  defp decode_theme("accent"), do: :accent
  defp decode_theme("brand"), do: :brand
  defp decode_theme("alert"), do: :alert
  defp decode_theme("success"), do: :success
  defp decode_theme(_), do: :accent

  defp encode_piece(nil), do: nil

  defp encode_piece(%Piece{type: type, rotation: rot, x: x, y: y}) do
    %{"type" => Atom.to_string(type), "rotation" => rot, "x" => x, "y" => y}
  end

  defp decode_piece(nil), do: nil

  defp decode_piece(%{"type" => type, "rotation" => rot, "x" => x, "y" => y}) do
    %Piece{type: decode_type(type), rotation: rot, x: x, y: y}
  end

  defp encode_type(nil), do: nil
  defp encode_type(type), do: Atom.to_string(type)

  defp decode_type(nil), do: nil
  defp decode_type(type) when is_binary(type), do: type_to_atom(type)
  defp decode_type(type) when is_atom(type), do: type

  defp type_to_atom("i"), do: :i
  defp type_to_atom("o"), do: :o
  defp type_to_atom("t"), do: :t
  defp type_to_atom("l"), do: :l
  defp type_to_atom(_), do: :i

  defp decode_status("playing"), do: :playing
  defp decode_status("game_over"), do: :game_over
  defp decode_status(status) when is_atom(status), do: status
  defp decode_status(_), do: :playing

  defp empty_board do
    List.duplicate(List.duplicate(nil, @cols), @rows)
  end

  defp spawn_piece(%__MODULE__{board: board} = game, type) do
    piece = %Piece{type: type, rotation: 0, x: 3, y: 0}

    if valid?(board, piece) do
      %{game | piece: piece, next_type: random_type()}
    else
      %{game | piece: nil, status: :game_over}
    end
  end

  defp move(game, dx, dy) do
    case try_move(game, dx, dy) do
      {:ok, g} -> g
      :blocked -> game
    end
  end

  defp soft_drop(game) do
    case try_move(game, 0, 1) do
      {:ok, g} -> g
      :blocked -> lock_piece(game)
    end
  end

  defp hard_drop(%__MODULE__{status: :playing, piece: %Piece{}} = game) do
    drop_until_blocked(game)
  end

  defp hard_drop(game), do: game

  defp drop_until_blocked(game) do
    case try_move(game, 0, 1) do
      {:ok, g} -> drop_until_blocked(g)
      :blocked -> lock_piece(game)
    end
  end

  defp rotate(game) do
    next_rot = rem(game.piece.rotation + 1, 4)

    kicks = [{0, 0}, {-1, 0}, {1, 0}, {-2, 0}, {2, 0}, {0, -1}, {0, 1}]

    Enum.find_value(kicks, game, fn {dx, dy} ->
      candidate = %{
        game
        | piece: %{
            game.piece
            | rotation: next_rot,
              x: game.piece.x + dx,
              y: game.piece.y + dy
          }
      }

      if valid?(candidate.board, candidate.piece), do: candidate
    end)
  end

  defp try_move(%__MODULE__{board: board, piece: piece} = game, dx, dy)
       when not is_nil(piece) do
    moved = %{piece | x: piece.x + dx, y: piece.y + dy}

    if valid?(board, moved) do
      {:ok, %{game | piece: moved}}
    else
      :blocked
    end
  end

  defp try_move(game, _, _), do: {:ok, game}

  defp lock_piece(%__MODULE__{board: board, piece: piece} = game) when not is_nil(piece) do
    board = merge_piece(board, piece)
    full_rows = find_full_rows(board)

    if full_rows != [] do
      %{game | board: board, piece: nil, pending_clear: Enum.sort(full_rows)}
    else
      %{game | board: board, piece: nil}
      |> spawn_piece(game.next_type)
    end
  end

  defp lock_piece(game), do: game

  defp merged_board(%__MODULE__{board: board, piece: nil}), do: board

  defp merged_board(%__MODULE__{board: board, piece: piece}) do
    merge_piece(board, piece)
  end

  defp merge_piece(board, %Piece{} = piece) do
    Enum.reduce(block_coords(piece), board, fn {x, y}, acc ->
      if in_bounds?(x, y) do
        put_at(acc, x, y, %Cell{theme: theme_for_type(piece.type)})
      else
        acc
      end
    end)
  end

  defp find_full_rows(board) do
    board
    |> Enum.with_index()
    |> Enum.filter(fn {row, _} -> Enum.all?(row, &(&1 != nil)) end)
    |> Enum.map(fn {_, index} -> index end)
  end

  defp clear_lines_for_rows(board, rows) when is_list(rows) and rows != [] do
    row_set = MapSet.new(rows)
    incomplete = Enum.reject(Enum.with_index(board), fn {_, y} -> MapSet.member?(row_set, y) end)
    cleared = length(rows)
    empty_rows = List.duplicate(List.duplicate(nil, @cols), cleared)
    {empty_rows ++ Enum.map(incomplete, &elem(&1, 0)), cleared}
  end

  defp clear_lines_for_rows(board, _), do: {board, 0}

  defp valid?(board, %Piece{} = piece) do
    Enum.all?(block_coords(piece), fn {x, y} ->
      in_bounds?(x, y) and at(board, x, y) == nil
    end)
  end

  defp block_coords(%Piece{type: type, rotation: rot, x: px, y: py}) do
    shape(type, rot)
    |> Enum.map(fn {x, y} -> {px + x, py + y} end)
  end

  defp shape(:i, rot) when rem(rot, 2) == 0, do: [{0, 0}, {1, 0}, {2, 0}, {3, 0}]
  defp shape(:i, _), do: [{0, 0}, {0, 1}, {0, 2}, {0, 3}]

  defp shape(:o, _), do: [{0, 0}, {1, 0}, {0, 1}, {1, 1}]

  defp shape(:t, 0), do: [{0, 0}, {1, 0}, {2, 0}, {1, 1}]
  defp shape(:t, 1), do: [{1, 0}, {0, 1}, {1, 1}, {1, 2}]
  defp shape(:t, 2), do: [{0, 1}, {1, 1}, {2, 1}, {1, 0}]
  defp shape(:t, 3), do: [{1, 0}, {1, 1}, {2, 1}, {1, 2}]

  defp shape(:l, 0), do: [{0, 0}, {0, 1}, {0, 2}, {1, 2}]
  defp shape(:l, 1), do: [{0, 0}, {1, 0}, {2, 0}, {0, 1}]
  defp shape(:l, 2), do: [{1, 0}, {1, 1}, {1, 2}, {0, 0}]
  defp shape(:l, 3), do: [{2, 0}, {0, 1}, {1, 1}, {2, 1}]

  defp in_bounds?(x, y), do: x >= 0 and x < @cols and y >= 0 and y < @rows

  defp at(board, x, y) do
    row = Enum.at(board, y)
    Enum.at(row, x)
  end

  defp put_at(board, x, y, value) do
    List.update_at(board, y, fn row ->
      List.replace_at(row, x, value)
    end)
  end

  defp random_type, do: Enum.random(@piece_types)
end
