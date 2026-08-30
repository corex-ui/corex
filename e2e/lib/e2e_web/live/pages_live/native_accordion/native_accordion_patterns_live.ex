defmodule E2eWeb.NativeAccordionPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias Corex.NativeAccordion
  alias E2eWeb.Demos.NativeAccordionDemo, as: Demo

  @id_controlled "patterns-controlled"
  @id_uncontrolled "patterns-uncontrolled"
  @id_dynamic "patterns-dynamic"

  @initial_items [
    %{value: "1", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
    %{
      value: "2",
      label: "Duis dictum gravida odio ac pharetra?",
      content: "Nullam eget vestibulum ligula."
    },
    %{value: "3", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a."}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id_controlled, @id_controlled)
     |> assign(:id_uncontrolled, @id_uncontrolled)
     |> assign(:id_dynamic, @id_dynamic)
     |> assign(:open, ["lorem"])
     |> assign(:items, Demo.patterns_items())
     |> assign(:controlled_heex, Demo.patterns_controlled_heex())
     |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())
     |> assign(:uncontrolled_heex, Demo.patterns_uncontrolled_heex())
     |> assign(:dynamic_items, @initial_items)
     |> assign(:next_id, 4)}
  end

  def handle_event("patterns_controlled_changed", params, socket) do
    {:noreply,
     NativeAccordion.handle_toggle(socket, :open, params, multiple: false, collapsible: true)}
  end

  def handle_event("add_item", _params, socket) do
    id = to_string(socket.assigns.next_id)
    item = %{value: id, label: "Item #{id}", content: "Content for item #{id}."}

    {:noreply,
     socket
     |> assign(:dynamic_items, socket.assigns.dynamic_items ++ [item])
     |> assign(:next_id, socket.assigns.next_id + 1)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, socket |> assign(:dynamic_items, @initial_items) |> assign(:next_id, 4)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} theme={@theme} path={@path}>
      <.demo_page
        path={@path}
        id="native-accordion-patterns-page"
        title={~t"Native Accordion · Pattern"}
        subtitle={~t"Controlled LiveView state, uncontrolled JS pipes, and dynamic items."}
      >
        <.demo_section
          id="native-accordion-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <p class="text-sm opacity-80 mb-space-sm">Open: {inspect(@open)}</p>
            <.native_accordion
              id={@id_controlled}
              class="accordion"
              items={@items}
              multiple={false}
              controlled
              value={@open}
              on_value_change="patterns_controlled_changed"
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.native_accordion>
          </:preview>
        </.demo_section>

        <.demo_section
          id="native-accordion-patterns-uncontrolled"
          title={~t"Uncontrolled (JS pipes)"}
          code={@uncontrolled_heex}
        >
          <:preview>
            <.native_accordion
              id={@id_uncontrolled}
              class="accordion"
              items={@items}
              controlled={false}
              value={["lorem"]}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.native_accordion>
          </:preview>
        </.demo_section>

        <.demo_section
          id="native-accordion-patterns-dynamic"
          title={~t"Dynamic items"}
        >
          <:preview>
            <div class="flex flex-wrap gap-space-sm items-center w-full justify-center">
              <.action phx-click="add_item" class="button ui-size-sm ui-accent">
                <.heroicon name="hero-plus" /> Add item
              </.action>
              <.action phx-click="reset" class="button ui-size-sm ui-alert">
                Reset
              </.action>
            </div>
            <.native_accordion
              id={@id_dynamic}
              class="accordion"
              controlled={false}
              items={Corex.Content.new(@dynamic_items)}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.native_accordion>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end
end
