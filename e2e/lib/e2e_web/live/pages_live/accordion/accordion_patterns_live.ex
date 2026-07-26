defmodule E2eWeb.AccordionPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  alias E2eWeb.Demos.AccordionDemo, as: Demo

  @id_async "patterns-async"
  @id_controlled "patterns-controlled"
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
    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:id_dynamic, @id_dynamic)
      |> assign(:value, ["lorem"])
      |> assign(:items, items())
      |> assign(:async_heex_full, Demo.patterns_async_heex_full())
      |> assign(:async_heex_panel, Demo.patterns_async_heex_panel())
      |> assign(:async_elixir, Demo.patterns_async_elixir())
      |> assign(:controlled_heex, Demo.patterns_controlled_heex())
      |> assign(:controlled_elixir, Demo.patterns_controlled_elixir())
      |> assign(:dynamic_heex, Demo.patterns_dynamic_demo_heex())
      |> assign(:dynamic_elixir, Demo.patterns_dynamic_elixir())
      |> assign(:dynamic_items, @initial_items)
      |> assign(:next_id, 4)
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items =
          Corex.Content.new([
            %{
              value: "lorem",
              label: ~t"Lorem ipsum dolor sit amet",
              content: ~t"Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
            },
            %{
              value: "duis",
              label: ~t"Duis dictum gravida odio ac pharetra?",
              content: ~t"Nullam eget vestibulum ligula, at interdum tellus."
            },
            %{
              value: "donec",
              label: ~t"Donec condimentum ex mi",
              content: ~t"Congue molestie ipsum gravida a. Sed ac eros luctus."
            }
          ])

        {:ok, %{accordion: %{items: items, value: ["duis"]}}}
      end)

    {:ok, socket}
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

  def handle_event("patterns_controlled_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

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
        id="accordion-patterns-page"
        title={~t"Accordion · Pattern"}
        subtitle={~t"Async loading, controlled state, and dynamic items."}
      >
        <.demo_section
          id="accordion-patterns-async"
          title={~t"Async"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @async_elixir}
          ]}
        >
          <:preview>
            <.async_result :let={accordion} assign={@accordion}>
              <:loading>
                <.accordion_skeleton count={3} class="accordion" />
              </:loading>

              <.accordion
                id={@id_async}
                class="accordion"
                items={accordion.items}
                value={accordion.value}
              >
                <:indicator>
                  <.heroicon name="hero-chevron-right" />
                </:indicator>
              </.accordion>
            </.async_result>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-patterns-controlled"
          title={~t"Controlled (LiveView)"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @controlled_elixir}
          ]}
        >
          <:preview>
            <.accordion
              id={@id_controlled}
              class="accordion"
              items={@items}
              multiple={false}
              controlled
              value={@value}
              on_value_change="patterns_controlled_changed"
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-patterns-dynamic"
          title={~t"Dynamic items"}
          code_tabs={[
            %{value: "heex", label: ~t"Heex", language: :heex, code: @dynamic_heex},
            %{value: "elixir", label: ~t"Elixir", language: :elixir, code: @dynamic_elixir}
          ]}
        >
          <:preview>
            <div class="flex flex-wrap gap-2 items-center w-full justify-center">
              <.action phx-click="add_item" class="button ui-size-sm ui-accent">
                <.heroicon name="hero-plus" /> Add item
              </.action>
              <.action phx-click="reset" class="button ui-size-sm ui-alert">
                Reset
              </.action>
            </div>
            <.accordion
              id={@id_dynamic}
              class="accordion"
              items={Corex.Content.new(@dynamic_items)}
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>
      </.demo_page>
    </Layouts.app>
    """
  end

  defp items do
    Demo.patterns_items()
  end
end
