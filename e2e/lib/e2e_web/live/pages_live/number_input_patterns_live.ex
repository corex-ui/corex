defmodule E2eWeb.NumberInputPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

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
        path={@path}
        id="number-input-patterns-page"
        title="Number Input · Patterns"
        subtitle="Initial value on mount; the machine owns stepper changes after that."
      >
        <.demo_section
          id="number-input-patterns-initial-doc"
          title="Initial value"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: patterns_initial_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_initial_elixir()}
          ]}
        >
          <:preview>
            <div class="flex max-w-md flex-col gap-3">
              <.number_input
                id="number-input-patterns-initial-field"
                class="number-input w-full"
                value="10"
                min={0.0}
                step={1.0}
              >
                <:label>Quantity</:label>
                <:decrement_trigger>
                  <.heroicon name="hero-chevron-down" class="icon" />
                </:decrement_trigger>
                <:increment_trigger>
                  <.heroicon name="hero-chevron-up" class="icon" />
                </:increment_trigger>
              </.number_input>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp patterns_initial_heex do
    ~S"""
    <.number_input
      id="number-input-patterns-initial-field"
      class="number-input w-full"
      value="10"
      min={0.0}
      step={1.0}
    >
      <:label>Quantity</:label>
      <:decrement_trigger>
        <.heroicon name="hero-chevron-down" class="icon" />
      </:decrement_trigger>
      <:increment_trigger>
        <.heroicon name="hero-chevron-up" class="icon" />
      </:increment_trigger>
    </.number_input>
    """
  end

  defp patterns_initial_elixir do
    ~S"""
    <.number_input id="qty" class="number-input" value="10" min={0.0} step={1.0}>
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
    </.number_input>
    """
  end
end
