defmodule Mix.Tasks.Corex.Design.Build do
  use Mix.Task

  @shortdoc "Builds Corex design CSS bundle (generated tokens + static anatomy)"

  @moduledoc """
  Generates the Corex design bundle from Elixir theme config and shipped anatomy CSS.

  ## Options

    * `--output` — destination directory (default from `config :corex_design` or `assets/corex`)
    * `--config` — path to an Elixir config script whose keyword list is applied as `config :corex_design`
  """

  @impl Mix.Task
  def run(argv) do
    Mix.Task.run("app.start")

    {opts, _argv} =
      OptionParser.parse!(argv, strict: [output: :string, config: :string])

    maybe_load_config!(Keyword.get(opts, :config))
    Corex.Design.Config.validate!()

    output =
      opts
      |> Keyword.get(:output)
      |> case do
        nil -> Corex.Design.output_path()
        path -> Path.expand(path)
      end

    Corex.Design.Bundle.write!(output)
    Mix.shell().info("Wrote Corex design bundle to #{Path.relative_to_cwd(output)}")
    :ok
  end

  defp maybe_load_config!(nil), do: :ok

  defp maybe_load_config!(path) do
    {config, _} = Code.eval_file(Path.expand(path))

    unless is_list(config) do
      Mix.raise("Expected #{path} to evaluate to a keyword list")
    end

    for {key, value} <- config do
      Application.put_env(:corex_design, key, value)
    end
  end
end
