defmodule E2eWeb.TetrexLive do
  use E2eWeb, :live_view

  alias E2e.Tetrex
  alias E2e.Tetrex.Names
  alias E2e.Tetrex.OwnershipStore
  alias E2e.Tetrex.Registry
  alias E2e.Tetrex.Session
  alias E2e.Tetrex.Store
  alias E2eWeb.TetrexOwnership
  alias E2eWeb.TetrexPresence

  @tick_ms 700
  @replay_step_ms 280
  @replay_chunk_size 40
  @tile_base "checkbox w-full min-w-0 h-full min-h-0"
  @preview_tile "checkbox w-full aspect-square min-w-0 pointer-events-none"

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> TetrexOwnership.assign_owned(session)
     |> assign(:page_title, ~t"Tetrex")
     |> assign(:seo, E2eWeb.SEO.new(title: ~t"Tetrex", description: ~t"Checkbox Tetris."))
     |> assign(:game_id, nil)
     |> assign(:source, nil)
     |> assign(:started, false)
     |> assign(:score, 0)
     |> assign(:status, :playing)
     |> assign(:next_type, nil)
     |> assign(:board_cells, %{})
     |> assign(:preview_cells, Tetrex.preview_cells(nil))
     |> assign(:client_json, nil)
     |> assign(:replay_ready, false)
     |> assign(:replay_init_sent, false)
     |> assign(:tick_ms, @tick_ms)
     |> assign(:cols, Tetrex.cols())
     |> assign(:rows, Tetrex.rows())
     |> assign(:cell_coords, cell_coords())
     |> assign(:player_name, nil)
     |> assign(:can_edit_name, false)
     |> assign(:lines, 0)
     |> assign(:level, 1)
     |> assign(:watchers_count, 0)
     |> assign(:board_ready, true)
     |> assign(:leaderboard_saved, false)
     |> assign(:syncing_results, false)
     |> assign(:lv_connected, false)}
  end

  defp cell_coords do
    for row <- 0..(Tetrex.rows() - 1),
        col <- 0..(Tetrex.cols() - 1),
        do: {col, row}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket = assign(socket, :lv_connected, connected?(socket))

    case socket.assigns.live_action do
      :new ->
        handle_new(socket)

      action when action in [:show, :watch, :replay] ->
        id = params["id"]

        socket =
          socket
          |> assign(:game_id, id)
          |> reset_before_resolve()
          |> resolve_game(id, action)
          |> maybe_subscribe_watch(id, action)
          |> maybe_push_replay_init(action)
          |> track_player_presence(action)

        {:noreply, socket}
    end
  end

  defp handle_new(socket) do
    id = Registry.new_id()

    socket =
      socket
      |> assign(:game_id, id)
      |> assign(:board_ready, false)
      |> assign_empty_board()

    if connected?(socket) do
      case Session.ensure_started(id) do
        :ok ->
          socket =
            case Session.get_state(id) do
              {:ok, %{game: game, client: client}} ->
                socket
                |> apply_game_assigns(game, :session, started: false, client: client)
                |> assign(:board_ready, true)
                |> TetrexOwnership.claim(id)

              {:error, :not_found} ->
                socket
            end

          {:noreply, push_patch(socket, to: ~p"/showcases/tetrex/#{id}")}

        {:error, _reason} ->
          {:noreply, put_flash(socket, :error, "Could not start game.")}
      end
    else
      {:noreply, socket}
    end
  end

  defp assign_empty_board(socket) do
    empty = Tetrex.empty_board_state()

    socket
    |> assign(:source, :session)
    |> assign(:started, false)
    |> assign(:score, 0)
    |> assign(:lines, 0)
    |> assign(:level, 1)
    |> assign(:status, :playing)
    |> assign(:next_type, nil)
    |> assign(:board_cells, build_board_cells(empty))
    |> assign(:preview_cells, Tetrex.preview_cells(nil))
    |> assign(:client_json, nil)
  end

  defp resolve_game(socket, id, :replay) do
    if connected?(socket) and socket.assigns[:replay_ready] do
      socket
    else
      case Store.get_first_frame(id) do
        frame when is_map(frame) and map_size(frame) > 0 ->
          game = Tetrex.from_client(frame)

          socket
          |> apply_game_assigns(game, :store, started: true)
          |> assign(:replay_ready, true)

        _ ->
          assign_unavailable(socket)
      end
    end
  end

  defp resolve_game(socket, id, :watch) do
    case Session.get_state(id) do
      {:ok, %{game: game}} ->
        apply_game_assigns(socket, game, :session, started: true)

      {:error, :not_found} ->
        case Store.get_client_state(id) do
          nil ->
            assign_unavailable(socket)

          client ->
            game = Tetrex.from_client(client)

            socket
            |> apply_game_assigns(game, :store, started: true)
            |> assign(:leaderboard_saved, Store.on_leaderboard?(id))
            |> assign(:board_ready, true)
        end
    end
  end

  defp resolve_game(socket, id, :show) do
    case Session.get_state(id) do
      {:ok, %{game: game, client: client}} ->
        socket
        |> apply_game_assigns(game, :session, started: false, client: client)
        |> assign(:board_ready, true)

      {:error, :not_found} ->
        case Store.get_client_state(id) do
          nil ->
            assign_unavailable(socket)

          client ->
            game = Tetrex.from_client(client)

            socket
            |> apply_game_assigns(game, :store, started: true)
            |> assign(:leaderboard_saved, Store.on_leaderboard?(id))
            |> assign(:board_ready, true)
        end
    end
  end

  defp reset_before_resolve(socket) do
    replay_persist? =
      connected?(socket) and socket.assigns.live_action == :replay and
        socket.assigns[:replay_ready]

    socket
    |> assign(:leaderboard_saved, false)
    |> assign(:syncing_results, false)
    |> then(fn s ->
      if replay_persist?,
        do: s,
        else: assign(s, :replay_ready, false) |> assign(:replay_init_sent, false)
    end)
  end

  defp assign_unavailable(socket) do
    empty = Tetrex.empty_board_state()

    socket
    |> assign(:source, nil)
    |> assign(:started, false)
    |> assign(:score, 0)
    |> assign(:lines, 0)
    |> assign(:level, 1)
    |> assign(:status, :playing)
    |> assign(:next_type, nil)
    |> assign(:board_cells, build_board_cells(empty))
    |> assign(:preview_cells, Tetrex.preview_cells(nil))
    |> assign(:client_json, nil)
    |> assign(:replay_ready, false)
    |> assign(:replay_init_sent, false)
  end

  defp maybe_subscribe_watch(socket, _id, :watch) do
    if connected?(socket) and socket.assigns.source == :session and
         is_binary(socket.assigns.game_id) do
      game_id = socket.assigns.game_id

      Phoenix.PubSub.subscribe(E2e.PubSub, Session.session_topic(game_id))
      Phoenix.PubSub.subscribe(E2e.PubSub, TetrexPresence.lobby_topic())
      TetrexPresence.track_watch(socket, game_id)

      socket
      |> assign(:watchers_count, TetrexPresence.count_for_game(game_id))
    else
      assign(socket, :watchers_count, 0)
    end
  end

  defp maybe_subscribe_watch(socket, _id, _action), do: socket

  defp maybe_push_replay_init(socket, :replay) do
    if connected?(socket) and socket.assigns[:replay_ready] and
         not socket.assigns[:replay_init_sent] and is_binary(socket.assigns.game_id) do
      send(self(), {:replay_load, socket.assigns.game_id})
      assign(socket, :replay_init_sent, true)
    else
      socket
    end
  end

  defp maybe_push_replay_init(socket, _action), do: socket

  defp apply_game_assigns(socket, %Tetrex{} = game, source, opts) do
    started = Keyword.get(opts, :started, false)

    client_json =
      case Keyword.get(opts, :client) do
        nil -> encode_client(Tetrex.to_client(game))
        client -> encode_client(client)
      end

    socket =
      socket
      |> assign(:source, source)
      |> assign(:started, started)
      |> assign(:score, game.score)
      |> assign(:lines, game.lines)
      |> assign(:level, game.level)
      |> assign(:status, game.status)
      |> assign(:next_type, Tetrex.normalize_piece_type(game.next_type))
      |> assign(:board_cells, build_board_cells(game))
      |> assign(:preview_cells, Tetrex.preview_cells(game.next_type))
      |> assign(:client_json, client_json)
      |> assign_player_name()

    socket
  end

  defp track_player_presence(socket, action) when action in [:show, :new] do
    if connected?(socket) and socket.assigns[:source] == :session and
         is_binary(socket.assigns.game_id) do
      game_id = socket.assigns.game_id

      Phoenix.PubSub.subscribe(E2e.PubSub, TetrexPresence.lobby_topic())
      TetrexPresence.track_player(socket, game_id)
      Registry.track_player(game_id, self())

      assign(socket, :watchers_count, TetrexPresence.count_for_game(game_id))
    else
      socket
    end
  end

  defp track_player_presence(socket, _), do: socket

  defp assign_player_name(socket) do
    game_id = socket.assigns.game_id

    can_edit =
      is_binary(game_id) and
        TetrexOwnership.owned?(socket.assigns.owned_game_ids, game_id) and
        socket.assigns.live_action in [:show, :new]

    socket
    |> assign(:player_name, load_player_name(game_id))
    |> assign(:can_edit_name, can_edit)
  end

  defp load_player_name(nil), do: nil

  defp load_player_name(game_id) do
    case Store.get_player_name(game_id) do
      name when is_binary(name) and name != "" -> name
      _ -> Names.random()
    end
  end

  defp build_board_cells(%Tetrex{} = game) do
    game
    |> Tetrex.cells_for_render()
    |> Map.new(fn c ->
      {{c.col, c.row},
       %{checked: c.checked, theme: c.theme, clearing: Map.get(c, :clearing, false)}}
    end)
  end

  defp encode_client(client) when is_map(client) do
    Jason.encode!(client)
  end

  defp apply_sync_assigns(socket, %Tetrex{} = client_game) do
    socket =
      socket
      |> assign(:score, client_game.score)
      |> assign(:lines, client_game.lines)
      |> assign(:level, client_game.level)
      |> assign(:status, client_game.status)
      |> assign(:next_type, Tetrex.normalize_piece_type(client_game.next_type))

    if client_game.status == :playing do
      socket
    else
      socket
      |> assign(:board_cells, build_board_cells(client_game))
      |> assign(:preview_cells, Tetrex.preview_cells(client_game.next_type))
    end
  end

  @impl true
  def handle_info({:sync_game_over, id, game}, socket) when is_binary(id) and is_map(game) do
    _ = Session.sync(id, game)

    {:noreply,
     socket
     |> assign(:syncing_results, false)
     |> assign(:leaderboard_saved, Store.on_leaderboard?(id))
     |> assign_player_name()}
  end

  def handle_info({:replay_load, id}, socket) do
    case Store.get_frames(id) do
      frames when is_list(frames) and frames != [] ->
        chunks = Enum.chunk_every(frames, @replay_chunk_size)
        send(self(), {:replay_send, chunks, 0})
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info({:replay_send, chunks, index}, socket) do
    case Enum.at(chunks, index) do
      nil ->
        {:noreply, push_event(socket, "replay_done", %{})}

      chunk ->
        event = if index == 0, do: "replay_begin", else: "replay_chunk"

        payload =
          if index == 0 do
            %{frames: chunk, step_ms: @replay_step_ms}
          else
            %{frames: chunk}
          end

        send(self(), {:replay_send, chunks, index + 1})
        {:noreply, push_event(socket, event, payload)}
    end
  end

  def handle_info({:game, payload}, socket) when is_map(payload) do
    payload = normalize_game_payload(payload)

    {:noreply,
     socket
     |> assign_game_from_payload(payload)
     |> push_event("game_apply", %{cells: Map.get(payload, :cells)})}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", topic: topic}, socket) do
    if topic == TetrexPresence.lobby_topic() do
      {:noreply, assign_watchers_count(socket)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def terminate(_reason, socket) do
    if player_session?(socket) and is_binary(socket.assigns.game_id) do
      if sql_sandbox?() do
        Session.kill(socket.assigns.game_id)
        Registry.unregister(socket.assigns.game_id)
      else
        Session.stop(socket.assigns.game_id)
      end
    end

    :ok
  end

  @impl true
  def handle_event("start_game", _params, socket) do
    {:noreply,
     socket
     |> assign(:started, true)
     |> push_event("game_start", %{})}
  end

  def handle_event(
        "sync",
        %{"game" => game},
        %{assigns: %{live_action: :show, source: :session, game_id: id}} = socket
      )
      when is_map(game) and is_binary(id) do
    client_game = Tetrex.from_client(game)

    if client_game.status == :game_over do
      if socket.assigns[:syncing_results] do
        {:noreply, socket}
      else
        send(self(), {:sync_game_over, id, game})

        {:noreply,
         socket
         |> TetrexOwnership.claim(id)
         |> apply_sync_assigns(client_game)
         |> assign(:syncing_results, true)}
      end
    else
      if id, do: Session.sync(id, game)

      {:noreply,
       socket
       |> TetrexOwnership.claim(id)
       |> apply_sync_assigns(client_game)}
    end
  end

  def handle_event("sync", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("tetrex_player_name_changed", %{"value" => value}, socket) do
    game_id = socket.assigns.game_id

    if socket.assigns.can_edit_name and is_binary(game_id) do
      name = Store.sanitize_name(value)

      if name == "" do
        {:noreply, socket}
      else
        OwnershipStore.set_pending_name(game_id, name)

        if socket.assigns.leaderboard_saved do
          Store.update_player_name(game_id, name)
        end

        {:noreply, assign(socket, :player_name, name)}
      end
    else
      {:noreply, socket}
    end
  end

  defp normalize_game_payload(payload) when is_map(payload) do
    string_keys? = Enum.any?(payload, fn {k, _} -> is_binary(k) end)

    if string_keys? do
      %{
        score: payload["score"],
        lines: payload["lines"],
        level: payload["level"],
        status: payload["status"],
        next_type: payload["next_type"],
        cells: payload["cells"]
      }
    else
      %{
        score: payload[:score],
        lines: payload[:lines],
        level: payload[:level],
        status: payload[:status],
        next_type: payload[:next_type],
        cells: payload[:cells]
      }
    end
  end

  defp assign_game_from_payload(socket, payload) when is_map(payload) do
    score = Map.get(payload, :score) || 0
    lines = Map.get(payload, :lines) || 0

    level =
      case Map.get(payload, :level) do
        nil -> Tetrex.level_for_lines(lines)
        lv when is_integer(lv) -> lv
        _ -> Tetrex.level_for_lines(lines)
      end

    status =
      case Map.get(payload, :status) do
        nil -> :playing
        s when is_atom(s) -> s
        s -> decode_status(s)
      end

    next_type = Map.get(payload, :next_type)

    socket
    |> assign(:score, score)
    |> assign(:lines, lines)
    |> assign(:level, level)
    |> assign(:status, status)
    |> assign(:next_type, Tetrex.normalize_piece_type(next_type))
    |> assign(:preview_cells, Tetrex.preview_cells(Tetrex.normalize_piece_type(next_type)))
  end

  defp decode_status("game_over"), do: :game_over
  defp decode_status("playing"), do: :playing
  defp decode_status(:game_over), do: :game_over
  defp decode_status(:playing), do: :playing
  defp decode_status(_), do: :playing

  defp overlay_kind(assigns) do
    cond do
      assigns.source == nil -> :missing
      assigns.live_action == :replay -> nil
      play_board_loading?(assigns) -> :loading
      assigns[:syncing_results] -> :results_loading
      assigns.live_action == :show && assigns.source == :store -> :game_over
      assigns.live_action == :watch && assigns.status == :game_over -> :game_over
      assigns.live_action == :watch -> nil
      assigns.status == :game_over -> :game_over
      !assigns.started -> :start
      true -> nil
    end
  end

  defp play_board_loading?(assigns) do
    assigns.live_action == :new and assigns[:board_ready] != true
  end

  defp show_replay_link?(assigns) do
    is_binary(assigns.game_id) and Store.on_leaderboard?(assigns.game_id)
  end

  defp assign_watchers_count(socket) do
    if socket.assigns.source == :session and is_binary(socket.assigns.game_id) do
      assign(socket, :watchers_count, TetrexPresence.count_for_game(socket.assigns.game_id))
    else
      socket
    end
  end

  defp watchers_label(count) when is_integer(count) do
    ngettext("%{count} watcher", "%{count} watchers", count, count: count)
  end

  defp player_session?(socket) do
    socket.assigns[:source] == :session and socket.assigns.live_action in [:show, :new]
  end

  defp sql_sandbox?, do: Application.get_env(:corex_web, :sql_sandbox, false)

  defp board_mode(%{source: nil}), do: "view"
  defp board_mode(%{live_action: :replay}), do: "replay"
  defp board_mode(%{live_action: :watch}), do: "watch"
  defp board_mode(%{live_action: :show, source: :store}), do: "view"
  defp board_mode(_), do: "play"

  defp show_keyboard?(assigns) do
    assigns.live_action in [:show, :new] and assigns.source == :session
  end

  defp show_board?(assigns) do
    cond do
      assigns[:lv_connected] != true ->
        false

      is_nil(assigns.source) ->
        false

      assigns.live_action == :new ->
        false

      assigns.source == :session and assigns.live_action in [:show, :new] ->
        assigns[:board_ready] == true

      true ->
        true
    end
  end

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:overlay, overlay_kind(assigns))
      |> assign(:show_keyboard, show_keyboard?(assigns))

    ~H"""
    <Layouts.blog flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <div class="blog w-full">
        <div class="blog__inner w-full">
          <article
            id="tetrex-page"
            tabindex="0"
            dir="ltr"
            class="w-full max-w-5xl mx-auto flex flex-col gap-space-sm outline-none min-h-0 flex-1 focus:outline-none focus:ring-0"
          >
            <header class="flex items-center justify-between gap-space-sm shrink-0">
              <div class="flex items-center gap-space-sm min-w-0">
                <h1 class="font-display text-lg uppercase tracking-widest text-ui-ink m-0">Tetrex</h1>
                <.badge :if={@live_action == :watch && @source == :session} semantic="alert" size="sm">
                  {~t"LIVE"}
                </.badge>
                <.badge
                  :if={@source == :session && is_binary(@game_id)}
                  size="sm"
                  aria-live="polite"
                >
                  {watchers_label(@watchers_count)}
                </.badge>
                <.badge :if={@live_action == :replay} size="sm">{~t"Replay"}</.badge>
              </div>
              <.navigate to={~p"/showcases/tetrex"} semantic="accent" class="link text-sm shrink-0">
                {~t"Home"}
              </.navigate>
            </header>

            <div
              id="tetrex-cabinet"
              class="flex flex-col md:flex-row gap-space-sm md:gap-space items-stretch min-h-0 flex-1"
            >
              <div
                id="tetrex-board-wrap"
                class="flex-1 min-h-0 flex justify-center items-center w-full"
              >
                <div
                  id="tetrex-board-stage"
                  phx-hook="GameBoard"
                  data-mode={board_mode(assigns)}
                  data-board-ready={to_string(@board_ready)}
                  data-tick-ms={@tick_ms}
                  data-client={@client_json}
                  class="relative shrink-0 max-w-full max-h-full"
                >
                  <div
                    :if={show_board?(assigns)}
                    id="tetrex-board"
                    class="pointer-events-none absolute inset-0 border-2 border-border rounded-md p-0 bg-root overflow-hidden grid gap-0"
                    style={
                  "grid-template-columns: repeat(#{@cols}, minmax(0, 1fr)); grid-template-rows: repeat(#{@rows}, minmax(0, 1fr));"
                }
                    role="grid"
                    aria-label={~t"Game board"}
                  >
                    <.cell_checkbox
                      :for={{col, row} <- @cell_coords}
                      col={col}
                      row={row}
                      board_cells={@board_cells}
                    />
                  </div>

                  <.board_overlay
                    :if={@overlay}
                    overlay={@overlay}
                    score={@score}
                    game_id={@game_id}
                    live_action={@live_action}
                    source={@source}
                    leaderboard_saved={@leaderboard_saved}
                    show_replay_link={show_replay_link?(assigns)}
                    can_edit_name={@can_edit_name}
                    player_name={@player_name}
                  />

                  <.replay_end_overlay :if={@live_action == :replay && @source == :store} />
                </div>
              </div>

              <aside class="flex flex-col gap-1 md:gap-space-sm w-full md:min-w-56 md:w-56 shrink-0 min-h-0">
                <.tetrex_hud
                  score={@score}
                  level={@level}
                  lines={@lines}
                  preview_cells={@preview_cells}
                />

                <.touch_controls :if={@show_keyboard} />

                <.keyboard_controls :if={@show_keyboard} />

                <.replay_controls :if={@live_action == :replay && @source == :store} />
              </aside>
            </div>
          </article>
        </div>
      </div>
    </Layouts.blog>
    """
  end

  attr(:overlay, :atom, required: true)
  attr(:score, :integer, required: true)
  attr(:game_id, :string, required: true)
  attr(:live_action, :atom, required: true)
  attr(:source, :atom, required: true)
  attr(:leaderboard_saved, :boolean, default: false)
  attr(:show_replay_link, :boolean, default: false)
  attr(:can_edit_name, :boolean, default: false)
  attr(:player_name, :string, default: nil)

  defp board_overlay(%{overlay: :loading} = assigns) do
    ~H"""
    <div
      id="tetrex-overlay"
      class="absolute inset-0 z-[1] flex flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center"
      aria-live="polite"
      aria-busy="true"
    >
      <span class="ui-loading size-8" aria-hidden="true" />
      <p class="text-ui-ink-muted text-xs m-0">{~t"Loading game…"}</p>
    </div>
    """
  end

  defp board_overlay(%{overlay: :results_loading} = assigns) do
    ~H"""
    <div
      id="tetrex-overlay"
      class="absolute inset-0 z-[1] flex flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center"
      aria-live="polite"
      aria-busy="true"
    >
      <span class="ui-loading size-8" aria-hidden="true" />
      <p class="text-ui-ink-muted text-xs m-0">{~t"Loading results…"}</p>
    </div>
    """
  end

  defp board_overlay(%{overlay: :start} = assigns) do
    ~H"""
    <div
      id="tetrex-overlay"
      class="absolute inset-0 z-[1] flex flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center"
      aria-live="polite"
    >
      <p class="font-display text-lg uppercase tracking-widest text-ui-ink m-0">Tetrex</p>
      <p class="text-ui-ink-muted text-xs m-0">{~t"Clear rows. Beat your score."}</p>
      <.action phx-click="start_game" semantic="accent">
        {~t"Start"}
      </.action>
    </div>
    """
  end

  defp board_overlay(%{overlay: :game_over} = assigns) do
    ~H"""
    <div
      id="tetrex-overlay"
      class="absolute inset-0 z-[1] flex flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center"
      aria-live="polite"
    >
      <p class="font-display text-lg uppercase tracking-widest text-alert m-0">{~t"Game over"}</p>
      <p class="font-display text-2xl tabular-nums text-ui-ink-accent m-0 leading-tight">
        {String.pad_leading(Integer.to_string(@score), 6, "0")}
      </p>
      <p :if={@show_replay_link} class="text-ui-ink-muted text-sm m-0 max-w-xs">
        {~t"Congratulations! You are on the leaderboard."}
      </p>
      <.editable
        :if={@show_replay_link && @can_edit_name}
        id="tetrex-overlay-player-name"
        class="editable editable--size-sm w-full editable--max-w-xs"
        value={@player_name}
        placeholder={~t"Name"}
        on_value_change="tetrex_player_name_changed"
      >
        <:label class="sr-only">{~t"Name"}</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
      </.editable>
      <.navigate
        :if={@show_replay_link}
        to={~p"/showcases/tetrex/#{@game_id}/replay"}
        as="button"
      >
        {~t"Watch replay"}
      </.navigate>
      <.navigate to={~p"/showcases/tetrex/new"} as="button" semantic="accent" class="w-full max-w-xs">
        {~t"New game"}
      </.navigate>
    </div>
    """
  end

  defp board_overlay(%{overlay: :missing} = assigns) do
    ~H"""
    <div
      id="tetrex-overlay"
      class="absolute inset-0 z-[1] flex flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center"
      aria-live="polite"
    >
      <p class="font-display text-lg uppercase tracking-widest text-ui-ink m-0">
        {~t"Game unavailable"}
      </p>
      <p class="text-ui-ink-muted text-xs m-0">
        {~t"This game ended or was removed from the leaderboard."}
      </p>
      <.navigate to={~p"/showcases/tetrex"} as="button">
        {~t"Home"}
      </.navigate>
    </div>
    """
  end

  defp replay_end_overlay(assigns) do
    ~H"""
    <div
      id="tetrex-replay-end-overlay"
      class="absolute inset-0 z-[2] hidden"
      aria-live="polite"
      aria-hidden="true"
    >
      <div class="flex h-full flex-col items-center justify-center gap-space rounded-md bg-root/92 p-space text-center">
        <.action data-replay-action="watch-again" class="w-full max-w-xs">
          {~t"Watch again"}
        </.action>
      </div>
    </div>
    """
  end

  attr(:cell, :map, required: true)

  defp preview_tile(assigns) do
    assigns = assign(assigns, :tile_class, @preview_tile)

    ~H"""
    <div
      data-preview={"#{@cell.col}-#{@cell.row}"}
      class={[
        @tile_class,
        @cell.filled && @cell.theme && "checkbox--#{Tetrex.theme_name(@cell.theme)}"
      ]}
    >
      <div
        data-scope="checkbox"
        data-part="control"
        data-state={if @cell.filled, do: "checked", else: "unchecked"}
        class="w-full h-full min-h-0"
        aria-hidden="true"
      />
    </div>
    """
  end

  defp replay_controls(assigns) do
    ~H"""
    <div
      id="tetrex-replay-controls"
      class="flex flex-col gap-space-sm border-t border-border pt-space-sm"
    >
      <p class="text-ui-ink-muted text-xs uppercase tracking-wider m-0">{~t"Replay"}</p>
      <div class="flex flex-wrap items-center gap-1">
        <.toggle
          id="tetrex-replay-play"
          size="sm"
          pressed
          data-toggle-dual-label
          on_pressed_change_client="tetrex-replay-play-changed"
        >
          <span>
            <.heroicon name="hero-play" />
            <span class="sr-only">{~t"Play"}</span>
          </span>
          <span data-pressed>
            <.heroicon name="hero-pause" />
            <span class="sr-only">{~t"Pause"}</span>
          </span>
        </.toggle>
        <.action
          data-replay-action="restart"
          shape="square"
          radius="full"
          size="sm"
          aria_label={~t"Restart replay"}
        >
          <.heroicon name="hero-arrow-path" />
        </.action>
        <.action
          id="tetrex-replay-speed"
          data-replay-action="speed"
          size="sm"
          aria_label={~t"Replay speed"}
        >
          ×2
        </.action>
      </div>
    </div>
    """
  end

  attr(:score, :integer, required: true)
  attr(:level, :integer, required: true)
  attr(:lines, :integer, required: true)
  attr(:preview_cells, :list, required: true)

  defp tetrex_hud(assigns) do
    ~H"""
    <div class="flex flex-row md:flex-col items-center md:items-stretch justify-between gap-2 md:gap-space-sm w-full min-w-0 shrink-0">
      <div class="grid grid-cols-3 gap-x-2 gap-y-0 flex-1 min-w-0 md:grid-cols-2 md:gap-space-sm">
        <div>
          <p class="text-ui-ink-muted text-[0.65rem] md:text-xs uppercase tracking-wider m-0">
            {~t"Score"}
          </p>
          <p
            id="tetrex-score"
            class="font-display text-base md:text-xl tabular-nums text-ui-ink-accent m-0 leading-none md:leading-tight"
          >
            {String.pad_leading(Integer.to_string(@score), 6, "0")}
          </p>
        </div>
        <div>
          <p class="text-ui-ink-muted text-[0.65rem] md:text-xs uppercase tracking-wider m-0">
            {~t"Level"}
          </p>
          <p
            id="tetrex-level"
            class="font-display text-base md:text-xl tabular-nums text-ui-ink m-0 leading-none md:leading-tight"
          >
            {@level}
          </p>
        </div>
        <div class="md:col-span-2">
          <p class="text-ui-ink-muted text-[0.65rem] md:text-xs uppercase tracking-wider m-0">
            {~t"Lines"}
          </p>
          <p
            id="tetrex-lines"
            class="font-display text-sm md:text-lg tabular-nums text-ui-ink m-0 leading-none md:leading-tight"
          >
            {@lines}
          </p>
        </div>
      </div>

      <div class="shrink-0">
        <p class="text-ui-ink-muted text-[0.65rem] md:text-xs uppercase tracking-wider m-0 text-end md:text-start">
          {~t"Next"}
        </p>
        <div
          id="tetrex-next"
          class="border border-border rounded-md bg-root p-0.5 w-12 md:w-16 mt-0.5 ms-auto md:ms-0"
          aria-label={~t"Next piece"}
        >
          <div class="grid gap-px w-full" style="grid-template-columns: repeat(4, minmax(0, 1fr));">
            <.preview_tile :for={cell <- @preview_cells} cell={cell} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp touch_controls(assigns) do
    ~H"""
    <div
      id="tetrex-touch-controls"
      class="md:hidden flex flex-col gap-1 touch-manipulation select-none shrink-0 pb-[max(0px,env(safe-area-inset-bottom))]"
    >
      <p class="sr-only">{~t"Controls"}</p>
      <div class="grid grid-cols-3 gap-1.5 max-w-[10.5rem] mx-auto w-full">
        <.action
          type="button"
          data-tetrex-cmd="rotate"
          shape="square"
          radius="full"
          size="md"
          class="col-start-2"
          aria_label={~t"Rotate"}
        >
          <.heroicon name="hero-arrow-path" />
        </.action>
        <.action
          type="button"
          data-tetrex-cmd="left"
          shape="square"
          radius="full"
          size="md"
          class="col-start-1 row-start-2"
          aria_label={~t"Move left"}
        >
          <.heroicon name="hero-arrow-left" />
        </.action>
        <.action
          type="button"
          data-tetrex-cmd="down"
          shape="square"
          radius="full"
          size="md"
          class="col-start-2 row-start-2"
          aria_label={~t"Soft drop"}
        >
          <.heroicon name="hero-arrow-down" />
        </.action>
        <.action
          type="button"
          data-tetrex-cmd="right"
          shape="square"
          radius="full"
          size="md"
          class="col-start-3 row-start-2"
          aria_label={~t"Move right"}
        >
          <.heroicon name="hero-arrow-right" />
        </.action>
      </div>
    </div>
    """
  end

  defp keyboard_controls(assigns) do
    ~H"""
    <div class="hidden md:flex flex-col gap-space-sm border-t border-border pt-space-sm">
      <p class="text-ui-ink-muted text-xs uppercase tracking-wider m-0">{~t"Keyboard"}</p>
      <ul class="flex flex-col gap-1 m-0 p-0 list-none">
        <.keyboard_row keys={["←", "→"]} label={~t"Move"} />
        <.keyboard_row keys={["↓"]} label={~t"Soft drop"} />
        <.keyboard_row keys={["Space"]} label={~t"Rotate"} />
      </ul>
      <p class="text-xs text-ui-ink-muted m-0">{~t"Focus the game area, then play."}</p>
    </div>
    """
  end

  attr(:keys, :list, required: true)
  attr(:label, :string, required: true)

  defp keyboard_row(assigns) do
    ~H"""
    <li class="flex items-center justify-between gap-space-sm min-w-0">
      <span class="inline-flex flex-wrap items-center gap-1 shrink-0">
        <.badge :for={key <- @keys} size="sm" class="font-mono">{key}</.badge>
      </span>
      <span class="text-sm text-ui-ink-muted text-end">{@label}</span>
    </li>
    """
  end

  attr(:col, :integer, required: true)
  attr(:row, :integer, required: true)
  attr(:board_cells, :map, required: true)

  defp cell_checkbox(assigns) do
    cell = Map.get(assigns.board_cells, {assigns.col, assigns.row}, %{checked: false, theme: nil})

    assigns =
      assigns
      |> assign(:cell_id, Tetrex.cell_id(assigns.col, assigns.row))
      |> assign(:checked, cell.checked)
      |> assign(:cell_class, cell_checkbox_class(cell.checked, cell.theme))

    ~H"""
    <.checkbox
      id={@cell_id}
      checked={@checked}
      orientation="vertical"
      class={@cell_class}
      aria_label={"cell-#{@col}-#{@row}"}
    />
    """
  end

  defp cell_checkbox_class(false, _), do: @tile_base
  defp cell_checkbox_class(true, nil), do: @tile_base

  defp cell_checkbox_class(true, theme) when not is_nil(theme) do
    @tile_base <> " checkbox--#{Tetrex.theme_name(theme)}"
  end
end
