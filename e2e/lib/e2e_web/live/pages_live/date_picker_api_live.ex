defmodule E2eWeb.DatePickerApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    m = E2eWeb.Demos.DatePickerDemo

    socket =
      socket
      |> assign(:codes, %{
        set_value_client: m.api_set_value_client_binding_code(),
        set_value_js_heex: m.api_set_value_client_js_heex(),
        set_value_js: m.api_set_value_client_js_js(),
        set_value_js_ts: m.api_set_value_client_js_ts(),
        set_value_server_heex: m.api_set_value_server_heex(),
        set_value_server_elixir: m.api_set_value_server_elixir()
      })

    {:ok, socket}
  end

  @impl true
  def handle_event("date_picker_api_set_value", %{"date" => value}, socket) do
    {:noreply, Corex.DatePicker.set_value(socket, "date-picker-api-sv-server", value)}
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
        id="date-picker-api-page"
        title="Date Picker · API"
        subtitle="Set the value from a LiveView binding, from JS, or from the server."
      >
        <.demo_section
          id="date-picker-api-set-value-binding"
          title="Set value (Client binding)"
          code={@codes.set_value_client}
        >
          <:preview>
            <E2eWeb.Demos.DatePickerDemo.api_set_value_client_binding_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-api-set-value-js"
          title="Set value (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_js_ts}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.DatePickerDemo.api_set_value_client_js_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="date-picker-api-set-value-server"
          title="Set value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_value_server_elixir
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.DatePickerDemo.api_set_value_server_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
