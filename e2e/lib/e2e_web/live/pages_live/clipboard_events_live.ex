defmodule E2eWeb.ClipboardEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:logs, [])
     |> assign(:codes, %{
       heex: E2eWeb.Demos.ClipboardDemo.events_server_heex(),
       elixir: E2eWeb.Demos.ClipboardDemo.events_server_elixir()
     })}
  end

  @impl true
  def handle_event("clipboard_copied", %{"value" => value, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("copied", id, inspect(value)), at: 0)}
  end

  @impl true
  def handle_event("clipboard_copied_client", %{"id" => id, "value" => value}, socket) do
    {:noreply, stream_insert(socket, :logs, new_log("copied_client", id, inspect(value)), at: 0)}
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
        path={@path}
        id="clipboard-events-page"
        title="Clipboard · Event"
        subtitle="Copy events (server + client)."
      >
        <.demo_section
          id="clipboard-events-section"
          title="Copy"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.action phx-click={Corex.Clipboard.copy("clipboard-events")} class="button button--sm">
                Copy
              </.action>

              <.clipboard
                id="clipboard-events"
                class="clipboard"
                value="info@netoum.com"
                trigger_aria_label="Copy to clipboard"
                input_aria_label="Value to copy"
                on_copy="clipboard_copied"
                on_copy_client="clipboard-copied"
              >
                <:label>Copy</:label>
                <:copy>
                  <.heroicon name="hero-clipboard" />
                </:copy>
                <:copied>
                  <.heroicon name="hero-check" />
                </:copied>
              </.clipboard>

              <script :type={Phoenix.LiveView.ColocatedHook} name=".ClipboardEventsClient">
                export default {
                  mounted() {
                    const el = document.getElementById("clipboard-events");
                    if(!el) return;
                    el.addEventListener("clipboard-copied", (event) => {
                      const d = event.detail;
                      this.pushEvent("clipboard_copied_client", { id: d?.id ?? "clipboard-events", value: d?.value ?? null });
                    });
                  }
                }
              </script>

              <.data_table id="clipboard-events-log" class="data-table max-w-3xl" rows={@streams.logs}>
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Event">{row.event}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Click Copy.</p>
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
