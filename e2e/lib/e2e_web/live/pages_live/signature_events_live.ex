defmodule E2eWeb.SignatureEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "signature-events-server"
  @id_client "signature-events-client"

  @server_heex E2eWeb.Demos.SignatureDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.SignatureDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.SignatureDemo.events_client_heex()
  @client_js E2eWeb.Demos.SignatureDemo.events_client_js()
  @client_ts E2eWeb.Demos.SignatureDemo.events_client_ts()

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

  def handle_event("signature_drawn", %{"id" => id, "url" => url}, socket) do
    log = new_log("server", id, String.slice(url, 0, 32))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("signature_client_drawn", %{"id" => id, "url" => url}, socket) do
    log = new_log("client", id, String.slice(url, 0, 32))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
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
        id="signature-events-page"
        title={~t"Signature Pad · Event"}
        subtitle={~t"Subscribe to draw end from LiveView or the client."}
      >
        <.demo_section
          id="signature-events-server-section"
          title={~t"On Draw End (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.signature_pad
                id={@id_server}
                on_draw_end="signature_drawn"
              >
                <:label>Sign here</:label>
                <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
              </.signature_pad>

              <.data_table
                id="signature-events-log-server"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="signature-events-client-section"
          title={~t"On Draw End (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.signature_pad
                id={@id_client}
                on_draw_end_client="signature-drawn"
              >
                <:label>Sign here</:label>
                <:clear_trigger><.heroicon name="hero-x-mark" /></:clear_trigger>
              </.signature_pad>

              <div
                id="signature-events-client-listener"
                class="w-full"
                phx-hook=".SignatureEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".SignatureEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("signature-events-client");
                      if(!el) return;
                      el.addEventListener("signature-drawn", (event) => {
                        const d = event.detail;
                        this.pushEvent("signature_client_drawn", { id: d.id, url: d.url });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="signature-events-log-client"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
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
