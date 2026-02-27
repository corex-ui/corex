defmodule Mix.Tasks.Corex.Gen.Live do
  @shortdoc "Generates LiveView, templates, and context for a resource (Corex components)"

  @moduledoc """
  Generates LiveView, templates, and context for a resource.

  Same as `mix phx.gen.live` but uses Corex components when templates are installed.

  Corex templates must be installed first. Run `mix corex.install` if you see:

      Corex templates not found. Run mix corex.install first.

  See `mix help phx.gen.live` for options and examples.
  """
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    unless templates_exist?("phx.gen.live", "form.ex") do
      Mix.raise("""
      Corex templates not found. Run mix corex.install first.
      """)
    end

    Mix.Task.reenable("phx.gen.live")
    Mix.Task.run("phx.gen.live", args)
  end

  defp templates_exist?(template_dir, check_file) do
    base = templates_base_path()
    path = Path.join([base, "priv", "templates", template_dir, check_file])
    File.exists?(path)
  end

  defp templates_base_path do
    File.cwd!()
  end
end
