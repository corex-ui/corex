defmodule E2eWeb.PresenceEventsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, stream(socket, :logs, [])}

  @impl true
  def handle_event("presence_changed", payload, socket) do
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
      <.demo_page path={@path} id="presence-events-page" title="Presence · Events" subtitle="Value change events.">
        <.demo_section id="presence-events-section" title="On value change">
          <:preview>
            <div class="flex flex-col gap-space-lg items-center w-full">
              <.presence id="presence-events" class="presence" on_exit_complete="presence_changed" />
              <.data_table id="presence-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
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
