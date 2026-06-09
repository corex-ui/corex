defmodule E2eWeb.ActionPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:type_snippets, E2eWeb.AuthoringSnippet.heex_snippets(E2eWeb.Demos.ActionDemo.patterns_type_code()))
     |> assign(
       :phx_click_snippets,
       E2eWeb.AuthoringSnippet.heex_snippets(E2eWeb.Demos.ActionDemo.patterns_phx_click_code())
     )
     |> assign(
       :phx_click_js_snippets,
       E2eWeb.AuthoringSnippet.heex_snippets(E2eWeb.Demos.ActionDemo.patterns_phx_click_js_code())
     )}
  end

  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

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
        id="action-patterns-page"
        title={~t"Action · Pattern"}
        subtitle={~t"type, phx-click, and Corex JS commands on <.action>."}
      >
        <.demo_section
          id="action-patterns-type"
          title={~t"Type"}
          code={@type_snippets}
        >
          <:preview><E2eWeb.Demos.ActionDemo.patterns_type_example /></:preview>
        </.demo_section>

        <.demo_section
          id="action-patterns-phx-click"
          title={~t"Trigger · phx-click"}
          code={@phx_click_snippets}
        >
          <:preview><E2eWeb.Demos.ActionDemo.patterns_phx_click_example /></:preview>
        </.demo_section>

        <.demo_section
          id="action-patterns-phx-click-js"
          title={~t"Trigger · phx-click JS"}
          code={@phx_click_js_snippets}
        >
          <:preview><E2eWeb.Demos.ActionDemo.patterns_phx_click_js_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
