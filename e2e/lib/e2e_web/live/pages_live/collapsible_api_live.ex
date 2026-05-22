defmodule E2eWeb.CollapsibleApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.CollapsibleDemo, as: Demo

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
  def handle_event("collapsible_api_open", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "collapsible-api-server", true)}
  end

  def handle_event("collapsible_api_close", _, socket) do
    {:noreply, Corex.Collapsible.set_open(socket, "collapsible-api-server", false)}
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
        id="collapsible-api-page"
        title="Collapsible · API"
        subtitle="Open and close from LiveView bindings, DOM events, or server push."
      >
        <.demo_section
          id="collapsible-api-client-binding"
          title="Client bindings"
          code={@codes.binding}
        >
          <:preview>
            <Demo.api_client_binding_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="collapsible-api-client-js"
          title="Client JS"
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
          id="collapsible-api-server-section"
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
