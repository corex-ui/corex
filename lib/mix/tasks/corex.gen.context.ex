defmodule Mix.Tasks.Corex.Gen.Context do
  @shortdoc "Generates a context with functions around an Ecto schema"

  @moduledoc """
  Delegates to `mix phx.gen.context`. Context and schema generation use Phoenix's implementation.

  Run `mix phx.gen.context` directly for the same behavior. See `mix help phx.gen.context` for options and examples.
  """

  use Mix.Task

  @doc false
  def run(args), do: Mix.Tasks.Phx.Gen.Context.run(args)
end
