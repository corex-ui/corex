defmodule Mix.Tasks.Corex do
  use Mix.Task

  @shortdoc "Prints Corex help information"

  @moduledoc """
  Prints Corex tasks and their information.

      $ mix corex

  To print the Corex version, pass `-v` or `--version`:

      $ mix corex --version

  To create a new project with Corex, use the installer (install separately with `mix archive.install hex corex_new`). Example with locale switching, RTL, mode, and themes:

      $ mix corex.new my_app --lang en:fr:ar --rtl ar --mode --theme neo:uno:duo:leo

  See `Mix.Tasks.Corex.New` for all options.
  """

  @version Mix.Project.config()[:version]

  alias Mix.Tasks.Help

  @impl true
  @doc false
  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Corex v#{@version}")
  end

  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix corex")
    end
  end

  defp general do
    Application.ensure_all_started(:corex)
    Mix.shell().info("Corex v#{Application.spec(:corex, :vsn)}")
    Mix.shell().info("Accessible and unstyled UI components library")
    Mix.shell().info("\n## Options\n")
    Mix.shell().info("-v, --version        # Prints Corex version\n")
    Help.run(["--search", "corex."])
  end
end
