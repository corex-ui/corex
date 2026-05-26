defmodule E2e.Tetrex.OwnershipStore do
  @moduledoc false

  use GenServer

  @max_owned 20

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, Keyword.put_new(opts, :name, __MODULE__))
  end

  def claim(browser_session, game_id)
      when is_map(browser_session) and is_binary(game_id) do
    GenServer.call(__MODULE__, {:claim, session_key(browser_session), game_id})
  end

  def list(browser_session) when is_map(browser_session) do
    GenServer.call(__MODULE__, {:list, session_key(browser_session)})
  end

  def set_pending_name(game_id, name) when is_binary(game_id) and is_binary(name) do
    GenServer.call(__MODULE__, {:set_pending_name, game_id, name})
  end

  def pop_pending_name(game_id) when is_binary(game_id) do
    GenServer.call(__MODULE__, {:pop_pending_name, game_id})
  end

  @impl true
  def init(_opts), do: {:ok, %{owned: %{}, pending: %{}}}

  @impl true
  def handle_call({:claim, key, game_id}, _from, %{owned: owned} = state) do
    ids =
      owned
      |> Map.get(key, [])
      |> then(fn ids -> [game_id | ids] end)
      |> Enum.uniq()
      |> Enum.take(@max_owned)

    {:reply, MapSet.new(ids), put_in(state, [:owned, key], ids)}
  end

  def handle_call({:list, key}, _from, %{owned: owned} = state) do
    {:reply, MapSet.new(Map.get(owned, key, [])), state}
  end

  def handle_call({:set_pending_name, game_id, name}, _from, state) do
    {:reply, :ok, put_in(state, [:pending, game_id], name)}
  end

  def handle_call({:pop_pending_name, game_id}, _from, %{pending: pending} = state) do
    {name, pending} = Map.pop(pending, game_id)
    {:reply, name, %{state | pending: pending}}
  end

  defp session_key(session), do: :erlang.phash2(session)
end
