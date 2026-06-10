defmodule Corex.Design.Vocabulary do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales

  @style_axes ~W(semantic size text radius weight visual shape space)a

  def configured?, do: Corex.Design.configured?()

  def semantic_roles do
    Theme.resolved_themes()
    |> Map.values()
    |> Enum.flat_map(&component_roles/1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def semantic_strings, do: Enum.map(semantic_roles(), &Atom.to_string/1)

  def axis_values(axis) when axis in @style_axes do
    case axis do
      :semantic -> [nil | semantic_strings()]
      other -> [nil | scale_strings(other)]
    end
  end

  def validate!(axis, value) when is_binary(value) do
    if axis in @style_axes do
      allowed = axis_values(axis)

      if value in allowed do
        :ok
      else
        raise ArgumentError, invalid_message(axis, allowed, value)
      end
    else
      :ok
    end
  end

  def validate!(axis, value) when is_atom(value) do
    validate!(axis, Atom.to_string(value))
  end

  def warn!(axis, value) do
    if axis in @style_axes do
      allowed = axis_values(axis)

      if value in allowed do
        :ok
      else
        require Logger
        Logger.warning(invalid_message(axis, allowed, value))
      end
    else
      :ok
    end
  end

  defp component_roles(spec) do
    for mode <- Theme.modes(),
        roles = spec.colors |> Map.get(mode, %{}) |> Map.get(:roles, %{}),
        {role, cfg} <- roles,
        component?(cfg) do
      role
    end
  end

  defp component?(cfg) when is_map(cfg) do
    Map.get(cfg, :component, true) == true
  end

  defp scale_strings(:size), do: Scales.size_steps()
  defp scale_strings(:text), do: Scales.text_steps()
  defp scale_strings(:radius), do: Scales.radius_steps()
  defp scale_strings(:weight), do: Scales.weight_steps()
  defp scale_strings(:visual), do: Scales.visual_steps()
  defp scale_strings(:shape), do: Scales.shape_steps()
  defp scale_strings(:space), do: Scales.space_steps()

  defp invalid_message(axis, allowed, value) do
    shown = allowed |> Enum.reject(&is_nil/1) |> Enum.sort()

    """
    invalid value for attribute "#{axis}".
    Expected one of #{inspect(shown)},
    got: #{inspect(value)}
    """
    |> String.trim()
  end
end
