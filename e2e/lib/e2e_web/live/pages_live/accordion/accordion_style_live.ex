defmodule E2eWeb.AccordionStyleLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage,
    only: [
      demo_page: 1,
      demo_playground: 1,
      demo_preview_tabs: 1,
      demo_section: 1,
      demo_style_matrix: 1
    ]

  alias E2eWeb.Demos.AccordionDemo
  alias E2eWeb.StyleLiveHelpers, as: StyleHelpers

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      semantic: "default",
      variant: "subtle",
      size: "md",
      text: "default",
      radius: "default",
      width: "default",
      max_width: "default",
      height: "default",
      max_height: "default"
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:semantic_items, StyleHelpers.semantic_items())
      |> assign(:variant_items, StyleHelpers.variant_items())
      |> assign(:size_items, StyleHelpers.size_items())
      |> assign(:text_items, StyleHelpers.text_items())
      |> assign(:radius_items, StyleHelpers.radius_items())
      |> assign(:width_items, StyleHelpers.select_items_for_axis(:width))
      |> assign(:max_width_items, StyleHelpers.select_items_for_axis(:max_width))
      |> assign(:height_items, StyleHelpers.select_items_for_axis(:height))
      |> assign(:max_height_items, StyleHelpers.select_items_for_axis(:max_height))
      |> assign_style_snippet()
      |> sync_items()

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
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
        <.demo_playground id="accordion-style-playground">
          <:controls>
            <.select
              id="accordion-semantic"
              size="sm"
              class="w-4xs"
              value={[@controls.semantic]}
              deselectable={false}
              items={@semantic_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Semantic"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Semantic</:label>
            </.select>

            <.select
              id="accordion-variant"
              size="sm"
              class="w-4xs"
              value={[@controls.variant]}
              deselectable={false}
              items={@variant_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Variant"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Variant</:label>
            </.select>

            <.select
              id="accordion-size"
              size="sm"
              class="w-4xs"
              value={[@controls.size]}
              deselectable={false}
              items={@size_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Size"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Size</:label>
            </.select>

            <.select
              id="accordion-text"
              size="sm"
              class="w-4xs"
              value={[@controls.text]}
              deselectable={false}
              items={@text_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Text"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Text</:label>
            </.select>

            <.select
              id="accordion-radius"
              size="sm"
              class="w-4xs"
              value={[@controls.radius]}
              deselectable={false}
              items={@radius_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Radius"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Radius</:label>
            </.select>

            <.select
              id="accordion-width"
              size="sm"
              class="w-4xs"
              value={[@controls.width]}
              deselectable={false}
              items={@width_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Width"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Width</:label>
            </.select>

            <.select
              id="accordion-max-width"
              size="sm"
              class="w-4xs"
              value={[@controls.max_width]}
              deselectable={false}
              items={@max_width_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Max width"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Max width</:label>
            </.select>

            <.select
              id="accordion-height"
              size="sm"
              class="w-4xs"
              value={[@controls.height]}
              deselectable={false}
              items={@height_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Height"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Height</:label>
            </.select>

            <.select
              id="accordion-max-height"
              size="sm"
              class="w-4xs"
              value={[@controls.max_height]}
              deselectable={false}
              items={@max_height_items}
              on_value_change="control_changed"
              translation={%Corex.Select.Translation{placeholder: "Max height"}}
              positioning={%Corex.Positioning{same_width: true}}
            >
              <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
              <:label>Max height</:label>
            </.select>
          </:controls>
          <:canvas>
            <.demo_preview_tabs
              id="accordion-style-preview"
              code={@style_snippet}
              authoring_scope="styled"
              trigger_class="button button--sm"
            >
              <:preview>
                <.accordion
                  id="my-accordion"
                  semantic={styling_attr(@controls.semantic, "default")}
                  variant={@controls.variant}
                  size={styling_attr(@controls.size, "md")}
                  text={styling_attr(@controls.text, "default")}
                  radius={styling_attr(@controls.radius, "default")}
                  width={preview_width_attr(@controls)}
                  max_width={styling_attr(@controls.max_width, "default")}
                  height={styling_attr(@controls.height, "default")}
                  max_height={styling_attr(@controls.max_height, "default")}
                  value="lorem"
                  items={@items}
                >
                  <:content :let={item}>
                    <p>{item.content}</p>
                  </:content>
                  <:indicator>
                    <.heroicon name="hero-chevron-right" />
                  </:indicator>
                </.accordion>
              </:preview>
            </.demo_preview_tabs>
          </:canvas>
        </.demo_playground>

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

  defp update_control(socket, key, value) when is_binary(key) do
    socket
    |> update(:controls, &Map.put(&1, String.to_existing_atom(key), value))
    |> assign_style_snippet()
    |> sync_items()
  end

  defp assign_style_snippet(socket) do
    assign(socket, :style_snippet, style_snippet(socket.assigns.controls))
  end

  defp sync_items(socket) do
    assign(socket, :items, preview_items(socket.assigns.controls))
  end

  defp style_snippet(controls) do
    attrs = styling_keyword(controls)
    items_code = items_code(controls)

    E2eWeb.AuthoringSnippet.playground_snippets(:accordion, attrs,
      inner: indicator_slot(),
      slots: ~s( items={#{items_code}})
    )
  end

  defp styling_keyword(controls) do
    []
    |> maybe_keyword(:semantic, controls.semantic, "default")
    |> maybe_keyword(:variant, controls.variant, "subtle")
    |> maybe_keyword(:size, controls.size, "md")
    |> maybe_keyword(:text, controls.text, "default")
    |> maybe_keyword(:radius, controls.radius, "default")
    |> maybe_keyword(:width, width_attr(controls))
    |> maybe_keyword(:max_width, styling_attr(controls.max_width, "default"))
    |> maybe_keyword(:height, styling_attr(controls.height, "default"))
    |> maybe_keyword(:max_height, styling_attr(controls.max_height, "default"))
  end

  defp maybe_keyword(keywords, _key, nil), do: keywords
  defp maybe_keyword(keywords, key, value), do: Keyword.put(keywords, key, value)

  defp maybe_keyword(keywords, key, value, default) do
    if value == default, do: keywords, else: Keyword.put(keywords, key, value)
  end

  defp styling_attr(value, default) do
    if value == default, do: nil, else: value
  end

  defp width_attr(%{width: "default", max_width: max_width}) when max_width != "default",
    do: "full"

  defp width_attr(%{width: "default", max_width: _}), do: nil
  defp width_attr(%{width: width}), do: width

  defp preview_width_attr(controls) do
    case width_attr(controls) do
      nil -> "full"
      value -> value
    end
  end

  defp preview_items(controls) do
    if long_content?(controls) do
      AccordionDemo.styling_height_items()
    else
      AccordionDemo.styling_items()
    end
  end

  defp items_code(controls) do
    if long_content?(controls) do
      String.trim(E2eWeb.Demos.DocExamples.code_content_items_with_values_long())
    else
      String.trim(E2eWeb.Demos.DocExamples.code_content_items_with_values())
    end
  end

  defp long_content?(controls) do
    controls.height != "default" or controls.max_height != "default"
  end

  defp indicator_slot do
    ~s(
      <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
    )
  end

  defp control_id("accordion-semantic"), do: "semantic"
  defp control_id("accordion-variant"), do: "variant"
  defp control_id("accordion-size"), do: "size"
  defp control_id("accordion-text"), do: "text"
  defp control_id("accordion-radius"), do: "radius"
  defp control_id("accordion-width"), do: "width"
  defp control_id("accordion-max-width"), do: "max_width"
  defp control_id("accordion-height"), do: "height"
  defp control_id("accordion-max-height"), do: "max_height"
  defp control_id(id), do: id
end
