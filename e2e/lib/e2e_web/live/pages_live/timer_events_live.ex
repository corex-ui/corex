defmodule E2eWeb.TimerEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

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
    {:ok, socket |> assign(:last_tick, nil) |> stream(:logs, [])}
  end

  @impl true
  def handle_event("timer_tick", %{"id" => id} = params, socket) do
    ft = Map.get(params, "formattedTime", "")
    {:noreply, assign(socket, last_tick: "#{id} #{ft}")}
  end

  @impl true
  def handle_event("timer_complete", %{"id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("on_complete", id, "done"), at: 0)}
  end

  @impl true
  def handle_event("timer_tick_client", params, socket) do
    id = Map.get(params, "id", "timer-events-live")
    ft = Map.get(params, "formattedTime", "")
    {:noreply, stream_insert(socket, :logs, new_log("on_tick_client", id, ft), at: 0)}
  end

  @impl true
  def handle_event("timer_complete_client", %{"id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("on_complete_client", id, "done"), at: 0)}
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
        subtitle="Tick and complete (server + client)."
      >
        <.demo_section
          id="timer-events"
          title="On tick and on complete (Server and client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.TimerDemo.events_combined_heex()
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: E2eWeb.Demos.TimerDemo.events_server_elixir()
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: E2eWeb.Demos.TimerDemo.events_client_js()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.timer
                id="timer-events-live"
                countdown
                start_ms={3_600_000}
                target_ms={0}
                class="timer"
                on_tick="timer_tick"
                on_tick_client="timer-tick"
                on_complete="timer_complete"
                on_complete_client="timer-complete"
              >
                <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
                <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
                <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
                <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
              </.timer>

              <div :if={@last_tick} class="code-block code-block--sm w-full max-w-3xl">
                <div class="code-block__line">Last server tick: {@last_tick}</div>
              </div>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".TimerEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("timer-events-live")
                    if (!el) return
                    el.addEventListener("timer-tick", (event) => {
                      const d = event.detail
                      this.pushEvent("timer_tick_client", {
                        id: d?.id ?? "timer-events-live",
                        formattedTime: d?.formattedTime ?? "",
                      })
                    })
                    el.addEventListener("timer-complete", (event) => {
                      const d = event.detail
                      this.pushEvent("timer_complete_client", { id: d?.id ?? "timer-events-live" })
                    })
                  },
                }
              </script>

              <.data_table id="timer-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
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
