defmodule Corex.Design.Taxonomy do
  @moduledoc """
  Recipe styling coverage expectations by component category.

  Components declare accepted axes via `Corex.Bem.Variants` (`axes:` on each module).
  Recipes declare which axes they **style** via `variants`. This taxonomy lists
  axes a recipe in each category is expected to cover for baseline styling.
  Parity is enforced by `Corex.Design.AxisCoverageTest`; component `axes:` lists
  may be broader than recipe `variants` until aligned per component.
  """

  @standard_axes ~W(semantic size variant radius text width height max_width max_height shape)a

  @categories %{
    trigger: ~W(semantic variant size radius text width height max_width max_height)a,
    field: ~W(semantic size radius width height max_width max_height)a,
    surface: ~W(semantic size radius width height max_width max_height)a,
    decorative: ~W(size width height max_width max_height)a
  }

  @component_categories %{
    button: :trigger,
    link: :trigger,
    toggle: :trigger,
    action: :trigger,
    navigate: :trigger,
    select: :field,
    combobox: :field,
    listbox: :field,
    menu: :field,
    checkbox: :field,
    radio_group: :field,
    switch: :field,
    native_input: :field,
    number_input: :field,
    password_input: :field,
    pin_input: :field,
    color_picker: :field,
    tags_input: :field,
    date_picker: :field,
    dialog: :surface,
    toast: :surface,
    tooltip: :surface,
    floating_panel: :surface,
    menu_overlay: :surface,
    accordion: :surface,
    tabs: :surface,
    carousel: :surface,
    collapsible: :surface,
    editable: :surface,
    file_upload: :surface,
    data_table: :surface,
    pagination: :surface,
    timer: :decorative,
    avatar: :decorative,
    clipboard: :decorative,
    code: :decorative,
    data_list: :surface,
    marquee: :decorative,
    angle_slider: :decorative,
    signature_pad: :field,
    tree_view: :surface,
    layout_heading: :decorative
  }

  def standard_axes, do: @standard_axes

  def categories, do: @categories

  def category_for(component_id) when is_atom(component_id) do
    Map.get(@component_categories, component_id)
  end

  @required_axis_omit %{
    floating_panel: [:size],
    data_list: [:radius, :width, :height, :max_width, :max_height]
  }

  def required_axes(component_id) when is_atom(component_id) do
    case category_for(component_id) do
      nil ->
        []

      category ->
        @categories
        |> Map.fetch!(category)
        |> omit_axes(component_id)
    end
  end

  defp omit_axes(axes, component_id) do
    case Map.get(@required_axis_omit, component_id) do
      nil -> axes
      omit -> axes -- omit
    end
  end

  def component_categories, do: @component_categories
end
