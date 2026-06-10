defmodule Corex.Design.Theme do
  @moduledoc """
  Resolves host `config :corex_design, themes: %{...}` into color and
  dimension inputs for the compiler.

  Each theme spec may include:

    * `:seeds` — hex anchors for OKLCH generation
    * `:colors` — `%{light: %{semantic, surface, ink, utility}, dark: ...}`
    * `:dimensions` — `space_scale`, `size_scale`, `text_scale`, `radius_scale`,
      `container_scale`, optional per-step `:radius`, optional `:font`
    * `:typography` — optional element style map (see `Corex.Design.Typography`)
    * `:extends` — deep-merge onto another theme id (e.g. `:neo`)
    * `:accessibility` — `%{level: :aa}` theme default, optional `:light`/`:dark` overrides

  Global default: `config :corex_design, accessibility_level: :aa`.

  Semantic fills use `bg` = seed name and mid lightness (~36–44 in light mode).
  Soft button looks use the `visual` axis, not inverted semantic roles.

  When `:themes` is omitted, `Corex.Design.Theme.Presets.all/0` is used.
  """

  alias Corex.Design.Accessibility.Level
  alias Corex.Design.Theme.Options, as: ThemeOptions
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Tokens.Scales
  alias Corex.Design.Typography

  @base_unit 0.25
  @modes [:light, :dark]
  @dimension_axes ~w(space_scale size_scale text_scale radius_scale container_scale)a

  def modes, do: @modes

  def themes, do: theme_ids()

  def default_theme, do: Keyword.get(config(), :default_theme, :neo)
  def default_mode, do: Keyword.get(config(), :default_mode, :light)

  def scaling(theme), do: dimension_scale(theme, :space_scale)

  @doc "Themeable Tailwind spacing base (`--spacing`) in rem."
  def spacing(theme), do: Scales.rem_value(@base_unit * dimension_scale(theme, :space_scale))

  @doc "The per-theme base spacing unit in rem (the multiplier source for space/size)."
  def base(theme), do: @base_unit * dimension_scale(theme, :space_scale)

  @doc "Resolved space scale for a theme as `[{step, css}]`."
  def space(_theme) do
    for {step, mult} <- Scales.space_mult(), do: {step, calc_spacing(mult)}
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

  @doc "The default (unstepped) space value for a theme: the `md` step."
  def space_default(_theme), do: calc_spacing(Map.new(Scales.space_mult())[:md])

  @doc "The default (unstepped) size value for a theme: the `md` step."
  def size_default(theme),
    do: calc_spacing(Map.new(Scales.size_mult())[:md] * size_spacing_ratio(theme))

  @doc "The default (unstepped) radius value for a theme: the `md` step."
  def radius_default(theme), do: radius(theme) |> Keyword.fetch!(:md)

  def theme_ids do
    resolved_themes()
    |> Map.keys()
    |> Enum.sort()
  end

  def resolved_themes do
    raw =
      case themes_input() do
        %{} = themes when map_size(themes) > 0 ->
          ThemeOptions.validate!(themes)

        _ ->
          Presets.all()
      end

    resolved =
      raw
      |> Enum.map(fn {id, spec} -> {id, resolve_spec(id, spec, raw, MapSet.new())} end)
      |> Map.new()

    ThemeOptions.validate_resolved!(resolved)

    resolved
  end

  @doc false
  def normalize_input_spec(spec) when is_map(spec), do: normalize_spec(spec)

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
    spec!(theme)
    |> Map.get(:typography, Typography.default())
  end

  def global_accessibility_level do
    Corex.Design.design_config()
    |> Keyword.get(:accessibility_level, :aa)
    |> Level.normalize()
  end

  def accessibility_level(theme, mode) when is_atom(theme) and mode in @modes do
    spec = spec!(theme)
    a11y = Map.get(spec, :accessibility, %{level: nil, modes: %{}})

    Map.get(a11y.modes, mode) || a11y.level ||
      global_accessibility_level()
      |> Level.normalize()
  end

  @doc false
  def color_config do
    global = palette_globals()

    themes =
      resolved_themes()
      |> Enum.flat_map(fn {id, spec} ->
        seeds = stringify_map(spec.seeds)

        for mode <- @modes do
          mode_key = mode
          mode_body = Map.fetch!(spec.colors, mode_key) |> stringify_map()

          level = accessibility_level(id, mode_key)

          body =
            mode_body
            |> Map.put("seeds", seeds)
            |> Map.put("accessibility_level", Level.to_string(level))
            |> Map.put("output", "tokens/themes/#{id}/color/#{mode}.json")

          {"#{id}-#{mode}", body}
        end
      end)
      |> Map.new()

    Map.put(global, "themes", themes)
  end

  def validate!(themes) when is_map(themes), do: ThemeOptions.validate!(themes)

  defp themes_input do
    Corex.Design.design_config()
    |> Keyword.get(:themes)
  end

  defp palette_globals do
    cfg = Corex.Design.design_config()

    %{
      "semantic_ratio_base" =>
        stringify_map(
          Keyword.get(cfg, :semantic_ratio_base, Presets.default_semantic_ratio_base())
        ),
      "state_lightness_offsets" =>
        stringify_map(
          Keyword.get(cfg, :state_lightness_offsets, Presets.default_state_lightness_offsets())
        ),
      "state_order" => Keyword.get(cfg, :state_order, Presets.default_state_order()),
      "ui_ratio_base" =>
        stringify_map(Keyword.get(cfg, :ui_ratio_base, Presets.default_ui_ratio_base()))
    }
  end

  defp normalize_spec(spec) when is_map(spec) do
    %{
      extends: Map.get(spec, :extends) || Map.get(spec, "extends"),
      seeds: normalize_seeds(Map.get(spec, :seeds) || Map.get(spec, "seeds", %{})),
      colors: normalize_colors(Map.get(spec, :colors) || Map.get(spec, "colors", %{})),
      dimensions:
        normalize_dimensions(Map.get(spec, :dimensions) || Map.get(spec, "dimensions", %{})),
      typography: normalize_typography(Map.get(spec, :typography) || Map.get(spec, "typography")),
      accessibility:
        normalize_accessibility(Map.get(spec, :accessibility) || Map.get(spec, "accessibility"))
    }
  end

  defp normalize_accessibility(nil), do: %{level: nil, modes: %{}}

  defp normalize_accessibility(map) when is_map(map) do
    level = Map.get(map, :level) || Map.get(map, "level")
    level = if level, do: Level.normalize(level), else: nil

    modes =
      @modes
      |> Enum.reduce(%{}, fn mode, acc ->
        case Map.get(map, mode) || Map.get(map, Atom.to_string(mode)) do
          nil ->
            acc

          %{level: ml} ->
            Map.put(acc, mode, Level.normalize(ml))

          %{"level" => ml} ->
            Map.put(acc, mode, Level.normalize(ml))

          ml when is_atom(ml) or is_binary(ml) ->
            Map.put(acc, mode, Level.normalize(ml))

          other ->
            raise ArgumentError,
                  "accessibility.#{mode} must be a level (:a, :aa, :aaa), got: #{inspect(other)}"
        end
      end)

    %{level: level, modes: modes}
  end

  defp normalize_seeds(seeds) when is_map(seeds) do
    Map.new(seeds, fn {k, v} -> {to_string(k), to_string(v)} end)
  end

  defp normalize_colors(colors) when is_map(colors) do
    %{
      light:
        (Map.get(colors, :light) || Map.get(colors, "light") || empty_mode())
        |> normalize_mode_colors(),
      dark:
        (Map.get(colors, :dark) || Map.get(colors, "dark") || empty_mode())
        |> normalize_mode_colors()
    }
  end

  defp normalize_mode_colors(mode) when is_map(mode) do
    %{
      semantic: normalize_key_map(Map.get(mode, :semantic) || Map.get(mode, "semantic", %{})),
      surface: normalize_key_map(Map.get(mode, :surface) || Map.get(mode, "surface", %{})),
      ink: normalize_key_map(Map.get(mode, :ink) || Map.get(mode, "ink", %{})),
      utility: normalize_key_map(Map.get(mode, :utility) || Map.get(mode, "utility", %{}))
    }
  end

  defp normalize_dimensions(dims) when is_map(dims) do
    scale = fetch_float(dims, :scale)
    radius = Map.get(dims, :radius) || Map.get(dims, "radius")

    %{
      scale: scale,
      space_scale: fetch_float(dims, :space_scale) || scale || 1.0,
      size_scale: fetch_float(dims, :size_scale) || scale || 1.0,
      text_scale: fetch_float(dims, :text_scale) || scale || 1.0,
      radius_scale: fetch_float(dims, :radius_scale) || scale || 1.0,
      container_scale: fetch_float(dims, :container_scale) || scale || 1.0,
      radius: if(is_map(radius), do: normalize_radius_overrides(radius), else: %{}),
      font: normalize_font(Map.get(dims, :font) || Map.get(dims, "font"))
    }
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Map.new()
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

  defp fetch_float(map, key) do
    case Map.get(map, key) || Map.get(map, to_string(key)) do
      n when is_number(n) -> n * 1.0
      _ -> nil
    end
  end

  defp resolve_spec(id, spec, all, visited) do
    if MapSet.member?(visited, id) do
      raise ArgumentError, "cyclic :extends for theme #{inspect(id)}"
    end

    visited = MapSet.put(visited, id)

    base =
      case Map.get(spec, :extends) do
        nil ->
          %{
            seeds: %{},
            colors: %{light: empty_mode(), dark: empty_mode()},
            dimensions: %{},
            typography: Typography.default(),
            accessibility: %{level: nil, modes: %{}}
          }

        parent when is_atom(parent) ->
          parent_spec = Map.fetch!(all, parent)
          resolve_spec(parent, parent_spec, all, visited)
      end

    deep_merge(base, %{
      seeds: Map.get(spec, :seeds, %{}),
      colors: Map.get(spec, :colors, %{light: empty_mode(), dark: empty_mode()}),
      dimensions: Map.get(spec, :dimensions, %{}),
      typography: Map.get(spec, :typography),
      accessibility: Map.get(spec, :accessibility, %{level: nil, modes: %{}})
    })
  end

  defp empty_mode, do: %{semantic: %{}, surface: %{}, ink: %{}, utility: %{}}

  defp deep_merge(%{colors: bc} = base, %{colors: oc} = over) do
    %{
      seeds: Map.merge(base.seeds, over.seeds),
      colors: %{
        light:
          deep_merge_mode(Map.get(bc, :light, empty_mode()), Map.get(oc, :light, empty_mode())),
        dark: deep_merge_mode(Map.get(bc, :dark, empty_mode()), Map.get(oc, :dark, empty_mode()))
      },
      dimensions:
        deep_merge_dims(Map.get(base, :dimensions, %{}), Map.get(over, :dimensions, %{})),
      typography: deep_merge_typography(Map.get(base, :typography), Map.get(over, :typography)),
      accessibility:
        deep_merge_accessibility(Map.get(base, :accessibility), Map.get(over, :accessibility))
    }
  end

  defp deep_merge_typography(nil, over), do: over || Typography.default()
  defp deep_merge_typography(base, nil), do: base || Typography.default()

  defp deep_merge_typography(base, over) do
    Typography.merge(base || Typography.default(), over || %{})
  end

  defp deep_merge_accessibility(nil, over), do: over || %{level: nil, modes: %{}}
  defp deep_merge_accessibility(base, nil), do: base || %{level: nil, modes: %{}}

  defp deep_merge_accessibility(base, over) do
    %{
      level: Map.get(over, :level) || Map.get(base, :level),
      modes: Map.merge(Map.get(base, :modes, %{}), Map.get(over, :modes, %{}))
    }
  end

  defp deep_merge_mode(base, over) do
    %{
      semantic: deep_merge_maps(Map.get(base, :semantic, %{}), Map.get(over, :semantic, %{})),
      surface: deep_merge_maps(Map.get(base, :surface, %{}), Map.get(over, :surface, %{})),
      ink: deep_merge_maps(Map.get(base, :ink, %{}), Map.get(over, :ink, %{})),
      utility: deep_merge_maps(Map.get(base, :utility, %{}), Map.get(over, :utility, %{}))
    }
  end

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

  def deep_merge_maps_public(a, b), do: deep_merge_maps(a, b)

  defp normalize_key_map(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      key = if is_atom(k), do: k, else: String.to_atom(k)
      val = if is_map(v), do: normalize_key_map(v), else: v
      {key, val}
    end)
  end

  defp stringify_map(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      key = if is_atom(k), do: Atom.to_string(k), else: to_string(k)
      val = if is_map(v), do: stringify_map(v), else: v
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

  defp config, do: Corex.Design.design_config()
end

defmodule Corex.Design.Theme.Options do
  @moduledoc """
  NimbleOptions schemas and validation for `config :corex_design, themes: %{...}`.
  """

  alias Corex.Design.Accessibility.Level
  alias Corex.Design.Semantics
  alias Corex.Design.Theme

  @hex_regex ~r/^#[0-9A-Fa-f]{6}$/

  @theme_spec_schema NimbleOptions.new!(
                       extends: [
                         type: :atom,
                         doc: "Parent theme id to deep-merge"
                       ],
                       seeds: [
                         type: {:map, :string, :string},
                         required: true,
                         doc: "Hex seed colors keyed by name"
                       ],
                       colors: [
                         type: :map,
                         default: %{},
                         doc: "Per-mode color overrides"
                       ],
                       dimensions: [
                         type: :map,
                         default: %{},
                         doc: "Scale multipliers and per-step overrides"
                       ],
                       typography: [
                         type: :map,
                         doc: "Optional typography element map"
                       ],
                       accessibility: [
                         type: :map,
                         default: %{},
                         doc: "Accessibility level overrides"
                       ]
                     )

  @doc """
  Validates a themes map. Returns `{:ok, normalized}` or `{:error, message}`.
  """
  def validate(themes) when is_map(themes) do
    with :ok <- validate_non_empty(themes),
         {:ok, normalized} <- validate_specs(themes),
         :ok <- validate_graph(normalized) do
      {:ok, normalized}
    end
  end

  @doc false
  def validate!(themes) when is_map(themes) do
    case validate(themes) do
      {:ok, normalized} -> normalized
      {:error, message} -> raise ArgumentError, message
    end
  end

  def validate_presets!(presets) when is_map(presets) do
    validate!(presets)
  end

  @doc false
  def preset_ids, do: ~w(neo uno duo leo)a

  defp validate_non_empty(themes) do
    if map_size(themes) == 0 do
      {:error, "themes must contain at least one theme"}
    else
      :ok
    end
  end

  defp validate_specs(themes) do
    normalized =
      Map.new(themes, fn {id, spec} ->
        case validate_theme_id(id) do
          :ok -> :ok
          {:error, msg} -> throw({:error, msg})
        end

        case validate_theme_spec(spec) do
          {:ok, norm} -> {normalize_id(id), norm}
          {:error, msg} -> throw({:error, msg})
        end
      end)

    {:ok, normalized}
  catch
    {:error, msg} -> {:error, msg}
  end

  defp validate_theme_spec(spec) when is_map(spec) do
    string_keys = string_key_map?(spec)

    atom_spec =
      if string_keys do
        string_key_to_atom_map(spec)
      else
        spec
      end

    with {:ok, parsed} <- NimbleOptions.validate(atom_spec, @theme_spec_schema),
         :ok <- validate_seeds_hex(parsed.seeds),
         :ok <- validate_colors_shape(parsed.colors) do
      {:ok, Theme.normalize_input_spec(parsed)}
    end
  end

  defp validate_theme_spec(other) do
    {:error, "theme spec must be a map, got: #{inspect(other)}"}
  end

  defp validate_seeds_hex(seeds) when is_map(seeds) do
    Enum.reduce_while(seeds, :ok, fn {_k, hex}, :ok ->
      if is_binary(hex) and Regex.match?(@hex_regex, hex) do
        {:cont, :ok}
      else
        {:halt, {:error, "invalid seed hex #{inspect(hex)} (expected #RRGGBB)"}}
      end
    end)
  end

  defp validate_colors_shape(colors) when is_map(colors) do
    has_light = Map.has_key?(colors, :light) or Map.has_key?(colors, "light")
    has_dark = Map.has_key?(colors, :dark) or Map.has_key?(colors, "dark")

    if map_size(colors) == 0 or (has_light and has_dark) do
      :ok
    else
      {:error, "theme colors must include :light and :dark when present"}
    end
  end

  defp validate_graph(themes) do
    Enum.each(themes, fn {id, spec} ->
      case Map.get(spec, :extends) do
        nil ->
          :ok

        parent when is_atom(parent) ->
          unless Map.has_key?(themes, parent) do
            raise ArgumentError,
                  "themes.#{id}.extends references unknown theme #{inspect(parent)}"
          end

        other ->
          raise ArgumentError, "themes.#{id}.extends must be an atom, got: #{inspect(other)}"
      end
    end)

    Enum.each(Map.keys(themes), fn id ->
      detect_cycle!(themes, id, MapSet.new(), [])
    end)

    :ok
  rescue
    e in ArgumentError -> {:error, Exception.message(e)}
  end

  defp detect_cycle!(themes, id, visited, chain) do
    if MapSet.member?(visited, id) do
      chain_str = Enum.map_join(chain ++ [id], " → ", &inspect/1)
      raise ArgumentError, "themes: cyclic :extends chain #{chain_str}"
    end

    visited = MapSet.put(visited, id)
    chain = chain ++ [id]

    case Map.get(themes, id) do
      %{extends: parent} when is_atom(parent) ->
        detect_cycle!(themes, parent, visited, chain)

      _ ->
        :ok
    end
  end

  defp validate_semantic_roles(themes) do
    allowed = MapSet.new(Semantics.atoms())

    try do
      Enum.each(themes, fn {id, spec} ->
        seeds = Map.get(spec, :seeds, %{})
        colors = Map.get(spec, :colors, %{light: %{}, dark: %{}})

        for mode <- [:light, :dark],
            semantic <- [Map.get(colors, mode, %{}) |> Map.get(:semantic, %{})],
            {role, cfg} <- semantic do
          unless MapSet.member?(allowed, role) do
            raise ArgumentError,
                  "themes.#{id}.colors.#{mode}.semantic: role #{inspect(role)} not in config :corex semantics #{inspect(Semantics.atoms())}"
          end

          bg =
            case cfg do
              %{bg: bg} -> bg
              %{"bg" => bg} -> bg
              _ -> role
            end

          bg_str = if is_atom(bg), do: Atom.to_string(bg), else: to_string(bg)

          unless Map.has_key?(seeds, bg_str) do
            raise ArgumentError,
                  "themes.#{id}: semantic #{inspect(role)} references seed #{inspect(bg_str)} missing from seeds"
          end
        end
      end)

      :ok
    rescue
      e in ArgumentError -> {:error, Exception.message(e)}
    end
  end

  defp validate_theme_id(id) when is_atom(id) and id != :extends, do: :ok

  defp validate_theme_id(id) do
    {:error, "invalid theme id #{inspect(id)}"}
  end

  defp normalize_id(id) when is_atom(id), do: id

  defp normalize_id(id) when is_binary(id) do
    String.to_existing_atom(id)
  rescue
    ArgumentError -> String.to_atom(id)
  end

  defp string_key_map?(map) do
    map
    |> Map.keys()
    |> Enum.any?(fn key -> is_binary(key) end)
  end

  defp string_key_to_atom_map(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      key = if is_binary(k), do: String.to_atom(k), else: k
      val = if is_map(v), do: string_key_to_atom_map(v), else: v
      {key, val}
    end)
  end

  @doc false
  def validate_resolved!(resolved) when is_map(resolved) do
    case validate_semantic_roles(resolved) do
      :ok -> :ok
      {:error, message} -> raise ArgumentError, message
    end
  end

  @doc false
  def validate_accessibility_level!(level) do
    Level.normalize(level)
  end
end

defmodule Corex.Design.Theme.Presets do
  @moduledoc """
  Built-in theme presets (neo, uno, duo, leo). Copy into host config or reference
  directly:

      config :corex_design,
        themes: Corex.Design.Theme.Presets.all()
  """

  def all do
    %{neo: neo(), uno: uno(), duo: duo(), leo: leo()}
  end

  def neo, do: neo_spec()
  def uno, do: uno_spec()
  def duo, do: duo_spec()
  def leo, do: leo_spec()

  def default_semantic_ratio_base do
    %{
      active: 1.0,
      default: -1.15,
      hover: -1.08,
      muted: -1.8
    }
  end

  def default_state_lightness_offsets do
    %{
      active: -7,
      default: 0,
      hover: -4,
      muted: 3.5
    }
  end

  def default_state_order, do: ["muted", "default", "hover", "active"]

  def default_ui_ratio_base do
    %{
      default: -1.12,
      hover: -1.08,
      muted: -1.2
    }
  end

  defp neo_spec do
    %{
      seeds: neo_seeds(),
      colors: %{light: neo_light_colors(), dark: neo_dark_colors()},
      dimensions: neo_dimensions()
    }
  end

  defp uno_spec do
    %{
      extends: :neo,
      seeds: uno_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{lightness: 97},
            root: %{lightness: 100},
            ui: %{lightness: 94}
          },
          utility: %{
            border: %{ratio: 1.32},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.1}
          },
          ink: %{default: %{ratio: 8.5}}
        },
        dark: %{
          surface: %{
            layer: %{lightness: 14},
            root: %{lightness: 7},
            ui: %{lightness: 24}
          },
          utility: %{
            border: %{ratio: 1.42},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.22}
          },
          ink: %{default: %{ratio: 12.25}}
        }
      },
      dimensions: %{
        space_scale: 0.92,
        size_scale: 0.92,
        text_scale: 0.92,
        radius_scale: 0.88,
        container_scale: 0.92,
        radius: uno_radius_curve(),
        font: uno_font_stacks()
      }
    }
  end

  defp duo_spec do
    %{
      extends: :neo,
      seeds: duo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{lightness: 97},
            root: %{lightness: 99},
            ui: %{lightness: 92}
          },
          utility: %{
            border: %{ratio: 1.34},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{lightness: 42},
            brand: %{lightness: 38},
            selected: %{ink: %{color: "brand", ratio: 7}}
          }
        },
        dark: %{
          surface: %{
            layer: %{lightness: 16},
            root: %{lightness: 10},
            ui: %{lightness: 24}
          },
          utility: %{
            border: %{ratio: 1.43},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.23}
          },
          ink: %{default: %{ratio: 12.1}}
        }
      },
      dimensions: %{
        space_scale: 1.0,
        size_scale: 1.0,
        text_scale: 1.02,
        radius_scale: 1.15,
        container_scale: 1.0,
        radius: duo_radius_curve(),
        font: duo_font_stacks()
      }
    }
  end

  defp leo_spec do
    %{
      extends: :neo,
      seeds: leo_seeds(),
      colors: %{
        light: %{
          surface: %{
            layer: %{lightness: 96},
            root: %{lightness: 98},
            ui: %{lightness: 92}
          },
          utility: %{
            border: %{ratio: 1.34},
            outline: %{ratio: 2.2},
            shadow: %{ratio: 1.07}
          },
          ink: %{default: %{ratio: 8.25}},
          semantic: %{
            accent: %{lightness: 36},
            brand: %{lightness: 42},
            success: %{lightness: 38}
          }
        },
        dark: %{
          surface: %{
            layer: %{lightness: 16},
            root: %{lightness: 9},
            ui: %{lightness: 24}
          },
          utility: %{
            border: %{ratio: 1.43},
            outline: %{ratio: 2.4},
            shadow: %{ratio: 1.23}
          },
          ink: %{default: %{ratio: 12.1}}
        }
      },
      dimensions: %{
        space_scale: 0.96,
        size_scale: 0.96,
        text_scale: 0.96,
        radius_scale: 0.82,
        container_scale: 0.96,
        radius: leo_radius_curve(),
        font: leo_font_stacks()
      }
    }
  end

  defp neo_dimensions do
    %{
      space_scale: 1.0,
      size_scale: 1.0,
      text_scale: 1.0,
      radius_scale: 1.0,
      container_scale: 1.0,
      radius: neo_radius_curve(),
      font: neo_font_stacks()
    }
  end

  defp neo_font_stacks do
    figtree = [
      "Figtree",
      "ui-sans-serif",
      "system-ui",
      "sans-serif",
      "Apple Color Emoji",
      "Segoe UI Emoji",
      "Segoe UI Symbol",
      "Noto Color Emoji"
    ]

    %{sans: figtree, display: figtree}
  end

  defp uno_font_stacks do
    %{
      sans: [
        "Inter",
        "ui-sans-serif",
        "system-ui",
        "sans-serif",
        "Apple Color Emoji",
        "Segoe UI Emoji"
      ]
    }
  end

  defp duo_font_stacks do
    %{
      sans: [
        "Source Sans 3",
        "Segoe UI",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ]
    }
  end

  defp leo_font_stacks do
    %{
      sans: [
        "IBM Plex Sans",
        "Segoe UI",
        "Roboto",
        "Helvetica Neue",
        "Arial",
        "sans-serif"
      ]
    }
  end

  defp neo_radius_curve do
    %{
      xs: 0.125,
      sm: 0.25,
      md: 0.375,
      lg: 0.5,
      xl: 0.75,
      "2xl": 1.0,
      "3xl": 1.5,
      "4xl": 2.0,
      full: 9999
    }
  end

  defp uno_radius_curve do
    %{
      xs: 0.1,
      sm: 0.2,
      md: 0.3,
      lg: 0.4,
      xl: 0.55,
      "2xl": 0.7,
      "3xl": 1.0,
      "4xl": 1.25,
      full: 9999
    }
  end

  defp duo_radius_curve do
    %{
      xs: 0.15,
      sm: 0.3,
      md: 0.45,
      lg: 0.7,
      xl: 1.0,
      "2xl": 1.35,
      "3xl": 2.0,
      "4xl": 2.75,
      full: 9999
    }
  end

  defp leo_radius_curve do
    %{
      xs: 0.08,
      sm: 0.15,
      md: 0.25,
      lg: 0.35,
      xl: 0.5,
      "2xl": 0.65,
      "3xl": 0.85,
      "4xl": 1.1,
      full: 9999
    }
  end

  defp neo_seeds do
    %{
      "accent" => "#4B4B4B",
      "alert" => "#A43C3C",
      "base" => "#F0F0F0",
      "brand" => "#32479C",
      "info" => "#1F77D4",
      "success" => "#059669"
    }
  end

  defp uno_seeds do
    %{
      "accent" => "#475569",
      "alert" => "#B91C1C",
      "base" => "#EEF2F7",
      "brand" => "#0E7490",
      "info" => "#0369A1",
      "success" => "#047857"
    }
  end

  defp duo_seeds do
    %{
      "accent" => "#57534E",
      "alert" => "#9F1239",
      "base" => "#FAF7F2",
      "brand" => "#5B21B6",
      "info" => "#1D4ED8",
      "success" => "#15803D"
    }
  end

  defp leo_seeds do
    %{
      "accent" => "#3F3F46",
      "alert" => "#991B1B",
      "base" => "#F4F4F5",
      "brand" => "#B45309",
      "info" => "#1E40AF",
      "success" => "#166534"
    }
  end

  defp neo_light_colors do
    %{
      ink: %{
        accent: %{color: "accent", ratio: 6},
        alert: %{color: "alert", ratio: 6},
        brand: %{color: "brand", ratio: 6},
        default: %{color: "base", ratio: 8},
        info: %{color: "info", ratio: 6},
        link: %{color: "info", ratio: 6},
        muted: %{color: "base", ratio: 5.15},
        success: %{color: "success", ratio: 6}
      },
      semantic: %{
        accent: %{bg: "accent", ink: %{color: "base", ratio: 7}, lightness: 40},
        alert: %{bg: "alert", ink: %{color: "base", ratio: 7}, lightness: 40},
        brand: %{bg: "brand", ink: %{color: "base", ratio: 7}, lightness: 40},
        info: %{bg: "info", ink: %{color: "base", ratio: 7}, lightness: 40},
        selected: %{bg: "base", ink: %{color: "base", ratio: 7}, lightness: 85},
        success: %{bg: "success", ink: %{color: "base", ratio: 7}, lightness: 40}
      },
      surface: %{
        layer: %{color: "base", lightness: 97},
        root: %{color: "base", lightness: 98},
        ui: %{color: "base", lightness: 94, states: true}
      },
      utility: %{
        border: %{color: "base", ratio: 1.3},
        outline: %{color: "base", ratio: 2.2},
        shadow: %{color: "base", ratio: 1.05}
      }
    }
  end

  defp neo_dark_colors do
    %{
      ink: %{
        accent: %{color: "accent", ratio: 7.5},
        alert: %{color: "alert", ratio: 7.5},
        brand: %{color: "brand", ratio: 7.5},
        default: %{color: "base", ratio: 12},
        info: %{color: "info", ratio: 7.5},
        link: %{color: "info", ratio: 7.5},
        muted: %{color: "base", ratio: 6},
        success: %{color: "success", ratio: 7.5}
      },
      semantic: %{
        accent: %{bg: "accent", ink: %{color: "base", ratio: 7}, lightness: 52},
        alert: %{bg: "alert", ink: %{color: "base", ratio: 7}, lightness: 48},
        brand: %{bg: "brand", ink: %{color: "base", ratio: 7}, lightness: 48},
        info: %{bg: "info", ink: %{color: "base", ratio: 7}, lightness: 48},
        selected: %{bg: "base", ink: %{color: "base", ratio: 7}, lightness: 34},
        success: %{bg: "success", ink: %{color: "base", ratio: 7}, lightness: 48}
      },
      surface: %{
        layer: %{color: "base", lightness: 15},
        root: %{color: "base", lightness: 8},
        ui: %{color: "base", lightness: 24, states: true}
      },
      utility: %{
        border: %{color: "base", ratio: 1.4},
        outline: %{color: "base", ratio: 2.4},
        shadow: %{color: "base", ratio: 1.2}
      }
    }
  end
end
