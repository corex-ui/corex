defmodule E2eWeb.NumberInputPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:patterns_controlled_value, "10")
     |> assign(:patterns_value_as_number, 10)}
  end

  @impl true
  def handle_event("number_input_patterns_value", payload, socket) do
    id = payload["id"]

    if id == "number-input-patterns-controlled-field" do
      v = payload["value"] || ""
      n = payload["valueAsNumber"]

      {:noreply,
       socket
       |> assign(:patterns_controlled_value, v)
       |> assign(:patterns_value_as_number, n)}
    else
      {:noreply, socket}
    end
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
        id="number-input-patterns-page"
        title="Number Input · Patterns"
        subtitle="Standalone controlled value: use on_value_change so the server assigns value on each change (required for +/- with controlled)."
      >
        <.demo_section
          id="number-input-patterns-controlled-doc"
          title="Controlled (value)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: patterns_controlled_heex()},
            %{value: "elixir", label: "Elixir", language: :elixir, code: patterns_controlled_elixir()}
          ]}
        >
          <:preview>
            <div class="flex max-w-md flex-col gap-3">
              <.number_input
                id="number-input-patterns-controlled-field"
                class="number-input w-full"
                controlled
                value={@patterns_controlled_value}
                min={0.0}
                step={1.0}
                on_value_change="number_input_patterns_value"
              >
                <:label>Quantity</:label>
                <:decrement_trigger>
                  <.heroicon name="hero-chevron-down" class="icon" />
                </:decrement_trigger>
                <:increment_trigger>
                  <.heroicon name="hero-chevron-up" class="icon" />
                </:increment_trigger>
              </.number_input>
              <p class="font-mono text-sm text-ink-muted" id="number-input-patterns-controlled-state">
                value: {inspect(@patterns_controlled_value)} · valueAsNumber:{" "}
                {inspect(@patterns_value_as_number)}
              </p>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp patterns_controlled_heex do
    ~S"""
    <.number_input
      id="number-input-patterns-controlled-field"
      class="number-input w-full"
      controlled
      value={@patterns_controlled_value}
      min={0.0}
      step={1.0}
      on_value_change="number_input_patterns_value"
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

  defp patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign(:patterns_controlled_value, "10")
       |> assign(:patterns_value_as_number, 10)}
    end

    def handle_event("number_input_patterns_value", payload, socket) do
      case payload do
        %{"id" => "number-input-patterns-controlled-field", "value" => v} ->
          n = payload["valueAsNumber"]

          {:noreply,
           socket
           |> assign(:patterns_controlled_value, v || "")
           |> assign(:patterns_value_as_number, n)}

        _ ->
          {:noreply, socket}
      end
    end
    """
  end
end
