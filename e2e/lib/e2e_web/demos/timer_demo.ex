defmodule E2eWeb.Demos.TimerDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_minimal_code do
    ~S"""
    <.timer start_ms={60_000} class="timer" />
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
    <.timer start_ms={60_000} class="timer">
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
    <.timer countdown start_ms={60_000} target_ms={0} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
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
    <.timer start_ms={60_000} interval={2000} auto_start class="timer">
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
      class="timer"
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
    <.timer id="t-interval" start_ms={60_000} interval={1000} auto_start class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_template_props_direction_heex do
    ~S"""
    <.timer id="t-dir" start_ms={0} target_ms={30_000} dir="rtl" class="timer">
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

  def api_controls_client_binding_code do
    ~S"""
    <.action phx-click={Corex.Timer.start("timer-api-controls-client")} class="button ui-size-sm">Start</.action>
    <.action phx-click={Corex.Timer.pause("timer-api-controls-client")} class="button ui-size-sm">Pause</.action>
    <.action phx-click={Corex.Timer.resume("timer-api-controls-client")} class="button ui-size-sm">Resume</.action>
    <.action phx-click={Corex.Timer.reset("timer-api-controls-client")} class="button ui-size-sm">Reset</.action>
    <.action phx-click={Corex.Timer.restart("timer-api-controls-client")} class="button ui-size-sm">Restart</.action>
    <.timer id="timer-api-controls-client" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_server_heex do
    ~S"""
    <.action phx-click="api_timer_start_server" class="button ui-size-sm">Start</.action>
    <.action phx-click="api_timer_pause_server" class="button ui-size-sm">Pause</.action>
    <.action phx-click="api_timer_resume_server" class="button ui-size-sm">Resume</.action>
    <.action phx-click="api_timer_reset_server" class="button ui-size-sm">Reset</.action>
    <.action phx-click="api_timer_restart_server" class="button ui-size-sm">Restart</.action>
    <.timer id="timer-api-controls-server" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_controls_client_js_heex do
    ~S"""
    <.action phx-click={JS.dispatch("corex:timer:start", to: "#timer-api-controls-js", bubbles: false)} class="button ui-size-sm">Start</.action>
    <.action phx-click={JS.dispatch("corex:timer:pause", to: "#timer-api-controls-js", bubbles: false)} class="button ui-size-sm">Pause</.action>
    <.action phx-click={JS.dispatch("corex:timer:resume", to: "#timer-api-controls-js", bubbles: false)} class="button ui-size-sm">Resume</.action>
    <.action phx-click={JS.dispatch("corex:timer:reset", to: "#timer-api-controls-js", bubbles: false)} class="button ui-size-sm">Reset</.action>
    <.action phx-click={JS.dispatch("corex:timer:restart", to: "#timer-api-controls-js", bubbles: false)} class="button ui-size-sm">Restart</.action>
    <.timer id="timer-api-controls-js" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
    <.action phx-click={Corex.Timer.state("timer-api-state-client")} class="button ui-size-sm">
      Read state
    </.action>
    <.timer id="timer-api-state-client" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    </.timer>
    """
  end

  def api_state_server_heex do
    ~S"""
    <.action phx-click="api_timer_state_server" class="button ui-size-sm">
      Read state
    </.action>
    <.timer id="timer-api-state-server" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
      class="button ui-size-sm"
    >
      Read state
    </.action>
    <.timer id="timer-api-state-js" countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
        class="button ui-size-sm"
      >
        Start
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:pause", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Pause
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:resume", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Resume
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:reset", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Reset
      </.action>
      <.action
        phx-click={JS.dispatch("corex:timer:restart", to: "##{@id}", bubbles: false)}
        class="button ui-size-sm"
      >
        Restart
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
      <.action phx-click={Corex.Timer.start(@id)} class="button ui-size-sm">Start</.action>
      <.action phx-click={Corex.Timer.pause(@id)} class="button ui-size-sm">Pause</.action>
      <.action phx-click={Corex.Timer.resume(@id)} class="button ui-size-sm">Resume</.action>
      <.action phx-click={Corex.Timer.reset(@id)} class="button ui-size-sm">Reset</.action>
      <.action phx-click={Corex.Timer.restart(@id)} class="button ui-size-sm">Restart</.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
      <.action phx-click="api_timer_start_server" class="button ui-size-sm">Start</.action>
      <.action phx-click="api_timer_pause_server" class="button ui-size-sm">Pause</.action>
      <.action phx-click="api_timer_resume_server" class="button ui-size-sm">Resume</.action>
      <.action phx-click="api_timer_reset_server" class="button ui-size-sm">Reset</.action>
      <.action phx-click="api_timer_restart_server" class="button ui-size-sm">Restart</.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
      <.action phx-click={Corex.Timer.state(@id)} class="button ui-size-sm">
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
      <.action phx-click="api_timer_state_server" class="button ui-size-sm">
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
        class="button ui-size-sm"
      >
        Read state
      </.action>
    </div>
    <.timer id={@id} countdown start_ms={60_000} target_ms={0} auto_start={false} class="timer">
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
    <.action phx-click="timer_api_remount" class="button ui-size-sm">Remount</.action>
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
    <.timer class="timer ui-size-sm w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-size-md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-size-lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-size-xl w-full" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.timer
        id="timer-style-sm"
        class="timer ui-size-sm w-full"
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
        class="timer ui-size-md w-full"
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
        class="timer ui-size-lg w-full"
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
        class="timer ui-size-xl w-full"
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
    <.timer class="timer ui-rounded-none w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-rounded-md w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-rounded-lg w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-rounded-xl w-full" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-rounded-full w-full" start_ms={60_000} target_ms={0} countdown />
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-col gap-4 w-full max-w-md">
      <.timer
        id="timer-style-rounded-none"
        class="timer ui-rounded-none w-full"
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
        class="timer ui-rounded-md w-full"
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
        class="timer ui-rounded-lg w-full"
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
        class="timer ui-rounded-xl w-full"
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
        class="timer ui-rounded-full w-full"
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
    <.timer class="timer w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-accent w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-brand w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-alert w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-info w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
    <.timer class="timer ui-success w-full max-w-xs" start_ms={60_000} target_ms={0} countdown />
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
        class="timer ui-accent w-full max-w-xs"
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
        class="timer ui-brand w-full max-w-xs"
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
        class="timer ui-alert w-full max-w-xs"
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
        class="timer ui-info w-full max-w-xs"
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
        class="timer ui-success w-full max-w-xs"
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

  def styling_variant_code do
    triggers = styling_triggers_code()

    """
    <.timer class="timer w-full max-w-xs" start_ms={60_000} target_ms={0} countdown>
    #{triggers}
    </.timer>
    <.timer class="timer ui-solid w-full max-w-xs" start_ms={60_000} target_ms={0} countdown>
    #{triggers}
    </.timer>

    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-start w-full max-w-4xl">
      <.timer
        id="timer-style-variant-subtle"
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
        id="timer-style-variant-solid"
        class="timer ui-solid w-full max-w-xs"
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

  def styling_variant_matrix_code do
    triggers = styling_triggers_code()

    for semantic <- DemoScales.styling_semantic_axis_steps("timer"),
        variant <- DemoScales.styling_variant_axis_steps("timer") do
      class = DemoScales.join_matrix_modifiers("timer", semantic.modifier, variant.modifier)

      """
      <.timer class="#{class} w-full max-w-xs" start_ms={60_000} target_ms={0} countdown>
      #{triggers}
      </.timer>
      """
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("timer"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("timer"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.timer
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("timer", semantic.modifier, variant.modifier) <> " w-full max-w-xs"}
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
      </div>
    </div>
    """
  end

  defp styling_triggers_code do
    """
      <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
      <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
      <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
      <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
    """
  end

  def styling_width_code do
    triggers = styling_triggers_code()

    DemoScales.width_layout_variants("timer")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("timer", modifier)

      """
      <.timer class="#{class}" start_ms={60_000} target_ms={0} countdown>
      #{triggers}
      </.timer>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    triggers = styling_triggers_code()

    DemoScales.max_width_variants("timer")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("timer", modifier)

      """
      <.timer class="#{class}" start_ms={60_000} target_ms={0} countdown>
      #{triggers}
      </.timer>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("timer"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.timer
          id={"timer-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("timer", variant.modifier)}
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
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("timer"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.timer
          id={"timer-style-max-#{variant.id}"}
          class={DemoScales.join_block_modifiers("timer", variant.modifier)}
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
    </div>
    """
  end

  def anatomy_collapse_code do
    ~S"""
    <.timer
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
    <.timer start_ms={60_000} class="timer">
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
