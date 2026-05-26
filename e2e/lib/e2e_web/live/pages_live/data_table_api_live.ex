defmodule E2eWeb.DataTableApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1]

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
        id="data-table-api-page"
        title="Data Table · API"
        subtitle="Data table is render-only."
      >
        <div class="layout__section">
          <div class="code-block">
            <div class="code-block__line">No API</div>
          </div>
        </div>
      </.demo_page>
    </Layouts.app>
    """
  end
end
