defmodule Corex.Design.Theme.Options do
  @moduledoc """
  NimbleOptions schemas and validation for `config :corex_design, themes: %{...}`.
  """

  alias Corex.Design.Semantics
  alias Corex.Design.Theme

  @hex_regex ~r/^#[0-9A-Fa-f]{6}$/

  @theme_spec_schema NimbleOptions.new!(
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
         :ok <- validate_seeds_hex(parsed.seeds),
         :ok <- validate_colors_shape(parsed.colors) do
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
    Enum.any?([:semantic, :surface, :ink, :utility], &Map.has_key?(mode, &1)) or
      Enum.any?(["semantic", "surface", "ink", "utility"], &Map.has_key?(mode, &1))
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

  defp validate_semantic_roles(themes) do
    allowed = MapSet.new(Semantics.atoms())

    Enum.reduce_while(themes, :ok, fn {id, spec}, :ok ->
      case validate_theme_semantic_roles(id, spec, allowed) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_theme_semantic_roles(id, spec, allowed) do
    seeds = Map.get(spec, :seeds, %{})
    colors = Map.get(spec, :colors, %{light: %{}, dark: %{}})

    Enum.reduce_while([:light, :dark], :ok, fn mode, :ok ->
      semantic = colors |> Map.get(mode, %{}) |> Map.get(:semantic, %{})

      case validate_semantic_entries(id, mode, semantic, seeds, allowed) do
        :ok -> {:cont, :ok}
        {:error, _} = err -> {:halt, err}
      end
    end)
  end

  defp validate_semantic_entries(id, mode, semantic, seeds, allowed) do
    Enum.reduce_while(semantic, :ok, fn {role, cfg}, :ok ->
      validate_semantic_entry(id, mode, role, cfg, seeds, allowed)
    end)
  end

  defp validate_semantic_entry(id, mode, role, cfg, seeds, allowed) do
    if MapSet.member?(allowed, role) do
      validate_semantic_seed(id, role, cfg, seeds)
    else
      {:halt,
       {:error,
        "themes.#{id}.colors.#{mode}.semantic: role #{inspect(role)} not in config :corex semantics #{inspect(Semantics.atoms())}"}}
    end
  end

  defp validate_semantic_seed(id, role, cfg, seeds) do
    bg =
      case cfg do
        %{bg: bg} -> bg
        %{"bg" => bg} -> bg
        _ -> role
      end

    bg_str = if is_atom(bg), do: Atom.to_string(bg), else: to_string(bg)

    if Map.has_key?(seeds, bg_str) do
      {:cont, :ok}
    else
      {:halt,
       {:error,
        "themes.#{id}: semantic #{inspect(role)} references seed #{inspect(bg_str)} missing from seeds"}}
    end
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
    case validate_semantic_roles(resolved) do
      :ok -> :ok
      {:error, message} -> raise ArgumentError, message
    end
  end
end
