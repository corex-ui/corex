defmodule E2eWeb.TooltipPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TooltipDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :open, false)}
  end

  @impl true
  def handle_event("tooltip_pattern_open", %{"open" => open, "id" => _id}, socket) do
    o = open == true or open == "true"
    {:noreply, assign(socket, :open, o)}
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
        id="tooltip-patterns-page"
        title="Tooltip · Pattern"
        subtitle="Open state from a LiveView assign."
      >
        <.demo_section
          id="tooltip-patterns-controlled"
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
            <Demo.patterns_controlled_example open={@open} />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
