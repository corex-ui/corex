defmodule E2eWeb.RadioGroupApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :api_controlled_value, "lorem")}
  end

  @impl true
  def handle_event("radio_group_api_binding", _payload, socket) do
    {:noreply, socket}
  end

  def handle_event("radio_group_api_controlled", %{"value" => v}, socket) do
    {:noreply, assign(socket, :api_controlled_value, v)}
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
        subtitle="LiveView push, client DOM events, and controlled value from the server."
      >
        <.demo_section
          id="radio-group-api-clear-section"
          title="Clear value"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_clear_value_heex()},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: Demo.api_clear_value_elixir()
            }
          ]}
        >
          <:preview><Demo.api_clear_value_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-focus-section"
          title={~t"Focus"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_focus_heex()},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: Demo.api_focus_elixir()}
          ]}
        >
          <:preview><Demo.api_focus_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-server-section"
          title={~t"Set value (server)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_server_heex()},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: Demo.api_server_elixir()}
          ]}
        >
          <:preview><Demo.api_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-binding-section"
          title={~t"LiveView binding"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_binding_heex()},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: Demo.api_binding_elixir()}
          ]}
        >
          <:preview><Demo.api_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-client-section"
          title={~t"Client JS"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_client_heex()},
            %{value: "js", label: ~t"JS", language: :js, code: Demo.api_client_js()},
            %{value: "ts", label: ~t"TS", language: :javascript, code: Demo.api_client_ts()}
          ]}
        >
          <:preview><Demo.api_client_example /></:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-api-controlled-section"
          title={~t"Controlled value"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.api_controlled_heex()},
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.api_controlled_elixir()
            }
          ]}
        >
          <:preview><Demo.api_controlled_example value={@api_controlled_value} /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
