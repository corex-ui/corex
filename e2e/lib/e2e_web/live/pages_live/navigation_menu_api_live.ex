defmodule E2eWeb.NavigationMenuApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="navigation-menu-api-page"
        title="NavigationMenu · API"
        subtitle="Host API."
      >
        <.demo_section id="navigation-menu-api-minimal" title="Host">
          <:preview><.navigation_menu id="navigation-menu-api" class="navigation-menu" /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
