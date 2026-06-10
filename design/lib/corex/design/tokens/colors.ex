defmodule Corex.Design.Tokens.Colors do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.PaletteGen

  @doc """
  Generates every theme/mode color role map at compile time from seed hexes and
  tonal stop / contrast params via `Color.Palette` (tonal ramps and Leonardo
  contrast targeting).

  Returns `%{{theme_atom, mode_atom} => %{role_string => hex_string}}`.
  """
  def generate(config \\ Theme.color_config()) when is_map(config) do
    for {theme_mode_id, theme} <- config["themes"], into: %{} do
      {slug, mode} = split_id(theme_mode_id)
      {{String.to_atom(slug), String.to_atom(mode)}, build_theme_colors(theme)}
    end
  end

  defp split_id(theme_mode_id) do
    case Regex.run(~r/^(.+)-(light|dark)$/, theme_mode_id) do
      [_, slug, mode] -> {slug, mode}
      _ -> {theme_mode_id, "light"}
    end
  end

  @doc false
  def build_theme_colors(theme) do
    seeds = theme_seeds(theme)
    surface = theme["surface"] || %{}
    utility = theme["utility"] || %{}
    ink = theme["ink"] || %{}
    semantic = theme["semantic"] || %{}

    %{}
    |> surface_tokens(seeds, surface)
    |> then(fn acc ->
      ink_ref_hex = ink_reference_hex(seeds, surface)

      acc
      |> utility_tokens(seeds, utility, ink_ref_hex)
      |> ink_tokens(seeds, ink, ink_ref_hex)
      |> semantic_tokens(seeds, semantic)
    end)
  end

  defp theme_seeds(theme) do
    case Map.get(theme, "seeds") do
      %{} = t when map_size(t) > 0 -> string_key_map(t)
      _ -> %{}
    end
  end

  defp string_key_map(map), do: for({k, v} <- map, into: %{}, do: {to_string(k), v})

  defp surface_tokens(acc, seeds, surface) do
    Enum.reduce(surface, acc, fn {key, cfg}, tok ->
      put_surface_token(tok, seeds, to_string(key), cfg)
    end)
  end

  defp put_surface_token(tok, seeds, key, cfg) do
    hex = seed_hex(seeds, Map.fetch!(cfg, "color"))

    case cfg["states"] do
      %{} = states ->
        put_state_tokens(tok, key, hex, states)

      _ ->
        Map.put(tok, key, PaletteGen.tonal_stop(hex, Map.fetch!(cfg, "stop")))
    end
  end

  defp put_state_tokens(tok, key, hex, states) do
    Enum.reduce(states, tok, fn {state, stop}, acc ->
      sk = if to_string(state) == "default", do: key, else: "#{key}-#{state}"
      Map.put(acc, sk, PaletteGen.tonal_stop(hex, stop))
    end)
  end

  defp utility_tokens(acc, seeds, utility, ink_ref_hex) do
    Enum.reduce(utility, acc, fn {name, cfg}, tok ->
      seed = seed_hex(seeds, cfg["color"])
      bg_hex = utility_contrast_bg(acc, name, ink_ref_hex)
      ratio = cfg["ratio"] * 1.0
      {hex, _ach} = PaletteGen.contrast_fg(seed, bg_hex, ratio)
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
      {hex, _ach} = PaletteGen.contrast_fg(seed, ink_ref_hex, ratio)
      Map.put(tok, ink_output_key(to_string(name)), hex)
    end)
  end

  defp semantic_tokens(acc, seeds, semantic) do
    Enum.reduce(semantic, acc, fn {name, cfg}, tok ->
      put_semantic_tokens(tok, seeds, to_string(name), cfg)
    end)
  end

  defp put_semantic_tokens(tok, seeds, name, cfg) do
    bg_hex = seed_hex(seeds, cfg["bg"])

    tok =
      case cfg["states"] do
        %{} = states ->
          put_state_tokens(tok, name, bg_hex, states)

        _ ->
          Map.put(tok, name, PaletteGen.tonal_stop(bg_hex, Map.fetch!(cfg, "stop")))
      end

    sem_ref = semantic_ink_bg(cfg, bg_hex)
    ink_seed = seed_hex(seeds, cfg["ink"]["color"])
    ratio = cfg["ink"]["ratio"] * 1.0
    {ihex, _ach} = PaletteGen.contrast_fg(ink_seed, sem_ref, ratio)
    Map.put(tok, "#{name}-ink", ihex)
  end

  defp semantic_ink_bg(cfg, bg_hex) do
    stop =
      case cfg["states"] do
        %{} = states ->
          Map.get(states, "default") || Map.fetch!(cfg, "stop")

        _ ->
          Map.fetch!(cfg, "stop")
      end

    PaletteGen.tonal_stop(bg_hex, stop)
  end

  defp ink_output_key("default"), do: "ui-ink"
  defp ink_output_key("muted"), do: "ui-ink-muted"
  defp ink_output_key("link"), do: "link"
  defp ink_output_key(other), do: "ui-ink-#{other}"

  defp ink_reference_hex(seeds, surface) do
    {_key, cfg} = ink_reference_surface(surface)
    hex = seed_hex(seeds, Map.fetch!(cfg, "color"))

    stop =
      case cfg["states"] do
        %{} = states ->
          Map.get(states, "muted") || Map.get(states, "default") || Map.fetch!(cfg, "stop")

        _ ->
          Map.fetch!(cfg, "stop")
      end

    PaletteGen.tonal_stop(hex, stop)
  end

  defp ink_reference_surface(surface) do
    case Map.get(surface, "ui") do
      %{} = ui ->
        {"ui", string_key_map(ui)}

      _ ->
        Enum.max_by(surface, fn {_k, cfg} -> surface_stop_rank(cfg) end)
    end
  end

  defp surface_stop_rank(cfg) do
    case cfg["states"] do
      %{} = states ->
        states
        |> Map.values()
        |> Enum.map(&PaletteGen.normalize_stop!/1)
        |> Enum.max()

      _ ->
        PaletteGen.normalize_stop!(cfg["stop"])
    end
  end

  defp seed_hex(seeds, key) do
    s = to_string(key)
    if String.starts_with?(s, "#"), do: s, else: Map.fetch!(seeds, s)
  end
end
