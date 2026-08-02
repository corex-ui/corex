defmodule Corex.Design.Tokens.Colors do
  @moduledoc false

  alias Corex.Design.Color, as: DesignColor
  alias Corex.Design.Filter
  alias Corex.Design.Keys
  alias Corex.Design.Theme

  @roles Filter.default_semantic_strings()
  @structural Filter.structural_strings()
  @cache_key_normal {__MODULE__, :generate, :normal}
  @cache_key_more {__MODULE__, :generate, :more}

  @more_text_factor 1.4
  @more_text_floor 4.5
  @more_chrome_factor 1.5
  @more_chrome_floor 1.5

  @doc false
  def generate(opts \\ []) do
    contrast = Keyword.get(opts, :contrast, :normal)
    key = cache_key(contrast)

    case Process.get(key) do
      nil ->
        colors = do_generate(contrast)
        Process.put(key, colors)
        colors

      cached ->
        cached
    end
  end

  @doc false
  def clear_cache! do
    Process.delete(@cache_key_normal)
    Process.delete(@cache_key_more)
    :ok
  end

  defp cache_key(:normal), do: @cache_key_normal
  defp cache_key(:more), do: @cache_key_more

  defp do_generate(contrast) do
    for {theme_id, spec} <- Theme.resolved_themes(),
        mode <- Theme.modes(),
        into: %{} do
      mode_tokens = mode_token_map(spec, mode)
      {{theme_id, mode}, resolve_mode(spec.seeds, mode_tokens, contrast)}
    end
  end

  defp mode_token_map(spec, mode) do
    case Map.fetch!(spec.colors, mode) do
      %{tokens: tokens} when is_map(tokens) -> tokens
      %{} = other -> Map.new(other, fn {k, v} -> {to_string(k), v} end)
    end
  end

  defp resolve_mode(seeds, token_defs, contrast) do
    seeds = normalize_seeds(seeds)
    defs = normalize_defs(token_defs) |> filter_role_defs()

    {l_defs, contrast_defs} =
      Enum.split_with(defs, fn {_name, cfg} -> cfg.kind == :l end)

    acc =
      Enum.reduce(l_defs, %{}, fn {name, cfg}, tokens ->
        resolve_l_token(tokens, seeds, name, cfg)
      end)

    Enum.reduce(contrast_defs, acc, fn {name, cfg}, tokens ->
      resolve_contrast_token(tokens, seeds, name, cfg, contrast)
    end)
  end

  defp resolve_l_token(tokens, seeds, name, cfg) do
    seed = seed_hex(seeds, cfg.seed)

    case cfg.states do
      %{} = states when map_size(states) > 0 ->
        Enum.reduce(states, tokens, fn {state, lightness}, acc ->
          key = state_key(name, state)
          Map.put(acc, key, DesignColor.at_l(seed, lightness))
        end)
        |> maybe_put_default(name, seed, cfg)

      _ ->
        Map.put(tokens, name, DesignColor.at_l(seed, cfg.l))
    end
  end

  defp maybe_put_default(tokens, name, seed, cfg) do
    if Map.has_key?(tokens, name) do
      tokens
    else
      Map.put(tokens, name, DesignColor.at_l(seed, cfg.l))
    end
  end

  defp resolve_contrast_token(tokens, seeds, name, cfg, contrast) do
    seed = seed_hex(seeds, cfg.seed)
    bg = contrast_bg!(tokens, cfg.against)
    target = boost_target(name, cfg.target, contrast)

    {hex, _achieved} =
      if String.ends_with?(name, "-contrast") or String.ends_with?(name, "-text") do
        DesignColor.against_or_pick(seed, bg, target)
      else
        DesignColor.against(seed, bg, target)
      end

    Map.put(tokens, name, hex)
  end

  defp contrast_bg!(tokens, against) do
    key = to_string(against)

    if Map.has_key?(tokens, key) do
      Map.fetch!(tokens, key)
    else
      raise ArgumentError,
            "contrast against #{inspect(against)} missing; known: #{inspect(Map.keys(tokens))}"
    end
  end

  defp boost_target(_name, target, :normal), do: target * 1.0

  defp boost_target(name, target, :more) do
    cond do
      name in ~w(border focus shadow) ->
        max(target * @more_chrome_factor, @more_chrome_floor)

      true ->
        max(target * @more_text_factor, @more_text_floor)
    end
  end

  defp state_key(name, :default), do: name
  defp state_key(name, "default"), do: name
  defp state_key(name, state), do: "#{name}-#{state}"

  defp seed_hex(seeds, seed) do
    key = seed |> to_string() |> normalize_seed_name()

    if String.starts_with?(key, "#") do
      key
    else
      Map.fetch!(seeds, key)
    end
  end

  defp normalize_seeds(seeds) when is_map(seeds) do
    Map.new(seeds, fn {k, v} -> {normalize_seed_name(k), to_string(v)} end)
  end

  defp normalize_seed_name(key) when is_atom(key), do: normalize_seed_name(Atom.to_string(key))
  defp normalize_seed_name("base"), do: "neutral"
  defp normalize_seed_name(key) when is_binary(key), do: key

  defp normalize_defs(defs) when is_map(defs) do
    defs
    |> Enum.map(fn {name, cfg} -> {to_string(name), normalize_def(cfg)} end)
    |> Enum.reject(fn {_name, cfg} -> is_nil(cfg) end)
  end

  defp normalize_def(%{kind: kind} = cfg) when kind in [:l, :contrast] do
    cfg
    |> Map.update(:seed, "neutral", &normalize_seed_name/1)
    |> Map.update(:against, nil, fn
      nil -> nil
      value -> to_string(value)
    end)
    |> normalize_states()
  end

  defp normalize_def({:l, lightness}) do
    %{kind: :l, seed: "neutral", l: DesignColor.normalize_l!(lightness), states: %{}}
  end

  defp normalize_def({:l, lightness, opts}) when is_list(opts) do
    seed = Keyword.get(opts, :seed, :neutral)
    states = Keyword.get(opts, :states, %{})

    %{
      kind: :l,
      seed: normalize_seed_name(seed),
      l: DesignColor.normalize_l!(lightness),
      states: normalize_state_map(states)
    }
  end

  defp normalize_def({:contrast, opts}) when is_list(opts) do
    %{
      kind: :contrast,
      seed: normalize_seed_name(Keyword.fetch!(opts, :seed)),
      against: opts |> Keyword.fetch!(:against) |> to_string(),
      target: Keyword.fetch!(opts, :target) * 1.0
    }
  end

  defp normalize_def(%{} = cfg) do
    cond do
      Map.has_key?(cfg, :l) or Map.has_key?(cfg, "l") ->
        normalize_def(%{
          kind: :l,
          seed: Keys.get(cfg, :seed, Keys.get(cfg, :palette, :neutral)),
          l: Keys.get(cfg, :l) || Keys.get(cfg, :lightness),
          states: Keys.get(cfg, :states, %{})
        })

      Map.has_key?(cfg, :target) or Map.has_key?(cfg, :ratio) ->
        normalize_def(%{
          kind: :contrast,
          seed: Keys.get(cfg, :seed, Keys.get(cfg, :palette, :neutral)),
          against: Keys.get(cfg, :against, :root),
          target: Keys.get(cfg, :target) || Keys.get(cfg, :ratio)
        })

      true ->
        nil
    end
  end

  defp normalize_def(_), do: nil

  defp normalize_states(%{kind: :l} = cfg) do
    Map.update(cfg, :states, %{}, &normalize_state_map/1)
  end

  defp normalize_states(cfg), do: cfg

  defp normalize_state_map(states) when is_map(states) do
    Map.new(states, fn {k, v} -> {k, DesignColor.normalize_l!(v)} end)
  end

  defp normalize_state_map(_), do: %{}

  defp filter_role_defs(defs) do
    allowed = Filter.semantic_strings() |> MapSet.new()

    Enum.filter(defs, fn {name, _cfg} ->
      role_allowed?(name, allowed)
    end)
  end

  defp role_allowed?(name, _allowed) when name in @structural, do: true

  defp role_allowed?(name, allowed) do
    cond do
      name in @roles ->
        MapSet.member?(allowed, name)

      String.ends_with?(name, "-contrast") ->
        role = String.replace_suffix(name, "-contrast", "")
        role in @roles and MapSet.member?(allowed, role)

      String.ends_with?(name, "-text") ->
        role = String.replace_suffix(name, "-text", "")
        role in @roles and MapSet.member?(allowed, role)

      String.contains?(name, "-") ->
        role = name |> String.split("-") |> hd()
        role in @roles and MapSet.member?(allowed, role)

      true ->
        true
    end
  end
end
