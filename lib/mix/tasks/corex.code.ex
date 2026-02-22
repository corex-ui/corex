defmodule Mix.Tasks.Corex.Code do
  use Mix.Task

  @shortdoc "Generate and copy Makeup syntax highlighting stylesheet to your project"

  @default_path "assets/css/code_highlight.css"

  @moduledoc """
  Generates the full Makeup syntax highlighting stylesheet and writes it to your project.

  Run when you add or update Makeup language packages (e.g. makeup_elixir, makeup_html, makeup_css).

  Requires `makeup` and `makeup_elixir` in your deps.

  ## Examples

      # Default path (assets/css/code_highlight.css)
      mix corex.code

      # Custom path and filename
      mix corex.code assets/styles/syntax.css

      # Override if file already exists
      mix corex.code --force
      mix corex.code assets/css/code_highlight.css --force

  ## Import

  Add the generated file to your CSS (e.g. assets/css/app.css):

      @import "./code_highlight.css";

  Works with or without Corex Design. For unstyled projects, import only the highlight file.
  """

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, paths, _} =
      OptionParser.parse(args, switches: [force: :boolean])

    path = List.first(paths) || @default_path
    force = Keyword.get(opts, :force, false)
    full_path = Path.expand(path, File.cwd!())

    validate_makeup!()
    validate_path!(full_path, force)
    generate!(full_path)

    Mix.shell().info("Makeup stylesheet written to: #{path}")
  end

  defp validate_makeup! do
    makeup = Module.concat(["Elixir", "Makeup"])

    unless Code.ensure_loaded?(makeup) do
      Mix.raise("""
      Makeup is not available. Add to your mix.exs:

        defp deps do
          [
            {:makeup, "~> 1.2"},
            {:makeup_elixir, "~> 1.0.1 or ~> 1.1"}
          ]
        end
      """)
    end
  end

  defp validate_path!(full_path, force) do
    if File.exists?(full_path) and not force do
      Mix.raise("""
      #{full_path} already exists.

      Re-run with --force to overwrite.
      """)
    end
  end

  defp generate!(full_path) do
    makeup = Module.concat(["Elixir", "Makeup"])
    stylesheet = apply(makeup, :stylesheet, [:default_style])

    full_path
    |> Path.dirname()
    |> File.mkdir_p!()

    File.write!(full_path, stylesheet)
  end
end
