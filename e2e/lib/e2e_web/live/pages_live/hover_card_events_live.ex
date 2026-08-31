defmodule E2eWeb.HoverCardEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, stream(socket, :logs, [])}

  @impl true
  def handle_event("hover_card_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, log("open_changed", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("hover_card_open_client_changed", %{"id" => id, "open" => open}, socket) do
    {:noreply, stream_insert(socket, :logs, log("open_client_changed", id, inspect(open)), at: 0)}
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
      <.demo_page path={@path} id="hover-card-events-page" title="Hover card · Events" subtitle="Open change events (server + client).">
        <.demo_section
          id="hover-card-events-section"
          title="On open change (Server and client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: ~S"""
              <.hover_card class="hover-card" on_open_change="hover_card_open_changed" on_open_change_client="hover-card-open-changed">
                <:trigger>Hover me</:trigger>
                <:content>Preview content</:content>
              </.hover_card>
              """
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: ~S"""
              def handle_event("hover_card_open_changed", %{"open" => open, "id" => id}, socket) do
                {:noreply, socket}
              end
              """
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: ~S"""
              const el = document.getElementById("hover-card-events");
              el?.addEventListener("hover-card-open-changed", (event) => {
                console.log(event.detail);
              });
              """
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.hover_card
                id="hover-card-events"
                class="hover-card"
                on_open_change="hover_card_open_changed"
                on_open_change_client="hover-card-open-changed"
              >
                <:trigger>Hover me</:trigger>
                <:content>Preview content</:content>
              </.hover_card>
              <script :type={Phoenix.LiveView.ColocatedHook} name=".HoverCardEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("hover-card-events");
                    if(!el) return;
                    el.addEventListener("hover-card-open-changed", (event) => {
                      const d = event.detail;
                      this.pushEvent("hover_card_open_client_changed", { id: d?.id ?? "hover-card-events", open: d?.open ?? null });
                    });
                  }
                }
              </script>
              <.data_table id="hover-card-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
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
