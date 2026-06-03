defmodule E2eWeb.MenuEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  import E2eWeb.Demos.MenuDemo, only: [events_binding_example: 1]

  alias E2eWeb.Demos.MenuDemo, as: Demo

  @id_server "menu-events-server"
  @id_client "menu-events-client"

  @server_heex Demo.events_server_heex()
  @server_elixir Demo.events_server_elixir()
  @client_heex Demo.events_client_heex()
  @client_js Demo.events_client_js()
  @client_ts Demo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:menu_items, Demo.demo_leaf_items())
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> assign(:binding_heex, Demo.events_binding_code())
      |> assign(:binding_elixir, Demo.events_binding_elixir())
      |> stream(:bind_logs, [])
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("menu_bind_open", %{"open" => open, "id" => id}, socket) do
    log = new_log("binding", id, inspect(%{kind: "open_changed", open: open}))
    {:noreply, stream_insert(socket, :bind_logs, log, at: 0)}
  end

  def handle_event("menu_bind_selected", %{"value" => value, "id" => id}, socket) do
    log = new_log("binding", id, inspect(%{kind: "selected", value: value}))
    {:noreply, stream_insert(socket, :bind_logs, log, at: 0)}
  end

  def handle_event("menu_open_changed", %{"open" => open, "id" => id}, socket) do
    log = new_log("server", id, inspect(%{kind: "open_changed", open: open}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("menu_selected", %{"value" => value, "id" => id}, socket) do
    log = new_log("server", id, inspect(%{kind: "selected", value: value}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("menu_open_client_changed", %{"open" => open, "id" => id}, socket) do
    log = new_log("client", id, inspect(%{kind: "open_changed", open: open}))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  def handle_event("menu_selected_client", %{"value" => value, "id" => id}, socket) do
    log = new_log("client", id, inspect(%{kind: "selected", value: value}))
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
        id="menu-events-page"
        title={~t"Menu · Events"}
        subtitle={
          ~t"Declarative LiveView attrs, server pushEvent logs, and client CustomEvent listeners."
        }
      >
        <.demo_section
          id="menu-events-binding"
          title={~t"Binding (Heex attrs)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @binding_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @binding_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.events_binding_example />
              <.data_table
                id="menu-events-log-bind"
                class="data-table data-table--max-w-3xl"
                rows={@streams.bind_logs}
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
          id="menu-events-server-section"
          title={~t"Server (Heex + Elixir)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.menu
                id={@id_server}
                on_select="menu_selected"
                on_open_change="menu_open_changed"
                items={@menu_items}
              >
                <:trigger>Corex</:trigger>
                <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
              </.menu>

              <.data_table
                id="menu-events-log-server"
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
          id="menu-events-client-section"
          title={~t"Client (Heex + JS + TS)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.menu
                id={@id_client}
                on_select_client="menu-item-selected"
                on_open_change_client="menu-open-changed"
                items={@menu_items}
              >
                <:trigger>Corex</:trigger>
                <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
              </.menu>

              <div
                id="menu-events-client-listener"
                class="w-full"
                phx-hook=".MenuEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".MenuEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("menu:menu-events-client");
                      if (!el) return;
                      el.addEventListener("menu-open-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("menu_open_client_changed", {
                          id: d?.id ?? "menu-events-client",
                          open: d?.open ?? null,
                        });
                      });
                      el.addEventListener("menu-item-selected", (event) => {
                        const d = event.detail;
                        const value = d?.value ?? null;
                        this.pushEvent("menu_selected_client", {
                          id: d?.id ?? "menu-events-client",
                          value,
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="menu-events-log-client"
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
