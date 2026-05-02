defmodule E2eWeb.SwitchApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SwitchDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("switch_api_on", _params, socket) do
    {:noreply, Corex.Switch.set_checked(socket, "switch-api-srv", true)}
  end

  @impl true
  def handle_event("switch_api_off", _params, socket) do
    {:noreply, Corex.Switch.set_checked(socket, "switch-api-srv", false)}
  end

  @impl true
  def handle_event("switch_api_toggle", _params, socket) do
    {:noreply, Corex.Switch.toggle_checked(socket, "switch-api-srv")}
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
        id="switch-api-page"
        title="Switch · API"
        subtitle="set_checked and toggle_checked via LiveView JS, DOM events on the hook root, or server push."
      >
        <.demo_section
          id="switch-api-set-checked-client-binding"
          title="LiveView binding"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.set_checked_client_binding}
          ]}
        >
          <:preview><Demo.api_set_checked_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="switch-api-set-checked-client-js"
          title="Client JS"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_checked_client_js_heex
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: @codes.set_checked_client_js
            },
            %{
              value: "ts",
              label: "TS",
              language: :javascript,
              code: @codes.set_checked_client_ts
            }
          ]}
        >
          <:preview><Demo.api_set_checked_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="switch-api-set-checked-server"
          title="Server push"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_checked_server_heex
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.set_checked_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_set_checked_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
