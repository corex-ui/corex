defmodule Corex.Design.BemTest do
  use ExUnit.Case, async: true

  alias Corex.Bem
  alias Corex.Design.Axes
  alias Corex.Design.Bem, as: DesignBem

  test "step/2 covers layout and standard axes" do
    assert Bem.step(:semantic, "accent") == "semantic-accent"
    assert Bem.step(:size, "md") == "size-md"
    assert Bem.step(:variant, "ghost") == "variant-ghost"
    assert Bem.step(:shape, "square") == "shape-square"
    assert Bem.step(:radius, "xl") == "rounded-xl"
    assert Bem.step(:width, "full") == "w-full"
    assert Bem.step(:max_width, "lg") == "max-w-lg"
    assert Bem.step(:surface, "layer") == "on-layer"
  end

  test "host_selector/3 matches runtime modifier_class/3" do
    for axis <- [:semantic, :size, :variant, :shape],
        value <- sample_values(axis) do
      base = "button"
      atom_value = if(is_atom(value), do: value, else: String.to_atom(value))
      string_value = if(is_atom(value), do: Atom.to_string(value), else: value)

      assert DesignBem.host_selector(:button, axis, atom_value) ==
               ".button.#{Bem.modifier_class(base, axis, string_value)}"
    end
  end

  defp sample_values(:semantic), do: Enum.take(Axes.semantic_atoms(), 2)
  defp sample_values(:size), do: [:sm, :md]
  defp sample_values(:variant), do: [:solid, :ghost]
  defp sample_values(:shape), do: [:square]
end
