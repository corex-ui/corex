defmodule E2eWeb.PinInputEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @server_heex E2eWeb.Demos.PinInputDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.PinInputDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.PinInputDemo.events_client_heex()
  @client_js E2eWeb.Demos.PinInputDemo.events_client_js()
  @client_ts E2eWeb.Demos.PinInputDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("pin_input_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("pin_input_client_changed", %{"id" => id, "value" => value}, socket) do
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
        id="pin-input-events-page"
        title="Pin Input · Event"
        subtitle="Subscribe to value changes from the server or a DOM listener."
      >
        <.demo_section
          id="pin-input-events-server-section"
          title="On Value Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.pin_input
                id="pin-input-events-server"
                count={4}
                class="pin-input"
                on_value_change="pin_input_changed"
              >
                <:label>Code</:label>
              </.pin_input>

              <.data_table
                id="pin-input-events-log-server"
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
          id="pin-input-events-client-section"
          title="On Value Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.pin_input
                id="pin-input-events-client"
                count={4}
                class="pin-input"
                on_value_change_client="pin-input-changed"
              >
                <:label>Code</:label>
              </.pin_input>

              <div
                id="pin-input-events-client-listener"
                class="w-full"
                phx-hook=".PinInputEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".PinInputEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("pin-input-events-client");
                      if(!el) return;
                      el.addEventListener("pin-input-changed", (event) => {
                        const d = event.detail;
                        const inner = d.value && typeof d.value === "object" && "value" in d.value ? d.value.value : d.value;
                        this.pushEvent("pin_input_client_changed", { id: d.id, value: inner });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="pin-input-events-log-client"
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
