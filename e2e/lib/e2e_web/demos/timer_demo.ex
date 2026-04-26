defmodule E2eWeb.Demos.TimerDemo do
  use E2eWeb, :html

  def anatomy_countdown_code do
    ~S"""
    <.timer id="timer-anatomy" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_countdown_example(assigns) do
    ~H"""
    <.timer id="timer-anatomy" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def events_combined_heex do
    ~S"""
    <.timer
      id="timer-events-live"
      countdown
      start_ms={3_600_000}
      target_ms={0}
      class="timer"
      on_tick="timer_tick"
      on_tick_client="timer-tick"
      on_complete="timer_complete"
      on_complete_client="timer-complete"
    >
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("timer_tick", %{"id" => id} = params, socket) do
      ft = Map.get(params, "formattedTime", "")
      _ = {id, ft}
      {:noreply, socket}
    end

    def handle_event("timer_complete", %{"id" => id}, socket) do
      _ = id
      {:noreply, socket}
    end
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("timer-events-live")
    if (!el) return
    el.addEventListener("timer-tick", (event) => {
      const d = event.detail
      console.log(d?.formattedTime, d?.id)
    })
    el.addEventListener("timer-complete", (event) => {
      console.log(event.detail?.id)
    })
    """
  end

  def events_server_heex, do: events_combined_heex()

  def api_template_props_countdown_heex do
    ~S"""
    <.timer
      id="t-countdown"
      countdown
      start_ms={60_000}
      target_ms={0}
      class="timer"
    >
      <:start_trigger>…</:start_trigger>
      <:pause_trigger>…</:pause_trigger>
      <:resume_trigger>…</:resume_trigger>
      <:reset_trigger>…</:reset_trigger>
    </.timer>
    """
  end

  def api_template_props_timing_heex do
    ~S"""
    <.timer id="t-interval" start_ms={60_000} interval={1000} auto_start class="timer">
      <:start_trigger>…</:start_trigger>
      <:pause_trigger>…</:pause_trigger>
      <:resume_trigger>…</:resume_trigger>
      <:reset_trigger>…</:reset_trigger>
    </.timer>
    """
  end

  def api_template_props_direction_heex do
    ~S"""
    <.timer id="t-dir" dir="rtl" orientation="vertical" class="timer">
      <:start_trigger>…</:start_trigger>
      <:pause_trigger>…</:pause_trigger>
      <:resume_trigger>…</:resume_trigger>
      <:reset_trigger>…</:reset_trigger>
    </.timer>
    """
  end

  def api_codes_intro do
    "Template attributes only—see Timer · Events for on_tick and on_complete."
  end

  def patterns_minimal_heex do
    ~S"""
    <.timer id="timer-pattern" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def patterns_minimal_elixir do
    ~S"""
    # No server state required for an uncontrolled timer.
    """
  end

  def patterns_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-patterns-minimal" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def styling_size_code do
    ~S"""
    <.timer id="timer-style-sm" class="timer timer--sm" start_ms={60_000}>
    <.timer id="timer-style-lg" class="timer timer--lg" start_ms={60_000}>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-8 items-start w-full max-w-4xl">
      <.timer
        id="timer-style-sm"
        class="timer timer--sm"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-lg"
        class="timer timer--lg"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
      </.timer>
    </div>
    """
  end

  def styling_color_code do
    ~S"""
    <.timer id="timer-c-def" class="timer" start_ms={60_000} />
    <.timer id="timer-c-ac" class="timer timer--accent" start_ms={60_000} />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-8 w-full max-w-4xl">
      <.timer
        id="timer-c-def"
        class="timer"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-ac"
        class="timer timer--accent"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
      </.timer>
    </div>
    """
  end
end
