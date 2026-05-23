defmodule E2e.Tetrex.ReplaySeed do
  @moduledoc false

  alias E2e.Tetrex
  alias E2e.Tetrex.SimulatedPlayer

  def build(target_score, seed) when is_integer(target_score) and is_integer(seed) do
    case SimulatedPlayer.play_until(target_score, seed) do
      {:ok, game, frames} ->
        %{
          frames: frames,
          client: Tetrex.to_client(game),
          score: game.score
        }

      {:error, :no_replay} ->
        raise "Tetrex.ReplaySeed could not simulate a replay for target #{target_score}"
    end
  end
end
