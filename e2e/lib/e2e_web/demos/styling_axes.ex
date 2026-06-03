defmodule E2eWeb.Demos.StylingAxes do
  @moduledoc false

  alias Corex.Design.Axes
  alias Corex.Design.Presets
  alias Corex.Design.Semantics

  def styling_axis_values(:semantic), do: Semantics.strings() |> Enum.join(", ")
  def styling_axis_values(:size), do: axis_values(Axes.size_atoms())
  def styling_axis_values(:text), do: axis_values(Axes.text_atoms())
  def styling_axis_values(:radius), do: axis_values(Axes.radius_atoms())
  def styling_axis_values(:variant), do: axis_values(Axes.visual_atoms())
  def styling_axis_values(:shape), do: axis_values(Axes.shape_atoms())
  def styling_axis_values(:width), do: axis_values(Keyword.keys(Presets.width_blocks()))
  def styling_axis_values(:max_width), do: axis_values(Keyword.keys(Presets.max_width_blocks()))
  def styling_axis_values(:height), do: axis_values(Keyword.keys(Presets.height_blocks()))
  def styling_axis_values(:max_height), do: axis_values(Keyword.keys(Presets.max_height_blocks()))
  def styling_axis_values(:side), do: "start, end, top, bottom"

  defp axis_values(atoms) do
    atoms
    |> Enum.map(&Atom.to_string/1)
    |> Enum.join(", ")
  end
end
