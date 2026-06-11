defmodule Mix.Tasks.Corex.Design.Config do
  use Mix.Task

  @shortdoc "Exports resolved config :corex, Corex.Design as JSON"

  @moduledoc """
  Exports the resolved design configuration for tooling and documentation.

  ## Examples

      mix corex.design.config
      mix corex.design.config --output /tmp/corex-design.json
  """

  @impl true
  def run(argv) do
    Mix.Task.run("app.config")

    {opts, _, _} =
      OptionParser.parse(argv,
        strict: [output: :string]
      )

    if Corex.Design.configured?() do
      payload = Corex.Design.Config.export()

      case Keyword.get(opts, :output) do
        nil ->
          Mix.shell().info(Jason.encode!(payload, pretty: true))

        path ->
          File.write!(path, Jason.encode!(payload, pretty: true) <> "\n")
          Mix.shell().info("Wrote #{path}")
      end
    else
      Mix.shell().info("config :corex, Corex.Design is empty; nothing to export")
    end
  end
end
