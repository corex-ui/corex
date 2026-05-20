defmodule E2eWeb.TooltipEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :logs, [])}
  end

  @impl true
  def handle_event("tooltip_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("open_changed", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("tooltip_open_client_changed", %{"id" => id, "open" => open}, socket) do
    {:noreply,
     stream_insert(socket, :logs, new_log("open_client_changed", id, inspect(open)), at: 0)}
  end

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
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_page
        id="tooltip-events-page"
        title="Tooltip · Events"
        subtitle="Open change events (server + client)."
      >
        <.demo_section
          id="tooltip-events-section"
          title="On open change (Server and client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.TooltipDemo.events_server_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: E2eWeb.Demos.TooltipDemo.events_server_elixir()
            },
            %{
              value: "js",
              label: ~t"JS",
              language: :js,
              code: E2eWeb.Demos.TooltipDemo.events_client_listener_js()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tooltip
                id="tooltip-events"
                class="tooltip"
                on_open_change="tooltip_open_changed"
                on_open_change_client="tooltip-open-changed"
              >
                <:trigger>Hover me</:trigger>
                <:content>Tooltip content</:content>
              </.tooltip>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".TooltipEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("tooltip-events");
                    if(!el) return;
                    el.addEventListener("tooltip-open-changed", (event) => {
                      const d = event.detail;
                      this.pushEvent("tooltip_open_client_changed", { id: d?.id ?? "tooltip-events", open: d?.open ?? null });
                    });
                  }
                }
              </script>

              <.data_table id="tooltip-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
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
