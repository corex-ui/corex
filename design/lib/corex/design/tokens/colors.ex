defmodule Corex.Design.Tokens.Colors do
  @moduledoc false

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.PaletteGen

  @default_on_ink %{palette: "neutral", ratio: 7.0}
  @default_on_page_light %{palette: "neutral", against: :page, ratio: 8.0}
  @default_on_page_dark %{palette: "neutral", against: :page, ratio: 12.0}
  @default_on_muted_light %{palette: "neutral", against: :page, ratio: 5.15}
  @default_on_muted_dark %{palette: "neutral", against: :page, ratio: 6.0}
  @default_on_link_light %{palette: "info", against: :page, ratio: 6.0}
  @default_on_link_dark %{palette: "info", against: :page, ratio: 7.5}
  @default_on_control_light %{palette: "neutral", against: :control, ratio: 8.0}
  @default_on_control_dark %{palette: "neutral", against: :control, ratio: 12.0}

  def generate do
    for {theme_id, spec} <- Theme.resolved_themes(),
        mode <- Theme.modes(),
        into: %{} do
      mode_map = Map.fetch!(spec.colors, mode)
      {{theme_id, mode}, build_mode_colors(spec.palette, mode_map, mode)}
    end
  end

  def build_mode_colors(palette, mode_map, mode) when is_map(palette) and is_map(mode_map) do
    palette = string_key_map(palette)
    surface = map_get(mode_map, :surface, %{})
    roles = map_get(mode_map, :roles, %{})
    on = map_get(mode_map, :on, %{})
    cache = PaletteGen.new_cache()

    {surface_tokens, cache} = surface_tokens(%{}, palette, surface, cache)
    {role_tokens, cache} = role_tokens(surface_tokens, palette, roles, cache)
    on = merge_auto_on(on, roles, mode)
    {on_tokens, cache} = on_tokens(role_tokens, palette, on, surface_tokens, role_tokens, cache)

    on_tokens
    |> then(fn acc ->
      acc
      |> put_flat_token(palette, :border, map_get(mode_map, :border, nil), surface_tokens, cache)
      |> put_flat_token(palette, :focus, map_get(mode_map, :focus, nil), surface_tokens, cache)
      |> put_flat_token(palette, :shadow, map_get(mode_map, :shadow, nil), surface_tokens, cache)
    end)
  end

  defp surface_tokens(acc, palette, surface, cache) do
    Enum.reduce(surface, {acc, cache}, fn {key, cfg}, {tok, c} ->
      put_surface_token(tok, palette, surface_key(key), cfg, c)
    end)
  end

  defp surface_key(key) when is_atom(key), do: Atom.to_string(key)
  defp surface_key(key) when is_binary(key), do: key

  defp put_surface_token(tok, palette, key, cfg, cache) do
    hex = palette_hex(palette, Map.get(cfg, :palette, Map.get(cfg, :color, "neutral")))

    case Map.get(cfg, :states) do
      %{} = states ->
        put_state_tokens(tok, "surface-#{key}", hex, states, cache)

      _ ->
        {hex_out, cache} = at_lightness(hex, Map.fetch!(cfg, :lightness), cache)
        {Map.put(tok, "surface-#{key}", hex_out), cache}
    end
  end

  defp role_tokens(acc, palette, roles, cache) do
    Enum.reduce(roles, {acc, cache}, fn {name, cfg}, {tok, c} ->
      put_role_token(tok, palette, role_key(name), cfg, c)
    end)
  end

  defp role_key(key) when is_atom(key), do: Atom.to_string(key)
  defp role_key(key) when is_binary(key), do: key

  defp put_role_token(tok, palette, name, cfg, cache) do
    hex = palette_hex(palette, Map.get(cfg, :palette, Map.get(cfg, :bg, name)))

    case Map.get(cfg, :states) do
      %{} = states ->
        put_state_tokens(tok, name, hex, states, cache)

      _ ->
        {hex_out, cache} = at_lightness(hex, Map.fetch!(cfg, :lightness), cache)
        {Map.put(tok, name, hex_out), cache}
    end
  end

  defp put_state_tokens(tok, key, hex, states, cache) do
    Enum.reduce(states, {tok, cache}, fn {state, lightness}, {acc, c} ->
      {hex_out, c2} = at_lightness(hex, lightness, c)
      sk = if to_string(state) == "default", do: key, else: "#{key}-#{state}"
      {Map.put(acc, sk, hex_out), c2}
    end)
  end

  defp on_tokens(acc, palette, on, surface_tokens, role_tokens, cache) do
    Enum.reduce(on, {acc, cache}, fn {name, cfg}, {tok, c} ->
      key = on_key(name)
      bg = contrast_bg(cfg, surface_tokens, role_tokens)
      seed = palette_hex(palette, Map.get(cfg, :palette, Map.get(cfg, :color, "neutral")))
      ratio = Map.get(cfg, :ratio, 7.0) * 1.0
      {hex, _ach} = PaletteGen.contrast_fg(seed, bg, ratio)
      {Map.put(tok, "on-#{key}", hex), c}
    end)
  end

  defp on_key(key) when is_atom(key), do: Atom.to_string(key)
  defp on_key(key) when is_binary(key), do: key

  defp contrast_bg(cfg, surface_tokens, role_tokens) do
    against =
      case Map.get(cfg, :against) do
        nil -> :page
        value -> value
      end

    against_str = if is_atom(against), do: Atom.to_string(against), else: to_string(against)

    cond do
      Map.has_key?(role_tokens, against_str) ->
        Map.fetch!(role_tokens, against_str)

      Map.has_key?(surface_tokens, "surface-#{against_str}") ->
        Map.fetch!(surface_tokens, "surface-#{against_str}")

      true ->
        Map.get(surface_tokens, "surface-page") ||
          Map.get(surface_tokens, "surface-control") ||
          "#808080"
    end
  end

  defp put_flat_token(acc, _palette, _name, nil, _surface_tokens, _cache), do: acc

  defp put_flat_token(acc, palette, name, cfg, surface_tokens, _cache) when is_map(cfg) do
    bg = flat_contrast_bg(cfg, surface_tokens)
    seed = palette_hex(palette, Map.get(cfg, :palette, Map.get(cfg, :color, "neutral")))
    ratio = Map.get(cfg, :ratio, 1.12) * 1.0
    {hex, _ach} = PaletteGen.contrast_fg(seed, bg, ratio)
    Map.put(acc, Atom.to_string(name), hex)
  end

  defp flat_contrast_bg(cfg, surface_tokens) do
    against =
      case Map.get(cfg, :against) do
        nil -> :control
        value -> value
      end

    against_str = if is_atom(against), do: Atom.to_string(against), else: to_string(against)

    Map.get(surface_tokens, "surface-#{against_str}") ||
      Map.get(surface_tokens, "surface-page") ||
      "#808080"
  end

  defp merge_auto_on(on, roles, mode) do
    defaults = default_on(mode)

    role_on =
      Map.new(roles, fn {role, cfg} ->
        role_str = role_key(role)

        default =
          if Map.get(cfg, :component, true) do
            %{
              palette: "neutral",
              against: String.to_atom(role_str),
              ratio: Map.get(@default_on_ink, :ratio)
            }
          else
            nil
          end

        {role, default}
      end)
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()

    defaults
    |> Map.merge(role_on)
    |> Map.merge(on)
  end

  defp default_on(:light) do
    %{
      page: @default_on_page_light,
      muted: @default_on_muted_light,
      link: @default_on_link_light,
      control: @default_on_control_light
    }
  end

  defp default_on(:dark) do
    %{
      page: @default_on_page_dark,
      muted: @default_on_muted_dark,
      link: @default_on_link_dark,
      control: @default_on_control_dark
    }
  end

  defp default_on(_), do: default_on(:light)

  defp palette_hex(palette, key) do
    s = to_string(key)
    if String.starts_with?(s, "#"), do: s, else: Map.fetch!(palette, s)
  end

  defp at_lightness(hex, lightness, cache) do
    PaletteGen.at_lightness(hex, lightness, cache)
  end

  defp string_key_map(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {to_string(k), v} end)
  end

  defp map_get(map, key, default) when is_map(map) do
    Map.get(map, key) || Map.get(map, Atom.to_string(key)) || default
  end
end
