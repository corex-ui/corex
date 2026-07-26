defmodule Corex.Dataset do
  @moduledoc false

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

  @spec put_string(map(), String.t(), term()) :: map()
  def put_string(map, _key, nil), do: map
  def put_string(map, key, value), do: Map.put(map, key, to_string(value))

  @spec encode_json(term()) :: String.t() | nil
  def encode_json(nil), do: nil
  def encode_json(value), do: Corex.Json.encode!(value)
end
