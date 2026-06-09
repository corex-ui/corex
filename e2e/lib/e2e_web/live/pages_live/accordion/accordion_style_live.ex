defmodule E2eWeb.AccordionStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage,
    only: [demo_page: 1, demo_section: 1, demo_style_matrix: 1]

  alias E2eWeb.Demos.AccordionDemo

  @impl true
  def handle_event("control_changed", %{"value" => value, "id" => id}, socket)
      when is_list(value) do
    normalized =
      case value do
        [v] -> v
        [] -> nil
      end

    send_update(E2eWeb.AccordionStylePlayground,
      id: "accordion-style-playground",
      control_changed: %{id: id, value: normalized}
    )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      path={@path}
      mode={@mode}
      theme={@theme}
    >
      <.demo_page
        path={@path}
        id="accordion-style-page"
        title="Accordion · Style"
      >
        <.live_component module={E2eWeb.AccordionStylePlayground} id="accordion-style-playground" />

        <.demo_style_matrix id="accordion-style-matrix">
          <.demo_section
            id="accordion-styling-variant-semantic"
            title="Variant × semantic"
            values={AccordionDemo.styling_variant_semantic_values()}
            code={AccordionDemo.styling_variant_semantic_code()}
          >
            <:preview>
              <AccordionDemo.styling_variant_semantic_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="accordion-styling-size"
            title="Size"
            values={AccordionDemo.styling_axis_values(:size)}
            code={AccordionDemo.styling_size_code()}
          >
            <:preview>
              <AccordionDemo.styling_size_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="accordion-styling-text"
            title="Text"
            values={AccordionDemo.styling_axis_values(:text)}
            code={AccordionDemo.styling_text_code()}
          >
            <:preview>
              <AccordionDemo.styling_text_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="accordion-styling-radius"
            title="Radius"
            values={AccordionDemo.styling_axis_values(:radius)}
            code={AccordionDemo.styling_radius_code()}
          >
            <:preview>
              <AccordionDemo.styling_radius_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="accordion-styling-max-width"
            title="Max width"
            values={AccordionDemo.styling_axis_values(:max_width)}
            code={AccordionDemo.styling_max_width_code()}
          >
            <:preview>
              <AccordionDemo.styling_max_width_example />
            </:preview>
          </.demo_section>

          <.demo_section
            id="accordion-styling-height"
            title="Max height"
            values={AccordionDemo.styling_axis_values(:max_height)}
            code={AccordionDemo.styling_height_code()}
          >
            <:preview>
              <AccordionDemo.styling_height_example />
            </:preview>
          </.demo_section>
        </.demo_style_matrix>
      </.demo_page>
    </Layouts.app>
    """
  end
end
