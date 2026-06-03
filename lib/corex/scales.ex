defmodule Corex.Scales do
  @moduledoc false

  @defaults [
    size: ~W(sm md lg xl)a,
    text: ~W(xs sm base lg xl 2xl 3xl 4xl)a,
    radius: ~W(none xs sm md lg xl 2xl 3xl 4xl full)a,
    weight: ~W(thin extralight light normal medium semibold bold extrabold black)a,
    container: ~W(7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl)a,
    sizing: ~W(auto fit full)a,
    visual: ~W(solid ghost outline subtle)a,
    shape: ~W(auto square circle)a,
    space: ~W(none sm md lg xl)a,
    align: ~W(start center end stretch baseline)a,
    justify: ~W(start center end between around evenly)a,
    direction: ~W(row column)a,
    wrap: ~W(wrap nowrap)a,
    grow: ~W(none fill)a,
    shrink: ~W(none 0)a,
    columns: ~W(1 2 3 4 5 6)a,
    orientation: ~W(horizontal vertical)a,
    min_height: ~W(none full screen dvh)a
  ]

  @default_semantics ~W(accent brand alert info success selected)a

  @doc false
  def all do
    overrides = Application.get_env(:corex, :scales, [])
    Keyword.merge(@defaults, overrides)
  end

  @doc false
  def steps(axis) when is_atom(axis) do
    case Keyword.fetch(all(), axis) do
      {:ok, steps} -> steps
      :error -> derived_steps(axis)
    end
  end

  @doc false
  def strings(axis) when is_atom(axis), do: Enum.map(steps(axis), &Atom.to_string/1)

  def size_atoms, do: steps(:size)
  def sizes, do: strings(:size)

  def text_atoms, do: steps(:text)
  def texts, do: strings(:text)

  def radius_atoms, do: steps(:radius)
  def radii, do: strings(:radius)

  def weight_atoms, do: steps(:weight)
  def weights, do: strings(:weight)

  def container_atoms, do: steps(:container)
  def containers, do: strings(:container)

  def sizing_atoms, do: steps(:sizing)
  def sizing, do: strings(:sizing)

  def visual_atoms, do: steps(:visual)
  def visuals, do: strings(:visual)

  def shape_atoms, do: steps(:shape)
  def shapes, do: strings(:shape)

  @doc false
  def constraint_atoms, do: [:none, :full | container_atoms()]
  def constraints, do: Enum.map(constraint_atoms(), &Atom.to_string/1)

  @doc false
  def semantic_atoms do
    Application.get_env(:corex, :semantics, @default_semantics)
    |> Enum.map(&normalize_atom/1)
  end

  def semantics, do: Enum.map(semantic_atoms(), &Atom.to_string/1)

  defp derived_steps(:semantic), do: semantic_atoms()
  defp derived_steps(:max_width), do: constraint_atoms()
  defp derived_steps(:max_height), do: constraint_atoms()
  defp derived_steps(:width), do: sizing_atoms()
  defp derived_steps(:height), do: sizing_atoms()

  defp derived_steps(axis) do
    raise ArgumentError, "unknown Corex.Scales axis #{inspect(axis)}"
  end

  defp normalize_atom(value) when is_atom(value), do: value

  defp normalize_atom(value) when is_binary(value) do
    String.to_existing_atom(value)
  rescue
    ArgumentError -> String.to_atom(value)
  end
end
