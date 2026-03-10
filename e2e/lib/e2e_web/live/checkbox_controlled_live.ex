defmodule E2eWeb.CheckboxControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checked, false)}
  end

  def handle_event("change", %{"checked" => checked}, socket) do
    IO.inspect(checked)
    {:noreply, assign(socket, :checked, checked)}
  end

  def handle_event("check_all", _params, socket) do
    {:noreply, assign(socket, :checked, true)}
  end

  def handle_event("uncheck_all", _params, socket) do
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
        <:title>Checkbox</:title>
        <:subtitle>Controlled Live View</:subtitle>
      </.layout_heading>

      <h3>Controlled State: {inspect(@checked)}</h3>

      <div class="layout__row">
        <.action phx-click="check_all" class="button button--sm">
          Set Checked to True
        </.action>
        <.action phx-click="uncheck_all" class="button button--sm">
          Set Checked to False
        </.action>
      </div>

      <div class="mt-4">
        <.checkbox
          id="controlled-checkbox"
          class="checkbox"
          controlled
          checked={@checked}
          on_checked_change="change"
        >
          <:label>
            Accept the terms
          </:label>
          <:indicator>
            <.heroicon name="hero-check" class="data-checked" />
          </:indicator>
        </.checkbox>
      </div>
    </Layouts.app>
    """
  end
end
