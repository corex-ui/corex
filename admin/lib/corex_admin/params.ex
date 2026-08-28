defmodule CorexAdmin.Params do
  @moduledoc """
  Parameter normalization shared by list state, attrs, export, and history.

  Admin state travels through URL params, LiveView events, and Plug params, which
  disagree about whether keys are atoms or strings. Every layer normalizes to
  string keys through this module so comparisons and merges are total.
  """

  @doc """
  String-keyed shallow copy of `map`. Non-maps become `%{}`.

  Nested maps are converted too, so a params map is safe to compare with
  `==` after a round trip.
  """
  @spec stringify(term()) :: map()
  def stringify(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {key, value} -> {to_key(key), stringify_value(value)} end)
  end

  def stringify(_), do: %{}

  @doc """
  String-keyed copy of `map` without descending into nested values.

  Use when nested values must keep their original shape (lists of structs, for
  example) and only the top level is addressed by string key.
  """
  @spec stringify_shallow(term()) :: map()
  def stringify_shallow(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {key, value} -> {to_key(key), value} end)
  end

  def stringify_shallow(_), do: %{}

  @doc "Whether a param value carries no information."
  @spec blank?(term()) :: boolean()
  def blank?(nil), do: true
  def blank?(""), do: true
  def blank?([]), do: true
  def blank?(map) when map == %{}, do: true
  def blank?(_), do: false

  @doc """
  Collapses LiveView event payload noise into a plain value.

  Zag components post single values as one-element lists and cleared values as
  `""` or `[]`; both mean "no value".
  """
  @spec normalize(term()) :: term()
  def normalize(nil), do: nil
  def normalize(""), do: nil
  def normalize([]), do: nil
  def normalize([value]), do: value
  def normalize(value), do: value

  @doc "Puts `value` under `key`, or removes `key` when the value is nil."
  @spec put_or_delete(map(), term(), term()) :: map()
  def put_or_delete(map, key, nil), do: Map.delete(map, to_key(key))
  def put_or_delete(map, key, value), do: Map.put(map, to_key(key), value)

  @doc """
  First scalar in a Corex `on_*_change` payload.

  Returns `nil` when the payload carries no usable value.
  """
  @spec event_value(map()) :: String.t() | nil
  def event_value(params) when is_map(params) do
    case Map.get(params, "value") do
      [value | _] -> to_string(value)
      value when is_binary(value) -> value
      value when is_atom(value) and not is_nil(value) -> Atom.to_string(value)
      value when is_number(value) -> to_string(value)
      _ -> nil
    end
  end

  def event_value(_), do: nil

  defp to_key(key) when is_binary(key), do: key
  defp to_key(key) when is_atom(key), do: Atom.to_string(key)
  defp to_key(key), do: to_string(key)

  defp stringify_value(value) when is_map(value) and not is_struct(value), do: stringify(value)
  defp stringify_value(value), do: value
end
