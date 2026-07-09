defmodule Mix.Tasks.Corex.Design.Validate do
  use Mix.Task

  @shortdoc "Validates Corex design host config"

  @impl Mix.Task
  def run(_argv) do
    Mix.Task.run("app.start")
    Corex.Design.Config.validate!()
    Mix.shell().info("Corex design config is valid")
    :ok
  end
end
