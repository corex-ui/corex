defmodule E2eWeb.ToggleGroupPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.ToggleGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, ["lorem"])}
  end

  @impl true
  def handle_event("toggle_group_pattern", %{"value" => v}, socket) do
    {:noreply, assign(socket, :value, v || [])}
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
        id="toggle-group-patterns-page"
        title="Toggle group · Pattern"
        subtitle="Controlled value synced with a LiveView assign."
      >
        <.demo_section
          id="toggle-group-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.patterns_controlled_heex()},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: Demo.patterns_controlled_elixir()
            }
          ]}
        >
          <:preview>
            <Demo.patterns_controlled_example value={@value} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
