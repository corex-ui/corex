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
      <:open_trigger>Close panel</:open_trigger>
      <:closed_trigger>Open panel</:closed_trigger>
      <:minimize_trigger>
        <.icon name="hero-arrow-down-left" />
      </:minimize_trigger>
      <:maximize_trigger>
        <.icon name="hero-x-mark" class="icon"/>
      </:maximize_trigger>
      <:default_trigger>
        <.icon name="hero-arrow-down-left" class="icon"/>
      </:default_trigger>
      <:close_trigger>
        <.icon name="hero-x-mark" class="icon"/>
      </:close_trigger>
      <:content>
        <p>
          Congue molestie ipsum gravida a. Sed ac eros luctus, cursus turpis
          non, pellentesque elit. Pellentesque sagittis fermentum.
        </p>
      </:content>
    </.floating_panel>
    </Layouts.app>
    """
  end
end
