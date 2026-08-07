defmodule Corex.Design.Scales do
  @moduledoc false

  alias Corex.Design.Filter
  alias Corex.Design.Tokens.Scales, as: TokenScales

  @master_ladder ~w(9xs 8xs 7xs 6xs 5xs 4xs 3xs 2xs xs sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl)a

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

  @dimension_axes ~w(density size text radius weight)a
  @scale_axis_aliases %{space: :density}

  def master_ladder_strings, do: Enum.map(@master_ladder, &Atom.to_string/1)

  @doc """
  Every axis name a `config :corex_design, scales:` entry may use, including the
  `:space` alias for `:density`.
  """
  def config_axes do
    Keyword.keys(@builtin_steps) ++ Map.keys(@scale_axis_aliases)
  end

  @doc """
  Resolves a config axis name to its atom, returning `:error` for an unknown one.

  A string axis name reaches this from a serialized config, where interning it
  would hide the typo behind an axis that has no steps.
  """
  def config_axis(axis) when is_atom(axis) do
    if axis in config_axes(), do: {:ok, normalize_scale_axis(axis)}, else: :error
  end

  def config_axis(axis) when is_binary(axis) do
    case Enum.find(config_axes(), &(Atom.to_string(&1) == axis)) do
      nil -> :error
      found -> {:ok, normalize_scale_axis(found)}
    end
  end

  def dimension_values(axis) when axis in @dimension_axes do
    case configured_axis(axis) do
      %{values: values} when map_size(values) > 0 -> values
      _ -> default_values(axis)
    end
  end

  def semantic_steps do
    Enum.map(semantic_atoms(), &Atom.to_string/1)
  end

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

  def builtin_step_strings(axis) when is_atom(axis) do
    axis
    |> builtin_steps()
    |> Enum.map(&Atom.to_string/1)
  end

  defp builtin_steps(axis) when is_atom(axis) do
    case Keyword.fetch(@builtin_steps, axis) do
      {:ok, steps} -> steps
      :error -> derived_builtin_steps(axis)
    end
  end

  defp semantic_atoms do
    theme_roles = Filter.theme_semantic_roles()

    if theme_roles == [] do
      Filter.default_semantics()
    else
      theme_roles
    end
  end

  defp default_semantic_atoms, do: Filter.default_semantics()

  defp configured_axis(axis) do
    parse_axis(axis, scales_input())
  end

  defp scales_input do
    Enum.map(Corex.Design.Config.resolved().scales, fn {axis, spec} ->
      {normalize_scale_axis(axis), spec}
    end)
  end

  defp parse_axis(axis, entries) do
    axis
    |> defaults_for()
    |> merge_step_overrides(Keyword.get(entries, normalize_scale_axis(axis)), axis)
  end

  defp defaults_for(axis), do: %{steps: default_steps(axis), values: default_values(axis)}

  defp merge_step_overrides(scale, spec, axis) when is_list(spec) do
    if keyword_with_values?(spec) do
      %{scale | values: Map.merge(default_values(axis), step_overrides(spec))}
    else
      scale
    end
  end

  defp merge_step_overrides(scale, _spec, _axis), do: scale

  defp step_overrides(spec) do
    Map.new(spec, fn {step, value} -> {normalize_step(step), value} end)
  end

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

  defp normalize_scale_axis(axis) do
    Map.get(@scale_axis_aliases, axis, axis)
  end

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
end
