defmodule Corex.Design.Theme.Validator do
  @moduledoc false

  alias Corex.Design.Color, as: DesignColor
  alias Corex.Design.Keys
  alias Corex.Design.Theme
  alias Corex.Design.Theme.Presets

  @host_scale_keys ~w(
    scale space_scale size_scale text_scale radius_scale container_scale
    shadow_scale blur_scale ring_width ring_offset border_width
    duration_fast duration_normal duration_slow
    opacity_disabled opacity_backdrop
  )a

  @hex_regex ~r/^#[0-9A-Fa-f]{6}$/
  @state_names MapSet.new(DesignColor.state_names())

  @doc """
  Validates a themes map. Returns `{:ok, normalized}` or `{:error, message}`.
  """
  def validate(themes) when is_map(themes) do
    with :ok <- validate_non_empty(themes) do
      validate_specs(themes)
    end
  end

  @doc false
  def validate!(themes) when is_map(themes) do
    case validate(themes) do
      {:ok, normalized} -> normalized
      {:error, message} -> raise ArgumentError, message
    end
  end

  @doc false
  def preset_ids, do: ~W(neo uno duo leo)a

  defp validate_non_empty(themes) do
    if map_size(themes) == 0 do
      {:error, "themes must contain at least one theme"}
    else
      :ok
    end
  end

  defp validate_specs(themes) do
    themes
    |> Enum.reduce_while({:ok, %{}}, fn entry, {:ok, acc} ->
      case normalize_spec(entry) do
        {:ok, {theme_id, norm}} -> {:cont, {:ok, Map.put(acc, theme_id, norm)}}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp normalize_spec({theme_id, spec}) when is_atom(theme_id) and is_map(spec) do
    with :ok <- reject_host_scale_keys(spec, theme_id),
         {:ok, prepared} <- prepare_theme_spec(theme_id, spec),
         {:ok, norm} <- validate_theme_spec(prepared) do
      {:ok, {theme_id, norm}}
    end
  end

  defp normalize_spec({theme_id, spec}) when is_atom(theme_id) do
    {:error, "themes.#{theme_id}: theme spec must be a map, got: #{inspect(spec)}"}
  end

  defp normalize_spec({theme_id, _spec}) do
    {:error, "invalid theme id #{inspect(theme_id)}, expected an atom"}
  end

  defp prepare_theme_spec(theme_id, spec) do
    if preset_id?(theme_id) do
      base = Map.fetch!(Presets.all(), theme_id)

      prepared =
        if spec == %{} do
          base
        else
          if resolved_spec?(spec) do
            spec
          else
            Theme.merge_specs(base, spec)
          end
        end

      {:ok, prepared}
    else
      cond do
        legacy_color_shapes?(spec) ->
          {:error,
           "themes.#{theme_id}: nested :surface/:roles/:on maps are not supported; use flat public token names (root, surface, ui, …)"}

        not resolved_spec?(spec) ->
          {:error, custom_theme_error(theme_id)}

        not has_dimensions_key?(spec) ->
          {:error,
           "themes.#{theme_id}: custom theme requires :dimensions key (use %{} for built-in radius defaults)"}

        true ->
          {:ok, Theme.normalize_input_spec(spec)}
      end
    end
  end

  defp legacy_color_shapes?(spec) when is_map(spec) do
    colors = Keys.get(spec, :colors, %{})
    legacy_nested_mode?(Keys.get(colors, :light, %{})) or
      legacy_nested_mode?(Keys.get(colors, :dark, %{}))
  end

  defp preset_id?(id), do: id in preset_ids()

  defp has_dimensions_key?(spec) when is_map(spec) do
    Map.has_key?(spec, :dimensions) or Map.has_key?(spec, "dimensions")
  end

  defp custom_theme_error(theme_id) do
    "themes.#{theme_id}: custom theme ids require a full spec " <>
      "(seeds, colors with :light and :dark, and dimensions)"
  end

  defp reject_host_scale_keys(spec, theme_id) when is_map(spec) do
    if resolved_spec?(spec) do
      :ok
    else
      reject_host_scale_keys_in_dimensions(spec, theme_id)
    end
  end

  defp reject_host_scale_keys_in_dimensions(spec, theme_id) do
    dims = Keys.get(spec, :dimensions)

    if is_map(dims) do
      found =
        dims
        |> Map.keys()
        |> Enum.find(fn key ->
          key_str = if is_atom(key), do: Atom.to_string(key), else: to_string(key)
          key_str in Enum.map(@host_scale_keys, &Atom.to_string/1)
        end)

      if found do
        key_str = if is_atom(found), do: Atom.to_string(found), else: to_string(found)

        {:error,
         "themes.#{theme_id}: #{key_str} is not allowed in host theme overrides; " <>
           "spacing/size/text steps are global via top-level scales:, and per-theme radius may only set dimensions.radius step values"}
      else
        :ok
      end
    else
      :ok
    end
  end

  defp validate_theme_spec(spec) do
    colors = Keys.get(spec, :colors, %{})
    seeds = Keys.get(spec, :seeds) || Keys.get(spec, :palette) || %{}

    with :ok <- validate_palette_hex(normalize_seeds_for_hex(seeds)),
         :ok <- reject_legacy_mode_shapes(colors),
         :ok <- validate_mode_tokens(colors) do
      {:ok, Theme.normalize_input_spec(spec)}
    end
  end

  defp normalize_seeds_for_hex(seeds) when is_map(seeds) do
    Map.new(seeds, fn {k, v} -> {to_string(k), v} end)
  end

  defp resolved_spec?(spec) do
    colors = Keys.get(spec, :colors)
    seeds = Keys.get(spec, :seeds) || Keys.get(spec, :palette)

    case colors do
      %{light: light, dark: dark} when is_map(light) and is_map(dark) and is_map(seeds) ->
        normalized_mode?(light) and normalized_mode?(dark)

      %{"light" => light, "dark" => dark} when is_map(light) and is_map(dark) and is_map(seeds) ->
        normalized_mode?(light) and normalized_mode?(dark)

      _ ->
        false
    end
  end

  defp normalized_mode?(mode) do
    cond do
      is_map(Keys.get(mode, :tokens)) -> true
      legacy_nested_mode?(mode) -> false
      Map.has_key?(mode, :root) or Map.has_key?(mode, "root") -> true
      Map.has_key?(mode, :surface) or Map.has_key?(mode, "surface") -> true
      true -> map_size(mode) > 0
    end
  end

  defp reject_legacy_mode_shapes(colors) when is_map(colors) do
    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Keys.get(colors, mode, %{})

      if legacy_nested_mode?(mode_map) do
        {:halt,
         {:error,
          "colors.#{mode}: nested :surface/:roles/:on maps are not supported; use flat public token names (root, surface, ui, …)"}}
      else
        {:cont, :ok}
      end
    end)
  end

  defp legacy_nested_mode?(mode) when is_map(mode) do
    cond do
      is_map(Keys.get(mode, :tokens)) -> false
      Map.has_key?(mode, :roles) or Map.has_key?(mode, "roles") -> true
      Map.has_key?(mode, :on) or Map.has_key?(mode, "on") -> true
      nested_surface_map?(Keys.get(mode, :surface)) -> true
      true -> false
    end
  end

  defp nested_surface_map?(surface) when is_map(surface) do
    Map.has_key?(surface, :page) or Map.has_key?(surface, "page") or
      Map.has_key?(surface, :raised) or Map.has_key?(surface, "raised") or
      Map.has_key?(surface, :control) or Map.has_key?(surface, "control")
  end

  defp nested_surface_map?(_), do: false

  defp validate_palette_hex(palette) when is_map(palette) do
    Enum.reduce_while(palette, :ok, fn {_k, hex}, :ok ->
      if is_binary(hex) and Regex.match?(@hex_regex, hex) do
        {:cont, :ok}
      else
        {:halt, {:error, "invalid seed hex #{inspect(hex)} (expected #RRGGBB)"}}
      end
    end)
  end

  defp validate_mode_tokens(colors) when is_map(colors) do
    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Keys.get(colors, mode, %{})
      tokens = Keys.get(mode_map, :tokens) || mode_map

      case validate_token_defs(tokens) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_token_defs(tokens) when is_map(tokens) do
    Enum.reduce_while(tokens, :ok, fn {name, cfg}, :ok ->
      case validate_token_def(name, cfg) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_token_def(_name, %{kind: :l} = cfg) do
    with :ok <- validate_lightness_value(Map.get(cfg, :l)),
         :ok <- validate_states(Map.get(cfg, :states, %{})) do
      :ok
    end
  end

  defp validate_token_def(_name, %{kind: :contrast} = cfg) do
    target = Map.get(cfg, :target)

    if is_number(target) and target > 0 do
      :ok
    else
      {:error, "contrast token requires positive :target, got: #{inspect(target)}"}
    end
  end

  defp validate_token_def(name, {:l, lightness}) do
    validate_lightness_value(lightness, name)
  end

  defp validate_token_def(name, {:l, lightness, opts}) when is_list(opts) do
    with :ok <- validate_lightness_value(lightness, name),
         :ok <- validate_states(Keyword.get(opts, :states, %{})) do
      :ok
    end
  end

  defp validate_token_def(_name, {:contrast, opts}) when is_list(opts) do
    target = Keyword.get(opts, :target)

    if is_number(target) and target > 0 do
      :ok
    else
      {:error, "contrast token requires positive :target, got: #{inspect(target)}"}
    end
  end

  defp validate_token_def(name, %{} = cfg) do
    cond do
      Map.has_key?(cfg, :l) or Map.has_key?(cfg, :lightness) or Map.has_key?(cfg, :states) ->
        with :ok <- validate_lightness_value(Map.get(cfg, :l) || Map.get(cfg, :lightness)),
             :ok <- validate_states(Map.get(cfg, :states, %{})) do
          :ok
        end

      Map.has_key?(cfg, :target) or Map.has_key?(cfg, :ratio) ->
        target = Map.get(cfg, :target) || Map.get(cfg, :ratio)

        if is_number(target) and target > 0 do
          :ok
        else
          {:error, "token #{inspect(name)} requires positive :target"}
        end

      true ->
        :ok
    end
  end

  defp validate_token_def(name, cfg) do
    {:error, "token #{inspect(name)} has invalid def #{inspect(cfg)}"}
  end

  defp validate_lightness_value(nil), do: :ok

  defp validate_lightness_value(value, _name \\ nil) do
    try do
      _ = DesignColor.normalize_l!(value)
      :ok
    rescue
      e in ArgumentError -> {:error, Exception.message(e)}
    end
  end

  defp validate_states(states) when is_map(states) do
    Enum.reduce_while(states, :ok, fn {state, lightness}, :ok ->
      state_str = to_string(state)

      cond do
        not MapSet.member?(@state_names, state_str) ->
          {:halt,
           {:error,
            "state #{inspect(state)} must be one of #{inspect(DesignColor.state_names())}"}}

        true ->
          case validate_lightness_value(lightness) do
            :ok -> {:cont, :ok}
            err -> {:halt, err}
          end
      end
    end)
  end

  defp validate_states(_), do: :ok

  defp validate_role_palette_refs(resolved) do
    Enum.reduce_while(resolved, :ok, fn {id, spec}, :ok ->
      seeds = Map.get(spec, :seeds) || Map.get(spec, :palette) || %{}
      colors = Map.get(spec, :colors, %{})

      case validate_theme_seed_refs(id, seeds, colors) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_theme_seed_refs(id, seeds, colors) do
    seed_keys =
      seeds
      |> Map.keys()
      |> Enum.map(&to_string/1)
      |> MapSet.new()

    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Map.get(colors, mode, %{})
      tokens = Map.get(mode_map, :tokens) || mode_map

      refs =
        tokens
        |> Enum.flat_map(fn {_k, cfg} -> seed_refs(cfg) end)
        |> Enum.reject(&is_nil/1)

      invalid =
        refs
        |> Enum.reject(fn ref ->
          ref_str = ref |> to_string() |> normalize_seed_ref()
          MapSet.member?(seed_keys, ref_str) or String.starts_with?(ref_str, "#")
        end)
        |> Enum.uniq()

      if invalid == [] do
        {:cont, :ok}
      else
        {:halt,
         {:error,
          "themes.#{id}.colors.#{mode}: seed refs #{inspect(invalid)} missing from seeds #{inspect(Map.keys(seeds))}"}}
      end
    end)
  end

  defp normalize_seed_ref("base"), do: "neutral"
  defp normalize_seed_ref(ref), do: ref

  defp seed_refs(%{seed: seed}), do: [seed]
  defp seed_refs(%{palette: seed}), do: [seed]
  defp seed_refs({:l, _l, opts}) when is_list(opts), do: [Keyword.get(opts, :seed)]
  defp seed_refs({:contrast, opts}) when is_list(opts), do: [Keyword.get(opts, :seed)]
  defp seed_refs(%{} = cfg), do: [Map.get(cfg, :seed), Map.get(cfg, :palette)]
  defp seed_refs(_), do: []

  @doc false
  def validate_resolved!(resolved) when is_map(resolved) do
    with :ok <- validate_role_palette_refs(resolved),
         :ok <- validate_resolved_tokens(resolved) do
      :ok
    else
      {:error, message} -> raise ArgumentError, message
    end
  end

  defp validate_resolved_tokens(resolved) do
    Enum.reduce_while(resolved, :ok, fn {_id, spec}, :ok ->
      colors = Map.get(spec, :colors, %{})

      case validate_mode_tokens(colors) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end
end
