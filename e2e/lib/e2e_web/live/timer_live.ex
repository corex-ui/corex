defmodule E2eWeb.TimerLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Timer</h1>
        <h2>Live View</h2>
      </div>
      <.timer id="my-timer" countdown target_ms={60_000} class="timer" />
    </Layouts.app>
    """
  end
end
