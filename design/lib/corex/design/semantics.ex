defmodule Corex.Design.Semantics do
  @moduledoc false

  @axis_atoms ~w(base accent brand alert info success)a

  def axis_atoms, do: @axis_atoms

  def axis_strings, do: Enum.map(@axis_atoms, &Atom.to_string/1)

  def atoms, do: @axis_atoms

  def strings, do: axis_strings()

  def style_values, do: [nil | strings()]
end
