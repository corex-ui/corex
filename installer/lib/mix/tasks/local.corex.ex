defmodule Mix.Tasks.Local.Corex do
  use Mix.Task

  @shortdoc "Updates the Corex project generator locally"

  @moduledoc """
  Updates the Corex project generator used by `mix corex.new`.

  Run this when you want the next `mix corex.new` to use the latest generator templates and options. It delegates to `archive.install hex corex_new` and accepts the same command line options (e.g. `--force` to reinstall without prompting).

      $ mix local.corex
  """

  @impl true
  def run(args) do
    Mix.Task.run("archive.install", ["hex", "corex_new" | args])
  end
end
