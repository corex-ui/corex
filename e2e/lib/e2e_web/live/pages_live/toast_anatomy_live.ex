defmodule E2eWeb.ToastAnatomyLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToastDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="toast-anatomy-page"
        title={~t"Toast · Anatomy"}
        subtitle={
          ~t"Toast type, duration, loading, and three trigger styles (redirect, Phoenix.LiveView.JS, custom label)."
        }
      >
        <.demo_section
          id="toast-anatomy-type"
          title={~t"Type"}
          code={Demo.anatomy_type_code()}
        >
          <:preview><Demo.anatomy_type_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-anatomy-duration"
          title={~t"Duration"}
          code={Demo.anatomy_duration_code()}
        >
          <:preview><Demo.anatomy_duration_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-anatomy-loading"
          title={~t"Loading"}
          code={Demo.anatomy_loading_code()}
        >
          <:preview><Demo.anatomy_loading_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-anatomy-trigger-redirect"
          title={~t"Trigger · Redirect"}
          code={Demo.anatomy_trigger_redirect_code()}
        >
          <:preview><Demo.anatomy_trigger_redirect_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-anatomy-trigger-live-view-js"
          title={~t"Trigger · Live View JS"}
          code={Demo.anatomy_trigger_live_view_js_code()}
        >
          <:preview><Demo.anatomy_trigger_live_view_js_example /></:preview>
        </.demo_section>

        <.demo_section
          id="toast-anatomy-trigger-custom-label"
          title={~t"Trigger · Custom label"}
          code={Demo.anatomy_trigger_custom_label_code()}
        >
          <:preview><Demo.anatomy_trigger_custom_label_example /></:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
