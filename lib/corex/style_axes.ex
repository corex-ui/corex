defmodule Corex.StyleAxes do
  @moduledoc false

  @builtin_steps [
    size: ~w(sm md lg xl)a,
    text: ~w(xs sm base lg xl 2xl 3xl 4xl)a,
    radius: ~w(none xs sm md lg xl 2xl 3xl 4xl full)a,
    weight: ~w(thin extralight light normal medium semibold bold extrabold black)a,
    container: ~w(7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl)a,
    sizing: ~w(auto fit full)a,
    visual: ~w(solid ghost outline subtle)a,
    shape: ~w(auto square circle)a,
    space: ~w(none sm md lg xl)a,
    align: ~w(start center end stretch baseline)a,
    justify: ~w(start center end between around evenly)a,
    direction: ~w(row column)a,
    wrap: ~w(wrap nowrap)a,
    grow: ~w(none fill)a,
    shrink: ~w(none 0)a,
    columns: ~w(1 2 3 4 5 6)a,
    orientation: ~w(horizontal vertical)a,
    min_height: ~w(none full screen dvh)a
  ]

  @builtin_semantics ~w(base accent brand alert info success)a

  @attr_axis_map %{
    padding: :space,
    padding_inline: :space,
    padding_block: :space,
    gap: :space
  }

  @no_attr_values ~w(variant)a

  @breakpoint_steps ~w(sm md lg xl 2xl)a

  @breakpoint_axes ~w(hide_from hide_below)a

  def builtin_steps(axis) when is_atom(axis) do
    case Keyword.fetch(@builtin_steps, axis) do
      {:ok, steps} -> steps
      :error -> derived_builtin_steps(axis)
    end
  end

  def builtin_step_strings(axis) when is_atom(axis),
    do: Enum.map(builtin_steps(axis), &Atom.to_string/1)

  def builtin_semantic_atoms, do: @builtin_semantics

  def builtin_semantics, do: Enum.map(@builtin_semantics, &Atom.to_string/1)

  def attr_values(axis) when is_atom(axis) do
    case attr_value_strings(axis) do
      nil -> nil
      strings -> [nil | strings]
    end
  end

  def attr_value_strings(axis) when axis in @no_attr_values, do: nil

  def attr_value_strings(:semantic), do: builtin_semantics()

  def attr_value_strings(axis) when axis in @breakpoint_axes, do: Enum.map(@breakpoint_steps, &Atom.to_string/1)

  def attr_value_strings(axis) do
    axis
    |> attr_scale_axis()
    |> builtin_step_strings()
  rescue
    ArgumentError -> nil
  end

  defp attr_scale_axis(axis), do: Map.get(@attr_axis_map, axis, axis)

  defp derived_builtin_steps(:semantic), do: @builtin_semantics

  defp derived_builtin_steps(:max_width),
    do: [:none, :full | builtin_steps(:container)]

  defp derived_builtin_steps(:max_height),
    do: [:none, :full | builtin_steps(:container)]

  defp derived_builtin_steps(:width), do: builtin_steps(:sizing)
  defp derived_builtin_steps(:height), do: builtin_steps(:sizing)

  defp derived_builtin_steps(axis) do
    raise ArgumentError, "unknown Corex.StyleAxes axis #{inspect(axis)}"
  end
end
