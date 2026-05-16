defmodule E2eWeb.PaginationEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.PaginationDemo, as: Demo

  @id_server "pagination-events-server"
  @id_client "pagination-events-client"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_server, @id_server)
     |> assign(:id_client, @id_client)
     |> assign(:server_heex, Demo.events_server_heex())
     |> assign(:server_elixir, Demo.events_server_elixir())
     |> assign(:client_heex, Demo.events_client_heex())
     |> assign(:client_js, Demo.events_client_js())
     |> assign(:client_ts, Demo.events_client_ts())
     |> stream(:server_logs, [])}
  end

  @impl true
  def handle_event("pagination_page_changed", %{"id" => id, "page" => page} = params, socket) do
    log = new_log("server", id, inspect(%{page: page, params: params}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  defp new_log(source, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      dom_id: dom_id,
      value: value
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="pagination-events-page"
        title="Pagination · Events"
        subtitle="Subscribe to page changes from LiveView or the client."
      >
        <.demo_section
          id="pagination-events-server-section"
          title="On page change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.pagination
                id={@id_server}
                class="pagination"
                count={95}
                page_size={10}
                on_page_change="pagination_page_changed"
              >
                <:prev><.heroicon name="hero-chevron-left" /></:prev>
                <:next><.heroicon name="hero-chevron-right" /></:next>
                <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
              </.pagination>

              <.data_table
                id="pagination-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Change page to log events.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="pagination-events-client-section"
          title="On page change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <.pagination
              id={@id_client}
              class="pagination"
              count={95}
              page_size={10}
              on_page_change_client="pagination-page-changed"
            >
              <:prev><.heroicon name="hero-chevron-left" /></:prev>
              <:next><.heroicon name="hero-chevron-right" /></:next>
              <:ellipsis><.heroicon name="hero-ellipsis-horizontal" /></:ellipsis>
            </.pagination>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
