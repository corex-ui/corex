defmodule E2eWeb.TimerApiLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TimerDemo, as: Demo

  import Demo,
    only: [
      api_controls_client_binding_example: 1,
      api_controls_client_js_example: 1,
      api_controls_server_example: 1,
      api_state_client_binding_example: 1,
      api_state_server_example: 1,
      api_state_client_js_example: 1
    ]

  @id_controls_client "timer-api-controls-client"
  @id_controls_js "timer-api-controls-js"
  @id_controls_server "timer-api-controls-server"
  @id_state_client "timer-api-state-client"
  @id_state_js "timer-api-state-js"
  @id_state_server "timer-api-state-server"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_controls_client, @id_controls_client)
      |> assign(:id_controls_js, @id_controls_js)
      |> assign(:id_controls_server, @id_controls_server)
      |> assign(:id_state_client, @id_state_client)
      |> assign(:id_state_js, @id_state_js)
      |> assign(:id_state_server, @id_state_server)
      |> assign(:codes, demo_codes())

    {:ok, socket}
  end

  defp demo_codes do
    m = Demo

    %{
      controls_binding: m.api_controls_client_binding_code(),
      controls_js_heex: m.api_controls_client_js_heex(),
      controls_js: m.api_controls_client_js_js(),
      controls_js_ts: m.api_controls_client_js_ts(),
      controls_server_heex: m.api_controls_server_heex(),
      controls_server_elixir: m.api_controls_server_elixir(),
      state_binding: m.api_state_client_binding_code(),
      state_server_heex: m.api_state_server_heex(),
      state_server_elixir: m.api_state_server_elixir(),
      state_js_heex: m.api_state_client_js_heex(),
      state_js: m.api_state_client_js_js(),
      state_js_ts: m.api_state_client_js_ts(),
      countdown: m.api_template_props_countdown_heex(),
      timing: m.api_template_props_timing_heex(),
      direction: m.api_template_props_direction_heex(),
      events_heex: m.events_combined_heex(),
      events_elixir: m.events_server_elixir(),
      events_js: m.events_combined_js()
    }
  end

  @impl true
  def handle_event("api_timer_start_server", _params, socket) do
    {:noreply, Corex.Timer.start(socket, @id_controls_server)}
  end

  @impl true
  def handle_event("api_timer_pause_server", _params, socket) do
    {:noreply, Corex.Timer.pause(socket, @id_controls_server)}
  end

  @impl true
  def handle_event("api_timer_resume_server", _params, socket) do
    {:noreply, Corex.Timer.resume(socket, @id_controls_server)}
  end

  @impl true
  def handle_event("api_timer_reset_server", _params, socket) do
    {:noreply, Corex.Timer.reset(socket, @id_controls_server)}
  end

  @impl true
  def handle_event("api_timer_restart_server", _params, socket) do
    {:noreply, Corex.Timer.restart(socket, @id_controls_server)}
  end

  @impl true
  def handle_event("api_timer_state_server", _params, socket) do
    {:noreply, Corex.Timer.state(socket, @id_state_server)}
  end

  @impl true
  def handle_event("timer_state_response", %{"id" => id} = payload, socket)
      when id in [@id_state_client, @id_state_js, @id_state_server] do
    running = Map.get(payload, "running")
    paused = Map.get(payload, "paused")
    progress = Map.get(payload, "progressPercent")
    time = Map.get(payload, "time", %{})
    formatted = Map.get(payload, "formattedTime", %{})

    desc =
      "#{id}\nrunning=#{running} paused=#{paused} progress=#{progress}%\ntime=#{inspect(time)} formatted=#{inspect(formatted)}"

    {:noreply,
     Corex.Toast.create(socket, "layout-toast", "timer_state_response", desc, :info,
       duration: 5000
     )}
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
        path={@path}
        id="timer-api-page"
        title="Timer · API"
        subtitle="Machine API: start, pause, resume, reset, restart, and read state from LiveView or the client."
      >
        <.demo_section
          id="timer-api-controls-binding"
          title="Controls (client binding)"
          code={@codes.controls_binding}
        >
          <:preview>
            <.api_controls_client_binding_example id={@id_controls_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-controls-js-section"
          title="Controls (client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.controls_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.controls_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.controls_js_ts}
          ]}
        >
          <:preview>
            <.api_controls_client_js_example id={@id_controls_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-controls-server-section"
          title="Controls (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.controls_server_heex},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: @codes.controls_server_elixir
            }
          ]}
        >
          <:preview>
            <.api_controls_server_example id={@id_controls_server} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-state-binding"
          title="State (client binding)"
          code={@codes.state_binding}
        >
          <:preview>
            <.api_state_client_binding_example id={@id_state_client} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-state-server-section"
          title="State (server)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.state_server_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @codes.state_server_elixir}
          ]}
        >
          <:preview>
            <.api_state_server_example id={@id_state_server} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-state-js-section"
          title="State (client JS)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @codes.state_js_heex},
            %{value: "js", label: "JS", language: :js, code: @codes.state_js},
            %{value: "ts", label: "TS", language: :javascript, code: @codes.state_js_ts}
          ]}
        >
          <:preview>
            <.api_state_client_js_example id={@id_state_js} />
          </:preview>
        </.demo_section>

        <.demo_section
          id="timer-api-template-countdown"
          title="Configuration: countdown range"
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
          title="Configuration: interval and auto start"
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
          title="Configuration: direction and orientation"
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
