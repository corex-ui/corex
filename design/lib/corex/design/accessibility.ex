defmodule Corex.Design.Accessibility do
  @moduledoc false

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

  @doc false
  def axes do
    Corex.Design.Config.resolved().accessibility
    |> normalize_axes()
  end

  @doc false
  def enabled?, do: axes() != []

  @doc false
  def axis_enabled?(axis) when is_atom(axis), do: axis in axes()

  @doc false
  def known_axes, do: @axes

  @doc false
  def values(axis) when is_atom(axis), do: Map.fetch!(@values, axis)

  @doc false
  def defaults do
    axes()
    |> Enum.map(fn axis ->
      {Atom.to_string(axis), Map.fetch!(@defaults, Atom.to_string(axis))}
    end)
    |> Map.new()
  end

  @doc false
  def default(axis) when is_atom(axis), do: Map.fetch!(@defaults, Atom.to_string(axis))

  @doc false
  def text_zoom(step) when is_binary(step), do: Map.get(@text_zooms, step, 1.0)

  @doc false
  def attr_name(axis) when is_atom(axis), do: "data-#{axis}"

  @doc false
  def parse(raw) when is_binary(raw) do
    raw
    |> decode_blob()
    |> sanitize()
  end

  def parse(map) when is_map(map), do: sanitize(map)
  def parse(_), do: defaults()

  @doc false
  def encode(map) when is_map(map) do
    map
    |> sanitize()
    |> URI.encode_query()
  end

  @doc false
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
  defp normalize_axes(nil), do: []
  defp normalize_axes(true), do: @axes

  defp normalize_axes(axes) when is_list(axes) do
    allowed = MapSet.new(@axes)

    axes
    |> Enum.map(&normalize_axis/1)
    |> Enum.filter(&(&1 in allowed))
    |> Enum.uniq()
  end

  defp normalize_axes(_), do: []

  @doc false
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
