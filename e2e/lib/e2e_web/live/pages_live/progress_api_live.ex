defmodule E2eWeb.ProgressApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page path={@path} id="progress-api-page" title="Progress · API" subtitle="Host API.">
        <.demo_section id="progress-api-minimal" title="Host">
          <:preview><.progress id="progress-api" class="progress" /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
