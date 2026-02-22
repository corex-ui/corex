defmodule E2eWeb.PinInputLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
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
      <div class="layout__row">
        <h1>Pin Input</h1>
        <h2>Live View</h2>
      </div>
      <.pin_input id="my-pin-input" count={4} class="pin-input">
        <:label>Code</:label>
      </.pin_input>
    </Layouts.app>
    """
  end
end
