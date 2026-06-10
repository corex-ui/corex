defmodule E2eWeb.ComponentStylePlayground do
  use E2eWeb, :live_component

  import E2eWeb.DemoPage, only: [demo_playground: 1, demo_preview_tabs: 1]

  alias E2eWeb.ComponentStyleConfig, as: StyleConfig
  alias E2eWeb.Demos.StylePlayground, as: DemoStyle
  alias E2eWeb.StyleLiveHelpers, as: StyleHelpers

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :controls, %{})}
  end

  @impl true
  def update(%{component: component} = assigns, socket) do
    config = StyleConfig.get(component)
    axes = config.playground_axes

    socket =
      socket
      |> assign(Map.drop(assigns, [:control_changed]))
      |> assign(:component, component)
      |> assign(:config, config)
      |> assign(:axes, axes)
      |> ensure_controls(component, axes)
      |> assign_axis_items(axes)
      |> assign_style_snippet()

    socket =
      if Map.has_key?(assigns, :control_changed) do
        %{id: id, value: value} = assigns.control_changed
        update_control(socket, control_id(component, id), value)
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.demo_playground id={"#{@config.slug}-style-playground"}>
        <:controls>
          <.style_control
            :for={axis <- @axes}
            component={@component}
            axis={axis}
            controls={@controls}
            items={Map.get(@axis_items, axis, [])}
          />
        </:controls>
        <:canvas>
          <.demo_preview_tabs
            id={"#{@config.slug}-style-preview"}
            code={@style_snippet}
            authoring_scope="styled"
            trigger_class="button button--size-sm"
          >
            <:preview>
              {render_preview(@config.demo_module, @component, @controls)}
            </:preview>
          </.demo_preview_tabs>
        </:canvas>
      </.demo_playground>
    </div>
    """
  end

  attr :component, :atom, required: true
  attr :axis, :atom, required: true
  attr :controls, :map, required: true
  attr :items, :list, required: true

  defp style_control(%{axis: :disabled} = assigns) do
    ~H"""
    <.switch
      id={control_dom_id(@component, @axis)}
      size="sm"
      checked={@controls[:disabled] == true}
      on_checked_change="control_changed"
      aria_label="Disabled"
    >
      <:label>Disabled</:label>
    </.switch>
    """
  end

  defp style_control(assigns) do
    ~H"""
    <.select
      id={control_dom_id(@component, @axis)}
      size="sm"
      class="w-4xs"
      value={StyleHelpers.select_value(Map.get(@controls, @axis))}
      deselectable={axis_deselectable?(@axis)}
      items={@items}
      on_value_change="control_changed"
      translation={%Corex.Select.Translation{placeholder: axis_label(@axis)}}
      positioning={%Corex.Positioning{same_width: true}}
    >
      <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
      <:label>{axis_label(@axis)}</:label>
    </.select>
    """
  end

  defp render_preview(demo_module, component, controls) do
    assigns = %{controls: controls, component: component}

    cond do
      function_exported?(demo_module, :style_playground, 1) ->
        apply(demo_module, :style_playground, [assigns])

      function_exported?(demo_module, :style_preview, 1) ->
        apply(demo_module, :style_preview, [assigns])

      true ->
        E2eWeb.Demos.StylePreview.preview(component, assigns)
    end
  end

  defp ensure_controls(socket, component, axes) do
    defaults = StyleHelpers.control_defaults(component)

    controls =
      axes
      |> Enum.map(fn axis -> {axis, Map.get(defaults, axis)} end)
      |> Map.new()
      |> Map.merge(socket.assigns[:controls] || %{})

    assign(socket, :controls, controls)
  end

  defp assign_axis_items(socket, axes) do
    items =
      axes
      |> Enum.reject(&(&1 == :disabled))
      |> Enum.map(fn axis -> {axis, axis_items(axis)} end)
      |> Map.new()

    assign(socket, :axis_items, items)
  end

  defp assign_style_snippet(socket) do
    %{component: component, controls: controls, axes: axes} = socket.assigns
    attrs = DemoStyle.snippet_attrs(controls, component, axes)

    snippet =
      E2eWeb.AuthoringSnippet.playground_snippets(component, attrs,
        inner: snippet_inner(component),
        slots: snippet_slots(component)
      )

    assign(socket, :style_snippet, snippet)
  end

  defp update_control(socket, key, value) when is_atom(key) do
    socket
    |> update(:controls, &Map.put(&1, key, value))
    |> assign_style_snippet()
  end

  defp snippet_inner(_component), do: ""
  defp snippet_slots(_component), do: ""

  defp axis_items(:semantic), do: StyleHelpers.semantic_items()
  defp axis_items(:variant), do: StyleHelpers.variant_items()
  defp axis_items(:size), do: StyleHelpers.size_items()
  defp axis_items(:text), do: StyleHelpers.text_items()
  defp axis_items(:radius), do: StyleHelpers.radius_items()
  defp axis_items(:shape), do: StyleHelpers.shape_items()
  defp axis_items(:as), do: StyleHelpers.as_items()
  defp axis_items(axis), do: StyleHelpers.select_items_for_axis(axis)

  defp axis_deselectable?(axis) when axis in [:variant, :size, :as, :width, :max_width, :height, :max_height],
    do: false

  defp axis_deselectable?(_), do: true

  defp axis_label(:as), do: "As"
  defp axis_label(:max_width), do: "Max width"
  defp axis_label(:max_height), do: "Max height"
  defp axis_label(axis), do: axis |> Atom.to_string() |> Phoenix.Naming.humanize()

  defp control_dom_id(component, axis) do
    "#{StyleConfig.slug(component)}-#{axis |> Atom.to_string() |> String.replace("_", "-")}"
  end

  defp control_id(component, id) do
    prefix = "#{StyleConfig.slug(component)}-"

    if String.starts_with?(id, prefix) do
      id
      |> String.replace_prefix(prefix, "")
      |> String.replace("-", "_")
      |> String.to_existing_atom()
    else
      String.to_existing_atom(id)
    end
  rescue
    ArgumentError -> :unknown
  end
end
