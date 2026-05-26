defmodule E2eWeb.TabsApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TabsDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("tabs_api_lorem", _params, socket) do
    {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", "lorem")}
  end

  @impl true
  def handle_event("tabs_api_duis", _params, socket) do
    {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", "duis")}
  end

  @impl true
  def handle_event("tabs_api_close", _params, socket) do
    {:noreply, Corex.Tabs.set_value(socket, "tabs-api-srv", nil)}
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
        id="tabs-api-page"
        title="Tabs · API"
        subtitle="Set the active value from client bindings, client JS, or a server event."
      >
        <.demo_section
          id="tabs-api-set-value-client-binding"
          title="Set value (Client binding)"
          code={@codes.set_value_client_binding}
        >
          <:preview><Demo.api_set_value_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="tabs-api-set-value-client-js"
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
          id="tabs-api-set-value-server"
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
      </.demo_page>
    </Layouts.app>
    """
  end
end
