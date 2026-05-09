defmodule E2eWeb.FloatingPanelEventsLive do
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
    {:ok, stream(socket, :logs, [])}
  end

  @impl true
  def handle_event("floating_panel_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("on_open_change", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("floating_panel_open_client", %{"id" => id, "open" => open}, socket) do
    {:noreply,
     stream_insert(socket, :logs, new_log("on_open_change_client", id, inspect(open)), at: 0)}
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
        id="floating-panel-events-page"
        title="Floating Panel · Events"
        subtitle="Open change (server + client)."
      >
        <.demo_section
          id="floating-panel-events"
          title="Open change"
          code={E2eWeb.Demos.FloatingPanelDemo.events_server_heex()}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.floating_panel
                id="fp-events-live"
                class="floating-panel"
                on_open_change="floating_panel_open_changed"
                on_open_change_client="floating-panel-open-changed"
              >
                <:trigger>
                  <span data-closed>Open panel</span>
                  <span data-open>Close panel</span>
                </:trigger>
                <:title>Panel</:title>
                <:minimize_trigger>
                  <.heroicon name="hero-arrow-down-left" class="icon" />
                </:minimize_trigger>
                <:maximize_trigger>
                  <.heroicon name="hero-arrows-pointing-out" class="icon" />
                </:maximize_trigger>
                <:default_trigger>
                  <.heroicon name="hero-rectangle-stack" class="icon" />
                </:default_trigger>
                <:close_trigger>
                  <.heroicon name="hero-x-mark" class="icon" />
                </:close_trigger>
                <:content>
                  <p>Lorem ipsum dolor sit amet.</p>
                </:content>
              </.floating_panel>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".FloatingPanelEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("fp-events-live")
                    if (!el) return
                    el.addEventListener("floating-panel-open-changed", (event) => {
                      const d = event.detail
                      this.pushEvent("floating_panel_open_client", {
                        id: d?.id ?? "fp-events-live",
                        open: d?.open
                      })
                    })
                  },
                }
              </script>

              <.data_table
                id="floating-panel-events-log"
                class="data-table max-w-3xl"
                rows={@streams.logs}
              >
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
