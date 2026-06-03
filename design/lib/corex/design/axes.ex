defmodule Corex.Design.Axes do
  @moduledoc """
  Design-side facade over the axis vocabulary. The step names come from
  `Corex.Scales` (the single source of truth in `:corex`); this module exposes
  them in the shapes the recipes/emitters expect. Step VALUES (multipliers,
  tokens) remain in `Corex.Design.Tokens.Scales`.
  """

  alias Corex.Design.Semantics
  alias Corex.Scales

  def colors, do: Semantics.strings()
  def semantic_atoms, do: Semantics.atoms()
  def color_atoms, do: semantic_atoms()

  def sizes, do: Scales.sizes()
  def size_atoms, do: Scales.size_atoms()

  def texts, do: Scales.texts()
  def text_atoms, do: Scales.text_atoms()

  def visuals, do: Scales.visuals()
  def visual_atoms, do: Scales.visual_atoms()

  def radii, do: Scales.radii()
  def radius_atoms, do: Scales.radius_atoms()

  def weights, do: Scales.weights()
  def weight_atoms, do: Scales.weight_atoms()

  def shapes, do: Scales.shapes()
  def shape_atoms, do: Scales.shape_atoms()
end

defmodule Corex.Design.Axis do
  @moduledoc false

  def name(axis) when is_atom(axis) do
    axis
    |> Atom.to_string()
    |> String.replace("_", "-")
  end
end
