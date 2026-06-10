defmodule Corex.Bem do
  @moduledoc false

  def step(:max_width, value), do: "max-w-#{value}"
  def step(:max_height, value), do: "max-h-#{value}"
  def step(:width, value), do: "w-#{value}"
  def step(:height, value), do: "h-#{value}"
  def step(:surface, value), do: "on-#{value}"
  def step(:radius, value), do: "rounded-#{value}"
  def step(axis, value), do: "#{axis_name(axis)}-#{value}"

  def axis_name(axis) when is_atom(axis) do
    axis
    |> Atom.to_string()
    |> String.replace("_", "-")
  end

  def modifier_class(base, axis, value) do
    "#{base}--#{step(axis, value)}"
  end
end
