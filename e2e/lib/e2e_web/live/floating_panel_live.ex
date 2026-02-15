defmodule E2eWeb.FloatingPanelLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Floating Panel</h1>
        <h2>Live View</h2>
      </div>
      <.floating_panel id="my-floating-panel" default_open={false} class="floating-panel">
        <:trigger>Open panel</:trigger>
        <div>Panel content</div>
      </.floating_panel>
    </Layouts.app>
    """
  end
end
