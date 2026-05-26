defmodule E2e.DesignPalette do
  @moduledoc false

  @default_design_dir "assets/corex/design"

  def run(opts \\ []) do
    design_dir =
      Keyword.get(
        opts,
        :design_dir,
        Path.expand(@default_design_dir, File.cwd!())
      )

    quiet = Keyword.get(opts, :quiet, false)

    config =
      case Keyword.fetch(opts, :config) do
        {:ok, c} when is_map(c) ->
          c

        :error ->
          case Keyword.fetch(opts, :config_path) do
            {:ok, path} ->
              load_config!(path)

            :error ->
              E2e.DesignPalette.Config.defaults()
          end
      end

    write_tokens!(design_dir, config, quiet: quiet)
    :ok
  end

  def generate_token_files(config) when is_map(config) do
    {theme_files, all_names} =
      Enum.reduce(config["themes"], {%{}, MapSet.new()}, fn {theme_id, theme}, {files, acc} ->
        out_rel = theme["output"]
        {sd, names} = build_style_dictionary(config, theme_id, theme)
        {Map.put(files, out_rel, sd), MapSet.union(acc, MapSet.new(names))}
      end)

    sem = semantic_aliases(all_names)

    %{
      theme_files: theme_files,
      semantic: sem,
      semantic_path: "tokens/semantic/color.json"
    }
  end

  def write_tokens!(design_dir, config, opts \\ []) when is_map(config) do
    quiet = Keyword.get(opts, :quiet, false)

    %{theme_files: theme_files, semantic: sem, semantic_path: sem_path} =
      generate_token_files(config)

    E2e.DesignPalette.Metadata.write!(design_dir, config)

    Enum.each(theme_files, fn {out_rel, sd} ->
      out_abs = Path.join(design_dir, out_rel)
      File.mkdir_p!(Path.dirname(out_abs))
      File.write!(out_abs, Jason.encode!(sd, pretty: true) <> "\n")
      info_line(quiet, [out_rel, " -> ", out_abs])
    end)

    sem_abs = Path.join(design_dir, sem_path)
    File.mkdir_p!(Path.dirname(sem_abs))
    File.write!(sem_abs, Jason.encode!(sem, pretty: true) <> "\n")
    info_line(quiet, ["semantic -> ", sem_abs])
    :ok
  end

  def run_with_config(config, opts \\ []) when is_map(config) do
    run(Keyword.put(opts, :config, config))
  end

  defp info_line(true, _msg), do: :ok

  defp info_line(false, msg) do
    if Code.ensure_loaded?(Mix) and function_exported?(Mix, :shell, 0) do
      Mix.shell().info(msg)
    end

    :ok
  end

  def semantic_aliases(%MapSet{} = names), do: build_semantic_tokens(names)

  def load_config!(path) do
    case File.read(path) do
      {:ok, body} -> Jason.decode!(body)
      {:error, _} -> Mix.raise("missing palette config: #{path}")
    end
  end

  def build_style_dictionary(global, _theme_id, theme) do
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

    tokens =
      surface_tokens(%{}, seeds, surface, state_order, ui_ratio_base, offsets)
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

    names = Map.keys(tokens) |> Enum.sort()
    sd = to_style_dictionary(tokens)
    {sd, names}
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

    {ink_bg_key, ink_bg_cfg} = ink_reference(surface)

    ink_ref_hex =
      ink_reference_hex(
        seeds,
        surface,
        ink_bg_key,
        ink_bg_cfg,
        state_order,
        ui_ratio_base,
        offsets
      )

    acc
    |> utility_tokens(seeds, utility, ink_bg_key, ink_bg_cfg, ink_ref_hex)
    |> ink_tokens(seeds, ink, ink_bg_key, ink_bg_cfg, ink_ref_hex)
    |> semantic_tokens(seeds, semantic, state_order, semantic_ratio_base, offsets)
  end

  defp theme_seeds(global, theme) do
    case Map.get(theme, "seeds") do
      %{} = t when map_size(t) > 0 ->
        string_key_map(t)

      _ ->
        string_key_map(global["seeds"] || %{})
    end
  end

  defp string_key_map(map) do
    for {k, v} <- map, into: %{}, do: {to_string(k), v}
  end

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
      v = neutral_at(hex, lightness)
      desc = solid_surface_desc(key, lightness, hex)
      Map.put(tok, key, %{value: v, description: desc})
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
      v = neutral_at(hex, l)
      sk = if state == "default", do: key, else: "#{key}-#{state}"
      desc = stateful_surface_desc(key, state, lightness, hex)
      Map.put(t2, sk, %{value: v, description: desc})
    end)
  end

  defp utility_tokens(acc, seeds, utility, ink_bg_key, _ink_bg_cfg, ink_ref_hex) do
    Enum.reduce(utility, acc, fn {name, cfg}, tok ->
      name = to_string(name)
      seed = seed_hex(seeds, cfg["color"])
      ratio = cfg["ratio"] * 1.0
      {hex, ach} = contrast_fg(seed, ink_ref_hex, ratio)
      desc = contrast_desc(ach, ink_bg_key, ink_ref_hex)
      Map.put(tok, name, %{value: hex, description: desc})
    end)
  end

  defp ink_tokens(acc, seeds, ink, ink_bg_key, _ink_bg_cfg, ink_ref_hex) do
    Enum.reduce(ink, acc, fn {name, cfg}, tok ->
      out = ink_output_key(to_string(name))
      seed = seed_hex(seeds, cfg["color"])
      ratio = cfg["ratio"] * 1.0
      {hex, ach} = contrast_fg(seed, ink_ref_hex, ratio)
      desc = contrast_desc(ach, ink_bg_key, ink_ref_hex)
      Map.put(tok, out, %{value: hex, description: desc})
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

  defp put_semantic_tokens(tok, seeds, name, cfg, state_order, semantic_ratio_base, offsets) do
    bg_hex = seed_hex(seeds, cfg["bg"])
    lightness = cfg["lightness"]
    ratio_base = Map.merge(semantic_ratio_base, string_key_map(cfg["ratio_base"] || %{}))
    ratios = ratios_for_lightness(lightness, ratio_base)

    tok =
      Enum.reduce(ordered_state_names(ratios, state_order), tok, fn state, t2 ->
        off = Map.get(offsets, state, 0.0)
        l = clamp_pct(lightness + off)
        v = neutral_at(bg_hex, l)
        sk = if state == "default", do: name, else: "#{name}-#{state}"
        desc = semantic_fill_desc(name, state, lightness, bg_hex)
        Map.put(t2, sk, %{value: v, description: desc})
      end)

    sem_ref = neutral_at(bg_hex, lightness)
    ink_seed = seed_hex(seeds, cfg["ink"]["color"])
    ink_ratio = cfg["ink"]["ratio"] * 1.0
    {ihex, ach} = contrast_fg(ink_seed, sem_ref, ink_ratio)
    idesc = contrast_desc(ach, name, sem_ref)
    Map.put(tok, "#{name}-ink", %{value: ihex, description: idesc})
  end

  defp ink_output_key("default"), do: "ink"
  defp ink_output_key("link"), do: "link"
  defp ink_output_key(other), do: "ink-#{other}"

  defp ink_reference(surface) do
    Enum.min_by(surface, fn {_k, c} ->
      l = c["lightness"]
      if is_number(l), do: l, else: 999.0
    end)
  end

  defp ink_reference_hex(
         seeds,
         _surface,
         _ink_bg_key,
         ink_bg_cfg,
         state_order,
         ui_ratio_base,
         offsets
       ) do
    if ink_bg_cfg["states"] do
      base = Map.merge(ui_ratio_base, string_key_map(ink_bg_cfg["ratio_base"] || %{}))
      ratios = ratios_for_lightness(ink_bg_cfg["lightness"], base)
      state = hd(ordered_state_names(ratios, state_order))
      off = Map.get(offsets, state, 0.0)
      l = clamp_pct(ink_bg_cfg["lightness"] + off)
      hex = seed_hex(seeds, ink_bg_cfg["color"])
      neutral_at(hex, l)
    else
      hex = seed_hex(seeds, ink_bg_cfg["color"])
      neutral_at(hex, ink_bg_cfg["lightness"])
    end
  end

  defp seed_hex(seeds, key) do
    s = to_string(key)
    if String.starts_with?(s, "#"), do: s, else: Map.fetch!(seeds, s)
  end

  defp neutral_at(hex, l_pct) do
    l = clamp01(l_pct / 100.0)
    {:ok, c} = Color.new(hex)
    {:ok, okl} = Color.convert(c, Color.Oklch)
    {:ok, out} = Color.convert(%{okl | l: l}, Color.SRGB)
    Color.to_hex(out)
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
      [%{color: %Color.SRGB{} = c, achieved: a}] ->
        {Color.to_hex(c), a}

      [%{color: :unreachable}] ->
        {seed_hex, r}

      _ ->
        {seed_hex, r}
    end
  end

  defp solid_surface_desc(key, lightness, chroma_hex) do
    "Surface #{key} at #{lightness}% lightness (chroma #{String.upcase(chroma_hex)})."
  end

  defp stateful_surface_desc(key, state, base_lightness, chroma_hex) do
    sl = if state == "default", do: "default", else: state

    "Surface #{key} #{sl} stop (base #{base_lightness}% lightness, chroma #{String.upcase(chroma_hex)})."
  end

  defp semantic_fill_desc(semantic_key, state, lightness, bg_hex) do
    sl = if state == "default", do: "default", else: state

    "Semantic #{semantic_key} #{sl} fill at #{lightness}% lightness (chroma #{String.upcase(bg_hex)})."
  end

  defp contrast_desc(achieved, reference_name, reference_hex) do
    a = Float.round(achieved * 1.0, 2)
    "#{a}:1 contrast against #{reference_name} (#{reference_hex})"
  end

  defp to_style_dictionary(tokens) do
    color =
      for {name, entry} <- tokens, into: %{} do
        v = entry.value
        row = %{"value" => v, "type" => "color"}
        row = if desc = entry.description, do: Map.put(row, "description", desc), else: row
        {name, row}
      end

    %{"theme" => %{"color" => color}}
  end

  defp build_semantic_tokens(name_set) do
    color =
      name_set
      |> Enum.sort()
      |> Enum.into(%{}, fn name ->
        {name, %{"value" => "{theme.color.#{name}}", "type" => "color"}}
      end)

    %{"color" => color}
  end
end
