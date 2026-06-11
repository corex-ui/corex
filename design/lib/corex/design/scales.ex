defmodule Corex.Design.Scales do
  @moduledoc false

  alias Corex.Design.Tokens.Scales, as: TokenScales

  @dimension_axes ~w(space size text radius weight visual shape)a

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

  def dimension_values(axis) when axis in @dimension_axes do
    case configured_axis(axis) do
      %{values: values} when map_size(values) > 0 -> values
      _ -> default_values(axis)
    end
  end

  def dimension_steps(axis) when axis in @dimension_axes do
    case configured_axis(axis) do
      %{steps: steps} when steps != [] -> steps
      _ -> default_steps(axis)
    end
  end

  def semantic_steps do
    case configured_axis(:semantic) do
      %{steps: steps} when steps != [] -> steps
      _ -> builtin_semantics()
    end
  end

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

  def builtin_visual_atoms, do: builtin_steps(:visual)
  def builtin_shape_atoms, do: builtin_steps(:shape)
  def builtin_size_atoms, do: builtin_steps(:size)
  def builtin_text_atoms, do: builtin_steps(:text)
  def builtin_radius_atoms, do: builtin_steps(:radius)
  def builtin_weight_atoms, do: builtin_steps(:weight)

  defp configured_axis(axis) do
    parse_axis(axis, scales_input())
  end

  defp scales_input do
    Corex.Design.Config.resolved_options()
    |> Keyword.get(:scales, [])
  end

  defp parse_axis(axis, entries) do
    spec = Keyword.get(normalize_entries(entries), axis)

    cond do
      is_nil(spec) ->
        %{steps: default_steps(axis), values: default_values(axis)}

      axis == :semantic ->
        %{steps: Enum.map(spec, &normalize_step/1), values: %{}}

      keyword_with_values?(spec) ->
        %{
          steps: Enum.map(spec, fn {step, _} -> normalize_step(step) end),
          values: Map.new(spec)
        }

      true ->
        steps = Enum.map(spec, &normalize_step/1)
        %{steps: steps, values: pick_defaults(axis, steps)}
    end
  end

  defp normalize_entries(list) when is_list(list), do: list
  defp normalize_entries(map) when is_map(map), do: Map.to_list(map)
  defp normalize_entries(_), do: []

  defp default_steps(axis) do
    builtin_steps(axis) |> Enum.map(&Atom.to_string/1)
  end

  defp default_values(axis) do
    table =
      case axis do
        :space -> TokenScales.builtin_space_mult()
        :size -> TokenScales.builtin_size_mult()
        :text -> TokenScales.builtin_text()
        :radius -> TokenScales.builtin_radius()
        :weight -> TokenScales.builtin_weight()
        :visual -> Enum.map(builtin_visual_atoms(), &{&1, &1})
        :shape -> Enum.map(builtin_shape_atoms(), &{&1, &1})
      end

    Map.new(table)
  end

  defp pick_defaults(axis, steps) do
    defaults = default_values(axis)

    steps
    |> Enum.map(fn step ->
      key =
        try do
          String.to_existing_atom(step)
        rescue
          ArgumentError -> String.to_atom(step)
        end

      {key, Map.fetch!(defaults, key)}
    end)
    |> Map.new()
  end

  defp keyword_with_values?(list) do
    Keyword.keyword?(list) and
      Enum.all?(list, fn
        {_step, value} when is_number(value) -> true
        {_step, :zero} -> true
        {_step, :full} -> true
        _ -> false
      end)
  end

  defp normalize_step(step) when is_atom(step), do: Atom.to_string(step)
  defp normalize_step(step) when is_binary(step), do: step

  defp derived_builtin_steps(:semantic), do: @builtin_semantics

  defp derived_builtin_steps(:max_width),
    do: [:none, :full | builtin_steps(:container)]

  defp derived_builtin_steps(:max_height),
    do: [:none, :full | builtin_steps(:container)]

  defp derived_builtin_steps(:width), do: builtin_steps(:sizing)
  defp derived_builtin_steps(:height), do: builtin_steps(:sizing)

  defp derived_builtin_steps(axis) do
    raise ArgumentError, "unknown Corex.Design.Scales axis #{inspect(axis)}"
  end
end
