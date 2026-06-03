defmodule E2eWeb.FloatingPanelEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "fp-events-server"
  @id_client "fp-events-client"

  @server_heex E2eWeb.Demos.FloatingPanelDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.FloatingPanelDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.FloatingPanelDemo.events_client_heex()
  @client_js E2eWeb.Demos.FloatingPanelDemo.events_client_js()
  @client_ts E2eWeb.Demos.FloatingPanelDemo.events_client_ts()

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("floating_panel_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :server_logs, new_log("server", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("floating_panel_open_client", %{"id" => id, "open" => open}, socket) do
    {:noreply, stream_insert(socket, :client_logs, new_log("client", id, inspect(open)), at: 0)}
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
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        path={@path}
        id="floating-panel-events-page"
        title="Floating Panel · Events"
        subtitle="Subscribe to open changes from LiveView or the client."
      >
        <.demo_section
          id="floating-panel-events-server-section"
          title="On Open Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.floating_panel
                id={@id_server}
                on_open_change="floating_panel_open_changed"
              >
                <:trigger>
                  <span data-closed>Open panel</span>
                  <span data-open>Close panel</span>
                </:trigger>
                <:title>Panel</:title>
                <:minimize_trigger>
                  <.heroicon name="hero-arrow-down-left" />
                </:minimize_trigger>
                <:maximize_trigger>
                  <.heroicon name="hero-arrows-pointing-out" />
                </:maximize_trigger>
                <:default_trigger>
                  <.heroicon name="hero-rectangle-stack" />
                </:default_trigger>
                <:close_trigger>
                  <.heroicon name="hero-x-mark" />
                </:close_trigger>
                <:content>
                  <p>Lorem ipsum dolor sit amet.</p>
                </:content>
              </.floating_panel>

              <.data_table
                id="floating-panel-events-log-server"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="floating-panel-events-client-section"
          title="On Open Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.floating_panel
                id={@id_client}
                on_open_change_client="floating-panel-open-changed"
              >
                <:trigger>
                  <span data-closed>Open panel</span>
                  <span data-open>Close panel</span>
                </:trigger>
                <:title>Panel</:title>
                <:minimize_trigger>
                  <.heroicon name="hero-arrow-down-left" />
                </:minimize_trigger>
                <:maximize_trigger>
                  <.heroicon name="hero-arrows-pointing-out" />
                </:maximize_trigger>
                <:default_trigger>
                  <.heroicon name="hero-rectangle-stack" />
                </:default_trigger>
                <:close_trigger>
                  <.heroicon name="hero-x-mark" />
                </:close_trigger>
                <:content>
                  <p>Lorem ipsum dolor sit amet.</p>
                </:content>
              </.floating_panel>

              <div
                id="floating-panel-events-client-listener"
                class="w-full"
                phx-hook=".FloatingPanelEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".FloatingPanelEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("fp-events-client")
                      if (!el) return
                      el.addEventListener("floating-panel-open-changed", (event) => {
                        const d = event.detail
                        this.pushEvent("floating_panel_open_client", {
                          id: d?.id ?? "fp-events-client",
                          open: d?.open
                        })
                      })
                    },
                  }
                </script>
              </div>

              <.data_table
                id="floating-panel-events-log-client"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
