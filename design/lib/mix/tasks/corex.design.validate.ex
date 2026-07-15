defmodule Mix.Tasks.Corex.Design.Validate do
  use Mix.Task

  @shortdoc "Validates Corex design host config"

  @moduledoc """
  Validates `config :corex_design` and prints contrast warnings.

      $ mix corex.design.validate
  """

  @impl Mix.Task
  def run(_argv) do
    Mix.Task.run("app.start")
    Corex.Design.Config.validate!()

    for warning <- Corex.Design.Tokens.Contrast.check!() do
      Mix.shell().info([
        :yellow,
        "warning: ",
        :reset,
        "contrast [#{warning.theme}/#{warning.mode}] #{warning.fg} on #{warning.bg}: " <>
          "#{Float.round(warning.ratio, 2)}:1 (target #{warning.target}:1) -- #{warning.label}"
      ])
    end

    Mix.shell().info("Corex design config is valid")
    :ok
  end
end
