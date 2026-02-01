defmodule Mix.Tasks.Corex.Design do
  use Mix.Task

  @shortdoc "Copy Corex design assets into your project"

  @moduledoc """
  Setup Corex design assets into your project.
  You can select a target directory, defaults to `assets/corex`.
  You can use the `--force` option to overwrite existing files.

  ## Examples

  ```bash
  mix corex.design
  mix corex.design assets/design
  mix corex.design --force
  mix corex.design --designex
  ```

  ## With Design Tokens

  You can also generate Tailwind CSS tokens and utilities from design tokens directly in Elixir using
  Style Dictionary and Token Studio.

  First install designex, add to your `mix.exs`:
  ```elixir
  def deps do
    [
      {:designex, "~> 1.0", only: :dev}
    ]
  end
  ```

    Add the configuration for Designex

  ```elixir
  config :designex,
  version: "1.0.2",
  commit: "1da4b31",
  cd: Path.expand("../assets", __DIR__),
  dir: "corex",
  corex: [
  build_args: ~w(
  --dir=design
  --script=build.mjs
  --tokens=tokens
  )
  ]
  ```

  Then run the task with the `--designex` option:
  This will copy the Corex design file including the design tokens and build scripts
  You may have to use the `--force` option to overwrite existing files.

  ```bash
  mix corex.design --designex
  mix corex.design --designex --force
  ```


  You can now build the design tokens

  ```bash
  mix designex corex
  ```

  Optionally you can add the build into your assets build pipeline by adding the following to your `mix.exs`:

  ```elixir
  "assets.build": ["compile", "tailwind my_app", "esbuild my_app", "designex corex"],
  ```

  the `designex corex` task will be run automatically when you run `mix assets.build`.

  You can also watch for changes in the design tokens by adding the following to your `config/dev.exs`:

  ```elixir
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:my_app, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:my_app, ~w(--watch)]},
    designex: {Designex, :install_and_run, [:corex, ~w(--watch)]}
  ]
  ```


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
