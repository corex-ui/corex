defmodule Corex.Design.Tokens.PaletteGen do
  @moduledoc false

  @tonal_stops [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950]
  @state_names ~w(muted default hover active)

  def tonal_stops, do: @tonal_stops
  def state_names, do: @state_names

  def tonal_scale(seed_hex) when is_binary(seed_hex) do
    Color.Palette.tonal(seed_hex)
  end

  def tonal_stop(seed_hex, stop) when is_binary(seed_hex) do
    stop = normalize_stop!(stop)

    seed_hex
    |> tonal_scale()
    |> then(fn palette -> Map.fetch!(palette.stops, stop) end)
    |> Color.to_hex()
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

  def normalize_stop!(stop) when is_integer(stop) do
    if stop in @tonal_stops do
      stop
    else
      raise ArgumentError,
            "invalid tonal stop #{inspect(stop)} (expected one of #{inspect(@tonal_stops)})"
    end
  end

  def normalize_stop!(stop) when is_binary(stop) do
    stop |> String.to_integer() |> normalize_stop!()
  end
end
