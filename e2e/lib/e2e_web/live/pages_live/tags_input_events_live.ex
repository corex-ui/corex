defmodule E2eWeb.TagsInputEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "tags-input-on-value-change-server"
  @id_client "tags-input-on-value-change-client"
  @id_invalid_server "tags-input-on-value-invalid-server"
  @id_invalid_client "tags-input-on-value-invalid-client"
  @client_event "tags-client-changed"
  @client_invalid_event "tags-client-invalid"

  @server_heex E2eWeb.Demos.TagsInputDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.TagsInputDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.TagsInputDemo.events_client_heex()
  @client_js E2eWeb.Demos.TagsInputDemo.events_client_js()
  @client_ts E2eWeb.Demos.TagsInputDemo.events_client_ts()
  @invalid_server_heex E2eWeb.Demos.TagsInputDemo.events_invalid_server_heex()
  @invalid_server_elixir E2eWeb.Demos.TagsInputDemo.events_invalid_server_elixir()
  @invalid_client_heex E2eWeb.Demos.TagsInputDemo.events_invalid_client_heex()
  @invalid_client_js E2eWeb.Demos.TagsInputDemo.events_invalid_client_js()
  @invalid_client_ts E2eWeb.Demos.TagsInputDemo.events_invalid_client_ts()

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:id_invalid_server, @id_invalid_server)
      |> assign(:id_invalid_client, @id_invalid_client)
      |> assign(:client_event, @client_event)
      |> assign(:client_invalid_event, @client_invalid_event)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> assign(:invalid_server_heex, @invalid_server_heex)
      |> assign(:invalid_server_elixir, @invalid_server_elixir)
      |> assign(:invalid_client_heex, @invalid_client_heex)
      |> assign(:invalid_client_js, @invalid_client_js)
      |> assign(:invalid_client_ts, @invalid_client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])
      |> stream(:server_invalid_logs, [])
      |> stream(:client_invalid_logs, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("tags_value_changed", %{"id" => id, "value" => value}, socket)
      when is_list(value) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  @impl true
  def handle_event("tags_client_changed", %{"id" => id, "value" => value}, socket)
      when is_list(value) do
    log = new_log("client", id, inspect(value))
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  @impl true
  def handle_event("tags_value_invalid", %{"id" => id, "reason" => reason}, socket) do
    log = new_invalid_log("server", id, inspect(reason))
    {:noreply, stream_insert(socket, :server_invalid_logs, log, at: 0)}
  end

  @impl true
  def handle_event("tags_client_invalid", %{"id" => id, "reason" => reason}, socket) do
    log = new_invalid_log("client", id, inspect(reason))
    {:noreply, stream_insert(socket, :client_invalid_logs, log, at: 0)}
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

  defp new_invalid_log(source, dom_id, reason) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      dom_id: dom_id,
      reason: reason
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="tags-input-events-page"
        title="Tags Input · Event"
        subtitle="Subscribe to value or validity changes from LiveView or a DOM listener."
      >
        <.demo_section
          id="tags-input-events-server-section"
          title="On Value Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tags_input
                id={@id_server}
                class="tags-input"
                value={["lorem", "duis", "donec"]}
                on_value_change="tags_value_changed"
              >
                <:label>Tags</:label>
                <:close><.heroicon name="hero-x-mark" /></:close>
              </.tags_input>

              <.data_table
                id="tags-input-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-events-client-section"
          title="On Value Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tags_input
                id={@id_client}
                class="tags-input"
                value={["lorem", "duis", "donec"]}
                on_value_change_client={@client_event}
              >
                <:label>Tags</:label>
                <:close><.heroicon name="hero-x-mark" /></:close>
              </.tags_input>

              <div
                id="tags-input-events-client-listener"
                class="w-full"
                phx-hook=".TagsInputEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".TagsInputEventsClient">
                  export default {
                    mounted() {
                      const valueEl = document.getElementById("tags-input-on-value-change-client");
                      valueEl?.addEventListener("tags-client-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("tags_client_changed", { id: d.id, value: d.value });
                      });
                      const invalidEl = document.getElementById("tags-input-on-value-invalid-client");
                      invalidEl?.addEventListener("tags-client-invalid", (event) => {
                        const d = event.detail;
                        this.pushEvent("tags_client_invalid", { id: d.id, reason: d.reason });
                      });
                    },
                  };
                </script>
              </div>

              <.data_table
                id="tags-input-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-events-invalid-server-section"
          title="On Value Invalid (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @invalid_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @invalid_server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tags_input
                id={@id_invalid_server}
                class="tags-input"
                value={["lorem", "duis"]}
                max={2}
                allow_overflow={true}
                on_value_invalid="tags_value_invalid"
              >
                <:label>Tags</:label>
                <:close><.heroicon name="hero-x-mark" /></:close>
              </.tags_input>

              <.data_table
                id="tags-input-events-log-invalid-server"
                class="data-table max-w-3xl"
                rows={@streams.server_invalid_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="DOM id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Reason">{row.reason}</:col>
                <:empty>
                  <p>No invalid event yet</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>
        <.demo_section
          id="tags-input-events-invalid-client-section"
          title="On Value Invalid (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @invalid_client_heex},
            %{value: "js", label: "JS", language: :js, code: @invalid_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @invalid_client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tags_input
                id={@id_invalid_client}
                class="tags-input"
                value={["lorem", "duis"]}
                max={2}
                allow_overflow={true}
                on_value_invalid_client={@client_invalid_event}
              >
                <:label>Tags</:label>
                <:close><.heroicon name="hero-x-mark" /></:close>
              </.tags_input>

              <.data_table
                id="tags-input-events-log-invalid-client"
                class="data-table max-w-3xl"
                rows={@streams.client_invalid_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="DOM id">{row.dom_id}</:col>
                <:col :let={{_dom_id, row}} label="Reason">{row.reason}</:col>
                <:empty>
                  <p>No invalid event yet</p>
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
