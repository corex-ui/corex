defmodule E2eWeb.Demos.TimerDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def anatomy_minimal_code do
    ~S"""
    <.timer start_ms={60_000}  />
    """
  end

  def anatomy_minimal_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-minimal" start_ms={60_000} />
    """
  end

  def anatomy_with_triggers_code do
    ~S"""
    <.timer start_ms={60_000} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_with_triggers_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-controls" start_ms={60_000}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_countdown_code do
    ~S"""
    <.timer countdown start_ms={60_000} target_ms={0} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_countdown_example(assigns) do
    ~H"""
    <.timer id="timer-anatomy-countdown" countdown start_ms={60_000} target_ms={0}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_timing_code do
    ~S"""
    <.timer start_ms={60_000} interval={2000} auto_start >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def anatomy_timing_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-anatomy-interval" start_ms={60_000} interval={2000} auto_start>
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
      countdown
      start_ms={3_600_000}
      target_ms={0}
      
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
      countdown
      start_ms={3_600_000}
      target_ms={0}
      
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
    E2eWeb.Demos.DocExamples.event_handlers_snippet([
      {"timer_tick", ~S|%{"id" => id} = params|},
      {"timer_complete", ~S|%{"id" => id} = params|}
    ])
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
    const el: HTMLElement | null = document.getElementById("timer-events-client")
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
      
    >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_props_timing_heex do
    ~S"""
    <.timer id="t-interval" start_ms={60_000} interval={1000} auto_start >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_props_direction_heex do
    ~S"""
    <.timer id="t-dir" start_ms={0} target_ms={30_000} dir="rtl" >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_countdown_preview(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-api-tpl-countdown" countdown start_ms={60_000} target_ms={0}>
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
    <.timer id="timer-api-tpl-timing" start_ms={60_000} interval={2000} auto_start>
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
    <.timer id="timer-api-tpl-direction" start_ms={0} target_ms={30_000} dir="rtl">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Timer.start("timer-api-controls-client")} size="sm">Start</.action>
    <.action phx-click={Corex.Timer.pause("timer-api-controls-client")} size="sm">Pause</.action>
    <.action phx-click={Corex.Timer.resume("timer-api-controls-client")} size="sm">Resume</.action>
    <.action phx-click={Corex.Timer.reset("timer-api-controls-client")} size="sm">Reset</.action>
    <.action phx-click={Corex.Timer.restart("timer-api-controls-client")} size="sm">Restart</.action>
    <.timer id="timer-api-controls-client" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_server_heex do
    ~S"""
    <.action phx-click="api_timer_start_server" size="sm">Start</.action>
    <.action phx-click="api_timer_pause_server" size="sm">Pause</.action>
    <.action phx-click="api_timer_resume_server" size="sm">Resume</.action>
    <.action phx-click="api_timer_reset_server" size="sm">Reset</.action>
    <.action phx-click="api_timer_restart_server" size="sm">Restart</.action>
    <.timer id="timer-api-controls-server" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_client_js_heex do
    ~S"""
    <.action phx-click={JS.dispatch("corex:timer:start", to: "#timer-api-controls-js", bubbles: false)} size="sm">Start</.action>
    <.action phx-click={JS.dispatch("corex:timer:pause", to: "#timer-api-controls-js", bubbles: false)} size="sm">Pause</.action>
    <.action phx-click={JS.dispatch("corex:timer:resume", to: "#timer-api-controls-js", bubbles: false)} size="sm">Resume</.action>
    <.action phx-click={JS.dispatch("corex:timer:reset", to: "#timer-api-controls-js", bubbles: false)} size="sm">Reset</.action>
    <.action phx-click={JS.dispatch("corex:timer:restart", to: "#timer-api-controls-js", bubbles: false)} size="sm">Restart</.action>
    <.timer id="timer-api-controls-js" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_client_js_js do
    ~S"""
    const el = document.getElementById("timer-api-controls-js");
    el?.dispatchEvent(new CustomEvent("corex:timer:start", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:pause", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:resume", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:reset", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:restart", { bubbles: false }));
    """
  end

  def api_controls_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("timer-api-controls-js");
    el?.dispatchEvent(new CustomEvent("corex:timer:start", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:pause", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:resume", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:reset", { bubbles: false }));
    el?.dispatchEvent(new CustomEvent("corex:timer:restart", { bubbles: false }));
    """
  end

  def api_controls_server_elixir do
    ~S"""
    def handle_event("api_timer_start_server", _params, socket) do
      {:noreply, Corex.Timer.start(socket, "timer-api-controls-server")}
    end

    def handle_event("api_timer_pause_server", _params, socket) do
      {:noreply, Corex.Timer.pause(socket, "timer-api-controls-server")}
    end

    def handle_event("api_timer_resume_server", _params, socket) do
      {:noreply, Corex.Timer.resume(socket, "timer-api-controls-server")}
    end

    def handle_event("api_timer_reset_server", _params, socket) do
      {:noreply, Corex.Timer.reset(socket, "timer-api-controls-server")}
    end

    def handle_event("api_timer_restart_server", _params, socket) do
      {:noreply, Corex.Timer.restart(socket, "timer-api-controls-server")}
    end
    """
  end

  def api_state_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Timer.state("timer-api-state-client")} size="sm">
      Read state
    </.action>
    <.timer id="timer-api-state-client" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_server_heex do
    ~S"""
    <.action phx-click="api_timer_state_server" size="sm">
      Read state
    </.action>
    <.timer id="timer-api-state-server" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_server_elixir do
    ~S"""
    def handle_event("api_timer_state_server", _params, socket) do
      {:noreply, Corex.Timer.state(socket, "timer-api-state-server")}
    end
    """
  end

  def api_state_client_js_heex do
    ~S"""
    <.action
      phx-click={JS.dispatch("corex:timer:state", to: "#timer-api-state-js", detail: %{}, bubbles: false)}
      size="sm"
    >
      Read state
    </.action>
    <.timer id="timer-api-state-js" countdown start_ms={60_000} target_ms={0} auto_start={false} >
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_client_js_js do
    ~S"""
    const el = document.getElementById("timer-api-state-js");
    el?.dispatchEvent(new CustomEvent("corex:timer:state", { bubbles: false, detail: {} }));
    """
  end

  def api_state_client_js_ts do
    ~S"""
    const el = document.getElementById("timer-api-state-js");
    el?.addEventListener("timer-state", (event: Event) => {
      console.log((event as CustomEvent).detail);
    });
    el?.dispatchEvent(new CustomEvent("corex:timer:state", { bubbles: false, detail: {} }));
    """
  end

  attr(:id, :string, required: true)

  def api_controls_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:timer:start", to: "##{@id}", bubbles: false)}
        size="sm"
      >
        Start
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:pause", to: "##{@id}", bubbles: false)}
        size="sm"
      >
        Pause
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:resume", to: "##{@id}", bubbles: false)}
        size="sm"
      >
        Resume
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:reset", to: "##{@id}", bubbles: false)}
        size="sm"
      >
        Reset
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:restart", to: "##{@id}", bubbles: false)}
        size="sm"
      >
        Restart
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Timer.start(@id)} size="sm">Start</.action>
      <.action phx-click={Corex.Timer.pause(@id)} size="sm">Pause</.action>
      <.action phx-click={Corex.Timer.resume(@id)} size="sm">Resume</.action>
      <.action phx-click={Corex.Timer.reset(@id)} size="sm">Reset</.action>
      <.action phx-click={Corex.Timer.restart(@id)} size="sm">Restart</.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_timer_start_server" size="sm">Start</.action>
      <.action phx-click="api_timer_pause_server" size="sm">Pause</.action>
      <.action phx-click="api_timer_resume_server" size="sm">Resume</.action>
      <.action phx-click="api_timer_reset_server" size="sm">Reset</.action>
      <.action phx-click="api_timer_restart_server" size="sm">Restart</.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click={Corex.Timer.state(@id)} size="sm">
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action phx-click="api_timer_state_server" size="sm">
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-2 mb-4">
      <.action
        phx-click={JS.dispatch("corex:timer:state", to: "##{@id}", detail: %{}, bubbles: false)}
        size="sm"
      >
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false}>
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def timer_api_codes do
    %{
      controls_binding: api_controls_client_binding_code(),
      controls_server_heex: api_controls_server_heex(),
      controls_server_elixir: api_controls_server_elixir(),
      state_client_heex: api_state_client_binding_code(),
      state_server_heex: api_state_server_heex(),
      state_server_elixir: api_state_server_elixir(),
      state_js_heex: api_state_client_js_heex(),
      state_js: api_state_client_js_js(),
      state_js_ts: api_state_client_js_ts(),
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
    <.action phx-click="timer_api_remount" size="sm">Remount</.action>
    <.timer id="timer-api-remount" countdown start_ms={45_000} target_ms={0} >
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
    <.timer class="timer timer--sm w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--xl w-full" start_ms={60_000} target_ms={0} countdown />
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
    <.timer class="timer timer--text-sm w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--text-xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--text-2xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--text-4xl w-full" start_ms={60_000} target_ms={0} countdown />
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
    <.timer class="timer timer--rounded-none w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--rounded-md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--rounded-lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--rounded-xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--rounded-full w-full" start_ms={60_000} target_ms={0} countdown />
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

  def styling_semantic_code do
    ~S"""
    <.timer class="timer w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--accent w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--brand w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--alert w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--info w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer timer--success w-full timer--max-w-xs" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.timer
        id="timer-c-def"
        class="timer w-full timer--max-w-xs"
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
        class="timer timer--accent w-full timer--max-w-xs"
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
        class="timer timer--brand w-full timer--max-w-xs"
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
        class="timer timer--alert w-full timer--max-w-xs"
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
        class="timer timer--info w-full timer--max-w-xs"
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
        class="timer timer--success w-full timer--max-w-xs"
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
      countdown
      start_ms={86_400_000 * 4 + 3_600_000 * 12}
      target_ms={0}
      
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
    />
    """
  end

  def layout_segments_code do
    ~S"""
    <.timer
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      
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
      segments={[:days, :hours, :minutes, :seconds]}
    />
    """
  end

  def layout_separator_code do
    ~S"""
    <.timer start_ms={60_000} >
      <:separator> · </:separator>
    </.timer>
    """
  end

  def layout_separator_example(assigns) do
    _ = assigns

    ~H"""
    <.timer id="timer-separator-dot" start_ms={60_000}>
      <:separator>·</:separator>
    </.timer>
    """
  end

  def layout_translation_code do
    ~S"""
    <.timer
      countdown
      start_ms={60_000}
      target_ms={0}
      
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
      translation={%Corex.Timer.Translation{area_label: "Countdown"}}
    />
    """
  end

  def layout_unit_labels_code do
    ~S"""
    <.timer
      countdown
      start_ms={86_400_000 + 3_600_000}
      target_ms={0}
      
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
      countdown
      start_ms={86_400_000 * 2 + 3_600_000}
      target_ms={0}
      
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
