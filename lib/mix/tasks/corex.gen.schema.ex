defmodule Mix.Tasks.Corex.Gen.Schema do
  @shortdoc "Generates an Ecto schema and migration file"

  @moduledoc """
  Delegates to `mix phx.gen.schema`. Schema and migration generation use Phoenix's implementation.

  Run `mix phx.gen.schema` directly for the same behavior. See `mix help phx.gen.schema` for options and examples.
  """

  use Mix.Task

  @doc false
  def run(args), do: Mix.Tasks.Phx.Gen.Schema.run(args)
end
