defmodule Corex.Design.Scales do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales, as: TokenScales
  alias Corex.Design.Vocabulary

  @master_ladder ~w(9xs 8xs 7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl)a

  @tailwind_container ~w(3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl)a
  @tailwind_radius ~w(xs sm md lg xl 2xl 3xl 4xl)a
  @tailwind_text ~w(xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl)a
  @tailwind_size_special ~w(none full)a
  @tailwind_height_special ~w(none full screen dvh)a

  @builtin_steps [
    density: ~w(xs sm md lg xl)a,
    size: ~w(xs sm md lg xl)a,
    text: ~w(xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl)a,
    radius: ~w(none xs sm md lg xl 2xl 3xl 4xl full)a,
    weight: ~w(thin extralight light normal medium semibold bold extrabold black)a,
    container: @master_ladder,
    sizing: ~w(auto fit full)a,
    surface: ~w(none page raised)a,
    shadow: ~w(none sm md lg)a,
    align: ~w(start center end stretch baseline)a,
    justify: ~w(start center end between around evenly)a,
    direction: ~w(row column)a,
    wrap: ~w(wrap nowrap)a,
    grow: ~w(none fill)a,
    shrink: ~w(none 0)a,
    columns: ~w(1 2 3 4 5 6)a,
    orientation: ~w(horizontal vertical)a,
    overflow: ~w(visible hidden auto scroll)a
  ]

  @builtin_semantics ~w(base accent brand alert info success)a
  @dimension_axes ~w(density size text radius weight)a
  @scale_axis_aliases %{space: :density}

  @attr_axis_map %{
    padding: :density,
    gap: :density
  }

  @display_steps ~w(flex none)a
  @no_attr_values ~w(variant)a

  def master_ladder, do: @master_ladder

  def master_ladder_strings, do: Enum.map(@master_ladder, &Atom.to_string/1)

  def tailwind_container, do: @tailwind_container

  def tailwind_container_strings, do: Enum.map(@tailwind_container, &Atom.to_string/1)

  def tailwind_radius_strings, do: Enum.map(@tailwind_radius, &Atom.to_string/1)

  def tailwind_text_strings, do: Enum.map(@tailwind_text, &Atom.to_string/1)

  def tailwind_height_special_strings, do: Enum.map(@tailwind_height_special, &Atom.to_string/1)

  def dimension_axes, do: @dimension_axes

  def dimension_values(axis) when axis in @dimension_axes do
    case configured_axis(axis) do
      %{values: values} when map_size(values) > 0 -> values
      _ -> default_values(axis)
    end
  end

  def dimension_steps(axis) when axis in @dimension_axes do
    default_steps(axis)
  end

  def semantic_steps do
    case configured_axis(:semantic) do
      %{steps: steps} when steps != [] -> steps
      _ -> Enum.map(semantic_atoms(), &Atom.to_string/1)
    end
  end

  def semantic_atoms do
    case configured_axis(:semantic) do
      %{steps: steps} when steps != [] -> Enum.map(steps, &normalize_step_atom/1)
      _ -> theme_semantic_atoms()
    end
  end

  def semantic_strings, do: Enum.map(semantic_atoms(), &Atom.to_string/1)

  def steps(axis) when is_atom(axis) do
    axis
    |> step_atoms()
    |> Enum.map(&Atom.to_string/1)
  end

  def step_atoms(axis) when axis in @dimension_axes, do: builtin_steps(axis)
  def step_atoms(:semantic), do: semantic_atoms()
  def step_atoms(:container), do: builtin_steps(:container)
  def step_atoms(:sizing), do: builtin_steps(:sizing)

  def step_atoms(axis) do
    builtin_steps(axis)
  rescue
    ArgumentError -> []
  end

  def builtin_steps(axis) when is_atom(axis) do
    case Keyword.fetch(@builtin_steps, axis) do
      {:ok, steps} -> steps
      :error -> derived_builtin_steps(axis)
    end
  end

  def builtin_step_strings(axis) when is_atom(axis) do
    axis
    |> builtin_steps()
    |> Enum.map(&Atom.to_string/1)
  end

  def default_semantic_atoms, do: @builtin_semantics

  def default_semantics, do: Enum.map(@builtin_semantics, &Atom.to_string/1)

  def builtin_semantic_atoms, do: default_semantic_atoms()
  def builtin_semantics, do: default_semantics()

  def attr_values(axis) do
    case attr_value_strings(axis) do
      nil -> nil
      strings -> [nil | strings]
    end
  end

  def attr_value_strings(axis) when axis in @no_attr_values, do: nil
  def attr_value_strings(:semantic), do: semantic_strings()
  def attr_value_strings(:surface), do: builtin_step_strings(:surface)
  def attr_value_strings(:shadow), do: builtin_step_strings(:shadow)
  def attr_value_strings(:display), do: Enum.map(@display_steps, &Atom.to_string/1)
  def attr_value_strings(:container), do: builtin_step_strings(:container)
  def attr_value_strings(:gap), do: density_layout_attr_value_strings()
  def attr_value_strings(:padding), do: density_layout_attr_value_strings()

  def attr_value_strings(axis) do
    axis
    |> attr_scale_axis()
    |> builtin_step_strings()
  rescue
    ArgumentError -> nil
  end

  def density_layout_attr_value_strings do
    ["none" | builtin_step_strings(:density)]
  end

  def export do
    %{
      semantic: semantic_strings(),
      master_ladder: master_ladder_strings(),
      dimensions:
        Map.new(@dimension_axes, fn axis ->
          {axis, %{steps: steps(axis), values: export_values(axis)}}
        end),
      container: %{steps: steps(:container)},
      sizing: %{steps: steps(:sizing)},
      themes: Theme.theme_ids(),
      default_theme: Theme.default_theme()
    }
  end

  def json, do: Jason.encode!(export(), pretty: true)

  defp configured_axis(axis) do
    parse_axis(axis, scales_input(), semantics_input())
  end

  defp semantics_input do
    Corex.Design.design_config()
    |> Map.get(:semantics)
    |> case do
      nil -> nil
      list when is_list(list) -> list
      _ -> nil
    end
  end

  defp scales_input do
    Corex.Design.Config.resolved_options()
    |> Keyword.get(:scales, [])
    |> normalize_entries()
    |> Enum.map(fn {axis, spec} -> {normalize_scale_axis(axis), spec} end)
  end

  defp parse_axis(axis, entries, semantics) do
    spec = Keyword.get(entries, normalize_scale_axis(axis))

    cond do
      axis == :semantic and is_list(semantics) and semantics != [] ->
        %{steps: Enum.map(semantics, &normalize_step/1), values: %{}}

      is_nil(spec) ->
        if axis == :semantic do
          %{steps: [], values: %{}}
        else
          %{steps: default_steps(axis), values: default_values(axis)}
        end

      axis == :semantic ->
        %{steps: Enum.map(spec, &normalize_step/1), values: %{}}

      keyword_with_values?(spec) ->
        overrides =
          spec
          |> Map.new(fn {step, value} -> {normalize_step(step), value} end)

        defaults = default_values(axis)

        %{
          steps: default_steps(axis),
          values: Map.merge(defaults, overrides)
        }

      true ->
        %{steps: default_steps(axis), values: default_values(axis)}
    end
  end

  defp normalize_entries(list) when is_list(list), do: list
  defp normalize_entries(map) when is_map(map), do: Map.to_list(map)
  defp normalize_entries(_), do: []

  defp default_steps(axis) do
    builtin_step_strings(axis)
  end

  defp default_values(axis) do
    table =
      case axis do
        :density -> TokenScales.builtin_density_mult()
        :size -> TokenScales.builtin_size_mult()
        :text -> TokenScales.builtin_text()
        :radius -> TokenScales.builtin_radius()
        :weight -> TokenScales.builtin_weight()
      end

    Map.new(table)
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

  defp theme_semantic_atoms do
    theme_roles = Vocabulary.semantic_roles()

    if theme_roles == [] do
      default_semantic_atoms()
    else
      theme_roles
    end
  end

  defp normalize_step_atom(step) when is_atom(step), do: step

  defp normalize_step_atom(step) when is_binary(step) do
    String.to_existing_atom(step)
  rescue
    ArgumentError -> String.to_atom(step)
  end

  defp normalize_scale_axis(axis) do
    Map.get(@scale_axis_aliases, axis, axis)
  end

  defp attr_scale_axis(axis), do: Map.get(@attr_axis_map, axis, axis)

  defp derived_builtin_steps(:semantic), do: default_semantic_atoms()

  @width_special ~w(auto full fit)a

  defp derived_builtin_steps(:max_width),
    do: @tailwind_size_special ++ @master_ladder

  defp derived_builtin_steps(:min_width),
    do: [:full | @master_ladder]

  defp derived_builtin_steps(:max_height),
    do: @tailwind_height_special ++ @master_ladder

  defp derived_builtin_steps(:min_height),
    do: [:full, :screen, :dvh | @master_ladder]

  defp derived_builtin_steps(:width),
    do: @width_special ++ @master_ladder

  defp derived_builtin_steps(:height), do: builtin_steps(:sizing)

  defp derived_builtin_steps(axis) do
    raise ArgumentError, "unknown Corex.Design.Scales axis #{inspect(axis)}"
  end

  defp export_values(axis) do
    axis
    |> dimension_values()
    |> Enum.map(fn {step, value} -> {Atom.to_string(step), normalize_export_value(value)} end)
    |> Map.new()
  end

  defp normalize_export_value(value) when is_number(value), do: value
  defp normalize_export_value(:zero), do: "zero"
  defp normalize_export_value(:full), do: "full"
  defp normalize_export_value(value) when is_atom(value), do: Atom.to_string(value)
  defp normalize_export_value(value), do: value
end
