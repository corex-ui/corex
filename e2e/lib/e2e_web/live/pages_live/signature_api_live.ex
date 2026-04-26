defmodule E2eWeb.SignatureApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SignatureDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :codes, Demo.api_codes())}
  end

  @impl true
  def handle_event("signature_api_clear", _params, socket) do
    {:noreply, Corex.SignaturePad.clear(socket, "signature-api-srv")}
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
        id="signature-api-page"
        title="Signature Pad · API"
        subtitle="Clear the canvas from client bindings, client JS, or a server event."
      >
        <.demo_section
          id="signature-api-clear-client-binding"
          title="Clear (Client binding)"
          code={@codes.clear_client_binding}
        >
          <:preview><Demo.api_clear_client_binding_example /></:preview>
        </.demo_section>

        <.demo_section
          id="signature-api-clear-client-js"
          title="Clear (Client JS)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.clear_client_js_heex
            },
            %{
              value: "js",
              label: "JS",
              language: :js,
              code: @codes.clear_client_js
            },
            %{
              value: "ts",
              label: "TS",
              language: :javascript,
              code: @codes.clear_client_ts
            }
          ]}
        >
          <:preview><Demo.api_clear_client_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="signature-api-clear-server"
          title="Clear (Server)"
          code_tabs={[
            %{
              value: "heex",
              label: "Heex",
              language: :heex,
              code: @codes.clear_server_heex
            },
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.clear_server_elixir
            }
          ]}
        >
          <:preview><Demo.api_clear_server_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
