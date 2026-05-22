defmodule E2eWeb.SwitchPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SwitchDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:checked, false)
     |> assign(:controlled_heex, Demo.patterns_controlled_heex())
     |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())}
  end

  @impl true
  def handle_event("patterns_checked", %{"checked" => checked}, socket) do
    c = checked == true or checked == "true"
    {:noreply, assign(socket, :checked, c)}
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
        id="switch-patterns-page"
        title="Switch · Pattern"
        subtitle="Controlled checked state synced with a LiveView assign."
      >
        <.demo_section
          id="switch-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.switch
              id="switch-patterns-controlled"
              class="switch"
              controlled
              checked={@checked}
              on_checked_change="patterns_checked"
            >
              <:label>Enable</:label>
            </.switch>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
