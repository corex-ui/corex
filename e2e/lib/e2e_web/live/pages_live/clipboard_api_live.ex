defmodule E2eWeb.ClipboardApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, demo_codes())}
  end

  defp demo_codes do
    m = E2eWeb.Demos.ClipboardDemo

    %{
      client_binding: m.api_client_binding_code(),
      client_elixir: m.api_client_elixir_note(),
      server_elixir_combo: m.api_server_elixir_combo(),
      server_preview_heex: m.api_server_preview_heex(),
      dispatch_heex: m.api_dispatch_heex(),
      dispatch_js: m.api_dispatch_js()
    }
  end

  @impl true
  def handle_event("clipboard_api_server_copy", _params, socket) do
    {:noreply, Corex.Clipboard.copy(socket, "clipboard-api-server")}
  end

  @impl true
  def handle_event("clipboard_api_server_set", _params, socket) do
    {:noreply, Corex.Clipboard.set_value(socket, "clipboard-api-server", "set-from-server")}
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
        id="clipboard-api-page"
        title="Clipboard · API"
        subtitle="Client bindings, JS and server API."
      >
        <.demo_section
          id="clipboard-api-client-section"
          title="Copy and set value (Client Binding)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.client_binding},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.client_elixir}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.ClipboardDemo.api_client_binding_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="clipboard-api-server-section"
          title="Copy and set value (Server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.server_preview_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.server_elixir_combo}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 mb-4">
              <.action phx-click="clipboard_api_server_copy" size="sm">
                Push copy
              </.action>
              <.action phx-click="clipboard_api_server_set" size="sm">
                Push set value
              </.action>
            </div>
            <.clipboard
              id="clipboard-api-server"
              value="server-push@example.com"
              trigger_aria_label="Copy"
              input_aria_label="Value"
            >
              <:label>Server-driven</:label>
              <:copy>
                <.heroicon name="hero-clipboard" />
              </:copy>
              <:copied>
                <.heroicon name="hero-check" />
              </:copied>
            </.clipboard>
          </:preview>
        </.demo_section>

        <.demo_section
          id="clipboard-api-dispatch-section"
          title="Copy (Client JS)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.dispatch_heex
            },
            %{value: "js", label: "JS", language: :javascript, code: @codes.dispatch_js}
          ]}
        >
          <:preview>
            <E2eWeb.Demos.ClipboardDemo.api_dispatch_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
