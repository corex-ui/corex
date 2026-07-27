defmodule Corex.Design.Theme do
  @moduledoc false

  alias Corex.Design.Keys
  alias Corex.Design.Theme.Validator, as: ThemeValidator
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Theme.Spec
  alias Corex.Design.Theme.Spec.Dimensions
  alias Corex.Design.Theme.Spec.Mode
  alias Corex.Design.Tokens.Scales

  @base_unit 0.25
  @default_modes [:light, :dark]
  @dimension_axes ~W(space_scale size_scale text_scale radius_scale container_scale)a

  def modes do
    case resolved().modes do
      nil ->
        @default_modes

      modes when is_list(modes) ->
        modes
        |> Enum.map(fn
          mode when is_atom(mode) -> mode
          mode when is_binary(mode) -> String.to_existing_atom(mode)
        end)
        |> Enum.filter(&(&1 in @default_modes))
        |> case do
          [] -> @default_modes
          list -> Enum.uniq(list)
        end
    end
  end

  def themes, do: theme_ids()

  def default_theme, do: resolved().default_theme
  def default_mode, do: resolved().default_mode

  @doc "Themeable Tailwind spacing base (`--spacing`) in rem."
  def spacing(theme), do: Scales.rem_value(@base_unit * dimension_scale(theme, :space_scale))

  @doc "Resolved density scale for a theme as `[{step, css}]`."
  def density(_theme) do
    for {step, mult} <- Scales.density_mult(), do: {step, calc_spacing(mult)}
  end

  @doc "Resolved size (component height) scale for a theme."
  def size(theme) do
    ratio = size_spacing_ratio(theme)

    for {step, mult} <- Scales.size_mult(), do: {step, calc_spacing(mult * ratio)}
  end

  @doc "Resolved font-size scale for a theme."
  def text(theme) do
    s = dimension_scale(theme, :text_scale)
    for {step, v} <- Scales.text(), do: {step, Scales.rem_value(v * s)}
  end

  @doc "Resolved border-radius scale for a theme."
  def radius(theme) do
    s = dimension_scale(theme, :radius_scale)
    overrides = radius_overrides(theme)

    for {step, v} <- Scales.radius() do
      {step, radius_value(step, v, s, Map.get(overrides, step))}
    end
  end

  @doc "Resolved container width scale for a theme."
  def container(theme) do
    s = dimension_scale(theme, :container_scale)
    for {step, v} <- Scales.container(), do: {step, Scales.rem_value(v * s)}
  end

  @doc "Per-theme multiplier for shadow blur/spread templates (default 1.0)."
  def shadow_scale(theme) when is_atom(theme) do
    scale_or_default(dimensions(theme).shadow_scale, 1.0)
  end

  @doc "Per-theme multiplier for blur templates (default 1.0)."
  def blur_scale(theme) when is_atom(theme) do
    scale_or_default(dimensions(theme).blur_scale, 1.0)
  end

  @doc "Focus ring width as a CSS length (default `2px`)."
  def ring_width(theme) when is_atom(theme) do
    px_value(dimensions(theme).ring_width, 2.0)
  end

  @doc "Focus ring offset as a CSS length (default `0px`)."
  def ring_offset(theme) when is_atom(theme) do
    px_value(dimensions(theme).ring_offset, 0.0)
  end

  @doc "Default border width as a CSS length (default `1px`)."
  def border_width(theme) when is_atom(theme) do
    px_value(dimensions(theme).border_width, 1.0)
  end

  @doc "Motion duration token (`:fast` | `:normal` | `:slow`) as a CSS time."
  def duration(theme, step) when is_atom(theme) and step in [:fast, :normal, :slow] do
    {key, default} =
      case step do
        :fast -> {:duration_fast, 80.0}
        :normal -> {:duration_normal, 120.0}
        :slow -> {:duration_slow, 200.0}
      end

    ms_value(Map.get(dimensions(theme), key), default)
  end

  @doc "Disabled control opacity (default `0.7`)."
  def opacity_disabled(theme) when is_atom(theme) do
    opacity_value(dimensions(theme).opacity_disabled, 0.7)
  end

  @doc "Dialog / overlay backdrop opacity (default `0.4`)."
  def opacity_backdrop(theme) when is_atom(theme) do
    opacity_value(dimensions(theme).opacity_backdrop, 0.4)
  end

  def theme_ids do
    resolved_themes()
    |> Map.keys()
    |> Enum.sort()
  end

  def resolved_themes do
    resolved =
      case themes_input() do
        nil ->
          Presets.all()

        themes when is_list(themes) ->
          ids = if Keyword.keyword?(themes), do: Keyword.keys(themes), else: themes
          Presets.all() |> Map.take(ids)

        %{} = themes ->
          ThemeValidator.validate!(themes)
      end

    ThemeValidator.validate_resolved!(resolved)
    resolved
  end

  @doc false
  def normalize_input_spec(spec) when is_map(spec), do: normalize_spec(spec)

  @doc false
  def merge_specs(base, overrides) when is_map(base) and is_map(overrides) do
    deep_merge(normalize_spec(base), normalize_spec(overrides))
  end

  def spec!(theme) when is_atom(theme) do
    case Map.get(resolved_themes(), theme) do
      nil -> raise ArgumentError, "unknown theme #{inspect(theme)}"
      spec -> spec
    end
  end

  def dimensions(theme) when is_atom(theme), do: spec!(theme).dimensions

  def dimension_scale(theme, axis) when axis in @dimension_axes do
    dims = dimensions(theme)
    (Map.fetch!(dims, axis) || dims.scale || 1.0) * 1.0
  end

  def radius_overrides(theme) when is_atom(theme), do: dimensions(theme).radius

  def font_stacks(theme) when is_atom(theme), do: dimensions(theme).font

  def typography(theme) when is_atom(theme), do: spec!(theme).typography || %{}

  @doc false
  def validate!(themes) when is_map(themes), do: ThemeValidator.validate!(themes)

  defp themes_input, do: resolved().themes

  defp resolved, do: Corex.Design.Config.resolved()

  defp normalize_spec(%Spec{} = spec), do: spec

  defp normalize_spec(spec) when is_map(spec) do
    %Spec{
      seeds: normalize_seeds(Keys.get(spec, :seeds) || Keys.get(spec, :palette, %{})),
      colors: normalize_colors(Keys.get(spec, :colors, %{})),
      dimensions: normalize_dimensions(Keys.get(spec, :dimensions, %{})),
      typography: normalize_typography(Keys.get(spec, :typography))
    }
  end

  defp normalize_seeds(seeds) when is_map(seeds) do
    Map.new(seeds, fn {k, v} -> {normalize_seed_key(k), to_string(v)} end)
  end

  defp normalize_seed_key(:base), do: "neutral"
  defp normalize_seed_key("base"), do: "neutral"
  defp normalize_seed_key(k) when is_atom(k), do: Atom.to_string(k)
  defp normalize_seed_key(k) when is_binary(k), do: k

  defp normalize_colors(colors) when is_map(colors) do
    %{
      light: normalize_mode_colors(Keys.get(colors, :light, %{})),
      dark: normalize_mode_colors(Keys.get(colors, :dark, %{}))
    }
  end

  defp normalize_mode_colors(%Mode{} = mode), do: mode

  defp normalize_mode_colors(mode) when is_map(mode) do
    tokens =
      if is_map(Keys.get(mode, :tokens)) do
        normalize_token_map(Keys.get(mode, :tokens))
      else
        normalize_token_map(mode)
      end

    %Mode{tokens: tokens}
  end

  defp normalize_token_map(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {to_string(k), v} end)
  end

  defp normalize_dimensions(%Dimensions{} = dims), do: dims

  defp normalize_dimensions(dims) when is_map(dims) do
    scale = fetch_float(dims, :scale)

    %Dimensions{
      scale: scale,
      space_scale: fetch_float(dims, :space_scale) || scale,
      size_scale: fetch_float(dims, :size_scale) || scale,
      text_scale: fetch_float(dims, :text_scale) || scale,
      radius_scale: fetch_float(dims, :radius_scale) || scale,
      container_scale: fetch_float(dims, :container_scale) || scale,
      shadow_scale: fetch_float(dims, :shadow_scale),
      blur_scale: fetch_float(dims, :blur_scale),
      ring_width: fetch_float(dims, :ring_width),
      ring_offset: fetch_float(dims, :ring_offset),
      border_width: fetch_float(dims, :border_width),
      duration_fast: fetch_float(dims, :duration_fast),
      duration_normal: fetch_float(dims, :duration_normal),
      duration_slow: fetch_float(dims, :duration_slow),
      opacity_disabled: fetch_float(dims, :opacity_disabled),
      opacity_backdrop: fetch_float(dims, :opacity_backdrop),
      radius: normalize_radius_overrides(Keys.get(dims, :radius, %{})),
      font: normalize_font(Keys.get(dims, :font))
    }
  end

  defp normalize_font(nil), do: nil

  defp normalize_font(font) when is_map(font) do
    Map.new(font, fn {k, v} ->
      members =
        case v do
          list when is_list(list) -> Enum.map(list, &to_string/1)
          _ -> raise(ArgumentError, "font stack must be a list of names")
        end

      {normalize_font_key(k), members}
    end)
  end

  defp normalize_font_key(k) do
    Keys.closed_atom!(k, Scales.font_steps(), "theme dimensions.font")
  end

  defp normalize_typography(nil), do: nil

  defp normalize_typography(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      key =
        case k do
          key when is_binary(key) -> key
          key when is_atom(key) -> Atom.to_string(key)
        end

      {key, v}
    end)
  end

  defp normalize_radius_overrides(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {Keys.closed_atom!(k, Scales.builtin_radius_steps(), "theme dimensions.radius"), v * 1.0}
    end)
  end

  defp fetch_float(map, key) do
    case Keys.get(map, key) do
      n when is_number(n) -> n * 1.0
      _ -> nil
    end
  end

  defp deep_merge(%Spec{} = base, %Spec{} = over) do
    %Spec{
      seeds: Map.merge(base.seeds, over.seeds),
      colors: %{
        light: deep_merge_mode(base.colors.light, over.colors.light),
        dark: deep_merge_mode(base.colors.dark, over.colors.dark)
      },
      dimensions: deep_merge_dims(base.dimensions, over.dimensions),
      typography: deep_merge_typography(base.typography, over.typography)
    }
  end

  defp deep_merge_typography(nil, nil), do: nil
  defp deep_merge_typography(nil, over), do: over
  defp deep_merge_typography(base, nil), do: base

  defp deep_merge_typography(base, over) do
    Map.merge(base, over, fn _key, left, right ->
      if is_map(left) and is_map(right), do: Map.merge(left, right), else: right
    end)
  end

  defp deep_merge_mode(%Mode{} = base, %Mode{} = over) do
    %Mode{tokens: Map.merge(base.tokens, over.tokens)}
  end

  defp deep_merge_dims(%Dimensions{} = base, %Dimensions{} = over) do
    %Dimensions{
      scale: pick_scale(over, base, :scale),
      space_scale: pick_scale(over, base, :space_scale),
      size_scale: pick_scale(over, base, :size_scale),
      text_scale: pick_scale(over, base, :text_scale),
      radius_scale: pick_scale(over, base, :radius_scale),
      container_scale: pick_scale(over, base, :container_scale),
      shadow_scale: pick_scale(over, base, :shadow_scale),
      blur_scale: pick_scale(over, base, :blur_scale),
      ring_width: pick_scale(over, base, :ring_width),
      ring_offset: pick_scale(over, base, :ring_offset),
      border_width: pick_scale(over, base, :border_width),
      duration_fast: pick_scale(over, base, :duration_fast),
      duration_normal: pick_scale(over, base, :duration_normal),
      duration_slow: pick_scale(over, base, :duration_slow),
      opacity_disabled: pick_scale(over, base, :opacity_disabled),
      opacity_backdrop: pick_scale(over, base, :opacity_backdrop),
      radius: Map.merge(base.radius, over.radius),
      font: merge_font(base.font, over.font)
    }
  end

  defp scale_or_default(n, _default) when is_number(n), do: n * 1.0
  defp scale_or_default(_n, default), do: default

  defp px_value(n, _default) when is_number(n), do: length_px(n)
  defp px_value(_n, default), do: length_px(default)

  defp ms_value(n, _default) when is_number(n), do: "#{Scales.num(n)}ms"
  defp ms_value(_n, default), do: "#{Scales.num(default)}ms"

  defp opacity_value(n, _default) when is_number(n), do: Scales.num(n)
  defp opacity_value(_n, default), do: Scales.num(default)

  defp length_px(n) when n == 0, do: "0px"
  defp length_px(n) when is_number(n), do: "#{Scales.num(n)}px"

  defp merge_font(nil, over), do: over
  defp merge_font(base, nil), do: base
  defp merge_font(base, over), do: Map.merge(base, over)

  defp pick_scale(over, base, key) do
    Map.get(over, key) || Map.get(base, key)
  end

  defp radius_value(_step, :zero, _s, _override), do: "0"
  defp radius_value(_step, :full, _s, _override), do: "9999px"

  defp radius_value(_step, _base, s, override) when is_number(override) do
    Scales.rem_value(override * s)
  end

  defp radius_value(_step, v, s, _override) when is_number(v), do: Scales.rem_value(v * s)

  defp size_spacing_ratio(theme) do
    dimension_scale(theme, :size_scale) / dimension_scale(theme, :space_scale)
  end

  defp calc_spacing(mult) when is_number(mult) do
    "calc(var(--spacing) * #{Scales.num(mult)})"
  end
end
