defmodule E2eWeb.ColorPickerEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @sv_heex E2eWeb.Demos.ColorPickerDemo.events_server_value_heex()
  @sv_elixir E2eWeb.Demos.ColorPickerDemo.events_server_value_elixir()
  @so_heex E2eWeb.Demos.ColorPickerDemo.events_server_open_heex()
  @so_elixir E2eWeb.Demos.ColorPickerDemo.events_server_open_elixir()
  @cv_heex E2eWeb.Demos.ColorPickerDemo.events_client_value_heex()
  @cv_js E2eWeb.Demos.ColorPickerDemo.events_client_value_js()
  @cv_ts E2eWeb.Demos.ColorPickerDemo.events_client_value_ts()
  @co_heex E2eWeb.Demos.ColorPickerDemo.events_client_open_heex()
  @co_js E2eWeb.Demos.ColorPickerDemo.events_client_open_js()
  @co_ts E2eWeb.Demos.ColorPickerDemo.events_client_open_ts()

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:sv_heex, @sv_heex)
      |> assign(:sv_elixir, @sv_elixir)
      |> assign(:so_heex, @so_heex)
      |> assign(:so_elixir, @so_elixir)
      |> assign(:cv_heex, @cv_heex)
      |> assign(:cv_js, @cv_js)
      |> assign(:cv_ts, @cv_ts)
      |> assign(:co_heex, @co_heex)
      |> assign(:co_js, @co_js)
      |> assign(:co_ts, @co_ts)
      |> stream(:server_v_logs, [])
      |> stream(:server_o_logs, [])
      |> stream(:client_v_logs, [])
      |> stream(:client_o_logs, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("cp_ev_server_value", %{"id" => id, "valueAsString" => value}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_v_logs, log, at: 0)}
  end

  @impl true
  def handle_event("cp_ev_server_open", %{"id" => id, "open" => open}, socket) do
    log = new_log("server", id, inspect(open))
    {:noreply, stream_insert(socket, :server_o_logs, log, at: 0)}
  end

  @impl true
  def handle_event("cp_client_forward_v", %{"id" => id, "valueAsString" => value}, socket) do
    log = new_log("client", id, inspect(value))
    {:noreply, stream_insert(socket, :client_v_logs, log, at: 0)}
  end

  @impl true
  def handle_event("cp_client_forward_o", %{"id" => id, "open" => open}, socket) do
    log = new_log("client", id, inspect(open))
    {:noreply, stream_insert(socket, :client_o_logs, log, at: 0)}
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
        path={@path}
        id="color-picker-events-page"
        title="Color Picker · Event"
        subtitle="Server push events, then client-only custom events, each in its own block."
      >
        <.demo_section
          id="color-picker-events-sv"
          title="on_value_change (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @sv_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @sv_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.color_picker
                id="color-picker-ev-sv"
                value="#3b82f6"
                label="Value (server)"
                presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
                on_value_change="cp_ev_server_value"
              />

              <.data_table
                id="color-picker-events-sv-table"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_v_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Change the color to see rows.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-events-so"
          title="on_open_change (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @so_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @so_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.color_picker
                id="color-picker-ev-so"
                value="#3b82f6"
                label="Open (server)"
                presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
                on_open_change="cp_ev_server_open"
              />

              <.data_table
                id="color-picker-events-so-table"
                class="data-table data-table--max-w-3xl"
                rows={@streams.server_o_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No event yet. Open or close the popover to see rows.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-events-cv"
          title="on_value_change_client (DOM only)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @cv_heex},
            %{value: "js", label: "JS", language: :js, code: @cv_js},
            %{value: "ts", label: "TS", language: :javascript, code: @cv_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.color_picker
                id="color-picker-ev-cv"
                value="#3b82f6"
                label="Value (client only)"
                presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
                on_value_change_client="color-picker-cv"
              />

              <div
                id="color-picker-events-cv-hook"
                class="w-full"
                phx-hook=".ColorPickerEventCv"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".ColorPickerEventCv">
                  export default {
                    mounted() {
                      const el = document.getElementById("color-picker-ev-cv");
                      if (!el) return;
                      el.addEventListener("color-picker-cv", (event) => {
                        const d = event.detail ?? {};
                        const v =
                          typeof d.valueAsString === "string" ? d.valueAsString : "";
                        this.pushEvent("cp_client_forward_v", { id: d.id, valueAsString: v });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="color-picker-events-cv-table"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_v_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No forwarded event yet. Change the color to see rows.</p>
                </:empty>
              </.data_table>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="color-picker-events-co"
          title="on_open_change_client (DOM only)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @co_heex},
            %{value: "js", label: "JS", language: :js, code: @co_js},
            %{value: "ts", label: "TS", language: :javascript, code: @co_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.color_picker
                id="color-picker-ev-co"
                value="#3b82f6"
                label="Open (client only)"
                presets={["#ff0000", "#00ff00", "#0000ff", "#3b82f6"]}
                on_open_change_client="color-picker-co"
              />

              <div
                id="color-picker-events-co-hook"
                class="w-full"
                phx-hook=".ColorPickerEventCo"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".ColorPickerEventCo">
                  export default {
                    mounted() {
                      const el = document.getElementById("color-picker-ev-co");
                      if (!el) return;
                      el.addEventListener("color-picker-co", (event) => {
                        const d = event.detail;
                        this.pushEvent("cp_client_forward_o", { id: d.id, open: d.open });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="color-picker-events-co-table"
                class="data-table data-table--max-w-3xl"
                rows={@streams.client_o_logs}
              >
                <:col :let={{_dom_id, row}} label="Time">{row.time}</:col>
                <:col :let={{_dom_id, row}} label="Source">{row.source}</:col>
                <:col :let={{_dom_id, row}} label="Value">{row.value}</:col>
                <:empty>
                  <p>No forwarded event yet. Open or close the popover to see rows.</p>
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
