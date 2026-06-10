defmodule E2eWeb.AccordionStylePlayground do
  use E2eWeb, :live_component

  import E2eWeb.DemoPage, only: [demo_playground: 1, demo_preview_tabs: 1]

  alias E2eWeb.Demos.AccordionDemo
  alias E2eWeb.StyleLiveHelpers, as: StyleHelpers

  @component :accordion

  @impl true
  def mount(socket) do
    controls = StyleHelpers.control_defaults(@component)

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
  def update(%{control_changed: %{id: id, value: value}} = assigns, socket) do
    socket = update_control(socket, control_id(id), value)
    {:ok, assign(socket, Map.delete(assigns, :control_changed))}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.demo_playground id="accordion-style-playground">
        <:controls>
          <.select
            id="accordion-semantic"
            size="sm"
            class="w-4xs"
            value={StyleHelpers.select_value(@controls.semantic)}
            deselectable
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
            value={StyleHelpers.select_value(@controls.variant)}
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
            value={StyleHelpers.select_value(@controls.size)}
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
            value={StyleHelpers.select_value(@controls.text)}
            deselectable
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
            value={StyleHelpers.select_value(@controls.radius)}
            deselectable
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
            value={StyleHelpers.select_value(@controls.width)}
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
            value={StyleHelpers.select_value(@controls.max_width)}
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
            value={StyleHelpers.select_value(@controls.height)}
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
            value={StyleHelpers.select_value(@controls.max_height)}
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
            trigger_class="button button--size-sm"
          >
            <:preview>
              <.accordion
                id="my-accordion"
                semantic={style_attr(@controls.semantic, :semantic)}
                variant={style_attr(@controls.variant, :variant)}
                size={style_attr(@controls.size, :size)}
                text={style_attr(@controls.text, :text)}
                radius={style_attr(@controls.radius, :radius)}
                width={preview_width_attr(@controls)}
                max_width={style_attr(@controls.max_width, :max_width)}
                height={style_attr(@controls.height, :height)}
                max_height={style_attr(@controls.max_height, :max_height)}
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
    </div>
    """
  end

  defp style_attr(value, axis) do
    StyleHelpers.styling_attr(value, StyleHelpers.axis_default(@component, axis))
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

    E2eWeb.AuthoringSnippet.playground_snippets(:accordion, attrs,
      inner: accordion_snippet_inner(),
      slots: items_slot()
    )
  end

  defp styling_keyword(controls) do
    []
    |> maybe_keyword(:semantic, controls.semantic, :semantic)
    |> maybe_keyword(:variant, controls.variant, :variant)
    |> maybe_keyword(:size, controls.size, :size)
    |> maybe_keyword(:text, controls.text, :text)
    |> maybe_keyword(:radius, controls.radius, :radius)
    |> maybe_keyword(:width, width_attr(controls))
    |> maybe_keyword(:max_width, controls.max_width, :max_width)
    |> maybe_keyword(:height, controls.height, :height)
    |> maybe_keyword(:max_height, controls.max_height, :max_height)
  end

  defp maybe_keyword(keywords, _key, nil), do: keywords

  defp maybe_keyword(keywords, key, value) when is_binary(value) do
    Keyword.put(keywords, key, value)
  end

  defp maybe_keyword(keywords, key, value, axis) do
    if StyleHelpers.omit_axis_value?(value, StyleHelpers.axis_default(@component, axis)),
      do: keywords,
      else: Keyword.put(keywords, key, value)
  end

  defp width_attr(%{width: "full", max_width: max_width}) when max_width != "md", do: "full"
  defp width_attr(%{width: "full", max_width: _}), do: nil
  defp width_attr(%{width: width}), do: width

  defp preview_width_attr(controls) do
    case width_attr(controls) do
      nil -> nil
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

  defp items_slot do
    E2eWeb.AuthoringSnippet.items_attr()
  end

  defp long_content?(controls) do
    controls.height != StyleHelpers.axis_default(@component, :height) or
      controls.max_height != StyleHelpers.axis_default(@component, :max_height)
  end

  defp accordion_snippet_inner do
    ~s(
      <:content :let={item}><p>{item.content}</p></:content>
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
