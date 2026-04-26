defmodule E2eWeb.TimerPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.TimerDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
        id="timer-patterns-page"
        title="Timer · Pattern"
        subtitle="Minimal countdown timer with trigger slots."
      >
        <.demo_section
          id="timer-patterns-minimal"
          title="Minimal"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.patterns_minimal_heex()},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: Demo.patterns_minimal_elixir()
            }
          ]}
        >
          <:preview>
            <Demo.patterns_minimal_example />
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
