defmodule E2eWeb.SwitchControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checked, false)}
  end

  def handle_event("checked_changed", %{"checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end

  def handle_event("set_on", _params, socket) do
    {:noreply, assign(socket, :checked, true)}
  end

  def handle_event("set_off", _params, socket) do
    {:noreply, assign(socket, :checked, false)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
      <.layout_heading>
        <:title>Switch</:title>
        <:subtitle>Controlled Live View</:subtitle>
      </.layout_heading>

      <h3>Controlled State: {inspect(@checked)}</h3>

      <div class="layout__row">
        <.action phx-click="set_on" class="button button--sm">
          Set to On
        </.action>
        <.action phx-click="set_off" class="button button--sm">
          Set to Off
        </.action>
      </div>

      <div class="mt-4">
        <.switch
          id="controlled-switch"
          class="switch"
          controlled
          checked={@checked}
          on_checked_change="checked_changed"
        >
          <:label>Enable notifications</:label>
        </.switch>
      </div>
    </Layouts.app>
    """
  end
end
