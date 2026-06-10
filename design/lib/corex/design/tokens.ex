defmodule Corex.Design.Tokens.Colors do
  @moduledoc false

  alias Corex.Design.Theme

  @doc """
  Generates every theme/mode color role map at compile time from seed hexes and
  lightness/contrast params, using the `color` dependency (OKLCH lightness ramps
  and WCAG contrast targeting).

  Returns `%{{theme_atom, mode_atom} => %{role_string => hex_string}}`.
  """
  def generate(config \\ Theme.color_config()) when is_map(config) do
    for {theme_mode_id, theme} <- config["themes"], into: %{} do
      {slug, mode} = split_id(theme_mode_id)
      {{String.to_atom(slug), String.to_atom(mode)}, build_theme_colors(config, theme)}
    end
  end

  defp split_id(theme_mode_id) do
    case Regex.run(~r/^(.+)-(light|dark)$/, theme_mode_id) do
      [_, slug, mode] -> {slug, mode}
      _ -> {theme_mode_id, "light"}
    end
  end

  @doc false
  def build_theme_colors(global, theme) do
    seeds = theme_seeds(global, theme)
    surface = theme["surface"]
    utility = theme["utility"] || %{}
    ink = theme["ink"] || %{}
    semantic = theme["semantic"] || %{}
    state_order = theme["state_order"] || global["state_order"] || ~W(default muted hover active)
    ui_ratio_base = string_key_map(theme["ui_ratio_base"] || global["ui_ratio_base"] || %{})

    semantic_ratio_base =
      string_key_map(theme["semantic_ratio_base"] || global["semantic_ratio_base"] || %{})

    offsets =
      string_key_map(theme["state_lightness_offsets"] || global["state_lightness_offsets"] || %{})

    %{}
    |> surface_tokens(seeds, surface, state_order, ui_ratio_base, offsets)
    |> finish_theme_tokens(%{
      seeds: seeds,
      surface: surface,
      utility: utility,
      ink: ink,
      semantic: semantic,
      state_order: state_order,
      ui_ratio_base: ui_ratio_base,
      semantic_ratio_base: semantic_ratio_base,
      offsets: offsets
    })
  end

  defp finish_theme_tokens(acc, ctx) do
    %{
      seeds: seeds,
      surface: surface,
      utility: utility,
      ink: ink,
      semantic: semantic,
      state_order: state_order,
      ui_ratio_base: ui_ratio_base,
      semantic_ratio_base: semantic_ratio_base,
      offsets: offsets
    } = ctx

    {_ink_bg_key, ink_bg_cfg} = ink_reference(surface)

    ink_ref_hex =
      ink_reference_hex(seeds, ink_bg_cfg, state_order, ui_ratio_base, offsets)

    acc
    |> utility_tokens(seeds, utility, ink_ref_hex)
    |> ink_tokens(seeds, ink, ink_ref_hex)
    |> semantic_tokens(seeds, semantic, state_order, semantic_ratio_base, offsets)
  end

  defp theme_seeds(global, theme) do
    case Map.get(theme, "seeds") do
      %{} = t when map_size(t) > 0 -> string_key_map(t)
      _ -> string_key_map(global["seeds"] || %{})
    end
  end

  defp string_key_map(map), do: for({k, v} <- map, into: %{}, do: {to_string(k), v})

  defp surface_tokens(acc, seeds, surface, state_order, ui_ratio_base, offsets) do
    Enum.reduce(surface, acc, fn {key, cfg}, tok ->
      put_surface_token(tok, seeds, to_string(key), cfg, state_order, ui_ratio_base, offsets)
    end)
  end

  defp put_surface_token(tok, seeds, key, cfg, state_order, ui_ratio_base, offsets) do
    color_key = Map.fetch!(cfg, "color")
    hex = seed_hex(seeds, color_key)
    lightness = cfg["lightness"]

    if cfg["states"] do
      put_stateful_surface_tokens(
        tok,
        key,
        hex,
        lightness,
        cfg,
        state_order,
        ui_ratio_base,
        offsets
      )
    else
      Map.put(tok, key, neutral_at(hex, lightness))
    end
  end

  defp put_stateful_surface_tokens(
         tok,
         key,
         hex,
         lightness,
         cfg,
         state_order,
         ui_ratio_base,
         offsets
       ) do
    base = Map.merge(ui_ratio_base, string_key_map(cfg["ratio_base"] || %{}))
    ratios = ratios_for_lightness(lightness, base)

    Enum.reduce(ordered_state_names(ratios, state_order), tok, fn state, t2 ->
      off = Map.get(offsets, state, 0.0)
      l = clamp_pct(lightness + off)
      sk = if state == "default", do: key, else: "#{key}-#{state}"
      Map.put(t2, sk, neutral_at(hex, l))
    end)
  end

  defp utility_tokens(acc, seeds, utility, ink_ref_hex) do
    Enum.reduce(utility, acc, fn {name, cfg}, tok ->
      seed = seed_hex(seeds, cfg["color"])
      bg_hex = utility_contrast_bg(acc, name, ink_ref_hex)
      ratio = cfg["ratio"] * 1.0
      {hex, _ach} = contrast_fg(seed, bg_hex, ratio)
      Map.put(tok, to_string(name), hex)
    end)
  end

  defp utility_contrast_bg(surface_tokens, name, ink_ref_hex) do
    if to_string(name) in ["border", "outline"] do
      Map.get(surface_tokens, "ui", ink_ref_hex)
    else
      ink_ref_hex
    end
  end

  defp ink_tokens(acc, seeds, ink, ink_ref_hex) do
    Enum.reduce(ink, acc, fn {name, cfg}, tok ->
      seed = seed_hex(seeds, cfg["color"])
      ratio = cfg["ratio"] * 1.0
      {hex, _ach} = contrast_fg(seed, ink_ref_hex, ratio)
      Map.put(tok, ink_output_key(to_string(name)), hex)
    end)
  end

  defp semantic_tokens(acc, seeds, semantic, state_order, semantic_ratio_base, offsets) do
    Enum.reduce(semantic, acc, fn {name, cfg}, tok ->
      put_semantic_tokens(
        tok,
        seeds,
        to_string(name),
        cfg,
        state_order,
        semantic_ratio_base,
        offsets
      )
    end)
  end

  defp put_semantic_tokens(
         tok,
         seeds,
         name,
         cfg,
         state_order,
         semantic_ratio_base,
         offsets
       ) do
    bg_hex = seed_hex(seeds, cfg["bg"])
    lightness = cfg["lightness"]
    ratio_base = Map.merge(semantic_ratio_base, string_key_map(cfg["ratio_base"] || %{}))
    ratios = ratios_for_lightness(lightness, ratio_base)

    tok =
      Enum.reduce(ordered_state_names(ratios, state_order), tok, fn state, t2 ->
        off = Map.get(offsets, state, 0.0)
        l = clamp_pct(lightness + off)
        sk = if state == "default", do: name, else: "#{name}-#{state}"
        Map.put(t2, sk, neutral_at(bg_hex, l))
      end)

    sem_ref = neutral_at(bg_hex, lightness)
    ink_seed = seed_hex(seeds, cfg["ink"]["color"])
    ratio = cfg["ink"]["ratio"] * 1.0
    {ihex, _ach} = contrast_fg(ink_seed, sem_ref, ratio)
    Map.put(tok, "#{name}-ink", ihex)
  end

  defp ink_output_key("default"), do: "ui-ink"
  defp ink_output_key("muted"), do: "ui-ink-muted"
  defp ink_output_key("link"), do: "link"
  defp ink_output_key(other), do: "ui-ink-#{other}"

  defp ink_reference(surface) do
    Enum.min_by(surface, fn {_k, c} ->
      l = c["lightness"]
      if is_number(l), do: l, else: 999.0
    end)
  end

  defp ink_reference_hex(seeds, ink_bg_cfg, state_order, ui_ratio_base, offsets) do
    if ink_bg_cfg["states"] do
      base = Map.merge(ui_ratio_base, string_key_map(ink_bg_cfg["ratio_base"] || %{}))
      ratios = ratios_for_lightness(ink_bg_cfg["lightness"], base)
      state = hd(ordered_state_names(ratios, state_order))
      off = Map.get(offsets, state, 0.0)
      l = clamp_pct(ink_bg_cfg["lightness"] + off)
      neutral_at(seed_hex(seeds, ink_bg_cfg["color"]), l)
    else
      neutral_at(seed_hex(seeds, ink_bg_cfg["color"]), ink_bg_cfg["lightness"])
    end
  end

  defp seed_hex(seeds, key) do
    s = to_string(key)
    if String.starts_with?(s, "#"), do: s, else: Map.fetch!(seeds, s)
  end

  defp neutral_at(hex, l_pct) do
    l = clamp01(l_pct / 100.0)

    with {:ok, c} <- Color.new(hex),
         {:ok, okl} <- Color.convert(c, Color.Oklch),
         {:ok, out} <- Color.convert(%{okl | l: l}, Color.SRGB) do
      Color.to_hex(out)
    else
      {:error, reason} ->
        raise ArgumentError, "invalid color #{inspect(hex)}: #{inspect(reason)}"
    end
  end

  defp clamp_pct(v), do: min(99.0, max(1.0, v))
  defp clamp01(v), do: min(1.0, max(0.0, v))

  defp ratios_for_lightness(lightness, base) when is_map(base) do
    dir = if is_number(lightness) and lightness >= 50, do: -1, else: 1
    b = string_key_map(base)

    %{
      "muted" => dir * (Map.get(b, "muted", 1.15) * 1.0),
      "default" => dir * (Map.get(b, "default", 1.1) * 1.0),
      "hover" => dir * (Map.get(b, "hover", 1.08) * 1.0),
      "active" => Map.get(b, "active", 1.0) * 1.0
    }
  end

  defp ordered_state_names(ratios, order) do
    first = Enum.filter(order, &Map.has_key?(ratios, &1))
    seen = MapSet.new(first)
    rest = for k <- Map.keys(ratios), not MapSet.member?(seen, k), do: k
    first ++ rest
  end

  defp contrast_fg(seed_hex, bg_hex, ratio) do
    r = ratio * 1.0
    p = Color.Palette.contrast(seed_hex, background: bg_hex, targets: [r])

    case p.stops do
      [%{color: %Color.SRGB{} = c, achieved: a}] -> {Color.to_hex(c), a}
      [%{color: :unreachable}] -> {seed_hex, r}
      _ -> {seed_hex, r}
    end
  end
end

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
