defmodule Corex.Json do
  @moduledoc false

  def encoder, do: Jason

  def encode!(term) do
    Jason.encode!(term)
  end

  def encode_to_iodata!(term) do
    if function_exported?(Jason, :encode_to_iodata!, 1) do
      Jason.encode_to_iodata!(term)
    else
      [Jason.encode!(term)]
    end
  end

  def decode!(iodata) when is_binary(iodata) or is_list(iodata) do
    iodata = if is_list(iodata), do: :erlang.iolist_to_binary(iodata), else: iodata
    Jason.decode!(iodata)
  end

  def decode(iodata) when is_binary(iodata) or is_list(iodata) do
    iodata = if is_list(iodata), do: :erlang.iolist_to_binary(iodata), else: iodata
    Jason.decode(iodata)
  end
end
