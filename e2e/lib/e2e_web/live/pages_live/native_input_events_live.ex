defmodule E2eWeb.NativeInputEventsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1]

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
        id="native-input-events-page"
        title="Native Input · Events"
        subtitle="Native inputs do not emit component events."
      >
        <div class="layout__section">
          <div class="code-block">
            <div class="code-block__line">No events</div>
          </div>
        </div>
      </.demo_page>
    </Layouts.app>
    """
  end
end
