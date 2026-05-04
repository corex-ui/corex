defmodule E2eWeb.DataListApiLive do
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
      <.demo_page id="data-list-api-page" title="Data List · API" subtitle="Items API input.">
        <.demo_section
          id="data-list-api-items"
          title="Items"
          code={E2eWeb.Demos.DataListDemo.api_items_code()}
        >
          <:preview><E2eWeb.Demos.DataListDemo.api_items_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
