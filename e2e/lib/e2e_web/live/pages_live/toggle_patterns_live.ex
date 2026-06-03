defmodule E2eWeb.TogglePatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToggleDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:pressed, false)
     |> assign(:controlled_heex, Demo.patterns_controlled_heex())
     |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())}
  end

  @impl true
  def handle_event("toggle_patterns_pressed", %{"pressed" => pressed}, socket) do
    {:noreply, assign(socket, :pressed, pressed == true or pressed == "true")}
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
        id="toggle-patterns-page"
        title="Toggle · Pattern"
        subtitle="Controlled pressed state synced with a LiveView assign."
      >
        <.demo_section
          id="toggle-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.toggle
              id="toggle-patterns-controlled"
              controlled
              pressed={@pressed}
              on_pressed_change="toggle_patterns_pressed"
            >
              lorem
            </.toggle>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
