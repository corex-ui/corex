defmodule E2eWeb.SwitchLive do
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
      <.layout_heading>
        <:title>Switch</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>
      <.switch class="switch">
        <:label>Enable notifications</:label>
      </.switch>
    </Layouts.app>
    """
  end
end
