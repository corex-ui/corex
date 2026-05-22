defmodule E2e.Tetrex.Session do
  @moduledoc false

  use GenServer

  alias E2e.Tetrex
  alias E2e.Tetrex.Store

  @idle_ttl_ms :timer.minutes(2)
  @max_frames 1200

  def start_link(game_id) when is_binary(game_id) do
    GenServer.start_link(__MODULE__, game_id, name: via(game_id))
  end

  def via(game_id), do: {:via, Registry, {E2e.Tetrex.SessionRegistry, game_id}}

  def whereis(game_id) do
    case Registry.lookup(E2e.Tetrex.SessionRegistry, game_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def ensure_started(game_id) when is_binary(game_id) do
    case whereis(game_id) do
      nil ->
        child = %{
          id: {:tetrex_session, game_id},
          start: {__MODULE__, :start_link, [game_id]},
          restart: :temporary
        }

        case DynamicSupervisor.start_child(E2e.Tetrex.SessionSupervisor, child) do
          {:ok, _pid} -> :ok
          {:error, {:already_started, _pid}} -> :ok
          {:error, _} = err -> err
        end

      _pid ->
        :ok
    end
  end

  def get_state(game_id) when is_binary(game_id) do
    {:ok, GenServer.call(via(game_id), :get_state)}
  catch
    :exit, _ -> {:error, :not_found}
  end

  def sync(game_id, client_game) when is_binary(game_id) and is_map(client_game) do
    game = Tetrex.from_client(client_game)

    if game.status == :game_over do
      GenServer.call(via(game_id), {:sync, client_game})
    else
      GenServer.cast(via(game_id), {:sync, client_game})
      :ok
    end
  catch
    :exit, _ -> {:error, :not_found}
  end

  def session_topic(game_id), do: "tetrex:session:#{game_id}"

  def stop(game_id) when is_binary(game_id) do
    case whereis(game_id) do
      nil ->
        E2e.Tetrex.Registry.unregister(game_id)
        :ok

      pid ->
        try do
          GenServer.call(pid, :abandon, :infinity)
        catch
          :exit, _ ->
            E2e.Tetrex.Registry.unregister(game_id)
            :ok
        end
    end
  end

  def kill(game_id) when is_binary(game_id) do
    case whereis(game_id) do
      nil ->
        :ok

      pid ->
        GenServer.stop(pid, :normal, :infinity)
    end
  catch
    :exit, _ -> :ok
  end

  @impl true
  def init(game_id) do
    game = Tetrex.new()
    cells = Tetrex.cells_for_render(game)
    initial_frame = Tetrex.to_client(game)

    state = %{
      id: game_id,
      game: game,
      last_cells: cells,
      frames: [initial_frame],
      idle_timer: schedule_idle(nil)
    }

    E2e.Tetrex.Registry.register(
      game_id,
      %{status: game.status, score: game.score},
      self()
    )

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, %{game: game, id: id} = state) do
    {:reply, %{id: id, game: game, client: Tetrex.to_client(game)}, state}
  end

  @impl true
  def handle_call(:abandon, _from, state) do
    {:stop, :normal, :ok, abandon_state(state)}
  end

  @impl true
  def handle_call({:sync, client_game}, _from, state) do
    {new_state, _update, finalize_result} = publish_after_sync(state, client_game)

    reply =
      case finalize_result do
        :saved -> :saved
        :skipped -> :skipped
        _ -> :ok
      end

    {:reply, reply, new_state}
  end

  @impl true
  def handle_cast({:sync, client_game}, state) do
    {new_state, _update, _finalize_result} = publish_after_sync(state, client_game)
    {:noreply, new_state}
  end

  defp publish_after_sync(state, client_game) do
    game = Tetrex.from_client(client_game)
    frames = append_frame(state.frames, client_game)
    publish(%{state | frames: frames, idle_timer: schedule_idle(state)}, game)
  end

  @impl true
  def handle_info(:request_abandon, state) do
    {:stop, :normal, abandon_state(state)}
  end

  @impl true
  def handle_info(:stop_after_game_over, state) do
    cleanup(state)
    {:stop, :normal, state}
  end

  @impl true
  def handle_info(:idle_timeout, state) do
    {:stop, :normal, abandon_state(state)}
  end

  defp publish(%{id: id, last_cells: _last_cells, frames: frames} = state, game) do
    frames =
      if(game.status == :game_over,
        do: append_frame(frames, Tetrex.to_client(game)),
        else: frames
      )

    cells = Tetrex.cells_for_render(game)

    update = %{
      cells: full_patch(cells),
      score: game.score,
      lines: game.lines,
      level: game.level,
      status: game.status,
      next_type: game.next_type
    }

    broadcast_watchers(id, update)

    E2e.Tetrex.Registry.update(id, %{status: game.status, score: game.score})

    finalize_result =
      if game.status == :game_over do
        final_frame = Tetrex.to_client(game)

        result =
          Store.finalize(
            id,
            game.score,
            append_frame(frames, final_frame),
            final_frame
          )

        E2e.Tetrex.Registry.unregister(id)
        Process.send(self(), :stop_after_game_over, [])
        result
      else
        nil
      end

    {%{state | game: game, last_cells: cells, frames: frames}, update, finalize_result}
  end

  defp append_frame(frames, client_game) when is_list(frames) and is_map(client_game) do
    case frames do
      [] ->
        cap_frames([client_game])

      frames ->
        last = last_frame(frames)

        if frame_equal?(last, client_game) do
          frames
        else
          cap_frames(frames ++ [client_game])
        end
    end
  end

  defp last_frame([frame]), do: frame
  defp last_frame([_ | rest]), do: last_frame(rest)

  defp frame_equal?(a, b) do
    Jason.encode!(a) == Jason.encode!(b)
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

  defp broadcast_watchers(game_id, update) do
    Phoenix.PubSub.broadcast(E2e.PubSub, session_topic(game_id), {:game, update})
  end

  defp full_patch(cells) do
    Enum.map(cells, fn c ->
      %{
        id: c.id,
        checked: c.checked,
        theme: c.theme,
        clearing: Map.get(c, :clearing, false)
      }
    end)
  end

  defp schedule_idle(%{idle_timer: ref}) when is_reference(ref) do
    Process.cancel_timer(ref)
    schedule_idle(nil)
  end

  defp schedule_idle(_state) do
    Process.send_after(self(), :idle_timeout, @idle_ttl_ms)
  end

  @impl true
  def terminate(_reason, _state), do: :ok

  defp abandon_state(%{game: %{status: :game_over}} = state) do
    cancel_idle(state)
  end

  defp abandon_state(state) do
    game = Tetrex.abandon(state.game)
    final_frame = Tetrex.to_client(game)
    frames = append_frame(state.frames, final_frame)
    cells = Tetrex.cells_for_render(game)

    broadcast_watchers(state.id, %{
      cells: full_patch(cells),
      score: game.score,
      lines: game.lines,
      level: game.level,
      status: :game_over,
      next_type: game.next_type
    })

    Store.finalize(state.id, game.score, frames, final_frame)
    E2e.Tetrex.Registry.unregister(state.id)
    cancel_idle(%{state | game: game, last_cells: cells, frames: frames})
  end

  defp cancel_idle(%{idle_timer: ref} = state) when is_reference(ref) do
    Process.cancel_timer(ref)
    %{state | idle_timer: nil}
  end

  defp cancel_idle(state), do: state

  defp cleanup(state) do
    E2e.Tetrex.Registry.unregister(state.id)
  end
end
