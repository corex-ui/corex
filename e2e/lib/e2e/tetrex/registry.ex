defmodule E2e.Tetrex.Registry do
  @moduledoc false

  use GenServer

  alias E2e.Tetrex.Session

  @sessions_topic "tetrex:sessions"

  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      %{entries: %{}, refs: %{}},
      Keyword.put_new(opts, :name, __MODULE__)
    )
  end

  def new_id do
    generate_id()
  end

  def create do
    id = new_id()
    register(id, %{status: :playing, score: 0})
    id
  end

  def register(id, meta, pid \\ nil) when is_binary(id) and is_map(meta) do
    GenServer.call(__MODULE__, {:register, id, meta, pid})
  end

  def track_player(id, player_pid) when is_binary(id) and is_pid(player_pid) do
    GenServer.call(__MODULE__, {:track_player, id, player_pid})
  end

  def update(id, meta) when is_binary(id) and is_map(meta) do
    GenServer.call(__MODULE__, {:update, id, meta})
  end

  def unregister(id) when is_binary(id) do
    GenServer.call(__MODULE__, {:unregister, id})
  end

  def list_active do
    GenServer.call(__MODULE__, :list_active)
  end

  def sessions_topic, do: @sessions_topic

  @impl true
  def init(state) do
    {:ok, normalize_state(state)}
  end

  @impl true
  def code_change(_version, state, _extra) do
    {:ok, normalize_state(state)}
  end

  @impl true
  def handle_call({:register, id, meta, pid}, _from, state) do
    entry = Map.merge(%{id: id, started_at: System.system_time(:second)}, meta)
    state = demonitor_id(state, id)
    state = put_in(state.entries[id], entry)
    state = if is_pid(pid), do: monitor_pid(state, id, pid, :session), else: state
    state = broadcast_sessions(state)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:track_player, id, player_pid}, _from, state) do
    state = demonitor_players(state, id)

    state =
      case Map.fetch(state.entries, id) do
        {:ok, entry} -> put_in(state.entries[id], Map.put(entry, :player_pid, player_pid))
        :error -> state
      end

    state = monitor_pid(state, id, player_pid, :player)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:update, id, meta}, _from, state) do
    state =
      case Map.fetch(state.entries, id) do
        {:ok, entry} -> put_in(state.entries[id], Map.merge(entry, meta))
        :error -> state
      end

    state = broadcast_sessions(state)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:unregister, id}, _from, state) do
    state = drop_entry(state, id)
    state = broadcast_sessions(state)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:list_active, _from, state) do
    state = prune_stale_entries(state)

    {:reply, live_entries(state), state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    case Map.pop(state.refs, ref) do
      {nil, _} ->
        {:noreply, state}

      {{id, kind}, refs} ->
        state = %{state | refs: refs}

        if kind == :player do
          case Session.whereis(id) do
            pid when is_pid(pid) -> send(pid, :request_abandon)
            _ -> :ok
          end
        end

        state = drop_entry(state, id)
        {:noreply, broadcast_sessions(state)}
    end
  end

  defp normalize_state(%{entries: _} = state), do: state
  defp normalize_state(state) when is_map(state), do: %{entries: state, refs: %{}}

  defp session_alive?(id) when is_binary(id) do
    case Session.whereis(id) do
      pid when is_pid(pid) -> Process.alive?(pid)
      _ -> false
    end
  end

  defp monitor_pid(state, id, pid, kind) do
    ref = Process.monitor(pid)
    put_in(state.refs[ref], {id, kind})
  end

  defp demonitor_players(state, id) do
    refs =
      Enum.reject(state.refs, fn {ref, {entry_id, kind}} ->
        if entry_id == id and kind == :player do
          Process.demonitor(ref, [:flush])
          true
        else
          false
        end
      end)

    %{state | refs: Map.new(refs)}
  end

  defp demonitor_id(state, id) do
    refs =
      Enum.reject(state.refs, fn {ref, {entry_id, _kind}} ->
        if entry_id == id do
          Process.demonitor(ref, [:flush])
          true
        else
          false
        end
      end)

    %{state | refs: Map.new(refs)}
  end

  defp prune_stale_entries(state) do
    stale_ids =
      state.entries
      |> Map.keys()
      |> Enum.reject(&session_alive?/1)

    Enum.reduce(stale_ids, state, &drop_entry(&2, &1))
  end

  defp drop_entry(state, id) do
    state = demonitor_id(state, id)
    %{state | entries: Map.delete(state.entries, id)}
  end

  defp broadcast_sessions(state) do
    state = prune_stale_entries(state)

    Phoenix.PubSub.broadcast(E2e.PubSub, @sessions_topic, {:sessions, live_entries(state)})
    state
  end

  defp live_entries(state) do
    state.entries
    |> Map.values()
    |> Enum.filter(&entry_live?/1)
    |> Enum.sort_by(& &1.id)
  end

  defp entry_live?(%{id: id} = entry) do
    player_alive =
      case Map.get(entry, :player_pid) do
        pid when is_pid(pid) -> Process.alive?(pid)
        _ -> false
      end

    player_alive and session_alive?(id)
  end

  defp generate_id do
    6
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 8)
  end
end
