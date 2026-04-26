defmodule E2eWeb.DialogApiLive do
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
        id="dialog-api-page"
        title="Dialog · API"
        subtitle="Client bindings for open/close."
      >
        <.demo_section
          id="dialog-api-client"
          title="Client bindings"
          code={E2eWeb.Demos.DialogDemo.api_client_binding_code()}
        >
          <:preview><E2eWeb.Demos.DialogDemo.api_client_binding_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
