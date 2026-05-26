defmodule E2eWeb.FileUploadEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.FileUploadDemo, as: Demo

  @server_heex Demo.events_server_heex()
  @server_elixir Demo.events_server_elixir()
  @client_heex Demo.events_client_heex()
  @client_js Demo.events_client_js()
  @client_elixir Demo.events_client_elixir()

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:server_heex, @server_heex)
     |> assign(:server_elixir, @server_elixir)
     |> assign(:client_heex, @client_heex)
     |> assign(:client_js, @client_js)
     |> assign(:client_elixir, @client_elixir)
     |> stream(:server_logs, [])
     |> stream(:client_logs, [])}
  end

  @impl true
  def handle_event(
        "fu_ev_server",
        %{"id" => id, "acceptedCount" => c, "rejectedCount" => r} = payload,
        socket
      ) do
    name = Map.get(payload, "firstAcceptedName")
    suffix = if is_binary(name) and name != "", do: " (#{name})", else: ""
    log = new_log(id, "#{c} accepted, #{r} rejected#{suffix}")
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  @impl true
  def handle_event(
        "fu_ev_client",
        %{"id" => id, "acceptedCount" => c, "rejectedCount" => r} = payload,
        socket
      ) do
    name = Map.get(payload, "firstAcceptedName")
    suffix = if is_binary(name) and name != "", do: " (#{name})", else: ""
    log = new_log(id, "#{c} accepted, #{r} rejected#{suffix}")
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  defp new_log(dom_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
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
        id="file-upload-events-page"
        title="File Upload · Events"
        subtitle="Subscribe to file changes from LiveView or the client."
      >
        <.demo_section
          id="file-upload-events-server-block"
          title="On file change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.file_upload
                id="file-upload-events-server"
                class="file-upload"
                name="ev-server[]"
                on_file_change="fu_ev_server"
              >
                <:label>Upload</:label>
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload>
              <.data_table
                id="file-upload-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="file-upload-events-client-block"
          title="On file change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @client_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.file_upload
                id="file-upload-events-client"
                class="file-upload"
                name="ev-client[]"
                on_file_change_client="file-upload-file-change"
              >
                <:label>Upload</:label>
                <:close>
                  <.heroicon name="hero-x-mark" />
                </:close>
              </.file_upload>

              <div
                id="file-upload-events-client-hook"
                class="w-full"
                phx-hook=".FileUploadEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".FileUploadEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("file-upload-events-client");
                      if (!el) return;
                      el.addEventListener("file-upload-file-change", (event) => {
                        const d = event.detail;
                        this.pushEvent("fu_ev_client", {
                          id: d?.id ?? "file-upload-events-client",
                          acceptedCount: d?.acceptedCount ?? 0,
                          rejectedCount: d?.rejectedCount ?? 0,
                          firstAcceptedName: d?.firstAcceptedName ?? null,
                        });
                      });
                    },
                  };
                </script>
              </div>

              <.data_table
                id="file-upload-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Id">{row.dom_id}</:col>
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
