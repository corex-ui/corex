defmodule E2eWeb.TooltipApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TooltipDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("tooltip_api_open", _params, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", true)}
  end

  @impl true
  def handle_event("tooltip_api_close", _params, socket) do
    {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", false)}
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
        id="tooltip-api-page"
        title="Tooltip · API"
        subtitle="Set open from client bindings, client JS, or a server event."
      >
        <.demo_section
          id="tooltip-api-set-open-client-binding"
          title="Set open (Client binding)"
          code={@codes.set_open_client_binding}
        >
          <:preview><Demo.api_set_open_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="tooltip-api-set-open-client-js"
          title="Set open (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_open_client_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.set_open_client_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.set_open_client_ts}
          ]}
        >
          <:preview><Demo.api_set_open_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="tooltip-api-set-open-server"
          title="Set open (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_open_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_open_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_set_open_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
