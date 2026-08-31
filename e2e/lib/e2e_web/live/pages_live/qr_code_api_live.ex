defmodule E2eWeb.QrCodeApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="qr-code-api-page" title="QrCode · API" subtitle="Host API.">
        <.demo_section id="qr-code-api-minimal" title="Host">
          <:preview><.qr_code id="qr-code-api" class="qr-code" /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
