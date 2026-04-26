defmodule E2eWeb.TreeViewEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "tree-events-server"
  @id_client "tree-events-client"
  @client_expanded_event "tree-view-expanded-client"
  @client_selection_event "tree-view-selection-client"

  @server_heex E2eWeb.Demos.TreeViewDemo.events_server_heex()
  @server_elixir E2eWeb.Demos.TreeViewDemo.events_server_elixir()
  @client_heex E2eWeb.Demos.TreeViewDemo.events_client_heex()
  @client_js E2eWeb.Demos.TreeViewDemo.events_client_js()
  @client_ts E2eWeb.Demos.TreeViewDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:demo_items, E2eWeb.Demos.TreeViewDemo.events_items())
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:client_expanded_event, @client_expanded_event)
      |> assign(:client_selection_event, @client_selection_event)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("tree_server_expanded", %{"id" => id, "value" => v}, socket) do
    expanded = Map.get(v, "expandedValue") || Map.get(v, :expandedValue) || []
    log = new_log("server", id, "expanded", expanded)
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("tree_server_selection", %{"id" => id, "value" => v}, socket) do
    log = new_log("server", id, "selection", v)
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("tree_client_expanded", %{"id" => id, "expanded_value" => ev}, socket) do
    log = new_log("client", id, "expanded", ev)
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  def handle_event("tree_client_selection", %{"id" => id, "payload" => payload}, socket) do
    log = new_log("client", id, "selection", payload)
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  defp new_log(source, tree_id, kind, payload) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      tree_id: tree_id,
      kind: kind,
      value: inspect(payload)
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
        id="tree-view-events-page"
        title="Tree view · Events"
        subtitle="Server on_expanded_change and on_selection_change, plus client DOM events."
        style="overflow-anchor: none;"
      >
        <.demo_section
          id="tree-view-events-server"
          title="On expanded and selection change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.tree_view
                id={@id_server}
                class="tree-view"
                items={@demo_items}
                on_expanded_change="tree_server_expanded"
                on_selection_change="tree_server_selection"
              >
                <:label>Corex</:label>
                <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
              </.tree_view>

              <.data_table
                id="tree-events-log-server"
                class="data-table max-w-3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Kind">{row.kind}</:col>
                <:col :let={{_dom_id, row}} label="Payload">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="tree-view-events-client"
          title="On expanded and selection change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <div class="w-full flex flex-col items-center">
                <.tree_view
                  id={@id_client}
                  class="tree-view"
                  expanded_value={["repo-lib"]}
                  items={@demo_items}
                  on_expanded_change_client={@client_expanded_event}
                  on_selection_change_client={@client_selection_event}
                >
                  <:label>Corex</:label>
                  <:branch_indicator><.heroicon name="hero-chevron-right" /></:branch_indicator>
                </.tree_view>
              </div>

              <div
                id="tree-events-client-listener"
                class="w-full flex flex-col items-center"
                phx-hook=".TreeViewEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".TreeViewEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("tree-events-client");
                      if (!el) return;
                      el.addEventListener("tree-view-expanded-client", (event) => {
                        const d = event.detail;
                        const v = d.value ?? {};
                        this.pushEvent("tree_client_expanded", {
                          id: d.id,
                          expanded_value: v.expandedValue ?? d.expandedValue,
                        });
                      });
                      el.addEventListener("tree-view-selection-client", (event) => {
                        const d = event.detail;
                        const v = d.value ?? {};
                        this.pushEvent("tree_client_selection", {
                          id: d.id,
                          payload: {
                            selectedValue: v.selectedValue ?? d.selectedValue,
                            focusedValue: v.focusedValue ?? d.focusedValue,
                            isItem: v.isItem ?? d.isItem,
                          },
                        });
                      });
                    },
                  };
                </script>
              </div>

              <.data_table
                id="tree-events-log-client"
                class="data-table max-w-3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Kind">{row.kind}</:col>
                <:col :let={{_dom_id, row}} label="Payload">{row.value}</:col>
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
