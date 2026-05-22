defmodule E2eWeb.DatePickerEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.DatePickerDemo, as: D

  @on_value_server_heex D.events_on_value_server_heex()
  @on_value_server_elixir D.events_on_value_server_elixir()
  @on_open_server_heex D.events_on_open_server_heex()
  @on_open_server_elixir D.events_on_open_server_elixir()
  @on_value_client_heex D.events_on_value_client_heex()
  @on_value_client_js D.events_on_value_client_js()
  @on_value_client_ts D.events_on_value_client_ts()
  @on_open_client_heex D.events_on_open_client_heex()
  @on_open_client_js D.events_on_open_client_js()
  @on_open_client_ts D.events_on_open_client_ts()

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:on_value_server_heex, @on_value_server_heex)
      |> assign(:on_value_server_elixir, @on_value_server_elixir)
      |> assign(:on_open_server_heex, @on_open_server_heex)
      |> assign(:on_open_server_elixir, @on_open_server_elixir)
      |> assign(:on_value_client_heex, @on_value_client_heex)
      |> assign(:on_value_client_js, @on_value_client_js)
      |> assign(:on_value_client_ts, @on_value_client_ts)
      |> assign(:on_open_client_heex, @on_open_client_heex)
      |> assign(:on_open_client_js, @on_open_client_js)
      |> assign(:on_open_client_ts, @on_open_client_ts)
      |> stream(:server_value_logs, [])
      |> stream(:server_open_logs, [])
      |> stream(:client_value_logs, [])
      |> stream(:client_open_logs, [])

    {:ok, socket}
  end

  def handle_event("dpe_on_value_server", %{"id" => id, "value" => value}, socket) do
    log = new_log("server", id, inspect(value))
    {:noreply, stream_insert(socket, :server_value_logs, log, at: 0)}
  end

  def handle_event("dpe_on_open_server", %{"id" => id, "open" => open}, socket) do
    log = new_log("server", id, inspect(open))
    {:noreply, stream_insert(socket, :server_open_logs, log, at: 0)}
  end

  def handle_event("dpe_on_value_client", %{"id" => id, "value" => value}, socket) do
    log = new_log("client", id, inspect(value))
    {:noreply, stream_insert(socket, :client_value_logs, log, at: 0)}
  end

  def handle_event("dpe_on_open_client", %{"id" => id, "open" => open}, socket) do
    log = new_log("client", id, inspect(open))
    {:noreply, stream_insert(socket, :client_open_logs, log, at: 0)}
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
        id="date-picker-events-page"
        title={~t"Date Picker · Event"}
        subtitle={
          ~t"Subscribe to value or open changes on LiveView, or to CustomEvent on the client."
        }
      >
        <.demo_section
          id="date-picker-events-on-value-server"
          title={~t"On value change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @on_value_server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @on_value_server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.date_picker
                id="date-picker-e-sv"
                translation={
                  %Corex.DatePicker.Translation{
                    open_calendar: "Select date",
                    close_calendar: "Select date",
                    input: "Select date"
                  }
                }
                class="date-picker"
                on_value_change="dpe_on_value_server"
              >
                <:label>Select a date</:label>
                <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
                <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
                <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
              </.date_picker>

              <.data_table
                id="date-picker-events-log-sv"
                class="data-table max-w-3xl"
                rows={@streams.server_value_logs}
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
          id="date-picker-events-on-open-server"
          title={~t"On open change (Server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @on_open_server_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @on_open_server_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.date_picker
                id="date-picker-e-so"
                translation={
                  %Corex.DatePicker.Translation{
                    open_calendar: "Select date",
                    close_calendar: "Select date",
                    input: "Select date"
                  }
                }
                class="date-picker"
                on_open_change="dpe_on_open_server"
              >
                <:label>Select a date</:label>
                <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
                <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
                <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
              </.date_picker>

              <.data_table
                id="date-picker-events-log-so"
                class="data-table max-w-3xl"
                rows={@streams.server_open_logs}
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
          id="date-picker-events-on-value-client"
          title={~t"On value change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @on_value_client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @on_value_client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @on_value_client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.date_picker
                id="date-picker-e-cv"
                translation={
                  %Corex.DatePicker.Translation{
                    open_calendar: "Select date",
                    close_calendar: "Select date",
                    input: "Select date"
                  }
                }
                class="date-picker"
                on_value_change_client="date-picker-value-changed"
              >
                <:label>Select a date</:label>
                <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
                <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
                <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
              </.date_picker>

              <div
                id="date-picker-events-cv-listener"
                class="w-full"
                phx-hook=".DatePickerEventClientValue"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".DatePickerEventClientValue">
                  export default {
                    mounted() {
                      const el = document.getElementById("date-picker-e-cv");
                      if (!el) return;
                      el.addEventListener("date-picker-value-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("dpe_on_value_client", { id: d.id, value: d.value });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="date-picker-events-log-cv"
                class="data-table max-w-3xl"
                rows={@streams.client_value_logs}
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
          id="date-picker-events-on-open-client"
          title={~t"On open change (Client)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @on_open_client_heex},
            %{value: "js", label: ~t"JS", language: :js, code: @on_open_client_js},
            %{value: "ts", label: ~t"TS", language: :javascript, code: @on_open_client_ts}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-4 items-center w-full">
              <.date_picker
                id="date-picker-e-co"
                translation={
                  %Corex.DatePicker.Translation{
                    open_calendar: "Select date",
                    close_calendar: "Select date",
                    input: "Select date"
                  }
                }
                class="date-picker"
                on_open_change_client="date-picker-open-changed"
              >
                <:label>Select a date</:label>
                <:trigger><.heroicon name="hero-calendar" class="icon" /></:trigger>
                <:prev_trigger><.heroicon name="hero-chevron-left" class="icon" /></:prev_trigger>
                <:next_trigger><.heroicon name="hero-chevron-right" class="icon" /></:next_trigger>
              </.date_picker>

              <div
                id="date-picker-events-co-listener"
                class="w-full"
                phx-hook=".DatePickerEventClientOpen"
                phx-update="ignore"
              >
                <script :type={Phoenix.LiveView.ColocatedHook} name=".DatePickerEventClientOpen">
                  export default {
                    mounted() {
                      const el = document.getElementById("date-picker-e-co");
                      if (!el) return;
                      el.addEventListener("date-picker-open-changed", (event) => {
                        const d = event.detail;
                        this.pushEvent("dpe_on_open_client", { id: d.id, open: d.open });
                      });
                    }
                  }
                </script>
              </div>

              <.data_table
                id="date-picker-events-log-co"
                class="data-table max-w-3xl"
                rows={@streams.client_open_logs}
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
