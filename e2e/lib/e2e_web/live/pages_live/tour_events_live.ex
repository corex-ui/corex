defmodule E2eWeb.TourEventsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, stream(socket, :logs, [])}

  @impl true
  def handle_event("tour_step_changed", payload, socket) do
    {:noreply, stream_insert(socket, :logs, log("step_changed", payload["id"], inspect(payload)), at: 0)}
  end

  @impl true
  def handle_event("tour_step_client_changed", payload, socket) do
    {:noreply, stream_insert(socket, :logs, log("step_client_changed", payload["id"], inspect(payload)), at: 0)}
  end

  defp log(event, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time: DateTime.utc_now() |> DateTime.truncate(:second) |> Calendar.strftime("%H:%M:%S"),
      event: event,
      dom_id: dom_id,
      value: value
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="tour-events-page" title="Tour · Events" subtitle="Step change events (server + client).">
        <.demo_section
          id="tour-events-section"
          title="On step change (Server and client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: ~S"""
              <.action phx-click={Corex.Tour.start("tour-events")} class="button">Start tour</.action>
              <.tour class="tour" on_step_change="tour_step_changed" on_step_change_client="tour-step-changed" />
              """
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: ~S"""
              def handle_event("tour_step_changed", payload, socket) do
                {:noreply, socket}
              end
              """
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: ~S"""
              const el = document.getElementById("tour-events");
              el?.addEventListener("tour-step-changed", (event) => {
                console.log(event.detail);
              });
              """
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.action phx-click={Corex.Tour.start("tour-events")} class="button">Start tour</.action>
              <div class="flex gap-space-sm">
                <button id="tour-target-nav" type="button" class="button ui-size-sm">Docs</button>
                <button id="tour-target-playground" type="button" class="button ui-size-sm">Playground</button>
              </div>
              <.tour
                id="tour-events"
                class="tour"
                on_step_change="tour_step_changed"
                on_step_change_client="tour-step-changed"
              />
              <script :type={Phoenix.LiveView.ColocatedHook} name=".TourEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("tour-events");
                    if(!el) return;
                    el.addEventListener("tour-step-changed", (event) => {
                      this.pushEvent("tour_step_client_changed", event.detail ?? {});
                    });
                  }
                }
              </script>
              <.data_table id="tour-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty><p>No event yet.</p></:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
