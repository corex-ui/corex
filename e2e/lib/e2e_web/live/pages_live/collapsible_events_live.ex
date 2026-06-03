defmodule E2eWeb.CollapsibleEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "collapsible-events-server"
  @id_client "collapsible-events-client"
  @client_event "collapsible-open-changed"

  @server_heex E2eWeb.Demos.CollapsibleDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.CollapsibleDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.CollapsibleDemo.events_client_heex()
  @client_js E2eWeb.Demos.CollapsibleDemo.events_client_js()
  @client_ts E2eWeb.Demos.CollapsibleDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:client_event, @client_event)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("collapsible_open_changed", %{"id" => id, "open" => open}, socket) do
    log = new_log("server", id, inspect(open))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("collapsible_client_open_changed", %{"id" => id, "open" => open}, socket) do
    log = new_log("client", id, inspect(open))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
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
        id="collapsible-events-page"
        title={~t"Collapsible · Event"}
        subtitle={~t"Subscribe to open changes from LiveView or the client."}
      >
        <.demo_section
          id="collapsible-events-server-section"
          title={~t"On Open Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.collapsible
                id={@id_server}
                on_open_change="collapsible_open_changed"
              >
                <:trigger>Toggle</:trigger>
                <:closed>
                  <.heroicon name="hero-chevron-right" />
                </:closed>
                <:content>Lorem ipsum dolor sit amet.</:content>
              </.collapsible>

              <.data_table
                id="collapsible-events-log-server"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="collapsible-events-client-section"
          title={~t"On Open Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.collapsible
                id={@id_client}
                on_open_change_client={@client_event}
              >
                <:trigger>Toggle</:trigger>
                <:closed>
                  <.heroicon name="hero-chevron-right" />
                </:closed>
                <:content>Lorem ipsum dolor sit amet.</:content>
              </.collapsible>

              <div
                id="collapsible-events-client-listener"
                class="w-full"
                phx-hook=".CollapsibleEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".CollapsibleEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("collapsible-events-client");
                      if (!el) return;
                      el.addEventListener("{@client_event}", (e) => {
                        const d = e.detail ?? {};
                        this.pushEvent("collapsible_client_open_changed", {
                          id: d.id,
                          open: d.open,
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="collapsible-events-log-client"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
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
