defmodule Corex.Design.Tokens.Scales do
  @moduledoc false

  @space_mult [sm: 2, md: 3, lg: 4, xl: 5]
  @size_mult [sm: 8, md: 10, lg: 12, xl: 14]

  @text [
    xs: 0.75,
    sm: 0.875,
    base: 1.0,
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
    base: "calc(1.5 / 1)",
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
    base: 1.5,
    lg: 1.5556,
    xl: 1.4,
    "2xl": 1.3333,
    "3xl": 1.2,
    "4xl": 1.1111,
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
    "7xl": 80.0
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
    layer: "0 1px 1px 0 var(--color-shadow), 0 1px 1px 0 var(--color-shadow)"
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

  @perspective [
    dramatic: "100px",
    near: "300px",
    normal: "500px",
    midrange: "800px",
    distant: "1200px"
  ]

  @aspect [video: "16 / 9"]

  @ease [
    {:in, "cubic-bezier(0.4, 0, 1, 1)"},
    {:out, "cubic-bezier(0, 0, 0.2, 1)"},
    {:"in-out", "cubic-bezier(0.4, 0, 0.2, 1)"}
  ]

  @animate [
    spin: "spin 1s linear infinite",
    ping: "ping 1s cubic-bezier(0, 0, 0.2, 1) infinite",
    pulse: "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite",
    bounce: "bounce 1s infinite"
  ]

  @breakpoint [
    sm: "40rem",
    md: "48rem",
    lg: "64rem",
    xl: "80rem",
    "2xl": "96rem"
  ]

  @keyframes """
  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }

  @keyframes ping {
    75%,
    100% {
      transform: scale(2);
      opacity: 0;
    }
  }

  @keyframes pulse {
    50% {
      opacity: 0.5;
    }
  }

  @keyframes bounce {
    0%,
    100% {
      transform: translateY(-25%);
      animation-timing-function: cubic-bezier(0.8, 0, 1, 1);
    }

    50% {
      transform: none;
      animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
    }
  }
  """

  def space_mult, do: @space_mult
  def size_mult, do: @size_mult
  def text, do: @text
  def text_leading, do: @text_leading
  def leading, do: @leading
  def tracking, do: @tracking
  def radius, do: @radius
  def weight, do: @weight
  def font, do: @font
  def container, do: @container
  def shadow, do: @shadow
  def inset_shadow, do: @inset_shadow
  def drop_shadow, do: @drop_shadow
  def text_shadow, do: @text_shadow
  def blur, do: @blur
  def perspective, do: @perspective
  def aspect, do: @aspect
  def ease, do: @ease
  def animate, do: @animate
  def breakpoint, do: @breakpoint
  def keyframes, do: @keyframes

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

  defp trim(value) do
    (value * 1.0)
    |> Float.round(4)
    |> :erlang.float_to_binary(decimals: 4)
    |> String.replace(~r/\.?0+$/, "")
  end
end
