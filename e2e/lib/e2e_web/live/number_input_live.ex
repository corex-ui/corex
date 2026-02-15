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
      </.number_input>
    </Layouts.app>
    """
  end
end
