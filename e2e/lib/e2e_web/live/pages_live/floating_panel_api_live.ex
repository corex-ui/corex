defmodule E2eWeb.FloatingPanelApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.FloatingPanelDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, demo_codes())}
  end

  defp demo_codes do
    %{
      binding: Demo.api_client_binding_code(),
      js_heex: Demo.api_client_js_heex(),
      js: Demo.api_client_js_js(),
      js_ts: Demo.api_client_js_ts(),
      server_heex: Demo.api_server_heex(),
      server_elixir: Demo.api_server_elixir()
    }
  end

  @impl true
  def handle_event("floating_panel_api_server_open", _, socket) do
    {:noreply, Corex.FloatingPanel.set_open(socket, "floating-panel-api-server", true)}
  end

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
        path={@path}
        id="floating-panel-api-page"
        title="Floating Panel · API"
        subtitle="Imperative open and close with Corex.FloatingPanel.set_open/2 (client) and set_open/3 (server)."
      >
        <.demo_section
          id="floating-panel-api-client-bindings"
          title="Client bindings"
          code={@codes.binding}
        >
          <:preview>
            <Demo.api_client_binding_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="floating-panel-api-client-js"
          title="Client JavaScript"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.js_ts}
          ]}
        >
          <:preview>
            <Demo.api_client_js_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="floating-panel-api-server-section"
          title="Server"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir}
          ]}
        >
          <:preview>
            <Demo.api_server_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
