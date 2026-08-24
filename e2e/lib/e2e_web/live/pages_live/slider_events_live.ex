defmodule E2eWeb.SliderEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server_change "events-slider-on-value-change-server"
  @id_server_end "events-slider-on-value-change-end-server"
  @id_client_change "events-slider-on-value-change-client"
  @id_client_end "events-slider-on-value-change-end-client"
  @client_event_change "slider-changed"
  @client_event_end "slider-change-ended"

  @server_heex E2eWeb.Demos.SliderDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.SliderDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.SliderDemo.events_client_heex()
  @client_js E2eWeb.Demos.SliderDemo.events_client_js()
  @client_ts E2eWeb.Demos.SliderDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server_change, @id_server_change)
      |> assign(:id_server_end, @id_server_end)
      |> assign(:id_client_change, @id_client_change)
      |> assign(:id_client_end, @id_client_end)
      |> assign(:client_event_change, @client_event_change)
      |> assign(:client_event_end, @client_event_end)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("slider_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("server:on_value_change", id, value)
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("slider_change_ended", %{"id" => id, "value" => value}, socket) do
    log = new_log("server:on_value_change_end", id, value)
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("slider_client_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("client", id, value)
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
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
        id="slider-events-page"
        title={~t"Slider · Event"}
        subtitle={~t"Subscribe to value changes and change-end events from LiveView or the client."}
      >
        <.demo_section
          id="slider-events-server"
          title={~t"On Value Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <div class="flex flex-wrap gap-space-xl justify-center w-full">
                <.slider
                  id={@id_server_change}
                  class="slider"
                  marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
                  on_value_change="slider_changed"
                >
                  <:label>On Change</:label>
                </.slider>

                <.slider
                  id={@id_server_end}
                  class="slider"
                  marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
                  value={50.0}
                  on_value_change_end="slider_change_ended"
                >
                  <:label>On End</:label>
                </.slider>
              </div>

              <.data_table
                id="slider-events-log-server"
                class="data-table max-w-4xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="slider-events-client"
          title={~t"On Value Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <div class="flex flex-wrap gap-space-xl justify-center w-full">
                <.slider
                  id={@id_client_change}
                  class="slider"
                  marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
                  on_value_change_client={@client_event_change}
                >
                  <:label>On Change</:label>
                </.slider>

                <.slider
                  id={@id_client_end}
                  class="slider"
                  marker_values={[0.0, 25.0, 50.0, 75.0, 100.0]}
                  value={50.0}
                  on_value_change_end_client={@client_event_end}
                >
                  <:label>On End</:label>
                </.slider>
              </div>

              <div
                id="slider-events-client-listener"
                class="w-full"
                phx-hook=".SliderEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".SliderEventsClient">
                  export default {
                    mounted() {
                      const attach = (id, event) => {
                        const el = document.getElementById(id);
                        if(!el) return;
                        el.addEventListener(event, (e) => {
                          const d = e.detail;
                          this.pushEvent("slider_client_changed", d);
                        });
                      };
                      attach("events-slider-on-value-change-client", "slider-changed");
                      attach("events-slider-on-value-change-end-client", "slider-change-ended");
                    }
                  }
                </script>
              </div>

              <.data_table
                id="slider-events-log-client"
                class="data-table max-w-4xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.source}</:col>
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

  defp new_log(source, slider_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      slider_id: slider_id,
      value: inspect(value)
    }
  end
end
