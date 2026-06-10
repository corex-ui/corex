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

  @utility_prefixes %{
    text: "text-",
    radius: "rounded-",
    size: "size-",
    max_width: "max-w-",
    max_height: "max-h-"
  }

  @slot_prefixes ~W(item branch control root label trigger indicator content error input icon)

  def name(axis) when is_atom(axis) do
    axis
    |> Atom.to_string()
    |> String.replace("_", "-")
  end

  def utility_prefix(axis), do: Map.get(@utility_prefixes, axis)

  def utility_host?(selector, name, axis) do
    case utility_prefix(axis) do
      nil -> false
      prefix -> String.starts_with?(selector, host_variant_prefix(name, prefix))
    end
  end

  def host_variant_prefix(name, suffix) when is_binary(name) and is_binary(suffix) do
    ".#{name}.#{name}--#{suffix}"
  end

  def slot_part?(key) when is_atom(key) do
    name = Atom.to_string(key)
    key == :host or Enum.any?(@slot_prefixes, &String.starts_with?(name, &1))
  end

  def slot_part?(_), do: false
end
