defmodule E2eWeb.MarqueeApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.MarqueeDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, demo_codes())}
  end

  defp demo_codes do
    %{
      controls_binding: Demo.api_controls_client_binding_code(),
      controls_js_heex: Demo.api_controls_client_js_heex(),
      controls_js: Demo.api_controls_client_js_js(),
      controls_js_ts: Demo.api_controls_client_js_ts(),
      controls_server_heex: Demo.api_controls_server_heex(),
      controls_server_elixir: Demo.api_controls_server_elixir()
    }
  end

  @impl true
  def handle_event("marquee_api_server_pause", _, socket) do
    {:noreply, Corex.Marquee.pause(socket, "api-controls-server")}
  end

  def handle_event("marquee_api_server_resume", _, socket) do
    {:noreply, Corex.Marquee.resume(socket, "api-controls-server")}
  end

  def handle_event("marquee_api_server_toggle_pause", _, socket) do
    {:noreply, Corex.Marquee.toggle_pause(socket, "api-controls-server")}
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
        id="marquee-api-page"
        title="Marquee · API"
        subtitle="Pause, resume, and toggle from LiveView bindings, client JS, or server push."
      >
        <.demo_section
          id="marquee-api-controls-binding"
          title="Controls (Client Binding)"
          code={@codes.controls_binding}
        >
          <:preview><Demo.api_controls_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-controls-js"
          title="Controls (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.controls_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.controls_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.controls_js_ts}
          ]}
        >
          <:preview><Demo.api_controls_client_js_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-controls-server"
          title="Controls (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.controls_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.controls_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_controls_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
