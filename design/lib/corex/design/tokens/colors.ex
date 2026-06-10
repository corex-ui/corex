defmodule Corex.Design.Tokens.Colors do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.PaletteGen

  @doc """
  Generates every theme/mode color role map at compile time from seed hexes and
  lightness / contrast params via `Color.Palette` (dense tonal ramps and
  Leonardo contrast targeting).

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
    cache = PaletteGen.new_cache()

    %{}
    |> surface_tokens(seeds, surface, cache)
    |> then(fn {acc, cache} ->
      ink_ref_hex = ink_reference_hex(seeds, surface, cache)

      {acc, cache}
      |> utility_tokens(seeds, utility, ink_ref_hex)
      |> ink_tokens(seeds, ink, ink_ref_hex)
      |> semantic_tokens(seeds, semantic)
      |> elem(0)
    end)
  end

  defp theme_seeds(theme) do
    case Map.get(theme, "seeds") do
      %{} = t when map_size(t) > 0 -> string_key_map(t)
      _ -> %{}
    end
  end

  defp string_key_map(map), do: for({k, v} <- map, into: %{}, do: {to_string(k), v})

  defp surface_tokens(acc, seeds, surface, cache) do
    Enum.reduce(surface, {acc, cache}, fn {key, cfg}, {tok, c} ->
      put_surface_token(tok, seeds, to_string(key), cfg, c)
    end)
  end

  defp put_surface_token(tok, seeds, key, cfg, cache) do
    hex = seed_hex(seeds, Map.fetch!(cfg, "color"))

    case cfg["states"] do
      %{} = states ->
        put_state_tokens(tok, key, hex, states, cache)

      _ ->
        {hex_out, cache} = at_lightness(hex, Map.fetch!(cfg, "lightness"), cache)
        {Map.put(tok, key, hex_out), cache}
    end
  end

  defp put_state_tokens(tok, key, hex, states, cache) do
    Enum.reduce(states, {tok, cache}, fn {state, lightness}, {acc, c} ->
      {hex_out, c2} = at_lightness(hex, lightness, c)
      sk = if to_string(state) == "default", do: key, else: "#{key}-#{state}"
      {Map.put(acc, sk, hex_out), c2}
    end)
  end

  defp utility_tokens({acc, cache}, seeds, utility, ink_ref_hex) do
    acc =
      Enum.reduce(utility, acc, fn {name, cfg}, tok ->
        seed = seed_hex(seeds, cfg["color"])
        bg_hex = utility_contrast_bg(acc, name, ink_ref_hex)
        ratio = cfg["ratio"] * 1.0
        {hex, _ach} = PaletteGen.contrast_fg(seed, bg_hex, ratio)
        Map.put(tok, to_string(name), hex)
      end)

    {acc, cache}
  end

  defp utility_contrast_bg(surface_tokens, name, ink_ref_hex) do
    if to_string(name) in ["border", "outline"] do
      Map.get(surface_tokens, "ui", ink_ref_hex)
    else
      ink_ref_hex
    end
  end

  defp ink_tokens({acc, cache}, seeds, ink, ink_ref_hex) do
    acc =
      Enum.reduce(ink, acc, fn {name, cfg}, tok ->
        seed = seed_hex(seeds, cfg["color"])
        ratio = cfg["ratio"] * 1.0
        {hex, _ach} = PaletteGen.contrast_fg(seed, ink_ref_hex, ratio)
        Map.put(tok, ink_output_key(to_string(name)), hex)
      end)

    {acc, cache}
  end

  defp semantic_tokens({acc, cache}, seeds, semantic) do
    Enum.reduce(semantic, {acc, cache}, fn {name, cfg}, {tok, c} ->
      put_semantic_tokens(tok, seeds, to_string(name), cfg, c)
    end)
  end

  defp put_semantic_tokens(tok, seeds, name, cfg, cache) do
    bg_hex = seed_hex(seeds, cfg["bg"])

    {tok, cache} =
      case cfg["states"] do
        %{} = states ->
          put_state_tokens(tok, name, bg_hex, states, cache)

        _ ->
          {hex_out, cache} = at_lightness(bg_hex, Map.fetch!(cfg, "lightness"), cache)
          {Map.put(tok, name, hex_out), cache}
      end

    {sem_ref, cache} = semantic_ink_bg(cfg, bg_hex, cache)
    ink_seed = seed_hex(seeds, cfg["ink"]["color"])
    ratio = cfg["ink"]["ratio"] * 1.0
    {ihex, _ach} = PaletteGen.contrast_fg(ink_seed, sem_ref, ratio)
    {Map.put(tok, "#{name}-ink", ihex), cache}
  end

  defp semantic_ink_bg(cfg, bg_hex, cache) do
    lightness =
      case cfg["states"] do
        %{} = states ->
          Map.get(states, "default") || Map.fetch!(cfg, "lightness")

        _ ->
          Map.fetch!(cfg, "lightness")
      end

    at_lightness(bg_hex, lightness, cache)
  end

  defp ink_output_key("default"), do: "ui-ink"
  defp ink_output_key("muted"), do: "ui-ink-muted"
  defp ink_output_key("link"), do: "link"
  defp ink_output_key(other), do: "ui-ink-#{other}"

  defp ink_reference_hex(seeds, surface, cache) do
    {_key, cfg} = ink_reference_surface(surface)
    hex = seed_hex(seeds, Map.fetch!(cfg, "color"))

    lightness =
      case cfg["states"] do
        %{} = states ->
          Map.get(states, "muted") || Map.get(states, "default") || Map.fetch!(cfg, "lightness")

        _ ->
          Map.fetch!(cfg, "lightness")
      end

    at_lightness(hex, lightness, cache)
    |> elem(0)
  end

  defp ink_reference_surface(surface) do
    case Map.get(surface, "ui") do
      %{} = ui ->
        {"ui", string_key_map(ui)}

      _ ->
        Enum.max_by(surface, fn {_k, cfg} -> surface_lightness_rank(cfg) end)
    end
  end

  defp surface_lightness_rank(cfg) do
    case cfg["states"] do
      %{} = states ->
        states
        |> Map.values()
        |> Enum.map(&PaletteGen.normalize_lightness!/1)
        |> Enum.max()

      _ ->
        PaletteGen.normalize_lightness!(cfg["lightness"])
    end
  end

  defp at_lightness(hex, lightness, cache) do
    PaletteGen.at_lightness(hex, lightness, cache)
  end

  defp seed_hex(seeds, key) do
    s = to_string(key)
    if String.starts_with?(s, "#"), do: s, else: Map.fetch!(seeds, s)
  end
end
