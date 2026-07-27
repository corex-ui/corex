defmodule Corex.Design.Theme.Presets.Shared do
  @moduledoc false

  alias Corex.Design.Color, as: DesignColor
  alias Corex.Design.Filter

  @dimension_scale_keys ~w(
    space_scale size_scale text_scale radius_scale container_scale shadow_scale blur_scale
    ring_width ring_offset border_width duration_fast duration_normal duration_slow
    opacity_disabled opacity_backdrop
  )a

  @radius_steps ~w(xs sm md lg xl 2xl 3xl 4xl full)a

  @font_roles ~w(sans display mono code serif)a

  def l(lightness, opts \\ []) when is_number(lightness) and is_list(opts) do
    seed = Keyword.get(opts, :seed, :neutral)
    states = Keyword.get(opts, :states)

    base = %{
      kind: :l,
      seed: seed,
      l: DesignColor.normalize_l!(lightness)
    }

    if is_map(states) do
      Map.put(base, :states, normalize_states(states, lightness))
    else
      Map.put(base, :states, %{})
    end
  end

  def contrast(opts) when is_list(opts) do
    %{
      kind: :contrast,
      seed: Keyword.fetch!(opts, :seed),
      against: Keyword.fetch!(opts, :against),
      target: Keyword.fetch!(opts, :target) * 1.0
    }
  end

  def fill(lightness, opts \\ []) when is_number(lightness) do
    delta = Keyword.get(opts, :delta, 0.03)
    seed = Keyword.get(opts, :seed, :neutral)
    muted = clamp_l(lightness + delta)
    hover = clamp_l(lightness - delta - 0.01)
    active = clamp_l(lightness - delta - 0.04)

    l(lightness,
      seed: seed,
      states: %{
        muted: muted,
        default: lightness,
        hover: hover,
        active: active
      }
    )
  end

  def mode(tokens) when is_map(tokens) do
    tokens
    |> stringify_keys()
    |> maybe_put_role_contrast()
    |> maybe_put_role_text()
  end

  def dimensions(scales, radius, fonts)
      when is_map(scales) and is_map(radius) and is_map(fonts) do
    scales
    |> Map.take(@dimension_scale_keys)
    |> Map.put(:radius, Map.take(radius, @radius_steps))
    |> Map.put(:font, Map.take(fonts, @font_roles))
  end

  def font_stack(families) when is_map(families) do
    Map.take(families, @font_roles)
  end

  defp stringify_keys(tokens) do
    Map.new(tokens, fn {k, v} -> {to_string(k), v} end)
  end

  defp maybe_put_role_contrast(tokens) do
    Enum.reduce(Filter.default_semantics(), tokens, fn role, acc ->
      role_s = Atom.to_string(role)
      key = "#{role_s}-contrast"

      if Map.has_key?(acc, role_s) and not Map.has_key?(acc, key) do
        Map.put(acc, key, contrast(seed: :neutral, against: role, target: 7.0))
      else
        acc
      end
    end)
  end

  defp maybe_put_role_text(tokens) do
    Enum.reduce(Filter.default_semantics(), tokens, fn role, acc ->
      role_s = Atom.to_string(role)
      key = "#{role_s}-text"

      if Map.has_key?(acc, role_s) and not Map.has_key?(acc, key) do
        Map.put(acc, key, contrast(seed: role, against: :ui, target: 4.6))
      else
        acc
      end
    end)
  end

  defp normalize_states(states, default_l) do
    states
    |> Map.put_new(:default, default_l)
    |> Map.new(fn {k, v} -> {k, DesignColor.normalize_l!(v)} end)
  end

  defp clamp_l(value) when is_number(value) do
    value |> max(0.0) |> min(1.0)
  end
end
