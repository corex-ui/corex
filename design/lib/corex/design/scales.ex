defmodule Corex.Design.Scales do
  @moduledoc false

  alias Corex.Design.Tokens.Scales, as: TokenScales
  alias Corex.StyleAxes

  @dimension_axes ~w(space size text radius weight visual shape)a

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
      _ -> StyleAxes.builtin_semantics()
    end
  end

  defdelegate builtin_steps(axis), to: StyleAxes
  defdelegate builtin_step_strings(axis), to: StyleAxes
  defdelegate builtin_semantic_atoms(), to: StyleAxes
  defdelegate builtin_semantics(), to: StyleAxes
  defdelegate attr_values(axis), to: StyleAxes
  defdelegate attr_value_strings(axis), to: StyleAxes

  def builtin_visual_atoms, do: StyleAxes.builtin_steps(:visual)
  def builtin_shape_atoms, do: StyleAxes.builtin_steps(:shape)
  def builtin_size_atoms, do: StyleAxes.builtin_steps(:size)
  def builtin_text_atoms, do: StyleAxes.builtin_steps(:text)
  def builtin_radius_atoms, do: StyleAxes.builtin_steps(:radius)
  def builtin_weight_atoms, do: StyleAxes.builtin_steps(:weight)

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
    StyleAxes.builtin_step_strings(axis)
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
end
