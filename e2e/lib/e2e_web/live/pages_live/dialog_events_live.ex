defmodule E2eWeb.DialogEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "dialog-events-server"
  @id_client "dialog-events-client"

  @server_heex E2eWeb.Demos.DialogDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.DialogDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.DialogDemo.events_client_heex()
  @client_js E2eWeb.Demos.DialogDemo.events_client_js()
  @client_ts E2eWeb.Demos.DialogDemo.events_client_ts()

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("dialog_open_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :server_logs, new_log("server", id, inspect(open)), at: 0)}
  end

  @impl true
  def handle_event("dialog_open_client_changed", %{"open" => open, "id" => id}, socket) do
    {:noreply, stream_insert(socket, :client_logs, new_log("client", id, inspect(open)), at: 0)}
  end

  defp new_log(source, dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
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
        subtitle="Subscribe to open changes from LiveView or the client."
      >
        <.demo_section
          id="dialog-events-server-section"
          title="On Open Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.dialog
                id={@id_server}
                class="dialog"
                on_open_change="dialog_open_changed"
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

              <.data_table
                id="dialog-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="dialog-events-client-section"
          title="On Open Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.dialog
                id={@id_client}
                class="dialog"
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

              <div
                id="dialog-events-client-listener"
                class="w-full"
                phx-hook=".DialogEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".DialogEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("dialog-events-client");
                      if (!el) return;
                      el.addEventListener("dialog-open-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("dialog_open_client_changed", {
                          id: d?.id ?? "dialog-events-client",
                          open: d?.open ?? null
                        });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="dialog-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
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
