defmodule Mix.Tasks.Corex.Gen.Auth do
  @shortdoc "Generates authentication (Corex components)"

  @moduledoc """
  Generates authentication for a Phoenix application.

  Same as `mix phx.gen.auth` but uses Corex components when templates are installed.

  Corex templates must be installed first. Run `mix corex.install` if you see:

      Corex templates not found. Run mix corex.install first.

  See `mix help phx.gen.auth` for options and examples.
  """
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    unless templates_exist?("phx.gen.auth", "auth.ex") do
      Mix.raise("""
      Corex templates not found. Run mix corex.install first.
      """)
    end

    Mix.Task.reenable("phx.gen.auth")
    Mix.Task.run("phx.gen.auth", args)
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
