defmodule E2eWeb.ToastAnatomyLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToastDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("toast_anatomy_redirect", _params, socket) do
    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Saved",
       "Action redirects to this anatomy page.",
       :success,
       id: "toast-anatomy-redirect",
       duration: 30_000,
       action: %{
         label: "Same page",
         class: "button ui-accent ui-size-sm",
         js: JS.patch(~p"/toast/anatomy")
       }
     )}
  end

  @impl true
  def handle_event("toast_anatomy_dismiss", _params, socket) do
    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Dismiss me",
       "Action runs a Phoenix.LiveView.JS command.",
       :info,
       id: "toast-anatomy-dismiss",
       duration: :infinity,
       action: %{
         label: "Dismiss",
         class: "button ui-accent ui-size-sm",
         js: Corex.Toast.dismiss("layout-toast", "toast-anatomy-dismiss")
       }
     )}
  end

  @impl true
  def handle_event("toast_anatomy_custom_label", _params, socket) do
    assigns = %{}

    label = ~H"""
    <.heroicon name="hero-arrow-top-right-on-square" /> Open
    """

    {:noreply,
     Corex.Toast.create(
       socket,
       "layout-toast",
       "Open docs",
       "Label is rendered from ~H with a heroicon.",
       :info,
       id: "toast-anatomy-custom-label",
       duration: 30_000,
       action: %{
         label: label,
         class: "button ui-accent ui-size-sm",
         js: JS.patch(~p"/toast/anatomy")
       }
     )}
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
          ~t"Toast type, duration, loading, and three action trigger styles (redirect, Phoenix.LiveView.JS, custom label). Action triggers require server create/6."
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
