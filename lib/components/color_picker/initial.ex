defmodule Corex.ColorPicker.Initial do
  @moduledoc false
  import Bitwise

  @doc """
  Parses a color string and returns values for SSR prerendering.
  Returns nil values when parsing fails or input is nil.
  """
  @spec parse(String.t() | nil) :: %{
          swatch_style: String.t() | nil,
          value_rgba: String.t() | nil,
          hex_value: String.t() | nil,
          alpha_value: String.t() | nil,
          red_value: String.t() | nil,
          green_value: String.t() | nil,
          blue_value: String.t() | nil
        }
  def parse(nil), do: empty(nil)

  def parse(""), do: empty(nil)

  def parse(str) when is_binary(str) do
    str = String.trim(str)
    parse_hex(str) || parse_rgba(str) || parse_rgb(str) || empty(maybe_css_color(str))
  end

  defp empty(swatch_fallback) do
    %{
      swatch_style: swatch_fallback,
      value_rgba: nil,
      hex_value: nil,
      alpha_value: nil,
      red_value: nil,
      green_value: nil,
      blue_value: nil
    }
  end

  defp maybe_css_color(<<"#", _::binary>> = s), do: s
  defp maybe_css_color(<<"rgb", _::binary>> = s), do: s
  defp maybe_css_color(<<"hsl", _::binary>> = s), do: s
  defp maybe_css_color(_), do: nil

  defp parse_hex(<<"#", rest::binary>>) do
    rest = String.downcase(rest)

    cond do
      Regex.match?(~r/^[0-9a-f]{3}$/, rest) ->
        {r, g, b} = expand_short_hex(rest)
        build(r, g, b, 1.0, "#" <> rest)

      Regex.match?(~r/^[0-9a-f]{8}$/, rest) ->
        {r, g, b, a} = parse_hex_8(rest)
        build(r, g, b, a, "#" <> rest)

      Regex.match?(~r/^[0-9a-f]{6}$/, rest) ->
        {r, g, b} = parse_hex_6(rest)
        build(r, g, b, 1.0, "#" <> rest)

      true ->
        nil
    end
  end

  defp parse_hex(_), do: nil

  defp expand_short_hex(<<r1, g1, b1>>) do
    {r, ""} = Integer.parse(<<r1>>, 16)
    {g, ""} = Integer.parse(<<g1>>, 16)
    {b, ""} = Integer.parse(<<b1>>, 16)
    {r * 17, g * 17, b * 17}
  end

  defp parse_hex_6(rest) do
    {n, ""} = Integer.parse(rest, 16)
    r = band(div(n, 65_536), 255)
    g = band(div(n, 256), 255)
    b = band(n, 255)
    {r, g, b}
  end

  defp parse_hex_8(rest) do
    {n, ""} = Integer.parse(rest, 16)
    r = band(div(n, 16_777_216), 255)
    g = band(div(n, 65_536), 255)
    b = band(div(n, 256), 255)
    a = band(n, 255)
    {r, g, b, a / 255}
  end

  defp parse_rgb(str) do
    regex = ~r/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i

    case Regex.run(regex, str) do
      [_, r, g, b] ->
        {r, g, b} = parse_ints(r, g, b)
        build(r, g, b, 1.0, str)

      _ ->
        nil
    end
  end

  defp parse_rgba(str) do
    rgba_regex = ~r/^rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)$/i
    rgb4_regex = ~r/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)$/i

    cond do
      match = Regex.run(rgba_regex, str) ->
        [_, r, g, b, a] = match
        parse_rgba_match(r, g, b, a, str)

      match = Regex.run(rgb4_regex, str) ->
        [_, r, g, b, a] = match
        parse_rgba_match(r, g, b, a, str)

      true ->
        nil
    end
  end

  defp parse_rgba_match(r, g, b, a, str) do
    {r, g, b} = parse_ints(r, g, b)
    {a, _} = Float.parse(a)
    a = max(0, min(1, a))
    build(r, g, b, a, str)
  end

  defp parse_ints(r, g, b) do
    {ri, _} = Integer.parse(r)
    {gi, _} = Integer.parse(g)
    {bi, _} = Integer.parse(b)
    ri = max(0, min(255, ri))
    gi = max(0, min(255, gi))
    bi = max(0, min(255, bi))
    {ri, gi, bi}
  end

  defp build(r, g, b, a, swatch_style) do
    hex = "#" <> to_hex(r) <> to_hex(g) <> to_hex(b)
    alpha_str = if a >= 1, do: "1", else: Float.to_string(Float.round(a * 1.0, 2))
    value_rgba = "rgba(#{r}, #{g}, #{b}, #{alpha_str})"

    %{
      swatch_style: swatch_style,
      value_rgba: value_rgba,
      hex_value: hex,
      alpha_value: alpha_str,
      red_value: to_string(r),
      green_value: to_string(g),
      blue_value: to_string(b)
    }
  end

  defp to_hex(n) when is_integer(n) do
    n
    |> max(0)
    |> min(255)
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
    |> String.upcase()
  end
end
