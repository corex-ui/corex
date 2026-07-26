defmodule Corex.MCP.Json do
  @moduledoc """
  OTP `:json` wrapper that encodes `nil` as `null` and decodes `null` back to `nil`.

  Deliberately a copy of `Corex.Json` rather than a delegation: `corex_mcp` does
  not depend on `corex` (see README), so it cannot reach that module. The two
  must stay byte-compatible, which `test/json_parity_test.exs` enforces.
  """

  def encoder, do: __MODULE__

  def encode!(term) do
    IO.iodata_to_binary(encode_to_iodata!(term))
  end

  def encode_to_iodata!(term) do
    :json.encode(term, &encode_value/2)
  end

  def decode!(iodata) when is_binary(iodata) or is_list(iodata) do
    binary = if is_list(iodata), do: IO.iodata_to_binary(iodata), else: iodata
    binary |> :json.decode() |> normalize_decode()
  end

  def decode(iodata) when is_binary(iodata) or is_list(iodata) do
    {:ok, decode!(iodata)}
  rescue
    e -> {:error, e}
  end

  defp encode_value(nil, encode), do: :json.encode_value(:null, encode)
  defp encode_value(other, encode), do: :json.encode_value(other, encode)

  defp normalize_decode(:null), do: nil

  defp normalize_decode(list) when is_list(list) do
    Enum.map(list, &normalize_decode/1)
  end

  defp normalize_decode(map) when is_map(map) do
    Map.new(map, fn {key, value} -> {key, normalize_decode(value)} end)
  end

  defp normalize_decode(other), do: other
end
