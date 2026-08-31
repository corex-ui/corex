defmodule E2eWeb.CascadeSelectEventsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, stream(socket, :logs, [])}

  @impl true
  def handle_event("cascade_select_changed", payload, socket) do
    {:noreply, stream_insert(socket, :logs, log("changed", payload["id"], inspect(payload)), at: 0)}
  end

  @impl true
  def handle_event("cascade_select_client_changed", payload, socket) do
    {:noreply, stream_insert(socket, :logs, log("client_changed", payload["id"], inspect(payload)), at: 0)}
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
      <.demo_page path={@path} id="cascade-select-events-page" title="Cascade select · Events" subtitle="Value change events (server + client).">
        <.demo_section
          id="cascade-select-events-section"
          title="On value change (Server and client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: ~S"""
              <.cascade_select class="cascade-select" on_value_change="cascade_select_changed" on_value_change_client="cascade-select-changed" />
              """
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: ~S"""
              def handle_event("cascade_select_changed", payload, socket) do
                {:noreply, socket}
              end
              """
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: ~S"""
              const el = document.getElementById("cascade-select-events");
              el?.addEventListener("cascade-select-changed", (event) => {
                console.log(event.detail);
              });
              """
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.cascade_select
                id="cascade-select-events"
                class="cascade-select"
                on_value_change="cascade_select_changed"
                on_value_change_client="cascade-select-changed"
              />
              <script :type={Phoenix.LiveView.ColocatedHook} name=".CascadeSelectEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("cascade-select-events");
                    if(!el) return;
                    el.addEventListener("cascade-select-changed", (event) => {
                      this.pushEvent("cascade_select_client_changed", event.detail ?? {});
                    });
                  }
                }
              </script>
              <.data_table id="cascade-select-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
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
