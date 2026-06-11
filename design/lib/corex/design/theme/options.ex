defmodule Corex.Design.Theme.Options do
  @moduledoc """
  NimbleOptions schemas and validation for `config :corex, Corex.Design, themes: %{...}`.
  """

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.PaletteGen

  @hex_regex ~r/^#[0-9A-Fa-f]{6}$/

  @theme_spec_schema NimbleOptions.new!(
                       palette: [
                         type: {:map, :string, :string},
                         required: true,
                         doc: "Hex palette anchors keyed by name"
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
                       ]
                     )

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
    if resolved_spec?(spec) do
      {:ok, drop_nil_typography(spec)}
    else
      validate_raw_theme_spec(spec)
    end
  end

  defp validate_theme_spec(other) do
    {:error, "theme spec must be a map, got: #{inspect(other)}"}
  end

  defp validate_raw_theme_spec(spec) do
    string_keys = string_key_map?(spec)

    atom_spec =
      if string_keys do
        string_key_to_atom_map(spec)
      else
        spec
      end

    atom_spec = Enum.reject(atom_spec, fn {_k, v} -> is_nil(v) end) |> Map.new()

    with {:ok, parsed} <- NimbleOptions.validate(atom_spec, @theme_spec_schema),
         :ok <- validate_palette_hex(parsed.palette),
         :ok <- validate_colors_shape(parsed.colors),
         :ok <- validate_color_lightness(parsed.colors) do
      {:ok, Theme.normalize_input_spec(parsed)}
    end
  end

  defp resolved_spec?(spec) do
    case map_get(spec, :colors) do
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

  defp map_get(map, key) when is_map(map) do
    Map.get(map, key) || Map.get(map, Atom.to_string(key))
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

  defp validate_colors_shape(colors) when is_map(colors) do
    has_light = Map.has_key?(colors, :light) or Map.has_key?(colors, "light")
    has_dark = Map.has_key?(colors, :dark) or Map.has_key?(colors, "dark")

    if map_size(colors) == 0 or (has_light and has_dark) do
      :ok
    else
      {:error, "theme colors must include :light and :dark when present"}
    end
  end

  defp validate_color_lightness(colors) when is_map(colors) do
    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      mode_map = Map.get(colors, mode, %{})

      with :ok <- validate_role_lightness(Map.get(mode_map, :surface, %{}), "surface"),
           :ok <- validate_role_lightness(Map.get(mode_map, :roles, %{}), "roles") do
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

  defp validate_fill_cfg(role, cfg, label) do
    lightness = Map.get(cfg, :lightness)
    states = Map.get(cfg, :states)

    cond do
      is_map(states) ->
        validate_states(role, states, label)

      is_integer(lightness) ->
        validate_lightness(role, lightness, label)

      is_nil(lightness) and is_nil(states) ->
        :ok

      true ->
        {:error, "themes colors #{label} #{inspect(role)} requires :lightness or :states"}
    end
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

  defp validate_theme_id(id) when is_atom(id), do: :ok

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
