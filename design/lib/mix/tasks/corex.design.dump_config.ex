defmodule Mix.Tasks.Corex.Design.DumpConfig do
  use Mix.Task

  @shortdoc "Exports resolved :corex_design config as JSON"

  @moduledoc """
  Dumps the resolved design configuration for tooling and documentation.

  ## Examples

      mix corex.design.dump-config
      mix corex.design.dump-config --output /tmp/corex-design.json
  """

  @impl true
  def run(argv) do
    Mix.Task.run("app.config")

    {opts, _, _} =
      OptionParser.parse(argv,
        strict: [output: :string]
      )

    payload = Corex.Design.DumpConfig.export()

    case Keyword.get(opts, :output) do
      nil ->
        Mix.shell().info(Jason.encode!(payload, pretty: true))

      path ->
        File.write!(path, Jason.encode!(payload, pretty: true) <> "\n")
        Mix.shell().info("Wrote #{path}")
    end
  end
end
