defmodule E2eWeb.RadioGroupApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("radio_group_api_lorem", _params, socket) do
    {:noreply, Corex.RadioGroup.set_value(socket, "radio-group-api-srv", "lorem")}
  end

  def handle_event("radio_group_api_duis", _params, socket) do
    {:noreply, Corex.RadioGroup.set_value(socket, "radio-group-api-srv", "duis")}
  end

  def handle_event("radio_group_api_donec", _params, socket) do
    {:noreply, Corex.RadioGroup.set_value(socket, "radio-group-api-srv", "donec")}
  end

  def handle_event("radio_group_api_clear_server", _params, socket) do
    {:noreply, Corex.RadioGroup.clear_value(socket, "radio-group-api-srv")}
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
        id="radio-group-api-page"
        title="Radio Group · API"
        subtitle="Set value, clear, and focus from client bindings, client JS, or the server."
      >
        <.demo_section
          id="radio-group-api-set-value-client-binding"
          title="Set value (Client binding)"
          code={@codes.set_value_client_binding}
        >
          <:preview><Demo.api_set_value_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-set-value-client-js"
          title="Set value (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_client_ts}
          ]}
        >
          <:preview><Demo.api_set_value_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-set-value-server"
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
          <:preview><Demo.api_set_value_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-clear-section"
          title="Clear value"
          code={@codes.clear_value_binding}
        >
          <:preview><Demo.api_clear_value_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-focus-section"
          title={~t"Focus"}
          code={@codes.focus_binding}
        >
          <:preview><Demo.api_focus_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
