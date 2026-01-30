defmodule Mix.Tasks.Corex.Design do
  use Mix.Task

  @shortdoc "Copies Corex design assets"

  @moduledoc """
  Copies Corex design assets.

      mix corex.design
      mix corex.design assets/design
      mix corex.design --force
      mix corex.design --designex
  """

  @default_target "assets/corex"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, paths, _} = parse_args(args)

    target = List.first(paths) || @default_target
    force = Keyword.get(opts, :force, false)
    designex = Keyword.get(opts, :designex, false)

    validate_source!()
    validate_target!(target, force)
    maybe_show_designex_info(designex)

    copy_design_files(target, designex)

    Mix.shell().info("Corex design copied to: #{target}")
  end

  defp parse_args(args) do
    OptionParser.parse(
      args,
      switches: [
        force: :boolean,
        designex: :boolean
      ]
    )
  end

  defp validate_source! do
    source = Application.app_dir(:corex, "priv/design")

    unless File.exists?(source) do
      Mix.raise("Corex priv/design directory not found")
    end
  end

  defp validate_target!(target, force) do
    if File.exists?(target) and not force do
      Mix.raise("""
      #{target} already exists.

      Re-run with --force to overwrite.
      """)
    end
  end

  defp maybe_show_designex_info(designex) do
    if designex and not designex_installed?() do
      Mix.shell().info("""
      To enable token builds, add to mix.exs:

      {:designex, "~> 1.0", only: :dev}
      """)
    end
  end

  defp copy_design_files(target, designex) do
    source = Application.app_dir(:corex, "priv/design")

    remove_if_exists(target)
    File.mkdir_p!(target)
    File.cp_r!(source, target)

    unless designex do
      remove_tokens(target)
    end
  end

  defp remove_if_exists(path) do
    if File.exists?(path) do
      File.rm_rf!(path)
    end
  end

  defp remove_tokens(target) do
    tokens_path = Path.join(target, "design")

    if File.exists?(tokens_path) do
      File.rm_rf!(tokens_path)
    end
  end

  defp designex_installed? do
    Code.ensure_loaded?(Designex)
  end
end
