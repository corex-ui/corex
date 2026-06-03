defmodule E2eWeb.TimerPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
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
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        path={@path}
        id="timer-playground"
        title="Timer · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
        </:controls>
        <:canvas>
          <.timer
            id={"timer-play-#{@remount}"}
            countdown
            start_ms={60_000}
            target_ms={0}
            dir={@dir}
          >
            <:start_trigger><.heroicon name="hero-play" /></:start_trigger>
            <:pause_trigger><.heroicon name="hero-pause" /></:pause_trigger>
            <:resume_trigger><.heroicon name="hero-play" /></:resume_trigger>
            <:reset_trigger><.heroicon name="hero-arrow-path" /></:reset_trigger>
          </.timer>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
