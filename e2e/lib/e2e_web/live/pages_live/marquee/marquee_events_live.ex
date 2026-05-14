defmodule E2eWeb.MarqueeEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "marquee-events-server"
  @id_client "marquee-events-client"

  @server_heex E2eWeb.Demos.MarqueeDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.MarqueeDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.MarqueeDemo.events_client_heex()
  @client_js E2eWeb.Demos.MarqueeDemo.events_client_js()
  @client_ts E2eWeb.Demos.MarqueeDemo.events_client_ts()

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

  def handle_event("pause_changed", %{"paused" => paused, "id" => id}, socket) do
    log = new_log("server", id, inspect(%{kind: "pause_changed", paused: paused}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("loop_complete", %{"id" => id}, socket) do
    log = new_log("server", id, inspect(%{kind: "loop_complete"}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("complete", %{"id" => id}, socket) do
    log = new_log("server", id, inspect(%{kind: "complete"}))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("marquee_client_pause", %{"id" => id, "paused" => paused}, socket) do
    log = new_log("client", id, inspect(%{kind: "pause_changed", paused: paused}))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  def handle_event("marquee_client_loop", %{"id" => id}, socket) do
    log = new_log("client", id, inspect(%{kind: "loop_complete"}))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  def handle_event("marquee_client_complete", %{"id" => id}, socket) do
    log = new_log("client", id, inspect(%{kind: "complete"}))
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
        id="marquee-events-page"
        title="Marquee · Event"
        subtitle="Pause, loop, and completion from LiveView or DOM events."
      >
        <.demo_section
          id="marquee-events-server-section"
          title="On Pause Change / On Loop Complete / On Complete (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.marquee
                id={@id_server}
                class="marquee"
                on_pause_change="pause_changed"
                on_loop_complete="loop_complete"
                on_complete="complete"
                loop_count={3}
                items={[
                  %{name: "Apple", logo: "🍎"},
                  %{name: "Banana", logo: "🍌"},
                  %{name: "Cherry", logo: "🍒"},
                  %{name: "Grape", logo: "🍇"},
                  %{name: "Lemon", logo: "🍋"}
                ]}
                duration={12}
                spacing="2rem"
                pause_on_interaction
              >
                <:item :let={item}>
                  <span>{item.logo}</span>
                  <span>{item.name}</span>
                </:item>
              </.marquee>

              <.data_table
                id="marquee-events-log-server"
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
          id="marquee-events-client-section"
          title="On Pause Change / On Loop Complete / On Complete (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.marquee
                id={@id_client}
                class="marquee"
                on_pause_change_client="marquee-pause-changed-client"
                on_loop_complete_client="marquee-loop-complete-client"
                on_complete_client="marquee-complete-client"
                loop_count={3}
                items={[
                  %{name: "Apple", logo: "🍎"},
                  %{name: "Banana", logo: "🍌"},
                  %{name: "Cherry", logo: "🍒"},
                  %{name: "Grape", logo: "🍇"},
                  %{name: "Lemon", logo: "🍋"}
                ]}
                duration={12}
                spacing="2rem"
                pause_on_interaction
              >
                <:item :let={item}>
                  <span>{item.logo}</span>
                  <span>{item.name}</span>
                </:item>
              </.marquee>

              <div
                id="marquee-events-client-listener"
                class="w-full flex flex-col items-center"
                phx-hook=".MarqueeEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".MarqueeEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("marquee-events-client");
                      if (!el) return;
                      el.addEventListener("marquee-pause-changed-client", (event) => {
                        const d = event.detail;
                        this.pushEvent("marquee_client_pause", {
                          id: d.id,
                          paused: d.paused,
                        });
                      });
                      el.addEventListener("marquee-loop-complete-client", (event) => {
                        const d = event.detail;
                        this.pushEvent("marquee_client_loop", { id: d.id });
                      });
                      el.addEventListener("marquee-complete-client", (event) => {
                        const d = event.detail;
                        this.pushEvent("marquee_client_complete", { id: d.id });
                      });
                    },
                  };
                </script>
              </div>

              <.data_table
                id="marquee-events-log-client"
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
