defmodule E2eWeb.ScrollAreaEventsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, stream(socket, :logs, [])}

  @impl true
  def handle_event("scroll_area_changed", payload, socket) do
    {:noreply,
     stream_insert(socket, :logs, log("changed", payload["id"], inspect(payload)), at: 0)}
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
      <.demo_page
        path={@path}
        id="scroll-area-events-page"
        title="ScrollArea · Events"
        subtitle="Value change events."
      >
        <.demo_section id="scroll-area-events-section" title="On value change">
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.scroll_area
                id="scroll-area-events"
                class="scroll-area"
                on_value_change="scroll_area_changed"
              />
              <.data_table
                id="scroll-area-events-log"
                class="data-table max-w-3xl"
                rows={@streams.logs}
              >
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
