defmodule Mix.Tasks.Corex.Design.Validate do
  use Mix.Task

  @shortdoc "Validates config :corex_design without compiling CSS"

  @moduledoc """
  Validates theme and design pipeline configuration using NimbleOptions schemas.

  ## Examples

      mix corex.design.validate
  """

  @impl true
  def run(_argv) do
    Mix.Task.run("app.config")

    if Corex.Design.configured?() do
      Corex.Design.Config.validate!()
      Mix.shell().info("Corex design config is valid")
    else
      Mix.shell().info("config :corex_design is empty; nothing to validate")
    end
  end
end
