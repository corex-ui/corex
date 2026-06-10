defmodule E2eWeb.Demos.StylePlayground do
  @moduledoc false

  alias E2eWeb.ComponentStyleDefaults, as: StyleDefaults
  alias E2eWeb.StyleLiveHelpers, as: StyleHelpers

  def preview_id(component) when is_atom(component) do
    "my-#{component |> Atom.to_string() |> String.replace("_", "-")}"
  end

  def attr(controls, component, axis) when is_map(controls) and is_atom(axis) do
    value = Map.get(controls, axis)

    StyleHelpers.styling_attr(value, StyleDefaults.axis_default(component, axis))
  end

  def snippet_attrs(controls, component, axes) when is_map(controls) and is_list(axes) do
    Enum.reduce(axes, [], fn axis, acc ->
      value = Map.get(controls, axis)
      default = StyleDefaults.axis_default(component, axis)

      if StyleHelpers.omit_axis_value?(value, default) do
        acc
      else
        Keyword.put(acc, axis, value)
      end
    end)
  end
end
