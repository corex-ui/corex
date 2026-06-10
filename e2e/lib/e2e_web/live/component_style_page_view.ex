defmodule E2eWeb.ComponentStylePageView do
  @moduledoc false

  use E2eWeb, :html

  import E2eWeb.DemoPage, only: [demo_page: 1]

  def page(assigns) do
    ~H"""
    <Layouts.app flash={@flash} path={@path} mode={@mode} theme={@theme}>
      <.demo_page path={@path} id={@config.page_id} title={@config.title}>
        <.live_component
          module={@config.playground_module}
          id={"#{@config.slug}-style-playground"}
          component={@component}
        />
        <E2eWeb.ComponentStyleMatrix.style_matrix component={@component} />
      </.demo_page>
    </Layouts.app>
    """
  end
end
