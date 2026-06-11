defmodule Corex.Design.Axes do
  @moduledoc """
  Design-side axis vocabulary from built-in Corex scale step names.
  """

  alias Corex.Design.Scales, as: ConfiguredScales
  alias Corex.Design.Vocabulary

  def colors, do: semantic_strings()
  def color_atoms, do: semantic_atoms()
  def semantic_strings, do: Enum.map(semantic_atoms(), &Atom.to_string/1)

  def semantic_atoms do
    case Vocabulary.semantic_roles() do
      [] -> ConfiguredScales.builtin_semantic_atoms()
      roles -> roles
    end
  end

  def sizes, do: Enum.map(size_atoms(), &Atom.to_string/1)
  def size_atoms, do: ConfiguredScales.builtin_size_atoms()

  def texts, do: Enum.map(text_atoms(), &Atom.to_string/1)
  def text_atoms, do: ConfiguredScales.builtin_text_atoms()

  def visuals, do: Enum.map(visual_atoms(), &Atom.to_string/1)
  def visual_atoms, do: ConfiguredScales.builtin_visual_atoms()

  def radii, do: Enum.map(radius_atoms(), &Atom.to_string/1)
  def radius_atoms, do: ConfiguredScales.builtin_radius_atoms()

  def weights, do: Enum.map(weight_atoms(), &Atom.to_string/1)
  def weight_atoms, do: ConfiguredScales.builtin_weight_atoms()

  def shapes, do: Enum.map(shape_atoms(), &Atom.to_string/1)
  def shape_atoms, do: ConfiguredScales.builtin_shape_atoms()
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
