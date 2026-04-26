defmodule E2eWeb.SelectApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SelectDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("select_api_on_value_server", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_api_server_set", %{"value" => ""}, socket) do
    {:noreply, Corex.Select.set_value(socket, "select-api-srv", [])}
  end

  @impl true
  def handle_event("select_api_server_set", %{"value" => v}, socket) when is_binary(v) do
    {:noreply, Corex.Select.set_value(socket, "select-api-srv", [v])}
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
        id="select-api-page"
        title="Select · API"
        subtitle="Change handlers, Set value, and Set open from LiveView, client actions, and server events."
      >
        <.demo_section
          id="select-api-on-value-server"
          title="On value change (Server)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.on_value_server_heex
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.on_value_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_on_value_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="select-api-on-value-client"
          title="On value change (Client)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.on_value_client_heex
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: @codes.on_value_client_js
            },
            %{
              value: "ts",
              label: "TS",
              language: :javascript,
              code: @codes.on_value_client_ts
            }
          ]}
        >
          <:preview><Demo.api_on_value_client_example /></:preview>
        </.demo_section>

        <.demo_section
          id="select-api-set-value-client-binding"
          title="Set value (Client binding)"
          code={@codes.set_value_client_binding}
        >
          <:preview><Demo.api_set_value_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="select-api-set-value-client-js"
          title="Set value (Client JS)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_value_client_js_heex
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: @codes.set_value_client_js
            },
            %{
              value: "ts",
              label: "TS",
              language: :javascript,
              code: @codes.set_value_client_ts
            }
          ]}
        >
          <:preview><Demo.api_set_value_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="select-api-set-value-server"
          title="Set value (Server)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.set_value_server_heex
            },
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
