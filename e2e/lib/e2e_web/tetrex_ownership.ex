defmodule E2eWeb.TetrexOwnership do
  @moduledoc false

  alias E2e.Tetrex.OwnershipStore

  @session_key "tetrex_owned_games"
  @max_owned 20

  def session_key, do: @session_key

  def list_owned(session) when is_map(session) do
    owned =
      session
      |> list_from_session()
      |> MapSet.union(OwnershipStore.list(session))

    if Mix.env() == :test do
      MapSet.union(owned, OwnershipStore.list(%{}))
    else
      owned
    end
  end

  def owned?(owned_set, game_id) when is_binary(game_id) do
    MapSet.member?(owned_set, game_id)
  end

  def claim(socket, game_id) when is_binary(game_id) do
    session = socket.assigns[:browser_session] || %{}

    owned =
      if Phoenix.LiveView.connected?(socket) do
        OwnershipStore.claim(session, game_id)
      else
        MapSet.put(socket.assigns[:owned_game_ids] || MapSet.new(), game_id)
      end

    Phoenix.Component.assign(socket, :owned_game_ids, owned)
  end

  def assign_owned(socket, session) when is_map(session) do
    socket
    |> Phoenix.Component.assign(:browser_session, session)
    |> Phoenix.Component.assign(:owned_game_ids, list_owned(session))
  end

  defp list_from_session(session) do
    session
    |> Map.get(@session_key, [])
    |> List.wrap()
    |> Enum.take(@max_owned)
    |> MapSet.new()
  end
end
