defmodule Corex.Design.Color do
  @moduledoc false

  @doc false
  def at_l(seed_hex, lightness)
      when is_binary(seed_hex) and is_number(lightness) do
    l = normalize_l!(lightness)

    with {:ok, oklch} <- Color.convert(seed_hex, Color.Oklch),
         mapped = %{oklch | l: l},
         {:ok, srgb} <- Color.Gamut.to_gamut(mapped, :SRGB) do
      Color.to_hex(srgb)
    else
      {:error, reason} ->
        raise ArgumentError, "cannot resolve lightness #{l} for #{seed_hex}: #{inspect(reason)}"
    end
  end

  @doc false
  def against(seed_hex, bg_hex, target)
      when is_binary(seed_hex) and is_binary(bg_hex) and is_number(target) do
    ratio = target * 1.0
    palette = Color.Palette.contrast(seed_hex, background: bg_hex, targets: [ratio])

    case palette.stops do
      [%{color: %Color.SRGB{} = color, achieved: achieved}] ->
        {Color.to_hex(color), achieved}

      [%{color: :unreachable}] ->
        raise ArgumentError,
              "contrast target #{ratio}:1 unreachable for seed #{seed_hex} on #{bg_hex}"

      other ->
        raise ArgumentError,
              "unexpected contrast result for #{seed_hex} on #{bg_hex}: #{inspect(other)}"
    end
  end

  @doc false
  def against_or_pick(seed_hex, bg_hex, target)
      when is_binary(seed_hex) and is_binary(bg_hex) and is_number(target) do
    case against_result(seed_hex, bg_hex, target) do
      {:ok, result} ->
        result

      :unreachable ->
        case Color.Contrast.pick_contrasting(bg_hex, ["#FFFFFF", "#000000"]) do
          {:ok, color} ->
            hex = Color.to_hex(color)
            {hex, Color.Contrast.wcag_ratio(hex, bg_hex)}

          other ->
            raise ArgumentError, "pick_contrasting failed for #{bg_hex}: #{inspect(other)}"
        end
    end
  end

  # credo:disable-for-next-line ExSlop.Check.Warning.RescueWithoutReraise
  defp against_result(seed_hex, bg_hex, target) do
    {:ok, against(seed_hex, bg_hex, target)}
  rescue
    ArgumentError -> :unreachable
  end

  @doc false
  def normalize_l!(value) when is_integer(value) and value >= 0 and value <= 100 do
    value / 100.0
  end

  def normalize_l!(value) when is_float(value) and value >= 0.0 and value <= 1.0, do: value

  def normalize_l!(value) when is_integer(value) and value >= 0 and value <= 1 do
    value * 1.0
  end

  def normalize_l!(value) do
    raise ArgumentError,
          "invalid lightness #{inspect(value)} (expected 0.0..1.0 or integer 0..100)"
  end

  @doc false
  def state_names, do: ~w(muted default hover active)
end
