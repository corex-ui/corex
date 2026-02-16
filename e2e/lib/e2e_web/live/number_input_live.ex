defmodule E2eWeb.NumberInputLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Number Input</h1>
        <h2>Live View</h2>
      </div>
      <.number_input id="my-number-input" class="number-input">
        <:label>Quantity</:label>
        <:decrement_trigger>
          <.icon name="hero-chevron-down" class="icon" />
        </:decrement_trigger>
        <:increment_trigger>
          <.icon name="hero-chevron-up" class="icon" />
        </:increment_trigger>
      </.number_input>
      <.number_input id="scrubber-number-input" class="number-input" scrubber>
        <:label>Enter Number</:label>
        <:scrubber_trigger>
          <.icon name="hero-chevron-up-down" class="icon icon--square rotate-90" />
        </:scrubber_trigger>
      </.number_input>
    </Layouts.app>
    """
  end
end
