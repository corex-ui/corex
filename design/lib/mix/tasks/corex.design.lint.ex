defmodule Mix.Tasks.Corex.Design.Lint do
  use Mix.Task

  @shortdoc "Lints HEEx/Elixir templates for axis values outside resolved scales and theme roles"

  @moduledoc """
  Scans `lib/**/*.{ex,heex}` for style axis string literals and reports values
  that are not in the resolved `:corex_design` scale subset or theme role catalog.

  Run after changing `scales:` or `themes:` in config.

  ## Examples

      mix corex.design.lint
  """

  @impl true
  def run(_argv) do
    Mix.Task.run("app.config")

    if Corex.Design.configured?() do
      Corex.Design.Config.validate!()
      Corex.Design.Lint.run!()
      Mix.shell().info("Corex design lint passed")
    else
      Mix.shell().info("config :corex_design is empty; nothing to lint")
    end
  end
end
