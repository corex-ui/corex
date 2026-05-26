defmodule E2eWeb.LayoutHeadingPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
        id="layout-heading-playground"
        title="Layout Heading · Playground"
        subtitle="Common layout heading combinations."
      >
        <.demo_section
          id="layout-heading-play-title-only"
          title="Title only"
          code={E2eWeb.Demos.LayoutHeadingDemo.title_only_code()}
        >
          <:preview><E2eWeb.Demos.LayoutHeadingDemo.title_only_example /></:preview>
        </.demo_section>

        <.demo_section
          id="layout-heading-play-title-subtitle"
          title="Title and subtitle"
          code={E2eWeb.Demos.LayoutHeadingDemo.title_and_subtitle_code()}
        >
          <:preview><E2eWeb.Demos.LayoutHeadingDemo.title_and_subtitle_example /></:preview>
        </.demo_section>

        <.demo_section
          id="layout-heading-play-actions"
          title="With actions"
          code={E2eWeb.Demos.LayoutHeadingDemo.with_actions_code()}
        >
          <:preview><E2eWeb.Demos.LayoutHeadingDemo.with_actions_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
