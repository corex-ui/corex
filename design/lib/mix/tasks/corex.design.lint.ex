defmodule Mix.Tasks.Corex.Design.Lint do
  use Mix.Task

  @shortdoc "Lint HEEx style attr literals against design vocabulary"

  @moduledoc """
  Scans project templates for style attribute literals and compares them to
  the resolved vocabulary from `Corex.Design.Config.export/0`.

  ## Examples

      mix corex.design.lint
      mix corex.design.lint lib/my_app_web
  """

  @impl true
  def run(argv) do
    Mix.Task.run("app.config")

    unless Corex.Design.configured?() do
      Mix.shell().info("config :corex, Corex.Design is empty; nothing to lint")
      System.halt(0)
    end

    paths =
      case argv do
        [] -> ["lib"]
        args -> args
      end

    {:ok, issues} = Corex.Design.Lint.run(paths)

    if issues == [] do
      Mix.shell().info("Corex design lint passed (#{length(paths)} path(s))")
    else
      for {path, axis, value, message} <- issues do
        Mix.shell().error("#{path}: #{axis}=#{value} (#{message})")
      end

      Mix.raise("Corex design lint found #{length(issues)} issue(s)")
    end
  end
end
