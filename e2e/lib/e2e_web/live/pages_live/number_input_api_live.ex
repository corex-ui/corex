defmodule E2eWeb.NumberInputApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.NumberInputDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("number_input_api_binding", _payload, socket) do
    {:noreply, socket}
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
        id="number-input-api-page"
        title="Number Input · API"
        subtitle="LiveView push, client DOM events, and initial value from attributes."
      >
        <.demo_section
          id="number-input-api-binding"
          title="LiveView binding"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_binding_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: Demo.api_binding_elixir()}
          ]}
        >
          <:preview><Demo.api_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-client"
          title="Client JS"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_client_heex()},
            %{value: "js", label: "JS", language: :js, code: Demo.api_client_js()},
            %{value: "ts", label: "TS", language: :javascript, code: Demo.api_client_ts()}
          ]}
        >
          <:preview><Demo.api_client_example /></:preview>
        </.demo_section>

        <.demo_section
          id="number-input-api-initial"
          title="Initial value"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.api_server_note_heex()},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: Demo.api_server_note_elixir()
            }
          ]}
        >
          <:preview><Demo.api_server_note_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
