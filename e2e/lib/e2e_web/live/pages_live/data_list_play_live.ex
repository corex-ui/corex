defmodule E2eWeb.DataListPlayLive do
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
        id="data-list-playground-page"
        title="Data List · Playground"
        subtitle="A minimal set of examples."
      >
        <.demo_section
          id="data-list-play-basic"
          title="Basic"
          code={E2eWeb.Demos.DataListDemo.anatomy_basic_code()}
        >
          <:preview><E2eWeb.Demos.DataListDemo.anatomy_basic_example /></:preview>
        </.demo_section>

        <.demo_section
          id="data-list-play-items-api"
          title="Items API"
          code={E2eWeb.Demos.DataListDemo.api_items_code()}
        >
          <:preview><E2eWeb.Demos.DataListDemo.api_items_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
