defmodule Corex.Json do
  @moduledoc false

  @jason_mod String.to_atom("Elixir.Jason")

  def encoder do
    if Code.ensure_loaded?(Phoenix) and function_exported?(Phoenix, :json_library, 0) do
      Phoenix.json_library()
    else
      Application.get_env(:phoenix, :json_library) || Application.get_env(:corex, :json_library) ||
        default_json_module!()
    end
  end

  def encode!(term) do
    encoder().encode!(term)
  end

  def encode_to_iodata!(term) do
    mod = encoder()

    if function_exported?(mod, :encode_to_iodata!, 1) do
      mod.encode_to_iodata!(term)
    else
      [encode!(term)]
    end
  end

  def decode!(iodata) when is_binary(iodata) or is_list(iodata) do
    mod = encoder()
    iodata = if is_list(iodata), do: :erlang.iolist_to_binary(iodata), else: iodata
    mod.decode!(iodata)
  end

  def decode(iodata) when is_binary(iodata) or is_list(iodata) do
    mod = encoder()
    iodata = if is_list(iodata), do: :erlang.iolist_to_binary(iodata), else: iodata

    if function_exported?(mod, :decode, 1) do
      mod.decode(iodata)
    else
      {:ok, mod.decode!(iodata)}
    end
  end

  defp default_json_module! do
    if Code.ensure_loaded?(@jason_mod) do
      @jason_mod
    else
      raise """
      No JSON module found. Add {:jason, "~> 1.0"} to your deps, or set \
      config :phoenix, :json_library, MyJson in config, or set \
      config :corex, :json_library, MyJson (e.g. when not using Phoenix). \
      """
    end
  end
end
