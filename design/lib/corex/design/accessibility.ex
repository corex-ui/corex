defmodule Corex.Design.Accessibility do
  @moduledoc """
  Allowlists, defaults, and sanitize/parse helpers for Design accessibility
  preference CSS (`data-text`, `data-contrast`, `data-motion`, `data-cursor`,
  `data-focus`, `data-links`).

  Enable emit with `config :corex_design, accessibility: true` (all six axes)
  or an axis list, then rebuild with `mix corex.design.build`. See the
  Accessibility guide on Corex Hexdocs for app wiring (plug, LiveView, bridge).
  """

  @axes [:text, :contrast, :motion, :cursor, :focus, :links]

  @values %{
    text: ~w(md lg),
    contrast: ~w(normal more),
    motion: ~w(system reduce),
    cursor: ~w(normal large),
    focus: ~w(normal strong),
    links: ~w(normal underline)
  }

  @defaults %{
    "text" => "md",
    "contrast" => "normal",
    "motion" => "system",
    "cursor" => "normal",
    "focus" => "normal",
    "links" => "normal"
  }

  @text_zooms %{"md" => 1.0, "lg" => 1.25}

  @doc """
  Enabled axes from resolved `config :corex_design, :accessibility`.

  `true` enables all known axes; `false` or missing yields `[]`.
  """
  def axes do
    case Corex.Design.Config.resolved().accessibility do
      axes when is_boolean(axes) or is_list(axes) -> normalize_axes(axes)
      _other -> []
    end
  end

  @doc "Whether any accessibility axes are enabled in config."
  def enabled?, do: axes() != []

  @doc "Whether `axis` is enabled in the current Design config."
  def axis_enabled?(axis) when is_atom(axis), do: axis in axes()

  @doc "All known accessibility axes (independent of config)."
  def known_axes, do: @axes

  @doc "Allowed string values for `axis`."
  def values(axis) when is_atom(axis), do: Map.fetch!(@values, axis)

  @doc "Default preference map for currently enabled axes (string keys)."
  def defaults do
    axes()
    |> Enum.map(fn axis ->
      {Atom.to_string(axis), Map.fetch!(@defaults, Atom.to_string(axis))}
    end)
    |> Map.new()
  end

  @doc "Default string value for `axis`."
  def default(axis) when is_atom(axis), do: Map.fetch!(@defaults, Atom.to_string(axis))

  @doc "Text zoom multiplier for a `data-text` step (`md` / `lg`)."
  def text_zoom(step) when is_binary(step), do: Map.get(@text_zooms, step, 1.0)

  @doc "HTML `data-*` attribute name for `axis`."
  def attr_name(axis) when is_atom(axis), do: "data-#{axis}"

  @doc """
  Parse a cookie / query blob or map into a sanitized preference map
  for enabled axes.
  """
  def parse(raw) when is_binary(raw) do
    raw
    |> decode_blob()
    |> sanitize()
  end

  def parse(map) when is_map(map), do: sanitize(map)
  def parse(_), do: defaults()

  @doc "Encode a preference map as a URI query blob (after sanitize)."
  def encode(map) when is_map(map) do
    map
    |> sanitize()
    |> URI.encode_query()
  end

  @doc """
  Keep only enabled axes and allowlisted values; fill missing keys from defaults.
  """
  def sanitize(map) when is_map(map) do
    enabled = axes() |> MapSet.new()

    Enum.reduce(enabled, defaults(), fn axis, acc ->
      key = Atom.to_string(axis)
      value = Map.get(map, key) || Map.get(map, axis) || Map.fetch!(@defaults, key)
      value = to_string(value)

      if value in Map.fetch!(@values, axis) do
        Map.put(acc, key, value)
      else
        Map.put(acc, key, Map.fetch!(@defaults, key))
      end
    end)
  end

  defp normalize_axes(false), do: []
  defp normalize_axes(true), do: @axes

  defp normalize_axes(axes) when is_list(axes) do
    allowed = MapSet.new(@axes)

    axes
    |> Enum.map(&normalize_axis/1)
    |> Enum.filter(&(&1 in allowed))
    |> Enum.uniq()
  end

  @doc """
  Axes enabled when config is `accessibility: true` (all known axes).
  """
  def preferred_axes, do: @axes

  defp normalize_axis(axis) when is_atom(axis), do: axis

  defp normalize_axis(axis) when is_binary(axis) do
    Enum.find(@axes, &(Atom.to_string(&1) == axis))
  end

  defp normalize_axis(_), do: nil

  defp decode_blob(raw) do
    raw
    |> URI.decode_query()
    |> Map.new(fn {k, v} -> {k, v} end)
  rescue
    _ -> %{}
  end
end
