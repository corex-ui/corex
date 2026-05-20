defmodule E2eWeb.RadioGroupPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @initial_items E2eWeb.Demos.DocExamples.radio_items()

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:items, dom_id: &"radio-group:stream-radio-group:item:#{&1.value}")
     |> stream(:items, @initial_items)
     |> assign(:items_list, @initial_items)
     |> assign(:stream_value, "lorem")
     |> assign(:next_id, 1)
     |> assign(:value, "lorem")}
  end

  @impl true
  def handle_event("patterns_radio_value", %{"value" => v}, socket) do
    {:noreply, assign(socket, :value, v)}
  end

  def handle_event("patterns_stream_value", %{"value" => v}, socket) do
    {:noreply, assign(socket, :stream_value, v)}
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
     |> assign(:stream_value, "lorem")
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
        id="radio-group-patterns-page"
        title="Radio Group · Pattern"
        subtitle="Controlled selection and stream-driven items."
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
              items={Demo.items_for_preview()}
              value={@value}
              controlled
              on_value_change="patterns_radio_value"
            >
              <:label>Choose one</:label>
              <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
            </.radio_group>
          </:preview>
        </.demo_section>

        <.demo_section
          id="radio-group-patterns-stream"
          title={~t"Stream"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_stream_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_stream_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-xl">
              <div class="flex flex-wrap gap-2">
                <.action phx-click="add_item" class="button button--sm button--accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="reset" class="button button--sm button--alert">
                  Reset
                </.action>
              </div>
              <.radio_group
                id="stream-radio-group"
                name="stream-rg"
                class="radio-group"
                items={@items_list}
                value={@stream_value}
                controlled
                on_value_change="patterns_stream_value"
              >
                <:label>Choose one</:label>
                <:item_control><.heroicon name="hero-check" class="data-checked" /></:item_control>
              </.radio_group>
            </div>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
