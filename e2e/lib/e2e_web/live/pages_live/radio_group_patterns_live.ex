defmodule E2eWeb.RadioGroupPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, "a")}
  end

  @impl true
  def handle_event("patterns_radio_value", %{"value" => v}, socket) do
    {:noreply, assign(socket, :value, v)}
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
        id="radio-group-patterns-page"
        title="Radio Group · Pattern"
        subtitle="Controlled selection synced with LiveView assign."
      >
        <.demo_section
          id="radio-group-patterns-controlled"
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
            <.radio_group
              id="patterns-radio-group-controlled"
              name="patterns-rg"
              class="radio-group"
              items={[
                %{value: "a", label: "Option A"},
                %{value: "b", label: "Option B"},
                %{value: "c", label: "Option C"}
              ]}
              value={@value}
              controlled
              on_value_change="patterns_radio_value"
            >
              <:label>Choose one</:label>
              <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
            </.radio_group>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
