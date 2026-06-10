defmodule E2eWeb.ActionStylePlayground do
  use E2eWeb, :live_component

  import E2eWeb.DemoPage, only: [demo_playground: 1, demo_preview_tabs: 1]

  alias E2eWeb.StyleLiveHelpers, as: StyleHelpers

  @component :action

  @impl true
  def mount(socket) do
    controls = StyleHelpers.control_defaults(@component)

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:as_items, StyleHelpers.as_items())
      |> assign(:semantic_items, StyleHelpers.semantic_items())
      |> assign(:variant_items, StyleHelpers.variant_items())
      |> assign(:size_items, StyleHelpers.size_items())
      |> assign(:radius_items, StyleHelpers.radius_items())
      |> assign(:shape_items, StyleHelpers.shape_items())
      |> assign_style_snippet()

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
      <.demo_playground id="action-style-playground">
        <:controls>
          <.select
            id="action-as"
            size="sm"
            class="w-4xs"
            value={StyleHelpers.select_value(@controls.as)}
            deselectable={false}
            items={@as_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "As"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>As</:label>
          </.select>

          <.select
            id="action-semantic"
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
            id="action-variant"
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
            id="action-size"
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
            id="action-radius"
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
            id="action-shape"
            size="sm"
            class="w-4xs"
            value={StyleHelpers.select_value(@controls.shape)}
            deselectable
            items={@shape_items}
            on_value_change="control_changed"
            translation={%Corex.Select.Translation{placeholder: "Shape"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Shape</:label>
          </.select>

          <.switch
            size="sm"
            id="action-disabled"
            checked={@controls.disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.demo_preview_tabs
            id="action-style-preview"
            code={@style_snippet}
            authoring_scope="styled"
            trigger_class="button button--size-sm"
          >
            <:preview>
              <.action
                id="my-action"
                as={@controls.as}
                semantic={style_attr(@controls.semantic, :semantic)}
                variant={style_attr(@controls.variant, :variant)}
                size={style_attr(@controls.size, :size)}
                radius={preview_radius_attr(@controls)}
                shape={style_attr(@controls.shape, :shape)}
                aria_label={preview_aria_label(@controls)}
                disabled={@controls.disabled}
              >
                <.heroicon :if={icon_shape?(@controls)} name="hero-arrow-right" />
                <span :if={not icon_shape?(@controls)}>Preview</span>
              </.action>
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
  end

  defp assign_style_snippet(socket) do
    assign(socket, :style_snippet, style_snippet(socket.assigns.controls))
  end

  defp style_snippet(controls) do
    attrs = styling_keyword(controls)
    inner = preview_inner(controls)

    E2eWeb.AuthoringSnippet.playground_snippets(:action, attrs, inner: inner)
  end

  defp styling_keyword(controls) do
    []
    |> maybe_keyword(:as, controls.as, :as)
    |> maybe_keyword(:semantic, controls.semantic, :semantic)
    |> maybe_keyword(:variant, controls.variant, :variant)
    |> maybe_keyword(:size, controls.size, :size)
    |> maybe_keyword(:radius, preview_radius_keyword(controls), :radius)
    |> maybe_keyword(:shape, controls.shape, :shape)
    |> maybe_keyword(:disabled, controls.disabled, :disabled)
    |> maybe_aria_label(controls)
  end

  defp maybe_aria_label(keywords, controls) do
    case preview_aria_label(controls) do
      nil -> keywords
      label -> Keyword.put(keywords, :aria_label, label)
    end
  end

  defp preview_radius_keyword(%{shape: "circle"}), do: "full"
  defp preview_radius_keyword(%{radius: radius}), do: radius

  defp maybe_keyword(keywords, key, value, axis) when is_boolean(value) do
    if StyleHelpers.omit_axis_value?(value, StyleHelpers.axis_default(@component, axis)),
      do: keywords,
      else: Keyword.put(keywords, key, value)
  end

  defp maybe_keyword(keywords, key, value, axis) do
    if StyleHelpers.omit_axis_value?(value, StyleHelpers.axis_default(@component, axis)),
      do: keywords,
      else: Keyword.put(keywords, key, value)
  end

  defp preview_radius_attr(%{shape: "circle"}), do: "full"

  defp preview_radius_attr(controls) do
    style_attr(controls.radius, :radius)
  end

  defp preview_aria_label(%{shape: shape}) when shape in ["square", "circle"], do: "Preview"

  defp preview_aria_label(_controls), do: nil

  defp icon_shape?(controls) do
    controls.shape in ["square", "circle"]
  end

  defp preview_inner(controls) do
    if icon_shape?(controls) do
      ~s(<.heroicon name="hero-arrow-right" />)
    else
      "Preview"
    end
  end

  defp control_id("action-as"), do: "as"
  defp control_id("action-semantic"), do: "semantic"
  defp control_id("action-variant"), do: "variant"
  defp control_id("action-size"), do: "size"
  defp control_id("action-radius"), do: "radius"
  defp control_id("action-shape"), do: "shape"
  defp control_id("action-disabled"), do: "disabled"
  defp control_id(id), do: id
end
