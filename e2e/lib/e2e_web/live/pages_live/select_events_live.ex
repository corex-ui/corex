defmodule E2eWeb.SelectEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @items [
    %{label: "France", value: "fra"},
    %{label: "Belgium", value: "bel"},
    %{label: "Germany", value: "deu"}
  ]

  @server_heex E2eWeb.Demos.SelectDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.SelectDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.SelectDemo.events_client_heex()
  @client_js E2eWeb.Demos.SelectDemo.events_client_js()
  @client_ts E2eWeb.Demos.SelectDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:items, @items)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("select_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("select_client_changed", %{"id" => id, "value" => value}, socket) do
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
        id="select-events-page"
        title={~t"Select · Event"}
        subtitle={
          ~t"Subscribe to value changes from LiveView (on_value_change) or the client (CustomEvent and hook)."
        }
      >
        <.demo_section
          id="select-events-server-section"
          title={~t"On Value Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.select
                id="select-events-server"
                class="select"
                items={@items}
                translation={%Corex.Select.Translation{placeholder: "Select"}}
                on_value_change="select_changed"
              >
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.select>

              <.data_table
                id="select-events-log-server"
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
          id="select-events-client-section"
          title={~t"On Value Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.select
                id="select-events-client"
                class="select"
                items={@items}
                translation={%Corex.Select.Translation{placeholder: "Select"}}
                on_value_change_client="select-changed"
              >
                <:trigger><.heroicon name="hero-chevron-down" class="icon" /></:trigger>
              </.select>

              <div
                id="select-events-client-listener"
                class="w-full"
                phx-hook=".SelectEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".SelectEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("select-events-client");
                      if(!el) return;
                      el.addEventListener("select-changed", (event) => {
                        const d = event.detail ?? {};
                        const value = Array.isArray(d.value) ? d.value : [];
                        this.pushEvent("select_client_changed", { id: d.id, value });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="select-events-log-client"
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
