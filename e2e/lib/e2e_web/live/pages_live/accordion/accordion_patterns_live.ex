defmodule E2eWeb.AccordionPatternsLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_page: 1, demo_section: 1]

  @id_async "patterns-async"
  @id_controlled "patterns-controlled"
  @id_single "patterns-open-single"
  @id_multiple "patterns-open-multiple"

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:id_async, @id_async)
      |> assign(:id_controlled, @id_controlled)
      |> assign(:id_single, @id_single)
      |> assign(:id_multiple, @id_multiple)
      |> assign(:value, ["lorem"])
      |> assign(:items, items())
      |> assign(:async_heex_full, E2eWeb.Demos.AccordionDemo.patterns_async_heex_full())
      |> assign(:async_heex_panel, E2eWeb.Demos.AccordionDemo.patterns_async_heex_panel())
      |> assign(:async_elixir, E2eWeb.Demos.AccordionDemo.patterns_async_elixir())
      |> assign(:controlled_heex, E2eWeb.Demos.AccordionDemo.patterns_controlled_heex())
      |> assign(:controlled_elixir, E2eWeb.Demos.AccordionDemo.patterns_controlled_elixir())
      |> assign(:open_single_heex, E2eWeb.Demos.AccordionDemo.patterns_open_single_heex())
      |> assign(:open_multiple_heex, E2eWeb.Demos.AccordionDemo.patterns_open_multiple_heex())
      |> assign_async(:accordion, fn ->
        Process.sleep(1000)

        items =
          Corex.Content.new([
            %{
              value: "lorem",
              label: "Lorem ipsum dolor sit amet",
              content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
            },
            %{
              value: "duis",
              label: "Duis dictum gravida odio ac pharetra?",
              content: "Nullam eget vestibulum ligula, at interdum tellus."
            },
            %{
              value: "donec",
              label: "Donec condimentum ex mi",
              content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
            }
          ])

        {:ok, %{accordion: %{items: items, value: ["duis"]}}}
      end)

    {:ok, socket}
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
        id="accordion-patterns-page"
        title="Accordion · Pattern"
        subtitle="Common ways to structure Accordion state and data flows."
      >
        <.demo_section
          id="accordion-patterns-async"
          title="Async"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @async_heex_full},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @async_elixir}
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
          title="Controlled (LiveView)"
          code_tabs={[
            %{value: "heex", label: "Heex", language: :heex, code: @controlled_heex},
            %{value: "elixir", label: "Elixir", language: :elixir, code: @controlled_elixir}
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
          id="accordion-patterns-open-single"
          title="Open single"
          code={@open_single_heex}
        >
          <:preview>
            <.accordion
              id={@id_single}
              class="accordion"
              items={@items}
              multiple={false}
              value="lorem"
            >
              <:indicator>
                <.heroicon name="hero-chevron-right" />
              </:indicator>
            </.accordion>
          </:preview>
        </.demo_section>

        <.demo_section
          id="accordion-patterns-open-multiple"
          title="Open multiple"
          code={@open_multiple_heex}
        >
          <:preview>
            <.accordion
              id={@id_multiple}
              class="accordion"
              items={@items}
              multiple
              value={["lorem", "donec"]}
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
    E2eWeb.Demos.AccordionDemo.patterns_items()
  end
end
