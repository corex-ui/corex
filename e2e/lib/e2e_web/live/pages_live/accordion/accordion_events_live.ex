defmodule E2eWeb.AccordionEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1, authoring_preview: 1]

  @id_server "events-on-value-change-server"
  @id_client "events-on-value-change-client"
  @client_event "accordion-value-changed"

  @server_heex E2eWeb.Demos.AccordionDemo.events_server_heex()

  @server_elixir E2eWeb.Demos.AccordionDemo.events_server_elixir()

  @client_heex E2eWeb.Demos.AccordionDemo.events_client_heex()

  @client_js E2eWeb.Demos.AccordionDemo.events_client_js()

  @client_ts E2eWeb.Demos.AccordionDemo.events_client_ts()

  def mount(_params, _session, socket) do
    demo_items = E2eWeb.Demos.AccordionDemo.events_items()

    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:client_event, @client_event)
      |> assign(:server_heex, E2eWeb.AuthoringSnippet.heex_snippets(@server_heex))
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, E2eWeb.AuthoringSnippet.heex_snippets(@client_heex))
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> assign(:demo_items, demo_items)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("accordion_value_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("server", id, value)

    socket =
      socket
      |> stream_insert(:server_logs, log, at: 0)

    {:noreply, socket}
  end

  def handle_event("accordion_client_changed", %{"id" => id, "value" => value}, socket) do
    log = new_log("client", id, value)

    socket =
      socket
      |> stream_insert(:client_logs, log, at: 0)

    {:noreply, socket}
  end

  defp new_log(source, accordion_id, value) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      accordion_id: accordion_id,
      value: inspect(value)
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
        id="accordion-events-page"
        title={~t"Accordion · Event"}
        subtitle={~t"Subscribe to open value changes from LiveView or the client."}
      >
        <.demo_section
          id="accordion-events-server"
          title={~t"On Value Change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <.stack gap="lg" align="center" width="full">
              <.authoring_preview>
                <:styled>
                  <.accordion
                    id={@id_server}
                    class="accordion"
                    items={@demo_items}
                    on_value_change="accordion_value_changed"
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:styled>
                <:markup>
                  <.accordion
                    id={@id_server}
                    unstyled
                    items={@demo_items}
                    on_value_change="accordion_value_changed"
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:markup>
              </.authoring_preview>

              <.data_table
                id="accordion-events-log-server"
                class="data-table"
                max_width="3xl"
                rows={@streams.server_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </.stack>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-events-client"
          title={~t"On Value Change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <.stack gap="lg" align="center" width="full">
              <.authoring_preview>
                <:styled>
                  <.accordion
                    id={@id_client}
                    class="accordion"
                    items={@demo_items}
                    on_value_change_client={@client_event}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:styled>
                <:markup>
                  <.accordion
                    id={@id_client}
                    unstyled
                    items={@demo_items}
                    on_value_change_client={@client_event}
                  >
                    <:indicator>
                      <.heroicon name="hero-chevron-right" />
                    </:indicator>
                  </.accordion>
                </:markup>
              </.authoring_preview>

              <div
                id="accordion-events-client-listener"
                phx-hook=".AccordionEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".AccordionEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("events-on-value-change-client");
                      if(!el) return;
                      el.addEventListener("accordion-value-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("accordion_client_changed", { id: d.id, value: d.value });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="accordion-events-log-client"
                class="data-table"
                max_width="3xl"
                rows={@streams.client_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Interact with the components to receive new events</p>
                </:empty>
              </.data_table>
            </.stack>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
