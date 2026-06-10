defmodule Corex.Design.Tokens.PaletteGen do
  @moduledoc false

  @lightness_stops Enum.to_list(0..100)
  @state_names ~w(muted default hover active)

  def lightness_range, do: @lightness_stops
  def state_names, do: @state_names
  def new_cache, do: %{}

  def tonal_scale(seed_hex) when is_binary(seed_hex) do
    Color.Palette.tonal(seed_hex, stops: @lightness_stops)
  end

  def at_lightness(seed_hex, lightness_pct, cache \\ new_cache())
      when is_binary(seed_hex) and is_map(cache) do
    lightness_pct = normalize_lightness!(lightness_pct)
    {palette, cache} = fetch_scale(seed_hex, cache)
    {color_to_hex(pick_color_at_lightness(palette, lightness_pct)), cache}
  end

  def contrast_fg(seed_hex, bg_hex, ratio) do
    r = ratio * 1.0
    p = Color.Palette.contrast(seed_hex, background: bg_hex, targets: [r])

    case p.stops do
      [%{color: %Color.SRGB{} = c, achieved: a}] -> {Color.to_hex(c), a}
      [%{color: :unreachable}] -> {seed_hex, r}
      _ -> {seed_hex, r}
    end
  end

  def in_gamut?(seed_hex) when is_binary(seed_hex) do
    seed_hex |> tonal_scale() |> Color.Palette.in_gamut?()
  end

  def normalize_lightness!(value) when is_integer(value) do
    if value in @lightness_stops do
      value
    else
      raise ArgumentError,
            "invalid lightness #{inspect(value)} (expected integer from 0 to 100)"
    end
  end

  def normalize_lightness!(value) when is_binary(value) do
    value |> String.to_integer() |> normalize_lightness!()
  end

  defp fetch_scale(seed_hex, cache) do
    case Map.fetch(cache, seed_hex) do
      {:ok, palette} ->
        {palette, cache}

      :error ->
        palette = tonal_scale(seed_hex)
        {palette, Map.put(cache, seed_hex, palette)}
    end
  end

  defp pick_color_at_lightness(palette, lightness_pct) do
    target = lightness_pct / 100.0

    palette.stops
    |> Enum.min_by(fn {_label, color} ->
      abs(oklch_lightness(color) - target)
    end)
    |> elem(1)
  end

  defp oklch_lightness(color) do
    case Color.convert(color, Color.Oklch) do
      {:ok, okl} -> okl.l
      {:error, reason} -> raise ArgumentError, "invalid palette color: #{inspect(reason)}"
    end
  end

  defp color_to_hex(%Color.SRGB{} = color), do: Color.to_hex(color)
end
