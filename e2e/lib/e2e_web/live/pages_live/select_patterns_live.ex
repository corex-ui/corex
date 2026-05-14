defmodule E2eWeb.SelectPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:value, [])
     |> assign(:items, E2eWeb.Demos.SelectDemo.patterns_items_flat())
     |> assign(:controlled_heex, E2eWeb.Demos.SelectDemo.patterns_controlled_heex())
     |> assign(:controlled_elixir, E2eWeb.Demos.SelectDemo.patterns_controlled_elixir())}
  end

  @impl true
  def handle_event("value_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, assign(socket, :value, value)}
  end

  @impl true
  def handle_event("value_changed", _params, socket) do
    {:noreply, socket}
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
        id="select-patterns-page"
        title="Select · Pattern"
        subtitle="Controlled selection synced with a LiveView assign."
      >
        <.demo_section
          id="select-patterns-controlled-section"
          title="Controlled"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.select
              id="select-patterns-controlled"
              class="select"
              controlled
              value={@value}
              items={@items}
              on_value_change="value_changed"
            >
              <:label>Country</:label>
              <:trigger>
                <.heroicon name="hero-chevron-down" class="icon" />
              </:trigger>
            </.select>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
