defmodule E2eWeb.MenuPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.MenuDemo, as: Demo

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

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
        id="menu-patterns-page"
        title="Menu · Patterns"
        subtitle="Redirect menus: in-app paths, external docs (Zag.js, Phoenix LiveView), and per-item :href vs :navigate."
      >
        <.demo_section
          id="menu-patterns-redirect"
          title="Redirect"
          code={Demo.patterns_redirect_code()}
        >
          <:preview><Demo.patterns_redirect_example /></:preview>
        </.demo_section>

        <.demo_section
          id="menu-patterns-redirect-external"
          title="Redirect external"
          code={Demo.patterns_redirect_external_code()}
        >
          <:preview><Demo.patterns_redirect_external_example /></:preview>
        </.demo_section>

        <.demo_section
          id="menu-patterns-redirect-types"
          title="Redirect types"
          code={Demo.patterns_redirect_types_code()}
        >
          <:preview><Demo.patterns_redirect_types_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
