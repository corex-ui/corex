defmodule E2e.Tetrex.Store do
  @moduledoc false

  import Ecto.Query

  alias E2e.Repo
  alias E2e.Tetrex.Game
  alias E2e.Tetrex.Names

  @top 10
  @max_name_length 24
  @leaderboard_topic "tetrex:leaderboard"

  def leaderboard_topic, do: @leaderboard_topic

  def finalize(id, score, frames, client_state)
      when is_binary(id) and is_integer(score) and is_list(frames) and is_map(client_state) do
    if qualifies_for_leaderboard?(score) do
      now = DateTime.utc_now() |> DateTime.truncate(:second)

      player_name =
        case E2e.Tetrex.OwnershipStore.pop_pending_name(id) do
          name when is_binary(name) and name != "" ->
            sanitize_name(name)

          _ ->
            case get(id) do
              %Game{player_name: name} when is_binary(name) and name != "" -> name
              _ -> Names.random()
            end
        end

      %Game{id: id}
      |> Ecto.Changeset.change(%{
        score: score,
        status: "game_over",
        client_state: client_state,
        frames: frames,
        ended_at: now,
        player_name: player_name
      })
      |> Repo.insert(
        on_conflict:
          {:replace, [:score, :status, :client_state, :frames, :ended_at, :updated_at]},
        conflict_target: :id
      )

      trim_to_top()
      Phoenix.PubSub.broadcast(E2e.PubSub, @leaderboard_topic, :leaderboard_updated)
      :saved
    else
      :skipped
    end
  end

  def get(id) when is_binary(id), do: Repo.get(Game, id)

  def on_leaderboard?(id) when is_binary(id) do
    Enum.any?(list_top(), &(&1.id == id))
  end

  def list_top(limit \\ @top) do
    from(g in Game,
      order_by: [desc: g.score, asc: g.ended_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  def update_player_name(id, name) when is_binary(id) and is_binary(name) do
    name = sanitize_name(name)

    case get(id) do
      %Game{player_name: ^name} ->
        :ok

      %Game{} = game ->
        game
        |> Ecto.Changeset.change(%{player_name: name})
        |> Repo.update()

        Phoenix.PubSub.broadcast(E2e.PubSub, @leaderboard_topic, :leaderboard_updated)
        :ok

      nil ->
        :error
    end
  end

  def sanitize_name(name) do
    name
    |> String.trim()
    |> String.slice(0, @max_name_length)
  end

  def qualifies_for_leaderboard?(score) when is_integer(score) do
    entries = list_top(@top)

    cond do
      entries == [] -> true
      length(entries) < @top -> true
      true -> score > min_leaderboard_score(entries)
    end
  end

  defp min_leaderboard_score(entries) do
    entries |> Enum.map(& &1.score) |> Enum.min()
  end

  defp trim_to_top do
    keep_ids =
      from(g in Game,
        order_by: [desc: g.score, asc: g.ended_at],
        limit: ^@top,
        select: g.id
      )
      |> Repo.all()

    from(g in Game, where: g.id not in ^keep_ids)
    |> Repo.delete_all()
  end
end
