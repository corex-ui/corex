defmodule Corex.Design.Axes do
  @moduledoc """
  Design-side axis vocabulary from resolved scales.
  """

  alias Corex.Design.Scales

  def colors, do: semantic_strings()
  def color_atoms, do: semantic_atoms()
  def semantic_strings, do: Scales.semantic_strings()
  def semantic_atoms, do: Scales.semantic_atoms()

  def sizes, do: Scales.steps(:size)
  def size_atoms, do: Scales.step_atoms(:size)

  def texts, do: Scales.steps(:text)
  def text_atoms, do: Scales.step_atoms(:text)

  def radii, do: Scales.steps(:radius)
  def radius_atoms, do: Scales.step_atoms(:radius)

  def weights, do: Scales.steps(:weight)
  def weight_atoms, do: Scales.step_atoms(:weight)
end
