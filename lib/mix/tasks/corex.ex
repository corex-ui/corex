defmodule Mix.Tasks.Corex do
  @shortdoc "Prints Corex help information"

  @moduledoc """
  Prints Corex tasks and their information.

      $ mix corex

  To print the Corex version, pass `-v` or `--version`:

      $ mix corex --version

  To create a new project with Corex, use the installer (install separately with `mix archive.install hex corex_new`). Example with Gettext/Localize i18n, mode, and themes:

      $ mix corex.new my_app --mode --theme

  See `Mix.Tasks.Corex.New` for all options.
  """

  use Mix.Task

  alias Mix.Tasks.Help

  @version Mix.Project.config()[:version]

  @impl true
  @doc false
  def run([version]) when version in ~W(-v --version) do
    Mix.shell().info("Corex v#{@version}")
  end

  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix corex")
    end
  end

  defp general do
    start_corex!()
    Mix.shell().info("Corex v#{Application.spec(:corex, :vsn)}")
    Mix.shell().info("Accessible and unstyled UI components library")
    Mix.shell().info("\n## Options\n")
    Mix.shell().info("-v, --version        # Prints Corex version\n")
    Help.run(["--search", "corex."])
  end

  defp start_corex! do
    case Application.ensure_all_started(:corex) do
      {:ok, _apps} -> :ok
      {:error, reason} -> Mix.raise("could not start :corex, got: #{inspect(reason)}")
    end
  end
end
