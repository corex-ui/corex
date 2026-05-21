defmodule Corex.Dataset do
  @moduledoc false

  @spec bool_str(boolean()) :: String.t()
  def bool_str(true), do: "true"
  def bool_str(false), do: "false"

  @spec put_bool(map(), String.t(), boolean()) :: map()
  def put_bool(map, key, value), do: Map.put(map, key, bool_str(value))

  @spec put_string(map(), String.t(), term()) :: map()
  def put_string(map, _key, nil), do: map
  def put_string(map, key, value), do: Map.put(map, key, to_string(value))

  @spec encode_json(term()) :: String.t() | nil
  def encode_json(nil), do: nil
  def encode_json(value), do: Corex.Json.encode!(value)
end
