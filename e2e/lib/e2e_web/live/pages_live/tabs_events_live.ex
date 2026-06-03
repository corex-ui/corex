defmodule E2eWeb.TabsEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "tabs-events-server"
  @id_client "tabs-events-client"

  @server_heex E2eWeb.Demos.TabsDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.TabsDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.TabsDemo.events_client_heex()
  @client_js E2eWeb.Demos.TabsDemo.events_client_js()
  @client_ts E2eWeb.Demos.TabsDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:items, E2eWeb.Demos.TabsDemo.basic_items())
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("tabs_value_changed", %{"value" => value, "id" => id}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("tabs_client_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("client", id, inspect(value))
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
        id="tabs-events-page"
        title={~t"Tabs · Events"}
        subtitle={~t"Subscribe to value changes from LiveView or the client."}
      >
        <.demo_section
          id="tabs-events-server-section"
          title={~t"On value change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tabs
                id={@id_server}
                class="tabs w-full"
                value="lorem"
                on_value_change="tabs_value_changed"
                items={@items}
              />

              <.data_table
                id="tabs-events-log-server"
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
          id="tabs-events-client-section"
          title={~t"On value change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tabs
                id={@id_client}
                class="tabs w-full"
                value="lorem"
                on_value_change_client="tabs-value-changed"
                items={@items}
              />

              <div
                id="tabs-events-client-listener"
                class="w-full"
                phx-hook=".TabsEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".TabsEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("tabs-events-client");
                      if (!el) return;
                      el.addEventListener("tabs-value-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("tabs_client_changed", {
                          id: d?.id ?? "tabs-events-client",
                          value: d?.value ?? null,
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="tabs-events-log-client"
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
