defmodule E2eWeb.ComboboxEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @items [
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"}
  ]

  @server_heex E2eWeb.Demos.ComboboxDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.ComboboxDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.ComboboxDemo.events_client_heex()
  @client_js E2eWeb.Demos.ComboboxDemo.events_client_js()
  @client_ts E2eWeb.Demos.ComboboxDemo.events_client_ts()
  @open_server_heex E2eWeb.Demos.ComboboxDemo.events_open_server_heex()
  @open_server_elixir E2eWeb.Demos.ComboboxDemo.events_open_server_elixir()
  @open_client_heex E2eWeb.Demos.ComboboxDemo.events_open_client_heex()
  @open_client_js E2eWeb.Demos.ComboboxDemo.events_open_client_js()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:items, Corex.List.new(@items))
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> assign(:open_server_heex, @open_server_heex)
      |> assign(:open_server_elixir, @open_server_elixir)
      |> assign(:open_client_heex, @open_client_heex)
      |> assign(:open_client_js, @open_client_js)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])
      |> stream(:open_server_logs, [])
      |> stream(:open_client_logs, [])

    {:ok, socket}
  end

  def handle_event("combobox_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("combobox_client_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("client", id, inspect(value))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  def handle_event("combobox_open_changed", params, socket) do
    log = new_log("server-open", params["id"] || "", inspect(params))
    {:noreply, stream_insert(socket, :open_server_logs, log, at: 0)}
  end

  def handle_event("combobox_open_client_changed", %{"id" => id, "payload" => payload}, socket) do
    log = new_log("client-open", id, inspect(payload))
    {:noreply, stream_insert(socket, :open_client_logs, log, at: 0)}
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
        id="combobox-events-page"
        title={~t"Combobox · Event"}
        subtitle={~t"Subscribe to value changes from LiveView or the client."}
      >
        <.demo_section
          id="combobox-events-server-doc"
          title={~t"On Value Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.combobox
                id="combobox-events-server-field"
                class="combobox"
                placeholder={~t"Select"}
                items={@items}
                on_value_change="combobox_changed"
              >
                <:empty>No results</:empty>
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.combobox>

              <.data_table
                id="combobox-events-log-server"
                class="data-table max-w-3xl"
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
          id="combobox-events-client-doc"
          title={~t"On Value Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.combobox
                id="combobox-events-client-field"
                class="combobox"
                placeholder={~t"Select"}
                items={@items}
                on_value_change_client="combobox-changed"
              >
                <:empty>No results</:empty>
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.combobox>

              <div
                id="combobox-events-client-listener"
                class="w-full"
                phx-hook=".ComboboxEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".ComboboxEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("combobox-events-client-field");
                      if(!el) return;
                      el.addEventListener("combobox-changed", (event) => {
                        const d = event.detail;
                        const inner = d.value && typeof d.value === "object" && "value" in d.value ? d.value.value : d.value;
                        this.pushEvent("combobox_client_changed", { id: d.id, value: inner });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="combobox-events-log-client"
                class="data-table max-w-3xl"
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

        <.demo_section
          id="combobox-events-open-server-doc"
          title={~t"On Open Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @open_server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @open_server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.combobox
                id="combobox-events-open-server-field"
                class="combobox"
                placeholder={~t"Select"}
                items={@items}
                on_open_change="combobox_open_changed"
              >
                <:empty>No results</:empty>
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.combobox>

              <.data_table
                id="combobox-events-open-log-server"
                class="data-table max-w-3xl"
                rows={@streams.open_server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="combobox-events-open-client-doc"
          title={~t"On Open Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @open_client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @open_client_js}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.combobox
                id="combobox-events-open-client-field"
                class="combobox"
                placeholder={~t"Select"}
                items={@items}
                on_open_change_client="combobox-open-changed"
              >
                <:empty>No results</:empty>
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.combobox>

              <div
                id="combobox-events-open-client-listener"
                class="w-full"
                phx-hook=".ComboboxEventsOpenClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".ComboboxEventsOpenClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("combobox-events-open-client-field");
                      if (!el) return;
                      el.addEventListener("combobox-open-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("combobox_open_client_changed", {
                          id: d.id,
                          payload: d,
                        });
                      });
                    },
                  };
                </script>
              </div>

              <.data_table
                id="combobox-events-open-log-client"
                class="data-table max-w-3xl"
                rows={@streams.open_client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet.</p>
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
