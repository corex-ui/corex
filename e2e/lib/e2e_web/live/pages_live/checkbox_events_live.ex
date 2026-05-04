defmodule E2eWeb.CheckboxEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_server "checkbox-on-checked-change-server"
  @id_client "checkbox-on-checked-change-client"
  @client_event "checkbox-changed"

  @server_heex E2eWeb.Demos.CheckboxDemo.events_server_heex()

  @server_elixir E2eWeb.Demos.CheckboxDemo.events_server_elixir()

  @client_heex E2eWeb.Demos.CheckboxDemo.events_client_heex()

  @client_js E2eWeb.Demos.CheckboxDemo.events_client_js()

  @client_ts E2eWeb.Demos.CheckboxDemo.events_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_server, @id_server)
      |> assign(:id_client, @id_client)
      |> assign(:client_event, @client_event)
      |> assign(:server_heex, @server_heex)
      |> assign(:server_elixir, @server_elixir)
      |> assign(:client_heex, @client_heex)
      |> assign(:client_js, @client_js)
      |> assign(:client_ts, @client_ts)
      |> stream(:server_logs, [])
      |> stream(:client_logs, [])

    {:ok, socket}
  end

  def handle_event("checkbox_changed", %{"id" => id, "checked" => checked}, socket) do
    log = new_log("server", id, checked)
    {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
  end

  def handle_event("checkbox_client_changed", %{"id" => id, "checked" => checked}, socket) do
    log = new_log("client", id, checked)
    {:noreply, stream_insert(socket, :client_logs, log, at: 0)}
  end

  defp new_log(source, checkbox_id, checked) do
    %{
      id: "#{System.unique_integer([:positive])}",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Calendar.strftime("%H:%M:%S"),
      source: source,
      checkbox_id: checkbox_id,
      value: inspect(checked)
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
        id="checkbox-events-page"
        title="Checkbox · Event"
        subtitle="Subscribe to checked changes from LiveView or the client."
      >
        <.demo_section
          id="checkbox-events-server"
          title="On Checked Change (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.checkbox
                id={@id_server}
                class="checkbox"
                on_checked_change="checkbox_changed"
              >
                <:label>Subscribe</:label>
                <:indicator>
                  <.heroicon name="hero-check" />
                </:indicator>
                <:indeterminate>
                  <.heroicon name="hero-minus" />
                </:indeterminate>
              </.checkbox>

              <.data_table
                id="checkbox-events-log-server"
                class="data-table max-w-3xl"
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
          id="checkbox-events-client"
          title="On Checked Change (Client)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @client_heex},
            %{value: "js", label: "JS", language: :js, code: @client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.checkbox
                id={@id_client}
                class="checkbox"
                on_checked_change_client={@client_event}
              >
                <:label>Subscribe</:label>
                <:indicator>
                  <.heroicon name="hero-check" />
                </:indicator>
                <:indeterminate>
                  <.heroicon name="hero-minus" />
                </:indeterminate>
              </.checkbox>

              <div
                id="checkbox-events-client-listener"
                class="w-full"
                phx-hook=".CheckboxEventsClient"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".CheckboxEventsClient">
                  export default {
                    mounted() {
                      const el = document.getElementById("checkbox-on-checked-change-client");
                      if(!el) return;
                      el.addEventListener("checkbox-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("checkbox_client_changed", { id: d.id, checked: d.checked });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="checkbox-events-log-client"
                class="data-table max-w-3xl"
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
