defmodule E2e.Tetrex.SimulatedPlayer do
  @moduledoc false

  alias E2e.Tetrex
  alias E2e.Tetrex.Piece

  @max_frames 1200
  @max_pieces 900

  def play_until(target_score, seed, attempts \\ 0)

  def play_until(_target_score, _seed, attempts) when attempts > 20 do
    {:error, :no_replay}
  end

  def play_until(target_score, seed, attempts)
      when is_integer(target_score) and is_integer(seed) do
    :rand.seed(:exsss, {seed, 0, 0})

    game = Tetrex.new()
    frames = [Tetrex.to_client(game)]

    case play_loop(game, target_score, frames, 0) do
      {:ok, game, frames} ->
        game = %{game | status: :game_over, piece: nil}
        final = Tetrex.to_client(game)
        frames = finalize_frames(push_frame(final, frames))
        {:ok, game, frames}

      {:retry, _reason, _pieces, _score} ->
        play_until(target_score, seed + 1, attempts + 1)
    end
  end

  defp play_loop(game, target, frames, pieces) do
    game = resolve_clear(game)
    frames = push_frame(Tetrex.to_client(game), frames)

    cond do
      game.status == :game_over ->
        {:retry, :game_over, pieces, game.score}

      game.score >= target or pieces >= @max_pieces ->
        {:ok, game, frames}

      game.piece == nil ->
        {:retry, :no_piece, pieces, game.score}

      true ->
        {game, frames} = play_current_piece(game, frames)
        play_loop(game, target, frames, pieces + 1)
    end
  end

  defp play_current_piece(game, frames) do
    {x, rot} = best_placement(game)
    {game, frames} = aim_piece(game, frames, x, rot)
    soft_drop(game, frames, 0)
  end

  defp aim_piece(game, frames, target_x, target_rot) do
    game = rotate_to(game, target_rot)
    frames = push_frame(Tetrex.to_client(game), frames)
    aim_slide(game, frames, target_x)
  end

  defp aim_slide(%{piece: %Piece{x: x}} = game, frames, target_x) when x < target_x do
    next = Tetrex.command(game, :right)

    if next.piece.x == x do
      {game, frames}
    else
      frames = push_frame(Tetrex.to_client(next), frames)
      aim_slide(next, frames, target_x)
    end
  end

  defp aim_slide(%{piece: %Piece{x: x}} = game, frames, target_x) when x > target_x do
    next = Tetrex.command(game, :left)

    if next.piece.x == x do
      {game, frames}
    else
      frames = push_frame(Tetrex.to_client(next), frames)
      aim_slide(next, frames, target_x)
    end
  end

  defp aim_slide(game, frames, _target_x), do: {game, frames}

  defp best_placement(game) do
    base_score = game.score
    default = {-999_999, game.piece.x, game.piece.rotation}

    placements =
      for rot <- 0..3,
          x <- 0..(Tetrex.cols() - 1),
          do: {rot, x}

    {_score, x, rot} =
      Enum.reduce(placements, default, fn {rot, x}, acc ->
        trial = game |> move_to(x, rot) |> drop_piece_fast()

        if trial.status == :game_over do
          acc
        else
          score = evaluate_board(trial, base_score)

          case acc do
            {best, _, _} when score <= best -> acc
            _ -> {score, x, rot}
          end
        end
      end)

    {x, rot}
  end

  defp move_to(game, target_x, target_rot) do
    game
    |> rotate_to(target_rot)
    |> slide_to_target(target_x)
  end

  defp rotate_to(game, target_rot) do
    steps = rem(target_rot - game.piece.rotation + 4, 4)

    if steps == 0 do
      game
    else
      Enum.reduce(1..steps, game, fn _, g ->
        Tetrex.command(g, :rotate)
      end)
    end
  end

  defp slide_to_target(%{piece: %Piece{x: x}} = game, target_x) when x < target_x do
    next = Tetrex.command(game, :right)
    if next.piece.x == x, do: game, else: slide_to_target(next, target_x)
  end

  defp slide_to_target(%{piece: %Piece{x: x}} = game, target_x) when x > target_x do
    next = Tetrex.command(game, :left)
    if next.piece.x == x, do: game, else: slide_to_target(next, target_x)
  end

  defp slide_to_target(game, _target_x), do: game

  defp soft_drop(game, frames, tick) do
    game = resolve_clear(game)

    frames =
      if rem(tick, 2) == 0 do
        push_frame(Tetrex.to_client(game), frames)
      else
        frames
      end

    cond do
      game.status == :game_over ->
        {game, frames}

      game.piece == nil ->
        {resolve_clear(game), frames}

      true ->
        next = Tetrex.tick(game)

        cond do
          next == game ->
            {game, frames}

          next.status == :game_over ->
            {next, frames}

          next.piece == nil ->
            {resolve_clear(next), push_frame(Tetrex.to_client(next), frames)}

          piece_locked?(game, next) ->
            {next, push_frame(Tetrex.to_client(next), frames)}

          true ->
            soft_drop(next, frames, tick + 1)
        end
    end
  end

  defp piece_locked?(%{piece: %Piece{y: y_before}}, %{piece: %Piece{y: y_after}}) do
    y_after < y_before
  end

  defp piece_locked?(_, _), do: false

  defp drop_piece_fast(game) do
    game
    |> resolve_clear()
    |> Tetrex.command(:hard_drop)
    |> resolve_clear()
  end

  defp evaluate_board(game, base_score) do
    line_gain = (game.score - base_score) * 800
    heights = column_heights(game.board)
    aggregate = Enum.sum(heights)
    maximum = Enum.max(heights, fn -> 0 end)
    holes = count_holes(game.board)
    bumpiness = bumpiness(heights)

    line_gain - aggregate * 6 - maximum * 4 - holes * 40 - bumpiness * 2
  end

  defp column_heights(board) do
    for col <- 0..(Tetrex.cols() - 1) do
      Enum.reduce(0..(Tetrex.rows() - 1), 0, fn row, acc ->
        row_cells = Enum.at(board, row)

        if cell_filled?(Enum.at(row_cells, col)) do
          max(acc, Tetrex.rows() - row)
        else
          acc
        end
      end)
    end
  end

  defp cell_filled?(nil), do: false
  defp cell_filled?(_), do: true

  defp count_holes(board) do
    Enum.reduce(0..(Tetrex.cols() - 1), 0, fn col, holes ->
      {_seen, hole_count} =
        Enum.reduce(board, {false, 0}, fn row, {seen_block, count} ->
          cell = Enum.at(row, col)

          if cell_filled?(cell) do
            {true, count}
          else
            if seen_block, do: {seen_block, count + 1}, else: {seen_block, count}
          end
        end)

      holes + hole_count
    end)
  end

  defp bumpiness(heights) do
    heights
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [a, b], acc -> acc + abs(a - b) end)
  end

  defp resolve_clear(game) do
    if Tetrex.clear_locked?(game), do: Tetrex.commit_clear(game), else: game
  end

  defp push_frame(frame, frames), do: [frame | frames]

  defp finalize_frames(frames) do
    frames
    |> Enum.reverse()
    |> dedupe_frames()
    |> cap_frames()
  end

  defp dedupe_frames(frames) do
    Enum.reduce(frames, [], fn frame, acc ->
      case acc do
        [] -> [frame]
        [last | _] -> if frame_equal?(last, frame), do: acc, else: acc ++ [frame]
      end
    end)
  end

  defp frame_equal?(a, b) do
    frame_signature(a) == frame_signature(b)
  end

  defp frame_signature(frame) do
    {frame["score"], frame["lines"], frame["level"], frame["status"], frame["piece"],
     frame["pending_clear"]}
  end

  defp cap_frames(frames) do
    if length(frames) <= @max_frames do
      frames
    else
      [first | rest] = frames
      [last | middle_rev] = Enum.reverse(rest)
      middle = Enum.reverse(middle_rev)
      n = @max_frames - 2
      step = max(div(length(middle), n), 1)
      sampled = middle |> Enum.take_every(step) |> Enum.take(n)
      [first | sampled] ++ [last]
    end
  end
end
