defmodule E2eWeb.TetrexIndexLive do
  use E2eWeb, :live_view

  import E2eWeb.ListingPage

  alias E2e.Tetrex.Game
  alias E2e.Tetrex.Names
  alias E2e.Tetrex.Registry
  alias E2e.Tetrex.Store
  alias E2eWeb.TetrexOwnership
  alias E2eWeb.TetrexPresence

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(E2e.PubSub, Registry.sessions_topic())
      Phoenix.PubSub.subscribe(E2e.PubSub, Store.leaderboard_topic())
      Phoenix.PubSub.subscribe(E2e.PubSub, TetrexPresence.lobby_topic())
    end

    {:ok,
     socket
     |> TetrexOwnership.assign_owned(session)
     |> assign(:page_title, ~t"Tetrex")
     |> assign(
       :seo,
       E2eWeb.SEO.new(
         title: ~t"Tetrex",
         description: ~t"Checkbox Tetris — play, watch, and replay."
       )
     )
     |> assign_leaderboard_and_live(Registry.list_active(), Store.list_top())}
  end

  @impl true
  def handle_info({:sessions, sessions}, socket) do
    {:noreply, refresh_live_rows(socket, sessions)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", topic: topic}, socket) do
    if topic == TetrexPresence.lobby_topic() do
      {:noreply, refresh_live_rows(socket)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:leaderboard_updated, socket) do
    leaderboard = Store.list_top()

    {:noreply,
     socket
     |> assign(:leaderboard, leaderboard)
     |> assign(:leaderboard_rows, leaderboard_rows(leaderboard, socket.assigns.owned_game_ids))}
  end

  @impl true
  def handle_event("tetrex_player_name_changed", %{"id" => id, "value" => value}, socket) do
    game_id = String.replace_prefix(id, "tetrex-player-", "")

    if game_id != id and TetrexOwnership.owned?(socket.assigns.owned_game_ids, game_id) do
      name = Store.sanitize_name(value)

      if name == "" do
        {:noreply, socket}
      else
        case Store.update_player_name(game_id, name) do
          :ok -> {:noreply, apply_player_name(socket, game_id, name)}
          :error -> {:noreply, socket}
        end
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.blog flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <div id="tetrex-index-page" class="blog">
        <div class="blog__inner">
          <header class="blog__hero" aria-labelledby="tetrex-index-heading">
            <div class="flex items-start justify-between gap-space w-full max-w-none">
              <div class="blog__head min-w-0">
                <p class="blog__eyebrow">{~t"Checkbox Tetris"}</p>
                <h1 id="tetrex-index-heading" class="blog__display">
                  {~t"Tetrex"}
                </h1>
                <p class="blog__lede">
                  {~t"Play on the board, watch live games, or replay top scores from the leaderboard."}
                </p>
              </div>
              <.navigate to={~p"/showcases/tetrex/new"} as="button" semantic="accent" class="shrink-0">
                {~t"New game"}
              </.navigate>
            </div>
          </header>
        </div>

        <section class="blog__listing flex flex-col gap-size" aria-label={~t"Tetrex tables"}>
          <div class="blog__inner flex flex-col gap-size">
            <.listing_section_heading
              title={~t"Leaderboard"}
              subtitle={~t"Top 10 by score. Edit your name on rows from games you played."}
            />
            <.data_table
              id="tetrex-leaderboard"
              class="data-table data-table--max-w-none"
              rows={@leaderboard_rows}
            >
              <:col :let={row} label={~t"Rank"}>{row.rank}</:col>
              <:col :let={row} label={~t"Name"}>
                <.player_name_cell row={row} />
              </:col>
              <:col :let={row} label={~t"Score"}>
                <span class="font-display tabular-nums text-ui-ink-accent">{row.score_label}</span>
              </:col>
              <:col :let={row} label={~t"Ended"}>{row.ended_label}</:col>
              <:action :let={row}>
                <.navigate to={~p"/showcases/tetrex/#{row.id}/replay"} as="button">
                  {~t"Replay"}
                </.navigate>
              </:action>
              <:empty>
                <p class="text-ui-ink-muted m-0">{~t"No finished games yet — start a new game."}</p>
              </:empty>
            </.data_table>

            <.listing_section_heading
              title={~t"Live now"}
              subtitle={~t"Games in progress. Click Watch or use the action."}
            />
            <.data_table
              id="tetrex-live"
              class="data-table data-table--max-w-none"
              rows={@live_rows}
              row_click={fn row -> JS.navigate(~p"/showcases/tetrex/#{row.id}/watch") end}
            >
              <:col :let={row} label={~t"Game"}>
                <span class="font-mono text-sm">{row.id}</span>
              </:col>
              <:col :let={row} label={~t"Score"}>
                <span class="font-display tabular-nums">{row.score_label}</span>
              </:col>
              <:col :let={row} label={~t"Status"}>{row.status_label}</:col>
              <:col :let={row} label={~t"Watchers"}>
                <span class="font-display tabular-nums">{row.watchers_count}</span>
              </:col>
              <:action :let={row}>
                <.navigate to={~p"/showcases/tetrex/#{row.id}/watch"} as="button">
                  {~t"Watch"}
                </.navigate>
              </:action>
              <:empty>
                <p class="text-ui-ink-muted m-0">{~t"No live games — start Tetrex."}</p>
              </:empty>
            </.data_table>
          </div>
        </section>
      </div>
    </Layouts.blog>
    """
  end

  defp assign_leaderboard_and_live(socket, sessions, leaderboard) do
    owned = socket.assigns.owned_game_ids

    socket
    |> assign(:leaderboard, leaderboard)
    |> assign(:leaderboard_rows, leaderboard_rows(leaderboard, owned))
    |> refresh_live_rows(sessions)
  end

  defp refresh_live_rows(socket, _sessions \\ nil) do
    watcher_counts = TetrexPresence.counts_by_game()
    score_by_id = Map.new(Registry.list_active(), &{&1.id, &1})

    rows =
      TetrexPresence.live_player_game_ids()
      |> Enum.map(fn id ->
        case Map.get(score_by_id, id) do
          %{score: score, status: status} -> %{id: id, score: score, status: status}
          _ -> %{id: id, score: 0, status: :playing}
        end
      end)

    assign(socket, :live_rows, live_rows(rows, watcher_counts))
  end

  attr(:row, :map, required: true)

  defp player_name_cell(%{row: %{can_edit_name: true}} = assigns) do
    ~H"""
    <.editable
      id={"tetrex-player-#{@row.id}"}
      class="editable editable--size-sm"
      value={@row.player_name}
      placeholder={~t"Name"}
      on_value_change="tetrex_player_name_changed"
    >
      <:label class="sr-only">{~t"Name"}</:label>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
    """
  end

  defp player_name_cell(assigns) do
    ~H"""
    <span class="font-medium text-ui-ink">{@row.player_name}</span>
    """
  end

  defp apply_player_name(socket, game_id, name) do
    leaderboard =
      Enum.map(socket.assigns.leaderboard, fn
        %Game{id: ^game_id} = entry -> %{entry | player_name: name}
        entry -> entry
      end)

    socket
    |> assign(:leaderboard, leaderboard)
    |> assign(:leaderboard_rows, leaderboard_rows(leaderboard, socket.assigns.owned_game_ids))
  end

  defp leaderboard_rows(entries, owned) do
    Enum.with_index(entries, 1)
    |> Enum.map(fn {entry, rank} ->
      %{
        id: entry.id,
        rank: rank,
        player_name: Names.display(entry.player_name),
        can_edit_name: TetrexOwnership.owned?(owned, entry.id),
        score: entry.score,
        score_label: String.pad_leading(Integer.to_string(entry.score), 6, "0"),
        ended_label: format_ended_at(entry.ended_at)
      }
    end)
  end

  defp live_rows(sessions, watcher_counts) when is_map(watcher_counts) do
    Enum.map(sessions, fn session ->
      %{
        id: session.id,
        score: session.score,
        score_label: Integer.to_string(session.score),
        status: session.status,
        status_label: status_label(session.status),
        watchers_count: Map.get(watcher_counts, session.id, 0)
      }
    end)
  end

  defp format_ended_at(nil), do: "—"

  defp format_ended_at(%DateTime{} = dt),
    do: Calendar.strftime(dt, "%Y-%m-%d %H:%M")

  defp format_ended_at(_), do: "—"

  defp status_label(:playing), do: ~t"Playing"
  defp status_label(:game_over), do: ~t"Game over"
  defp status_label(_), do: ~t"Unknown"
end
