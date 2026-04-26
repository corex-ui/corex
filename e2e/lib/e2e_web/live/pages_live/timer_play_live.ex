defmodule E2eWeb.TimerPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:countdown, true)
     |> assign(:auto_start, false)
     |> assign(:start_ms, 60_000)
     |> assign(:remount, 0)
     |> assign(:dir, "ltr")}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "dir"}, socket)
      when is_binary(value) do
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, dir: value, remount: r)}
  end

  @impl true
  def handle_event("control_changed", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("countdown_changed", %{"checked" => checked, "id" => _}, socket) do
    v = checked == true or checked == "true"
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, countdown: v, remount: r)}
  end

  @impl true
  def handle_event("auto_start_changed", %{"checked" => checked, "id" => _}, socket) do
    v = checked == true or checked == "true"
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, auto_start: v, remount: r)}
  end

  @impl true
  def handle_event("duration_changed", %{"checked" => checked, "id" => _}, socket) do
    long = checked == true or checked == "true"
    ms = if long, do: 60_000, else: 30_000
    r = socket.assigns.remount + 1
    {:noreply, assign(socket, start_ms: ms, remount: r)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        id="timer-playground"
        title="Timer · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
          <.switch
            class="switch"
            id="timer-countdown"
            checked={@countdown}
            on_checked_change="countdown_changed"
          >
            <:label>Countdown</:label>
          </.switch>
          <.switch
            class="switch"
            id="timer-autostart"
            checked={@auto_start}
            on_checked_change="auto_start_changed"
          >
            <:label>Auto start</:label>
          </.switch>
          <.switch
            class="switch"
            id="timer-duration"
            checked={@start_ms == 60_000}
            on_checked_change="duration_changed"
          >
            <:label>60s start (off = 30s)</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.timer
            id={"timer-play-#{@remount}"}
            countdown={@countdown}
            start_ms={@start_ms}
            target_ms={0}
            auto_start={@auto_start}
            class="timer"
            dir={@dir}
          >
            <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
            <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
            <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
            <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
          </.timer>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
