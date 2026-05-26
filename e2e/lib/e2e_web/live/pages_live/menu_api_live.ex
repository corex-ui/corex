defmodule E2eWeb.MenuApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.MenuDemo, as: Demo

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_event("menu_api_server_open", _, socket) do
    {:noreply, Corex.Menu.set_open(socket, "menu-api-server", true)}
  end

  def handle_event("menu_api_server_close", _, socket) do
    {:noreply, Corex.Menu.set_open(socket, "menu-api-server", false)}
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
        id="menu-api-page"
        title="Menu · API"
        subtitle="Open and close imperatively: LiveView bindings, DOM events, or server push."
      >
        <.demo_section
          id="menu-api-binding"
          title="Open / close (Client Binding)"
          code={Demo.api_client_binding_code()}
        >
          <:preview><Demo.api_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="menu-api-client-js"
          title="Open / close (client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_client_js_heex()},
            %{value: "js", label: "JS", language: :js, code: Demo.api_client_js_js()},
            %{value: "ts", label: "TS", language: :javascript, code: Demo.api_client_js_ts()}
          ]}
        >
          <:preview><Demo.api_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="menu-api-server-section"
          title="Open / close (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_server_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: Demo.api_server_elixir()}
          ]}
        >
          <:preview><Demo.api_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
