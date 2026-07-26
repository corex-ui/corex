defmodule Corex.Design.Theme.Validator do
  @moduledoc false

  alias Corex.Design.Keys
  alias Corex.Design.Theme
  alias Corex.Design.Theme.Presets
  alias Corex.Design.Tokens.PaletteGen

  @host_scale_keys ~w(scale space_scale size_scale text_scale radius_scale container_scale shadow_scale)a

  @hex_regex ~r/^#[0-9A-Fa-f]{6}$/

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
        not resolved_spec?(spec) ->
          {:error, custom_theme_error(theme_id)}

        not has_dimensions_key?(spec) ->
          {:error,
           "themes.#{theme_id}: custom theme requires :dimensions key (use %{} for built-in radius defaults)"}

        true ->
          {:ok, spec}
      end
    end
  end

  defp preset_id?(id), do: id in preset_ids()

  defp has_dimensions_key?(spec) when is_map(spec) do
    Map.has_key?(spec, :dimensions) or Map.has_key?(spec, "dimensions")
  end

  defp custom_theme_error(theme_id) do
    "themes.#{theme_id}: custom theme ids require a full spec " <>
      "(palette, colors with :light and :dark, and dimensions)"
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

    with :ok <- validate_palette_hex(normalize_palette_for_hex(spec)),
         :ok <- validate_color_lightness(colors) do
      {:ok, drop_nil_typography(spec)}
    end
  end

  defp normalize_palette_for_hex(spec) do
    (Keys.get(spec, :palette) || %{})
    |> Map.new(fn {k, v} -> {to_string(k), v} end)
  end

  defp resolved_spec?(spec) do
    case Keys.get(spec, :colors) do
      %{light: light, dark: dark} when is_map(light) and is_map(dark) ->
        normalized_mode?(light) and normalized_mode?(dark)

      %{"light" => light, "dark" => dark} when is_map(light) and is_map(dark) ->
        normalized_mode?(light) and normalized_mode?(dark)

      _ ->
        false
    end
  end

  defp normalized_mode?(mode) do
    Enum.any?([:surface, :roles, :on], &Map.has_key?(mode, &1)) or
      Enum.any?(["surface", "roles", "on"], &Map.has_key?(mode, &1))
  end

  defp drop_nil_typography(spec) do
    case Map.get(spec, :typography) do
      nil -> Map.delete(spec, :typography)
      _ -> spec
    end
  end

  defp validate_palette_hex(palette) when is_map(palette) do
    Enum.reduce_while(palette, :ok, fn {_k, hex}, :ok ->
      if is_binary(hex) and Regex.match?(@hex_regex, hex) do
        {:cont, :ok}
      else
        {:halt, {:error, "invalid palette hex #{inspect(hex)} (expected #RRGGBB)"}}
      end
    end)
  end

  defp validate_color_lightness(colors) when is_map(colors) do
    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Keys.get(colors, mode, %{})

      with :ok <- validate_role_lightness(Keys.get(mode_map, :surface, %{}), "surface"),
           :ok <- validate_role_lightness(Keys.get(mode_map, :roles, %{}), "roles") do
        {:cont, :ok}
      else
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_role_lightness(roles, label) do
    Enum.reduce_while(roles, :ok, fn {role, cfg}, :ok ->
      case validate_fill_cfg(role, cfg, label) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_fill_cfg(role, cfg, label) when is_map(cfg) do
    validate_fill(role, label, Keys.get(cfg, :lightness), Keys.get(cfg, :states))
  end

  defp validate_fill_cfg(role, cfg, label) do
    {:error, "themes colors #{label} #{inspect(role)} must be a map, got: #{inspect(cfg)}"}
  end

  defp validate_fill(role, label, _lightness, states) when is_map(states),
    do: validate_states(role, states, label)

  defp validate_fill(role, label, lightness, _states) when is_integer(lightness),
    do: validate_lightness(role, lightness, label)

  defp validate_fill(_role, _label, nil, nil), do: :ok

  defp validate_fill(role, label, _lightness, _states) do
    {:error, "themes colors #{label} #{inspect(role)} requires :lightness or :states"}
  end

  defp validate_states(role, states, label) do
    allowed = MapSet.new(PaletteGen.state_names())

    Enum.reduce_while(states, :ok, fn {state, lightness}, :ok ->
      state_str = if is_atom(state), do: Atom.to_string(state), else: to_string(state)

      cond do
        not MapSet.member?(allowed, state_str) ->
          {:halt,
           {:error,
            "themes colors #{label} #{inspect(role)} state #{inspect(state)} must be one of #{inspect(PaletteGen.state_names())}"}}

        not is_integer(lightness) ->
          {:halt,
           {:error,
            "themes colors #{label} #{inspect(role)} state #{inspect(state)} lightness must be an integer"}}

        true ->
          case validate_lightness(role, lightness, label) do
            :ok -> {:cont, :ok}
            err -> {:halt, err}
          end
      end
    end)
  end

  defp validate_lightness(role, lightness, label) do
    if lightness in PaletteGen.lightness_range() do
      :ok
    else
      {:error,
       "themes colors #{label} #{inspect(role)} lightness #{inspect(lightness)} must be from 0 to 100"}
    end
  end

  defp validate_role_palette_refs(resolved) do
    Enum.reduce_while(resolved, :ok, fn {id, spec}, :ok ->
      palette = Map.get(spec, :palette, %{})
      colors = Map.get(spec, :colors, %{})

      case validate_theme_palette_refs(id, palette, colors) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_theme_palette_refs(id, palette, colors) do
    palette_keys =
      palette
      |> Map.keys()
      |> Enum.map(fn key -> if is_atom(key), do: Atom.to_string(key), else: to_string(key) end)
      |> MapSet.new()

    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Map.get(colors, mode, %{})

      refs =
        collect_palette_refs(mode_map)
        |> Enum.reject(&is_nil/1)

      invalid =
        Enum.reject(refs, fn ref ->
          ref_str = if is_atom(ref), do: Atom.to_string(ref), else: to_string(ref)
          MapSet.member?(palette_keys, ref_str)
        end)
        |> Enum.uniq()

      if invalid == [] do
        {:cont, :ok}
      else
        {:halt,
         {:error,
          "themes.#{id}.colors.#{mode}: palette refs #{inspect(invalid)} missing from palette #{inspect(Map.keys(palette))}"}}
      end
    end)
  end

  defp collect_palette_refs(mode_map) do
    surface_refs =
      mode_map
      |> Map.get(:surface, %{})
      |> Enum.flat_map(fn {_k, cfg} -> palette_ref(cfg) end)

    role_refs =
      mode_map
      |> Map.get(:roles, %{})
      |> Enum.flat_map(fn {_k, cfg} -> palette_ref(cfg) end)

    on_refs =
      mode_map
      |> Map.get(:on, %{})
      |> Enum.flat_map(fn {_k, cfg} -> palette_ref(cfg) end)

    flat_refs =
      [:border, :focus, :shadow]
      |> Enum.flat_map(fn key ->
        case Map.get(mode_map, key) do
          %{} = cfg -> palette_ref(cfg)
          _ -> []
        end
      end)

    surface_refs ++ role_refs ++ on_refs ++ flat_refs
  end

  defp palette_ref(cfg) when is_map(cfg) do
    [Map.get(cfg, :palette), Map.get(cfg, :color), Map.get(cfg, :bg)]
    |> Enum.reject(&is_nil/1)
  end

  @doc false
  def validate_resolved!(resolved) when is_map(resolved) do
    with :ok <- validate_role_palette_refs(resolved),
         :ok <- validate_resolved_stops(resolved) do
      :ok
    else
      {:error, message} -> raise ArgumentError, message
    end
  end

  defp validate_resolved_stops(resolved) do
    Enum.reduce_while(resolved, :ok, fn {_id, spec}, :ok ->
      colors = Map.get(spec, :colors, %{})

      case validate_color_lightness(colors) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end
end
