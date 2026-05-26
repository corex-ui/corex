defmodule E2eWeb.TetrexPresence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :corex_web,
    pubsub_server: E2e.PubSub

  @lobby_topic "tetrex:lobby"

  def lobby_topic, do: @lobby_topic

  def track_watch(socket, game_id) when is_binary(game_id) do
    track(self(), @lobby_topic, watch_key(socket, game_id), %{game_id: game_id, role: "watch"})
  end

  def track_player(socket, game_id) when is_binary(game_id) do
    track(self(), @lobby_topic, player_key(socket, game_id), %{game_id: game_id, role: "player"})
  end

  def watch_key(socket, game_id) do
    "#{game_id}:#{socket.id}"
  end

  def player_key(socket, game_id) do
    "#{game_id}:player:#{socket.id}"
  end

  def live_player_game_ids do
    list(@lobby_topic)
    |> Enum.flat_map(fn {_key, %{metas: metas}} ->
      for meta <- metas,
          meta[:role] == "player",
          is_binary(meta[:game_id]),
          do: meta[:game_id]
    end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def count_for_game(game_id) when is_binary(game_id) do
    list(@lobby_topic)
    |> Enum.count(fn {_key, %{metas: metas}} ->
      Enum.any?(metas, fn meta -> meta[:game_id] == game_id and meta[:role] == "watch" end)
    end)
  end

  def counts_by_game do
    list(@lobby_topic)
    |> Enum.reduce(%{}, fn {_key, %{metas: metas}}, acc ->
      case Enum.find(metas, &(&1[:role] == "watch" and is_binary(&1[:game_id]))) do
        %{game_id: game_id} -> Map.update(acc, game_id, 1, &(&1 + 1))
        _ -> acc
      end
    end)
  end
end
