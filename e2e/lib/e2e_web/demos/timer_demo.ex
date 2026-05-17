defmodule E2eWeb.Demos.TimerDemo do
  use E2eWeb, :html

  def anatomy_minimal_code do
    ~S"""
    <.timer id="timer-anatomy-minimal" start_ms={60_000} class="timer" />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-minimal" start_ms={60_000} class="timer" />
    """
  end

  def anatomy_with_triggers_code do
    ~S"""
    <.timer id="timer-anatomy-controls" start_ms={60_000} class="timer">
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_with_triggers_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-controls" start_ms={60_000} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_countdown_code do
    ~S"""
    <.timer id="timer-anatomy-countdown" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_countdown_example(assigns) do
    ~H"""
    <.timer id="timer-anatomy-countdown" countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_timing_code do
    ~S"""
    <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_timing_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
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
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
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
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
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
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_timing_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-timing" start_ms={60_000} interval={2000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_direction_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-direction" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
      <:start_trigger><.heroicon name="hero-play"/></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause"/></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play"/></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path"/></:reset_trigger>
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
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-md"
        class="timer timer--md w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-lg"
        class="timer timer--lg w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-xl"
        class="timer timer--xl w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-text-xl"
        class="timer timer--text-xl w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-text-2xl"
        class="timer timer--text-2xl w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-text-4xl"
        class="timer timer--text-4xl w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-rounded-md"
        class="timer timer--rounded-md w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-rounded-lg"
        class="timer timer--rounded-lg w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-rounded-xl"
        class="timer timer--rounded-xl w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-style-rounded-full"
        class="timer timer--rounded-full w-full"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-ac"
        class="timer timer--accent w-full max-w-xs"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-br"
        class="timer timer--brand w-full max-w-xs"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-al"
        class="timer timer--alert w-full max-w-xs"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-in"
        class="timer timer--info w-full max-w-xs"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
      <.timer
        id="timer-c-su"
        class="timer timer--success w-full max-w-xs"
        start_ms={60_000}
        target_ms={0}
        countdown
      >
        <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
        <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
        <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
        <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
      </.timer>
    </div>
    """
  end

  def anatomy_collapse_code do
    ~S"""
    <.timer
      id="timer-anatomy-collapse"
      countdown
      start_ms={86_400_000 * 4 + 3_600_000 * 12}
      target_ms={0}
      class="timer"
    />
    """
  end

  def anatomy_collapse_example(assigns) do
    _ = assigns

    ~H"""
    <.timer
      id="timer-anatomy-collapse"
      countdown
      start_ms={86_400_000 * 4 + 3_600_000 * 12}
      target_ms={0}
      class="timer"
    />
    """
  end

  def layout_segments_code do
    ~S"""
    <.timer
      id="timer-segments-fixed"
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      class="timer"
      segments={[:days, :hours, :minutes, :seconds]}
    />
    """
  end

  def layout_segments_example(assigns) do
    _ = assigns

    ~H"""
    <.timer
      id="timer-segments-fixed"
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      class="timer"
      segments={[:days, :hours, :minutes, :seconds]}
    />
    """
  end

  def layout_separator_code do
    ~S"""
    <.timer id="timer-separator-dot" start_ms={60_000} class="timer">
      <:separator> · </:separator>
    </.timer>
    """
  end

  def layout_separator_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-separator-dot" start_ms={60_000} class="timer">
      <:separator>·</:separator>
    </.timer>
    """
  end

  def layout_translation_code do
    ~S"""
    <.timer
      id="timer-translation"
      countdown
      start_ms={60_000}
      target_ms={0}
      class="timer"
      translation={%Corex.Timer.Translation{area_label: "Countdown"}}
    />
    """
  end

  def layout_translation_example(assigns) do
    _ = assigns

    ~H"""
    <.timer
      id="timer-translation"
      countdown
      start_ms={60_000}
      target_ms={0}
      class="timer"
      translation={%Corex.Timer.Translation{area_label: "Countdown"}}
    />
    """
  end

  def layout_unit_labels_code do
    ~S"""
    <.timer
      id="timer-unit-labels"
      countdown
      start_ms={86_400_000 + 3_600_000}
      target_ms={0}
      class="timer"
    >
      <:day_label>d</:day_label>
      <:hour_label>h</:hour_label>
      <:minute_label>m</:minute_label>
      <:second_label>s</:second_label>
    </.timer>
    """
  end

  def layout_unit_labels_example(assigns) do
    _ = assigns

    ~H"""
    <.timer
      id="timer-unit-labels"
      countdown
      start_ms={86_400_000 + 3_600_000}
      target_ms={0}
      class="timer"
    >
      <:day_label>d</:day_label>
      <:hour_label>h</:hour_label>
      <:minute_label>m</:minute_label>
      <:second_label>s</:second_label>
    </.timer>
    """
  end

  def layout_separator_and_labels_code do
    ~S"""
    <.timer
      id="timer-layout-separator-labels"
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      class="timer"
      segments={[:days, :hours, :minutes, :seconds]}
    >
      <:separator>:</:separator>
      <:day_label>Days</:day_label>
      <:hour_label>Hours</:hour_label>
      <:minute_label>Minutes</:minute_label>
      <:second_label>Seconds</:second_label>
    </.timer>
    """
  end

  def layout_separator_and_labels_example(assigns) do
    _ = assigns

    ~H"""
    <.timer
      id="timer-layout-separator-labels"
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      class="timer"
      segments={[:days, :hours, :minutes, :seconds]}
    >
      <:separator>:</:separator>
      <:day_label>Days</:day_label>
      <:hour_label>Hours</:hour_label>
      <:minute_label>Minutes</:minute_label>
      <:second_label>Seconds</:second_label>
    </.timer>
    """
  end
end
