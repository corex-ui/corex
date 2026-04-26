defmodule E2eWeb.FloatingPanelApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("floating_panel_api_server_open", _, socket) do
    {:noreply, Corex.FloatingPanel.set_open(socket, "floating-panel-api-server", true)}
  end

  @impl true
  def handle_event("floating_panel_api_server_close", _, socket) do
    {:noreply, Corex.FloatingPanel.set_open(socket, "floating-panel-api-server", false)}
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
        id="floating-panel-api-page"
        title="Floating Panel · API"
        subtitle="Imperative open and close with Corex.FloatingPanel.set_open/2 (client) and set_open/3 (server)."
      >
        <.demo_section
          id="floating-panel-api-client-bindings"
          title="Client bindings"
          code={E2eWeb.Demos.FloatingPanelDemo.api_client_binding_code()}
        >
          <:preview>
            <E2eWeb.Demos.FloatingPanelDemo.api_client_binding_example />
          </:preview>
        </.demo_section>
        <.demo_section
          id="floating-panel-api-client-js"
          title="Client JavaScript"
          code={E2eWeb.Demos.FloatingPanelDemo.api_client_js_code()}
        >
          <:preview>
            <E2eWeb.Demos.FloatingPanelDemo.api_client_js_example />
          </:preview>
        </.demo_section>
        <.demo_section
          id="floating-panel-api-server"
          title="Server"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: E2eWeb.Demos.FloatingPanelDemo.api_server_heex_code()
            },
            %{
              value: "elixir",
              label: "LiveView",
              language: :elixir,
              code: E2eWeb.Demos.FloatingPanelDemo.api_server_handler_code()
            }
          ]}
        >
          <:preview>
            <E2eWeb.Demos.FloatingPanelDemo.api_server_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
