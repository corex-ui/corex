defmodule Corex.Design.Tokens.Scales do
  @moduledoc false

  alias Corex.Design.Scales, as: ConfiguredScales

  @density_mult [xs: 1, sm: 2, md: 3, lg: 4, xl: 5]
  @size_mult [xs: 6, sm: 8, md: 10, lg: 12, xl: 14]

  @text [
    xs: 0.75,
    sm: 0.875,
    md: 1.0,
    lg: 1.125,
    xl: 1.25,
    "2xl": 1.5,
    "3xl": 1.875,
    "4xl": 2.25,
    "5xl": 3.0,
    "6xl": 3.75,
    "7xl": 4.5,
    "8xl": 6.0,
    "9xl": 8.0
  ]

  @text_leading [
    xs: "calc(1 / 0.75)",
    sm: "calc(1.25 / 0.875)",
    md: "calc(1.5 / 1)",
    lg: "calc(1.75 / 1.125)",
    xl: "calc(1.75 / 1.25)",
    "2xl": "calc(2 / 1.5)",
    "3xl": "calc(2.25 / 1.875)",
    "4xl": "calc(2.5 / 2.25)",
    "5xl": "1",
    "6xl": "1",
    "7xl": "1",
    "8xl": "1",
    "9xl": "1"
  ]

  @leading [
    xs: 1.3333,
    sm: 1.4286,
    md: 1.5,
    lg: 1.5556,
    xl: 1.4,
    "2xl": 1.3333,
    "3xl": 1.2,
    "4xl": 1.1111,
    "5xl": 1.0,
    "6xl": 1.0,
    "7xl": 1.0,
    "8xl": 1.0,
    "9xl": 1.0,
    tight: 1.25,
    snug: 1.375,
    normal: 1.5,
    relaxed: 1.625,
    loose: 2.0
  ]

  @tracking [
    tighter: "-0.05em",
    tight: "-0.025em",
    normal: "0em",
    wide: "0.025em",
    wider: "0.05em",
    widest: "0.1em"
  ]

  @radius [
    none: :zero,
    xs: 0.125,
    sm: 0.25,
    md: 0.375,
    lg: 0.5,
    xl: 0.75,
    "2xl": 1.0,
    "3xl": 1.5,
    "4xl": 2.0,
    full: :full
  ]

  @weight [
    thin: 100,
    extralight: 200,
    light: 300,
    normal: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
    extrabold: 800,
    black: 900
  ]

  @font_steps ~W(sans serif mono code display)a

  @font [
    sans: [
      "ui-sans-serif",
      "system-ui",
      "sans-serif",
      "Apple Color Emoji",
      "Segoe UI Emoji",
      "Segoe UI Symbol",
      "Noto Color Emoji"
    ],
    serif: ["ui-serif", "Georgia", "Cambria", "Times New Roman", "Times", "serif"],
    mono: [
      "ui-monospace",
      "SFMono-Regular",
      "Menlo",
      "Monaco",
      "Consolas",
      "Liberation Mono",
      "Courier New",
      "monospace"
    ],
    code: [
      "ui-monospace",
      "SFMono-Regular",
      "Menlo",
      "Monaco",
      "Consolas",
      "Liberation Mono",
      "Courier New",
      "monospace"
    ],
    display: [
      "ui-sans-serif",
      "system-ui",
      "sans-serif",
      "Apple Color Emoji",
      "Segoe UI Emoji",
      "Segoe UI Symbol",
      "Noto Color Emoji"
    ]
  ]

  @container [
    "9xs": 4.0,
    "8xs": 5.0,
    "7xs": 6.0,
    "6xs": 8.0,
    "5xs": 10.0,
    "4xs": 12.0,
    "3xs": 16.0,
    "2xs": 18.0,
    xs: 20.0,
    sm: 24.0,
    md: 28.0,
    lg: 32.0,
    xl: 36.0,
    "2xl": 42.0,
    "3xl": 48.0,
    "4xl": 56.0,
    "5xl": 64.0,
    "6xl": 72.0,
    "7xl": 80.0,
    "8xl": 88.0,
    "9xl": 96.0
  ]

  @shadow [
    "2xs": "0 1px var(--color-shadow)",
    xs: "0 1px 2px 0 var(--color-shadow)",
    sm: "0 1px 3px 0 var(--color-shadow), 0 1px 2px -1px var(--color-shadow)",
    md: "0 4px 6px -1px var(--color-shadow), 0 2px 4px -2px var(--color-shadow)",
    lg: "0 10px 15px -3px var(--color-shadow), 0 4px 6px -4px var(--color-shadow)",
    xl: "0 20px 25px -5px var(--color-shadow), 0 8px 10px -6px var(--color-shadow)",
    "2xl": "0 25px 50px -12px var(--color-shadow)",
    ui: "0 10px 15px -3px var(--color-shadow), 0 4px 6px -4px var(--color-shadow)",
    surface: "0 1px 1px 0 var(--color-shadow), 0 1px 1px 0 var(--color-shadow)"
  ]

  @inset_shadow [
    "2xs": "inset 0 1px var(--color-shadow)",
    xs: "inset 0 1px 1px var(--color-shadow)",
    sm: "inset 0 2px 4px var(--color-shadow)"
  ]

  @drop_shadow [
    xs: "0 1px 1px var(--color-shadow)",
    sm: "0 1px 2px var(--color-shadow)",
    md: "0 3px 3px var(--color-shadow)",
    lg: "0 4px 4px var(--color-shadow)",
    xl: "0 9px 7px var(--color-shadow)",
    "2xl": "0 25px 25px var(--color-shadow)"
  ]

  @text_shadow [
    "2xs": "0px 1px 0px var(--color-shadow)",
    xs: "0px 1px 1px var(--color-shadow)",
    sm:
      "0px 1px 0px var(--color-shadow), 0px 1px 1px var(--color-shadow), 0px 2px 2px var(--color-shadow)",
    md:
      "0px 1px 1px var(--color-shadow), 0px 1px 2px var(--color-shadow), 0px 2px 4px var(--color-shadow)",
    lg:
      "0px 1px 2px var(--color-shadow), 0px 3px 2px var(--color-shadow), 0px 4px 8px var(--color-shadow)"
  ]

  @blur [
    xs: "4px",
    sm: "8px",
    md: "12px",
    lg: "16px",
    xl: "24px",
    "2xl": "40px",
    "3xl": "64px"
  ]

  def builtin_density_mult, do: @density_mult
  def builtin_size_mult, do: @size_mult
  def builtin_text, do: @text
  def builtin_radius, do: @radius

  @doc """
  The built-in radius step names, without consulting the configured scale.

  Theme normalization needs the allowlist before the configured scales are
  resolved: reading `radius_steps/0` there would re-enter the scale resolution
  that theme specs are an input to.
  """
  def builtin_radius_steps, do: Keyword.keys(@radius)
  def builtin_weight, do: @weight

  def density_mult, do: configured_or_default(:density, @density_mult)
  def size_mult, do: configured_or_default(:size, @size_mult)
  def text, do: configured_or_default(:text, @text)
  def radius, do: configured_or_default(:radius, @radius)
  def weight, do: configured_or_default(:weight, @weight)

  def text_leading, do: @text_leading
  def leading, do: @leading
  def tracking, do: @tracking

  def container, do: @container

  def font, do: @font

  @doc """
  Every font step a theme may define a stack for.

  Wider than `font/0`, which carries only the steps that have a built-in stack:
  `:display` has no default and exists only when a theme names it.
  """
  def font_steps, do: @font_steps
  def shadow, do: @shadow
  def inset_shadow, do: @inset_shadow
  def drop_shadow, do: @drop_shadow
  def text_shadow, do: @text_shadow
  def blur, do: @blur

  defp configured_or_default(axis, default) do
    values = ConfiguredScales.dimension_values(axis)

    if map_size(values) > 0 do
      in_ladder_order(values, Keyword.keys(default))
    else
      default
    end
  end

  @doc """
  Orders a step map by `ladder`, with steps outside it sorted by name after.

  Configured scales arrive as maps, and iterating one follows the atom table
  rather than the ladder, so emitted token files would reorder whenever an
  unrelated module interned a new atom.
  """
  def in_ladder_order(values, ladder) when is_map(values) and is_list(ladder) do
    ordered = for step <- ladder, Map.has_key?(values, step), do: {step, Map.fetch!(values, step)}

    extra =
      values
      |> Map.drop(ladder)
      |> Enum.sort_by(fn {step, _value} -> to_string(step) end)

    ordered ++ extra
  end

  @doc "Formats a number as a `rem` length with trailing zeros trimmed."
  def rem_value(value) when is_number(value), do: trim(value) <> "rem"

  @doc "Formats a number with trailing zeros trimmed (no unit)."
  def num(value) when is_number(value), do: trim(value)
  def num(value) when is_binary(value), do: value

  @doc "Joins a font stack, quoting members that contain spaces."
  def font_stack(members) do
    Enum.map_join(members, ", ", fn name ->
      if String.contains?(name, " "), do: "'#{name}'", else: name
    end)
  end

  @doc """
  Scales shadow templates by parsing each layer into lengths + color, then
  multiplying lengths. Accepts the authored string form or a list of layer maps.
  """
  def scale_shadow_template(template, scale) when is_binary(template) and scale == 1.0,
    do: template

  def scale_shadow_template(template, scale) when is_binary(template) and is_number(scale) do
    template
    |> shadow_layers()
    |> Enum.map_join(", ", &format_shadow_layer(&1, scale))
  end

  def scale_shadow_template(layers, scale) when is_list(layers) and is_number(scale) do
    Enum.map_join(layers, ", ", &format_shadow_layer(&1, scale))
  end

  defp shadow_layers(template) when is_binary(template) do
    template
    |> String.split(",")
    |> Enum.map(&parse_shadow_layer/1)
  end

  defp parse_shadow_layer(layer) do
    trimmed = String.trim(layer)
    inset? = String.starts_with?(trimmed, "inset ")
    body = if inset?, do: String.trim_leading(trimmed, "inset "), else: trimmed

    {lengths, color} =
      case Regex.run(~r/^(.*?)\s+(var\(--[\w-]+\)|#[0-9A-Fa-f]{3,8}|[a-zA-Z]+)$/, body) do
        [_, nums, color] -> {nums, color}
        _ -> {body, "var(--color-shadow)"}
      end

    numbers =
      Regex.scan(~r/-?\d+(?:\.\d+)?/, lengths)
      |> Enum.map(fn [n] -> parse_shadow_num(n) end)

    %{inset: inset?, lengths: numbers, color: color}
  end

  defp format_shadow_layer(%{inset: inset?, lengths: lengths, color: color}, scale) do
    scaled = Enum.map_join(lengths, " ", fn n -> format_px(n * scale) end)
    prefix = if inset?, do: "inset ", else: ""
    "#{prefix}#{scaled} #{color}"
  end

  defp format_px(n) when n == 0, do: "0px"
  defp format_px(n) when is_number(n), do: "#{num(n)}px"

  defp parse_shadow_num(num) when is_binary(num) do
    case Float.parse(num) do
      {f, _} -> f
      :error -> String.to_integer(num) * 1.0
    end
  end

  defp trim(value) do
    (value * 1.0)
    |> Float.round(4)
    |> :erlang.float_to_binary(decimals: 4)
    |> String.replace(~r/\.?0+$/, "")
  end
end
