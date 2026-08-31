defmodule E2eWeb.ProgressPatternsLive do
  use E2eWeb, :live_view
  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ProgressDemo, as: Demo

  @id "patterns-progress"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, 20)}
  end

  @impl true
  def handle_event("progress_advance", _params, socket) do
    value = min(socket.assigns.value + 20, 100)

    {:noreply,
     socket
     |> assign(:value, value)
     |> Corex.Progress.set_value(@id, value)}
  end

  @impl true
  def handle_event("progress_reset", _params, socket) do
    {:noreply,
     socket
     |> assign(:value, 0)
     |> Corex.Progress.set_value(@id, 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="progress-patterns-page"
        title={~t"Progress · Pattern"}
        subtitle={~t"Update the value from the server, then reset it."}
      >
        <.demo_section
          id="progress-patterns-server"
          title={~t"Server value"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: Demo.patterns_server_heex()},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: Demo.patterns_server_elixir()}
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-space w-full max-w-sm">
              <div class="flex flex-wrap gap-space-sm">
                <.action phx-click="progress_advance" class="button ui-size-sm">Advance</.action>
                <.action phx-click="progress_reset" class="button ui-size-sm">Reset</.action>
              </div>
              <.progress id="patterns-progress" class="progress" value={@value} />
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
