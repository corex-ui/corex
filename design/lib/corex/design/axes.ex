defmodule Corex.Design.Axes do
  @moduledoc """
  Design-side axis vocabulary: `Corex.Scales` defaults merged with optional
  `:corex_design` `:scales` overrides, plus semantic roles from themes.
  """

  alias Corex.Design.Tokens.Scales, as: TokenScales
  alias Corex.Design.Vocabulary
  alias Corex.Scales, as: CoreScales

  def colors, do: semantic_strings()
  def color_atoms, do: semantic_atoms()
  def semantic_strings, do: Enum.map(semantic_atoms(), &Atom.to_string/1)

  def semantic_atoms do
    case Vocabulary.semantic_roles() do
      [] -> CoreScales.semantic_atoms()
      roles -> roles
    end
  end

  def sizes, do: Enum.map(size_atoms(), &Atom.to_string/1)
  def size_atoms, do: axis_atoms(:size, &CoreScales.size_atoms/0)

  def texts, do: Enum.map(text_atoms(), &Atom.to_string/1)
  def text_atoms, do: axis_atoms(:text, &CoreScales.text_atoms/0)

  def visuals, do: Enum.map(visual_atoms(), &Atom.to_string/1)
  def visual_atoms, do: axis_atoms(:visual, &CoreScales.visual_atoms/0)

  def radii, do: Enum.map(radius_atoms(), &Atom.to_string/1)
  def radius_atoms, do: axis_atoms(:radius, &CoreScales.radius_atoms/0)

  def weights, do: Enum.map(weight_atoms(), &Atom.to_string/1)
  def weight_atoms, do: axis_atoms(:weight, &CoreScales.weight_atoms/0)

  def shapes, do: Enum.map(shape_atoms(), &Atom.to_string/1)
  def shape_atoms, do: axis_atoms(:shape, &CoreScales.shape_atoms/0)

  defp axis_atoms(axis, default_fun) do
    case TokenScales.overrides() |> Keyword.get(axis) do
      nil -> default_fun.()
      steps -> Enum.map(steps, &normalize_step/1)
    end
  end

  defp normalize_step(step) when is_atom(step), do: step
  defp normalize_step(step) when is_binary(step), do: String.to_atom(step)
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
