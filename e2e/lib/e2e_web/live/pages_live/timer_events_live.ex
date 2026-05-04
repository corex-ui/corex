defmodule E2eWeb.TimerEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @server_heex E2eWeb.Demos.TimerDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.TimerDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.TimerDemo.events_client_heex()
  @client_js E2eWeb.Demos.TimerDemo.events_client_js()
  @client_ts E2eWeb.Demos.TimerDemo.events_client_ts()

  defp new_log(event, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      event: event,
      dom_id: dom_id,
      value: value
    }
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:server_heex, @server_heex)
     |> assign(:server_elixir, @server_elixir)
     |> assign(:client_heex, @client_heex)
     |> assign(:client_js, @client_js)
     |> assign(:client_ts, @client_ts)
     |> stream(:server_logs, [])
     |> stream(:client_logs, [])}
  end

  @impl true
  def handle_event("timer_tick", %{"id" => id} = params, socket) do
    ft = Map.get(params, "formattedTime", "")
    {:noreply, stream_insert(socket, :server_logs, new_log("on_tick", id, ft), at: 0)}
  end

  @impl true
  def handle_event("timer_complete", %{"id" => id}, socket) do
    {:noreply, stream_insert(socket, :server_logs, new_log("on_complete", id, "done"), at: 0)}
  end

  @impl true
  def handle_event("timer_tick_client", params, socket) do
    id = Map.get(params, "id", "timer-events-client")
    ft = Map.get(params, "formattedTime", "")
    {:noreply, stream_insert(socket, :client_logs, new_log("on_tick_client", id, ft), at: 0)}
  end

  @impl true
  def handle_event("timer_complete_client", %{"id" => id}, socket) do
    {:noreply,
     stream_insert(socket, :client_logs, new_log("on_complete_client", id, "done"), at: 0)}
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
        id="timer-events-page"
        title="Timer · Events"
        subtitle="Subscribe to tick and complete from LiveView or the client."
      >
        <.demo_section
          id="timer-events-server"
          title="On tick and on complete (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.timer
                id="timer-events-server"
                countdown
                start_ms={3_600_000}
                target_ms={0}
                class="timer"
                on_tick="timer_tick"
                on_complete="timer_complete"
              >
                <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
                <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
                <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
                <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
              </.timer>

              <.data_table
                id="timer-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
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
          id="timer-events-client"
          title="On tick and on complete (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.timer
                id="timer-events-client"
                countdown
                start_ms={3_600_000}
                target_ms={0}
                class="timer"
                on_tick_client="timer-tick"
                on_complete_client="timer-complete"
              >
                <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
                <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
                <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
                <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
              </.timer>

              <div
                id="timer-events-client-listener"
                class="w-full"
                phx-hook=".TimerEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".TimerEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("timer-events-client")
                      if (!el) return
                      el.addEventListener("timer-tick", (event) => {
                        const d = event.detail
                        this.pushEvent("timer_tick_client", {
                          id: d?.id ?? "timer-events-client",
                          formattedTime: d?.formattedTime ?? "",
                        })
                      })
                      el.addEventListener("timer-complete", (event) => {
                        const d = event.detail
                        this.pushEvent("timer_complete_client", { id: d?.id ?? "timer-events-client" })
                      })
                    },
                  }
                </script>
              </div>

              <.data_table
                id="timer-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
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
