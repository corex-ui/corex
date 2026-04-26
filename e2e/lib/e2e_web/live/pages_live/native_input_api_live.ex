defmodule E2eWeb.NativeInputApiLive do
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
        id="native-input-api-page"
        title="Native Input · API"
        subtitle="Native inputs are plain HTML."
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
