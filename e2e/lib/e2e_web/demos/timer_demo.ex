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

  def anatomy_timing_code do
    ~S"""
    <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_timing_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_direction_code do
    ~S"""
    <.timer id="timer-anatomy-dir" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_direction_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-dir" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
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
    <.timer id="t-dir" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
      <:start_trigger>…</:start_trigger>
      <:pause_trigger>…</:pause_trigger>
      <:resume_trigger>…</:resume_trigger>
      <:reset_trigger>…</:reset_trigger>
    </.timer>
    """
  end

  def timer_api_codes do
    %{
      remount_heex: timer_api_remount_heex(),
      remount_elixir: timer_api_remount_elixir(),
      countdown: api_template_props_countdown_heex(),
      timing: api_template_props_timing_heex(),
      direction: api_template_props_direction_heex(),
      events_heex: events_combined_heex(),
      events_elixir: events_server_elixir(),
      events_js: events_client_js()
    }
  end

  def timer_api_remount_heex do
    ~S"""
    <.action phx-click="timer_api_remount" class="button button--sm">Remount</.action>
    <.timer id="timer-api-remount" countdown start_ms={45_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def timer_api_remount_elixir do
    ~S"""
    def mount(_params, _session, socket), do: {:ok, assign(socket, :remount, 0)}

    def handle_event("timer_api_remount", _, socket) do
      {:noreply, update(socket, :remount, &(&1 + 1))}
    end
    """
  end

  def styling_size_code do
    ~S"""
    <.timer id="timer-style-sm" class="timer timer--sm" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-lg" class="timer timer--lg" start_ms={60_000} target_ms={0} countdown />
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
    <div class="flex flex-wrap gap-8 w-full max-w-4xl justify-center">
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
