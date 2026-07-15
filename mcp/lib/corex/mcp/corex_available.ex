defmodule Corex.MCP.CorexAvailable do
  @moduledoc false

  @corex :"Elixir.Corex"

  def corex_available? do
    match?({:module, _}, Code.ensure_loaded(@corex))
  end

  def ensure_corex do
    if corex_available?() do
      :ok
    else
      {:error, "corex is not loaded. Add {:corex, \"~> 0.2\"} to mix.exs."}
    end
  end

  def call(fun, args \\ []) when is_atom(fun) and is_list(args) do
    apply(@corex, fun, args)
  end
end
