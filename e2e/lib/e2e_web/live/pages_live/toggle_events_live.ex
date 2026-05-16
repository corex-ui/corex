defmodule E2eWeb.ToggleEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "toggle-on-pressed-change-server"
  @id_client "toggle-on-pressed-change-client"
  @client_event "toggle-client-changed"

  @server_heex E2eWeb.Demos.ToggleDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.ToggleDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.ToggleDemo.events_client_heex()
  @client_js E2eWeb.Demos.ToggleDemo.events_client_js()
  @client_ts E2eWeb.Demos.ToggleDemo.events_client_ts()

  @impl true
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
      |> assign(:pressed, false)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_pressed_changed", %{"pressed" => pressed}, socket) do
    p = pressed == true or pressed == "true"
    log = new_log("server", @id_server, p)
    {:noreply, socket |> assign(:pressed, p) |> stream_insert(:server_logs, log, at: 0)}
  end

  @impl true
  def handle_event("toggle_client_changed", %{"id" => id, "pressed" => pressed}, socket) do
    p = pressed == true or pressed == "true"
    log = new_log("client", id, p)
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  defp new_log(source, id, pressed) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      toggle_id: id,
      value: inspect(pressed)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        id="toggle-events-page"
        title="Toggle · Event"
        subtitle="lorem, duis, donec: pressed changes from LiveView or the client."
      >
        <.demo_section
          id="toggle-events-server-section"
          title="On pressed change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.toggle
                id={@id_server}
                class="toggle"
                controlled
                pressed={@pressed}
                on_pressed_change="toggle_pressed_changed"
              >
                lorem
              </.toggle>

              <.data_table
                id="toggle-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Toggle id">{row.toggle_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="toggle-events-client-section"
          title="On pressed change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div
                id="toggle-events-client-wrap"
                class="w-full"
                phx-hook=".ToggleEventsClient"
                phx-update="ignore"
                data-toggle-client-id={@id_client}
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".ToggleEventsClient">
                  export default {
                    mounted() {
                      const id = this.el.dataset.toggleClientId;
                      const el = id ? document.getElementById(id) : null;
                      el?.addEventListener("toggle-client-changed", (e) => {
                        this.pushEvent("toggle_client_changed", {
                          id: e.detail.id,
                          pressed: e.detail.pressed,
                        });
                      });
                    },
                  };
                </script>
                <.toggle id={@id_client} class="toggle" on_pressed_change_client={@client_event}>
                  lorem
                </.toggle>
              </div>

              <.data_table
                id="toggle-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Toggle id">{row.toggle_id}</:col>
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
