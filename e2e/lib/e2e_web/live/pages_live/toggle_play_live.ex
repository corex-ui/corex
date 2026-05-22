defmodule E2eWeb.TogglePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :disabled, false)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, assign(socket, :disabled, id == "disabled" and checked)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_playground path={@path} title="Toggle · Playground" heading_class="layout-heading">
        <:controls>
          <.switch
            class="switch"
            id="disabled"
            checked={@disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.toggle id="toggle-playground" class="toggle" disabled={@disabled}>
            lorem
          </.toggle>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
