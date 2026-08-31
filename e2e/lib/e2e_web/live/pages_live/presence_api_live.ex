defmodule E2eWeb.PresenceApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="presence-api-page" title="Presence · API" subtitle="Host API.">
        <.demo_section id="presence-api-minimal" title="Host">
          <:preview><.presence id="presence-api" class="presence" /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
