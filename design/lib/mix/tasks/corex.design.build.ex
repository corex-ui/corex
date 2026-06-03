defmodule Mix.Tasks.Corex.Design.Build do
  use Mix.Task

  @shortdoc "Builds Corex design CSS bundles (tokens, theme, recipes)"

  @moduledoc """
  Generates the Tailwind v4 design bundle from the Corex Elixir model.

  ## Options

    * `--output` — destination path (default `assets/css/corex.tailwind.theme.css`)
    * `--no-recipes` — emit tokens and `@theme` only, without the recipe layer
  """

  @requirements ["app.config"]

  @impl Mix.Task
  def run(argv) do
    {opts, argv} =
      OptionParser.parse!(argv, strict: [output: :string])

    include_recipes? = "--no-recipes" not in argv
    output = Keyword.get(opts, :output, "assets/css/corex.tailwind.theme.css")
    dir = Path.dirname(Path.expand(output))

    alias Corex.Design.Compiler

    File.mkdir_p!(dir)
    Compiler.write_tailwind_modular!(dir)

    unless include_recipes? do
      File.rm_rf!(Path.join(dir, "recipes"))
      File.rm_rf!(Path.join(dir, "aggregates"))
    end

    Mix.shell().info("Wrote Corex design bundle under #{dir}")
    :ok
  end
end
