defmodule E2eWeb.TimerApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :api_notes, E2eWeb.Demos.TimerDemo.api_codes_intro())}
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
      <.demo_page
        id="timer-api-page"
        title="Timer · API"
        subtitle={@api_notes}
      >
        <.demo_section
          id="timer-api-countdown"
          title="Countdown and time range"
          code={E2eWeb.Demos.TimerDemo.api_template_props_countdown_heex()}
        >
          <:preview>
            <E2eWeb.Demos.TimerDemo.anatomy_countdown_example />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-timing"
          title="Interval and auto start"
          code={E2eWeb.Demos.TimerDemo.api_template_props_timing_heex()}
        >
          <:preview>
            <.timer
              id="timer-api-preview-interval"
              start_ms={60_000}
              interval={2000}
              class="timer"
            >
              <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
              <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
              <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
              <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
            </.timer>
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-layout"
          title="Direction and orientation"
          code={E2eWeb.Demos.TimerDemo.api_template_props_direction_heex()}
        >
          <:preview>
            <.timer
              id="timer-api-preview-dir"
              start_ms={0}
              target_ms={30_000}
              dir="rtl"
              class="timer"
            >
              <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
              <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
              <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
              <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
            </.timer>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
