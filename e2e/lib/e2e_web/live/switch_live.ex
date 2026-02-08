defmodule E2eWeb.SwitchLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode}>
      <h1>Switch</h1>
      <h2>Live View</h2>
      <.switch class="switch">
        <:label>Enable notifications</:label>
      </.switch>
    </Layouts.app>
    """
  end
end
