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
      pause_binding: Demo.api_pause_client_binding_code(),
      pause_js_heex: Demo.api_pause_client_js_heex(),
      pause_js: Demo.api_pause_client_js_js(),
      pause_js_ts: Demo.api_pause_client_js_ts(),
      pause_server_heex: Demo.api_pause_server_heex(),
      pause_server_elixir: Demo.api_pause_server_elixir(),
      resume_binding: Demo.api_resume_client_binding_code(),
      resume_js_heex: Demo.api_resume_client_js_heex(),
      resume_js: Demo.api_resume_client_js_js(),
      resume_js_ts: Demo.api_resume_client_js_ts(),
      resume_server_heex: Demo.api_resume_server_heex(),
      resume_server_elixir: Demo.api_resume_server_elixir(),
      toggle_binding: Demo.api_toggle_client_binding_code(),
      toggle_js_heex: Demo.api_toggle_client_js_heex(),
      toggle_js: Demo.api_toggle_client_js_js(),
      toggle_js_ts: Demo.api_toggle_client_js_ts(),
      toggle_server_heex: Demo.api_toggle_server_heex(),
      toggle_server_elixir: Demo.api_toggle_server_elixir()
    }
  end

  @impl true
  def handle_event("marquee_api_server_pause", _, socket) do
    {:noreply, Corex.Marquee.pause(socket, "api-pause-server")}
  end

  def handle_event("marquee_api_server_resume", _, socket) do
    {:noreply, Corex.Marquee.resume(socket, "api-resume-server")}
  end

  def handle_event("marquee_api_server_toggle_pause", _, socket) do
    {:noreply, Corex.Marquee.toggle_pause(socket, "api-toggle-server")}
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
        id="marquee-api-page"
        title="Marquee · API"
        subtitle="Pause, resume, and toggle from LiveView bindings, client JS, or server push."
      >
        <.demo_section
          id="marquee-api-pause-binding"
          title="Pause (Client Binding)"
          code={@codes.pause_binding}
        >
          <:preview><Demo.api_pause_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-pause-js"
          title="Pause (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.pause_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.pause_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.pause_js_ts}
          ]}
        >
          <:preview><Demo.api_pause_client_js_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-pause-server"
          title="Pause (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.pause_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.pause_server_elixir}
          ]}
        >
          <:preview><Demo.api_pause_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="marquee-api-resume-binding"
          title="Resume (Client Binding)"
          code={@codes.resume_binding}
        >
          <:preview><Demo.api_resume_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-resume-js"
          title="Resume (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.resume_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.resume_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.resume_js_ts}
          ]}
        >
          <:preview><Demo.api_resume_client_js_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-resume-server"
          title="Resume (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.resume_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.resume_server_elixir}
          ]}
        >
          <:preview><Demo.api_resume_server_example /></:preview>
        </.demo_section>

        <.demo_section
          id="marquee-api-toggle-binding"
          title="Toggle pause (Client Binding)"
          code={@codes.toggle_binding}
        >
          <:preview><Demo.api_toggle_client_binding_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-toggle-js"
          title="Toggle pause (Client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.toggle_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.toggle_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.toggle_js_ts}
          ]}
        >
          <:preview><Demo.api_toggle_client_js_example /></:preview>
        </.demo_section>
        <.demo_section
          id="marquee-api-toggle-server"
          title="Toggle pause (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.toggle_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.toggle_server_elixir}
          ]}
        >
          <:preview><Demo.api_toggle_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
