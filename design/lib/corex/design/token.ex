defmodule Corex.Design.Token do
  @moduledoc """
  Keyword helpers for recipe stylesheet declarations.

  Use in recipe modules:

      import Corex.Design.Token

      padding: space(:md)
      background_color: color(:accent)
  """

  def space(step), do: {:space, step}
  def size(step), do: {:size, step}
  def radius(step), do: {:radius, step}
  def color(role), do: {:color, role}
  def text(step), do: {:text, step}
  def container(step), do: {:container, step}
  def raw(value), do: {:raw, value}
end
