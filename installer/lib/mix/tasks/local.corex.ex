defmodule Mix.Tasks.Local.Corex do
  use Mix.Task

  @shortdoc "Updates the Corex project generator locally"

  @moduledoc """
  Updates the Corex project generator locally.

      $ mix local.corex

  Accepts the same command line options as `archive.install hex corex_new`.
  """

  @impl true
  def run(args) do
    Mix.Task.run("archive.install", ["hex", "corex_new" | args])
  end
end
