defmodule Mix.Tasks.Corex.Design.Options do
  use Mix.Task

  @shortdoc "Lists valid config :corex_design values (components, semantics, themes, …)"

  @moduledoc """
  Prints allowed and current `config :corex_design` values for trimming the design bundle.

      $ mix corex.design.options

  Shows allowed `components:`, `semantics:`, theme presets, modes, size/radius steps,
  plus the values currently resolved from your app config.
  """

  @impl Mix.Task
  def run(_argv) do
    Mix.Task.run("app.start")
    Mix.shell().info(Corex.Design.Options.report())
    :ok
  end
end
