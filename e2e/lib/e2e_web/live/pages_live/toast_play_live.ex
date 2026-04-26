defmodule E2eWeb.ToastPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

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
      <.demo_playground
        id="toast-playground"
        title="Toast · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <E2eWeb.Demos.ToastDemo.api_client_binding_example />
        </:controls>
        <:canvas>
          <p class="typo-sm text-ink-muted max-w-md">
            Toasts render in the layout toast group (<span class="font-mono">layout-toast</span>) in the app shell.
          </p>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
