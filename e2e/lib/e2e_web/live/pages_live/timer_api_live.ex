defmodule E2eWeb.TimerApiLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TimerDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:remount, 0)
     |> assign(:codes, Demo.timer_api_codes())}
  end

  @impl true
  def handle_event("timer_api_remount", _, socket) do
    {:noreply, update(socket, :remount, &(&1 + 1))}
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
        subtitle="No Corex.Timer module—the client runs Zag. Remount to reset; template attributes and events below."
      >
        <.demo_section
          id="timer-api-remount"
          title="Remount (reset state)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.remount_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.remount_elixir}
          ]}
        >
          <:preview>
            <div class="flex w-full max-w-4xl flex-col items-center gap-4">
              <.action
                phx-click="timer_api_remount"
                class="button button--sm"
                id="timer-api-remount-btn"
              >
                Remount
              </.action>
              <.timer
                id={"timer-api-remount-#{@remount}"}
                countdown
                start_ms={45_000}
                target_ms={0}
                class="timer"
              >
                <:start_trigger><.heroicon name="hero-play" class="icon" /></:start_trigger>
                <:pause_trigger><.heroicon name="hero-pause" class="icon" /></:pause_trigger>
                <:resume_trigger><.heroicon name="hero-play" class="icon" /></:resume_trigger>
                <:reset_trigger><.heroicon name="hero-arrow-path" class="icon" /></:reset_trigger>
              </.timer>
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-template-countdown"
          title="Template: countdown range"
          code={@codes.countdown}
        >
          <:preview>
            <div class="flex w-full max-w-4xl flex-col items-center gap-4">
              <Demo.api_template_countdown_preview />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-template-timing"
          title="Template: interval and auto start"
          code={@codes.timing}
        >
          <:preview>
            <div class="flex w-full max-w-4xl flex-col items-center gap-4">
              <Demo.api_template_timing_preview />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-template-direction"
          title="Template: direction and orientation"
          code={@codes.direction}
        >
          <:preview>
            <div class="flex w-full max-w-4xl flex-col items-center gap-4">
              <Demo.api_template_direction_preview />
            </div>
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-events"
          title="Tick and complete"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.events_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.events_elixir},
            %{value: "js", label: "JS", language: :js, code: @codes.events_js}
          ]}
        >
          <:preview>
            <p class="typo-sm text-ink-muted max-w-2xl">
              Interactive log live on <.link navigate={~p"/timer/events"} class="link">Timer · Events</.link>.
            </p>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
