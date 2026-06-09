defmodule E2eWeb.StyleLiveHelpers do
  @moduledoc false

  alias E2eWeb.ComponentStyleDefaults, as: StyleDefaults
  alias E2eWeb.Demos.StylingAxes

  def select_items_for_axis(axis) do
    axis
    |> StylingAxes.styling_axis_values()
    |> split_axis_values()
    |> select_items_for_values()
  end

  def select_items_for_values(values) when is_list(values) do
    Enum.map(values, &select_item/1)
  end

  def select_item(value) when is_binary(value) do
    %{label: style_option_label(value), value: value}
  end

  def style_option_label(value), do: Phoenix.Naming.humanize(value)

  def select_value(nil), do: []
  def select_value(value), do: [value]

  def semantic_items do
    select_items_for_values(Corex.Design.Semantics.strings())
  end

  def variant_items do
    select_items_for_values(~w(solid ghost outline subtle))
  end

  def size_items do
    select_items_for_values(~w(sm md lg xl))
  end

  def text_items do
    select_items_for_values(~w(sm base lg xl 2xl 4xl))
  end

  def radius_items do
    select_items_for_values(~w(none sm md lg xl full))
  end

  def shape_items do
    select_items_for_axis(:shape)
  end

  def as_items do
    select_items_for_values(~w(button link))
  end

  def control_defaults(component), do: StyleDefaults.control_defaults(component)

  def axis_default(component, axis), do: StyleDefaults.axis_default(component, axis)

  def styling_attr(nil, _), do: nil

  def styling_attr(value, axis_default) when value == axis_default, do: nil

  def styling_attr(value, _), do: value

  def omit_axis_value?(value, axis_default) do
    is_nil(value) or value == axis_default
  end

  defp split_axis_values(values) when is_binary(values) do
    String.split(values, ", ", trim: true)
  end
end
