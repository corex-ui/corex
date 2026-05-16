defmodule E2eWeb.ToggleGroupApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToggleGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("tg_api_lorem", _params, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["lorem"])}
  end

  @impl true
  def handle_event("tg_api_duis", _params, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["duis"])}
  end

  @impl true
  def handle_event("tg_api_donec", _params, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", ["donec"])}
  end

  @impl true
  def handle_event("tg_api_clear", _params, socket) do
    {:noreply, Corex.ToggleGroup.set_value(socket, "toggle-group-api-srv", [])}
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
        id="toggle-group-api-page"
        title="Toggle group · API"
        subtitle="set_value via LiveView JS, DOM events on the hook root, or server push."
      >
        <.demo_section
          id="toggle-group-api-set-value-client-binding"
          title="LiveView binding"
          code={@codes.set_value_client_binding}
        >
          <:preview><Demo.api_set_value_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toggle-group-api-set-value-client-js"
          title="Client JS"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_value_client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_value_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_value_client_ts}
          ]}
        >
          <:preview><Demo.api_set_value_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toggle-group-api-set-value-server"
          title="Server push"
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
