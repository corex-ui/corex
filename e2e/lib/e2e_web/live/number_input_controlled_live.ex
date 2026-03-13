defmodule E2eWeb.NumberInputControlledLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, "0")}
  end

  def handle_event("value_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
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
        <:title>Number Input</:title>
        <:subtitle>Controlled Live View</:subtitle>
      </.layout_heading>

      <h3>Controlled State: {@value}</h3>

      <div class="layout__row">
        <.action phx-click={JS.push("set_value", value: %{value: "10"})} class="button button--sm">
          Set to 10
        </.action>
        <.action phx-click={JS.push("set_value", value: %{value: "0"})} class="button button--sm">
          Set to 0
        </.action>
        <.action phx-click={JS.push("set_value", value: %{value: "-5"})} class="button button--sm">
          Set to -5
        </.action>
      </div>

      <div class="mt-4">
        <.number_input
          id="controlled-number-input"
          class="number-input"
          controlled
          value={@value}
          on_value_change="value_changed"
        >
          <:label>Quantity</:label>
          <:decrement_trigger>
            <.heroicon name="hero-chevron-down" class="icon" />
          </:decrement_trigger>
          <:increment_trigger>
            <.heroicon name="hero-chevron-up" class="icon" />
          </:increment_trigger>
        </.number_input>
      </div>
    </Layouts.app>
    """
  end
end
