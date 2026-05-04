defmodule E2eWeb.DialogEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :logs, [])}
  end

  @impl true
  def handle_event("dialog_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("open_changed", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("dialog_open_client_changed", %{"open" => open, "id" => id}, socket) do
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
        id="dialog-events-page"
        title="Dialog · Event"
        subtitle="Open change events (server + client)."
      >
        <.demo_section
          id="dialog-events"
          title="Open change"
          code={E2eWeb.Demos.DialogDemo.events_server_heex()}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.dialog
                id="dialog-events"
                class="dialog"
                on_open_change="dialog_open_changed"
                on_open_change_client="dialog-open-changed"
              >
                <:trigger>Open Dialog</:trigger>
                <:title>Dialog Title</:title>
                <:content>
                  <p>Dialog content</p>
                </:content>
                <:close_trigger>
                  <.heroicon name="hero-x-mark" class="icon" />
                </:close_trigger>
              </.dialog>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".DialogEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("dialog-events");
                    if(!el) return;
                    el.addEventListener("dialog-open-changed", (event) => {
                      const d = event.detail;
                      this.pushEvent("dialog_open_client_changed", { id: d?.id ?? "dialog-events", open: d?.open ?? null });
                    });
                  }
                }
              </script>

              <.data_table id="dialog-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
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
