defmodule Mix.Tasks.Corex.New.Web do
  @moduledoc """
  Creates a new Phoenix web application inside an existing umbrella project.

  This task is only for use within an umbrella project. It must be run from the umbrella's `apps` directory. It creates a new web app (with Corex and Phoenix) that can depend on other apps in the umbrella. For a standalone project, use `mix corex.new` instead.

  It expects the name of the OTP app as the first argument:

      $ cd my_umbrella/apps
      $ mix corex.new.web APP [--module MODULE] [--app APP]

  The generated app is a bare Phoenix web project without database integration by default, which you can then wire to your umbrella's domain app(s).

  ## Examples

      $ mix corex.new.web hello_web

  Is equivalent to:

      $ mix corex.new.web hello_web --module HelloWeb

  For all available options (e.g. `--umbrella`, `--no-ecto`, `--theme`), see `Mix.Tasks.Corex.New`.
  """

  @shortdoc "Creates a new Phoenix web project within an umbrella project"

  use Mix.Task

  @impl true
  def run([]) do
    Mix.Tasks.Help.run(["corex.new.web"])
  end

  def run([path | _] = args) do
    unless Corex.New.Generator.in_umbrella?(path) do
      Mix.raise "The web task can only be run within an umbrella's apps directory"
    end

    Mix.Tasks.Corex.New.run(args, Corex.New.Web, :web_path)
  end
end
