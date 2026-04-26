defmodule E2eWeb.EditableApiLive do
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
        id="editable-api-page"
        title="Editable · API"
        subtitle="Use value or default_value for initial text; on_value_change for server updates."
      >
        <.demo_section
          id="editable-api-overview"
          title="Overview"
          code={E2eWeb.Demos.EditableDemo.api_overview_code()}
        >
          <:preview>
            <E2eWeb.Demos.EditableDemo.api_overview_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
