defmodule Corex.Design.Theme do
  @moduledoc """
  Resolves `config :corex_design` theme keys into color and dimension inputs for the compiler.

  Configure with flat keys: `default_theme`, `default_mode`, and `themes` (preset id list or catalog map).
  When `themes` is omitted, `Corex.Design.Theme.Presets.all/0` is used.

  Built-in preset ids (`neo`, `uno`, `duo`, `leo`) accept partial maps merged onto the preset.
  Custom theme ids require a full spec. Use `merge_specs/2` for programmatic merges only.
  """

  alias Corex.Design.Theme.Options, as: ThemeOptions
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Tokens.Scales

  @base_unit 0.25
  @modes [:light, :dark]
  @dimension_axes ~W(space_scale size_scale text_scale radius_scale container_scale)a

  def modes, do: @modes

  def themes, do: theme_ids()

  def default_theme, do: Keyword.get(resolved(), :default_theme, :neo)
  def default_mode, do: Keyword.get(resolved(), :default_mode, :light)

  def scaling(theme), do: dimension_scale(theme, :space_scale)

  @doc "Themeable Tailwind spacing base (`--spacing`) in rem."
  def spacing(theme), do: Scales.rem_value(@base_unit * dimension_scale(theme, :space_scale))

  @doc "The per-theme base spacing unit in rem (the multiplier source for space/size)."
  def base(theme), do: @base_unit * dimension_scale(theme, :space_scale)

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

  @doc "The default (unstepped) density value for a theme: the `md` step."
  def density_default(_theme), do: calc_spacing(Map.new(Scales.density_mult())[:md])

  @doc "The default (unstepped) size value for a theme: the `md` step."
  def size_default(theme),
    do: calc_spacing(Map.new(Scales.size_mult())[:md] * size_spacing_ratio(theme))

  @doc "The default (unstepped) radius value for a theme: the `md` step."
  def radius_default(theme), do: radius(theme) |> Keyword.fetch!(:md)

  @doc "Per-theme multiplier for shadow blur/spread templates (default 1.0)."
  def shadow_scale(theme) when is_atom(theme) do
    case Map.get(dimensions(theme), :shadow_scale) do
      n when is_number(n) -> n * 1.0
      _ -> 1.0
    end
  end

  def theme_ids do
    resolved_themes()
    |> Map.keys()
    |> Enum.sort()
  end

  def picker_ids, do: Enum.map(theme_ids(), &Atom.to_string/1)

  def resolved_themes do
    resolved =
      case themes_input() do
        nil ->
          Presets.all()

        themes when is_list(themes) ->
          ids = if Keyword.keyword?(themes), do: Keyword.keys(themes), else: themes
          Presets.all() |> Map.take(ids)

        %{} = themes ->
          ThemeOptions.validate!(themes)
      end

    ThemeOptions.validate_resolved!(resolved)
    resolved
  end

  @doc false
  def normalize_input_spec(spec) when is_map(spec), do: normalize_spec(spec)

  @doc false
  def merge_specs(base, overrides) when is_map(base) and is_map(overrides) do
    base_norm = if Map.has_key?(base, :colors), do: base, else: normalize_spec(base)
    deep_merge(base_norm, normalize_spec(overrides))
  end

  def spec!(theme) when is_atom(theme) do
    case Map.get(resolved_themes(), theme) do
      nil -> raise ArgumentError, "unknown theme #{inspect(theme)}"
      spec -> spec
    end
  end

  def dimensions(theme) when is_atom(theme) do
    spec!(theme)
    |> Map.get(:dimensions, %{})
  end

  def dimension_scale(theme, axis) when axis in @dimension_axes do
    dims = dimensions(theme)
    fallback = Map.get(dims, :scale, 1.0)
    Map.get(dims, axis, fallback) * 1.0
  end

  def radius_overrides(theme) when is_atom(theme) do
    dimensions(theme)
    |> Map.get(:radius, %{})
    |> normalize_key_map()
  end

  def font_stacks(theme) when is_atom(theme) do
    case Map.get(dimensions(theme), :font) do
      %{} = stacks -> normalize_key_map(stacks)
      _ -> nil
    end
  end

  def typography(theme) when is_atom(theme) do
    case Map.get(spec!(theme), :typography) do
      %{} = map -> map
      _ -> %{}
    end
  end

  @doc false
  def validate!(themes) when is_map(themes), do: ThemeOptions.validate!(themes)

  defp themes_input do
    resolved() |> Keyword.get(:themes)
  end

  defp resolved, do: Corex.Design.Config.resolved_options()

  defp normalize_spec(spec) when is_map(spec) do
    base = %{
      palette: normalize_palette(map_get(spec, :palette, %{})),
      colors: normalize_colors(map_get(spec, :colors, %{})),
      dimensions: normalize_dimensions(map_get(spec, :dimensions, %{}))
    }

    case normalize_typography(map_get(spec, :typography)) do
      %{} = typography -> Map.put(base, :typography, typography)
      _ -> base
    end
  end

  defp normalize_palette(palette) when is_map(palette) do
    Map.new(palette, fn {k, v} -> {normalize_palette_key(k), to_string(v)} end)
  end

  defp normalize_palette_key(:neutral), do: "base"
  defp normalize_palette_key("neutral"), do: "base"
  defp normalize_palette_key(k) when is_atom(k), do: Atom.to_string(k)
  defp normalize_palette_key(k) when is_binary(k), do: k

  defp normalize_colors(colors) when is_map(colors) do
    %{
      light: (map_get(colors, :light) || empty_mode()) |> normalize_mode_colors(),
      dark: (map_get(colors, :dark) || empty_mode()) |> normalize_mode_colors()
    }
  end

  defp normalize_mode_colors(mode) when is_map(mode) do
    %{
      surface: normalize_key_map(map_get(mode, :surface, %{})),
      roles: normalize_key_map(map_get(mode, :roles, %{})),
      on: normalize_key_map(map_get(mode, :on, %{})),
      border: normalize_flat_token(map_get(mode, :border)),
      focus: normalize_flat_token(map_get(mode, :focus)),
      shadow: normalize_flat_token(map_get(mode, :shadow))
    }
  end

  defp normalize_flat_token(nil), do: nil
  defp normalize_flat_token(token) when is_map(token), do: normalize_key_map(token)

  defp normalize_dimensions(dims) when is_map(dims) do
    scale = fetch_float(dims, :scale)
    radius = map_get(dims, :radius)

    %{}
    |> put_dim(:scale, scale)
    |> put_dim(:space_scale, fetch_float(dims, :space_scale) || scale)
    |> put_dim(:size_scale, fetch_float(dims, :size_scale) || scale)
    |> put_dim(:text_scale, fetch_float(dims, :text_scale) || scale)
    |> put_dim(:radius_scale, fetch_float(dims, :radius_scale) || scale)
    |> put_dim(:container_scale, fetch_float(dims, :container_scale) || scale)
    |> put_dim(:shadow_scale, fetch_float(dims, :shadow_scale))
    |> then(fn acc ->
      if is_map(radius) do
        Map.put(acc, :radius, normalize_radius_overrides(radius))
      else
        acc
      end
    end)
    |> then(fn acc ->
      case normalize_font(map_get(dims, :font)) do
        nil -> acc
        font -> Map.put(acc, :font, font)
      end
    end)
  end

  defp put_dim(map, _key, nil), do: map
  defp put_dim(map, key, val), do: Map.put(map, key, val)

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

  defp normalize_font_key(k) when is_atom(k), do: k
  defp normalize_font_key(k) when is_binary(k), do: String.to_atom(k)

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
      key =
        case k do
          k when is_atom(k) -> k
          k when is_binary(k) -> String.to_atom(k)
        end

      {key, v * 1.0}
    end)
  end

  defp map_get(map, key, default \\ nil)

  defp map_get(map, key, default) when is_map(map) and is_atom(key) do
    Map.get(map, key) || Map.get(map, Atom.to_string(key)) || default
  end

  defp map_get(_map, _key, default), do: default

  defp fetch_float(map, key) do
    case map_get(map, key) do
      n when is_number(n) -> n * 1.0
      _ -> nil
    end
  end

  defp empty_mode, do: %{surface: %{}, roles: %{}, on: %{}}

  defp deep_merge(%{colors: bc} = base, %{colors: oc} = over) do
    merged = %{
      palette: Map.merge(base.palette, over.palette),
      colors: %{
        light:
          deep_merge_mode(Map.get(bc, :light, empty_mode()), Map.get(oc, :light, empty_mode())),
        dark: deep_merge_mode(Map.get(bc, :dark, empty_mode()), Map.get(oc, :dark, empty_mode()))
      },
      dimensions:
        deep_merge_dims(Map.get(base, :dimensions, %{}), Map.get(over, :dimensions, %{}))
    }

    case deep_merge_typography(Map.get(base, :typography), Map.get(over, :typography)) do
      %{} = typography -> Map.put(merged, :typography, typography)
      _ -> merged
    end
  end

  defp deep_merge_typography(nil, nil), do: nil
  defp deep_merge_typography(nil, over), do: over
  defp deep_merge_typography(base, nil), do: base

  defp deep_merge_typography(base, over) do
    Map.merge(base, over, fn _key, left, right ->
      if is_map(left) and is_map(right), do: Map.merge(left, right), else: right
    end)
  end

  defp deep_merge_mode(base, over) do
    %{
      surface: deep_merge_maps(Map.get(base, :surface, %{}), Map.get(over, :surface, %{})),
      roles: deep_merge_maps(Map.get(base, :roles, %{}), Map.get(over, :roles, %{})),
      on: deep_merge_maps(Map.get(base, :on, %{}), Map.get(over, :on, %{})),
      border: pick_flat(Map.get(base, :border), Map.get(over, :border)),
      focus: pick_flat(Map.get(base, :focus), Map.get(over, :focus)),
      shadow: pick_flat(Map.get(base, :shadow), Map.get(over, :shadow))
    }
  end

  defp pick_flat(_base, over) when is_map(over), do: over
  defp pick_flat(base, _over), do: base

  defp deep_merge_dims(base, over) do
    font =
      case {Map.get(base, :font), Map.get(over, :font)} do
        {nil, nil} -> nil
        {b, nil} -> b
        {nil, o} -> o
        {b, o} -> Map.merge(b, o)
      end

    radius = Map.merge(Map.get(base, :radius, %{}), Map.get(over, :radius, %{}))

    %{
      scale: pick_scale(over, base, :scale),
      space_scale: pick_scale(over, base, :space_scale),
      size_scale: pick_scale(over, base, :size_scale),
      text_scale: pick_scale(over, base, :text_scale),
      radius_scale: pick_scale(over, base, :radius_scale),
      container_scale: pick_scale(over, base, :container_scale),
      shadow_scale: pick_scale(over, base, :shadow_scale),
      radius: radius,
      font: font
    }
    |> Enum.reject(fn {_k, v} -> v in [nil, %{}] end)
    |> Map.new()
  end

  defp pick_scale(over, base, key) do
    Map.get(over, key) || Map.get(base, key)
  end

  defp deep_merge_maps(a, b) do
    Map.merge(a, b, fn _, va, vb ->
      if is_map(va) and is_map(vb), do: deep_merge_maps(va, vb), else: vb
    end)
  end

  defp normalize_key_map(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      key = if is_atom(k), do: k, else: String.to_atom(k)
      val = if is_map(v), do: normalize_key_map(v), else: v
      {key, val}
    end)
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
