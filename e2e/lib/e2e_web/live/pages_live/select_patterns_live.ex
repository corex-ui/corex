defmodule E2eWeb.SelectPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.SelectDemo, as: Demo

  @initial_items [
    %{value: "lorem", label: "Lorem ipsum dolor sit amet"},
    %{value: "duis", label: "Duis dictum gravida odio ac pharetra?"},
    %{value: "donec", label: "Donec condimentum ex mi"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"select:stream-select:item:#{&1.value}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)
     |> assign(:next_id, 1)
     |> assign(:value, [])
     |> assign(:items, Demo.patterns_items_flat())
     |> assign(:controlled_heex, Demo.patterns_controlled_heex())
     |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())}
  end

  @impl true
  def handle_event("value_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, assign(socket, :value, value)}
  end

  def handle_event("value_changed", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("add_item", _params, socket) do
    id = "item-#{socket.assigns.next_id}"
    item = %{value: id, label: "Item #{socket.assigns.next_id}"}

    {:noreply,
     socket
     |> stream_insert(:items, item)
     |> assign(:items_list, socket.assigns.items_list ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> stream(:items, @initial_items, reset: true)
     |> assign(:items_list, @initial_items)
     |> assign(:next_id, 1)}
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
        id="select-patterns-page"
        title="Select · Pattern"
        subtitle="Controlled selection and stream-driven items."
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
              controlled
              value={@value}
              items={@items}
              on_value_change="value_changed"
            >
              <:label>Country</:label>
              <:trigger>
                <.heroicon name="hero-chevron-down" />
              </:trigger>
            </.select>
          </:preview>
        </.demo_section>

        <.demo_section
          id="select-patterns-stream-section"
          title="Stream"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: Demo.patterns_stream_demo_heex()},
            %{
              value: "elixir",
              label: "Elixir",
              language: :elixir,
              code: Demo.patterns_stream_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-xl">
              <div class="flex flex-wrap gap-2">
                <.action phx-click="add_item" size="sm" semantic="accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="reset" size="sm" semantic="alert">
                  Reset
                </.action>
              </div>
              <.select id="stream-select" items={Corex.List.new(@items_list)}>
                <:label>Country</:label>
                <:trigger>
                  <.heroicon name="hero-chevron-down" />
                </:trigger>
              </.select>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
