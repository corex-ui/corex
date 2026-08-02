defmodule E2eWeb.RadioGroupPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.RadioGroupDemo, as: Demo

  @initial_items E2eWeb.Demos.DocExamples.radio_items()

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:items, @initial_items)
     |> assign(:dynamic_value, "lorem")
     |> assign(:next_id, 1)
     |> assign(:items_version, 0)
     |> assign(:value, "lorem")}
  end

  @impl true
  def handle_event("patterns_radio_value", %{"value" => v}, socket) do
    {:noreply, assign(socket, :value, v)}
  end

  def handle_event("patterns_dynamic_value", %{"value" => v}, socket) do
    {:noreply, assign(socket, :dynamic_value, v)}
  end

  def handle_event("add_item", _params, socket) do
    id = "item-#{socket.assigns.next_id}"
    item = %{value: id, label: "Item #{socket.assigns.next_id}"}

    {:noreply,
     socket
     |> assign(:items, socket.assigns.items ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)
     |> update(:items_version, &(&1 + 1))}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(:items, @initial_items)
     |> assign(:dynamic_value, "lorem")
     |> assign(:next_id, 1)
     |> update(:items_version, &(&1 + 1))}
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
        id="radio-group-patterns-page"
        title="Radio Group · Pattern"
        subtitle="Controlled selection and dynamic items."
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
          id="radio-group-patterns-dynamic"
          title={~t"Dynamic items"}
          code_tabs={[
            %{
              value: "heex",
              label: ~t"Heex",
              language: :heex,
              code: Demo.patterns_dynamic_demo_heex()
            },
            %{
              value: "elixir",
              label: ~t"Elixir",
              language: :elixir,
              code: Demo.patterns_dynamic_elixir()
            }
          ]}
        >
          <:preview>
            <div class="flex flex-col gap-3 w-full max-w-xl">
              <div class="flex flex-wrap gap-2">
                <.action phx-click="add_item" class="button ui-size-sm ui-accent">
                  <.heroicon name="hero-plus" /> Add item
                </.action>
                <.action phx-click="reset" class="button ui-size-sm ui-alert">
                  Reset
                </.action>
              </div>
              <.radio_group
                id={"patterns-dynamic-#{@items_version}"}
                name="dynamic-rg"
                class="radio-group"
                items={@items}
                value={@dynamic_value}
                controlled
                on_value_change="patterns_dynamic_value"
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
