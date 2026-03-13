defmodule E2eWeb.TimerLive do
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
        <:title>Timer</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>
      <.timer id="my-timer" countdown start_ms={60_000} target_ms={0} class="timer">
        <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
      </.timer>
    </Layouts.app>
    """
  end
end
