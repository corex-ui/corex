defmodule Corex.Dataset do
  @moduledoc """
  Encode multi-value datasets for Corex component `data-*` attributes.

  Prefer `encode_json/1` when passing lists or maps into the DOM (select,
  combobox, listbox, tags, tree-view, color picker presets, and similar).
  """

  @doc """
  Maps a boolean to `"true"` / `"false"` for dataset attributes.
  """
  @spec bool_str(boolean()) :: String.t()
  def bool_str(true), do: "true"
  def bool_str(false), do: "false"

  @doc """
  Maps a boolean to its string, and anything else to `nil` so the attribute is
  omitted. For dataset fields whose value reaches the library unvalidated.
  """
  @spec optional_bool_str(term()) :: String.t() | nil
  def optional_bool_str(value) when is_boolean(value), do: bool_str(value)
  def optional_bool_str(_value), do: nil

  @doc """
  Puts `to_string(value)` under `key` when `value` is not `nil`.
  """
  @spec put_string(map(), String.t(), term()) :: map()
  def put_string(map, _key, nil), do: map
  def put_string(map, key, value), do: Map.put(map, key, to_string(value))

  @doc """
  JSON-encodes `value` for a dataset attribute, or `nil` when the value is `nil`
  (attribute omitted).
  """
  @spec encode_json(term()) :: String.t() | nil
  def encode_json(nil), do: nil
  def encode_json(value), do: Corex.Json.encode!(value)
end
