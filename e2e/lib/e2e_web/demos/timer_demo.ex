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

  def events_server_heex do
    ~S"""
    <.timer
      id="timer-events-server"
      countdown
      start_ms={3_600_000}
      target_ms={0}
      class="timer"
      on_tick="timer_tick"
      on_complete="timer_complete"
    >
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def events_client_heex do
    ~S"""
    <.timer
      id="timer-events-client"
      countdown
      start_ms={3_600_000}
      target_ms={0}
      class="timer"
      on_tick_client="timer-tick"
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
    defp new_log(event, dom_id, value) do
      %{
        id: "#{System.unique_integer([:positive])}",
        time:
          DateTime.utc_now()
          |> DateTime.truncate(:second)
          |> Calendar.strftime("%H:%M:%S"),
        event: event,
        dom_id: dom_id,
        value: value
      }
    end

    def handle_event("timer_tick", %{"id" => id} = params, socket) do
      ft = Map.get(params, "formattedTime", "")
      {:noreply, stream_insert(socket, :server_logs, new_log("on_tick", id, ft), at: 0)}
    end

    def handle_event("timer_complete", %{"id" => id}, socket) do
      {:noreply, stream_insert(socket, :server_logs, new_log("on_complete", id, "done"), at: 0)}
    end
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("timer-events-client")
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

  def events_client_ts do
    ~S"""
    const el = document.getElementById("timer-events-client")
    if (!el) return
    el.addEventListener("timer-tick", (event: CustomEvent<{ formattedTime?: string; id?: string }>) => {
      const d = event.detail
      console.log(d?.formattedTime, d?.id)
    })
    el.addEventListener("timer-complete", (event: CustomEvent<{ id?: string }>) => {
      console.log(event.detail?.id)
    })
    """
  end

  def events_combined_js do
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

  def api_template_countdown_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-countdown" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_timing_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-timing" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_direction_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-direction" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
      <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
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
      events_js: events_combined_js()
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
    <.timer id="timer-style-sm" class="timer timer--sm w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-md" class="timer timer--md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-lg" class="timer timer--lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-xl" class="timer timer--xl w-full" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.timer
        id="timer-style-sm"
        class="timer timer--sm w-full"
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
        id="timer-style-md"
        class="timer timer--md w-full"
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
        class="timer timer--lg w-full"
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
        id="timer-style-xl"
        class="timer timer--xl w-full"
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

  def styling_text_code do
    ~S"""
    <.timer id="timer-style-text-sm" class="timer timer--text-sm w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-text-xl" class="timer timer--text-xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-text-2xl" class="timer timer--text-2xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-text-4xl" class="timer timer--text-4xl w-full" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_text_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.timer
        id="timer-style-text-sm"
        class="timer timer--text-sm w-full"
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
        id="timer-style-text-xl"
        class="timer timer--text-xl w-full"
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
        id="timer-style-text-2xl"
        class="timer timer--text-2xl w-full"
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
        id="timer-style-text-4xl"
        class="timer timer--text-4xl w-full"
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

  def styling_radius_code do
    ~S"""
    <.timer id="timer-style-rounded-none" class="timer timer--rounded-none w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-rounded-md" class="timer timer--rounded-md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-rounded-lg" class="timer timer--rounded-lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-rounded-xl" class="timer timer--rounded-xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-rounded-full" class="timer timer--rounded-full w-full" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.timer
        id="timer-style-rounded-none"
        class="timer timer--rounded-none w-full"
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
        id="timer-style-rounded-md"
        class="timer timer--rounded-md w-full"
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
        id="timer-style-rounded-lg"
        class="timer timer--rounded-lg w-full"
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
        id="timer-style-rounded-xl"
        class="timer timer--rounded-xl w-full"
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
        id="timer-style-rounded-full"
        class="timer timer--rounded-full w-full"
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

  def styling_max_width_code do
    ~S"""
    <.timer id="timer-style-max-2xs" class="timer w-full max-w-2xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-max-md" class="timer w-full max-w-md" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-max-xl" class="timer w-full max-w-xl" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-max-2xl" class="timer w-full max-w-2xl" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_max_width_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full items-stretch">
      <.timer
        id="timer-style-max-2xs"
        class="timer w-full max-w-2xs"
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
        id="timer-style-max-md"
        class="timer w-full max-w-md"
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
        id="timer-style-max-xl"
        class="timer w-full max-w-xl"
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
        id="timer-style-max-2xl"
        class="timer w-full max-w-2xl"
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

  def styling_mix_modifiers_code do
    ~S"""
    <.timer id="timer-style-mix-1" class="timer timer--sm timer--brand timer--rounded-lg w-full max-w-2xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-mix-2" class="timer timer--lg timer--accent timer--rounded-md w-full max-w-md" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-style-mix-3" class="timer timer--md timer--alert timer--text-lg w-full max-w-lg" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_mix_modifiers_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full items-stretch">
      <.timer
        id="timer-style-mix-1"
        class="timer timer--sm timer--brand timer--rounded-lg w-full max-w-2xs"
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
        id="timer-style-mix-2"
        class="timer timer--lg timer--accent timer--rounded-md w-full max-w-md"
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
        id="timer-style-mix-3"
        class="timer timer--md timer--alert timer--text-lg w-full max-w-lg"
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
    <.timer id="timer-c-def" class="timer w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-c-ac" class="timer timer--accent w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-c-br" class="timer timer--brand w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-c-al" class="timer timer--alert w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-c-in" class="timer timer--info w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer id="timer-c-su" class="timer timer--success w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.timer
        id="timer-c-def"
        class="timer w-full max-w-xs"
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
        class="timer timer--accent w-full max-w-xs"
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
        id="timer-c-br"
        class="timer timer--brand w-full max-w-xs"
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
        id="timer-c-al"
        class="timer timer--alert w-full max-w-xs"
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
        id="timer-c-in"
        class="timer timer--info w-full max-w-xs"
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
        id="timer-c-su"
        class="timer timer--success w-full max-w-xs"
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
