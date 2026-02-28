if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Corex.Install do
    @shortdoc "Installs Corex into a Phoenix project"
    @moduledoc """
    Installs Corex into an existing Phoenix project.

    Run this after `mix phx.new` or use Igniter:

        mix corex.install
        mix igniter.install corex

    Add `--yes` to apply changes without prompting. To test with a local Corex source
    (e.g. before publishing to Hex):

        mix igniter.install corex@path:../corex

    ## Options

      * `--no-design` - skip copying Corex design files (does not touch daisyUI or add data-theme/data-mode)
      * `--designex` - include design tokens and build scripts in design/
      * `--mode` - enable light/dark mode (plug, script, toggle)
      * `--theme THEMES` - colon-separated themes (e.g. neo:uno). At least 2 values.
      * `--languages LANGUAGES` - colon-separated locales (e.g. en:fr:ar). At least 2 values.
      * `--rtl RTL` - RTL locale codes (e.g. ar)
    """
    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def supports_umbrella?, do: true

    @impl Igniter.Mix.Task
    def info(_argv, _parent) do
      %Igniter.Mix.Task.Info{
        group: :corex,
        composes: [],
        schema: [
          design: :boolean,
          designex: :boolean,
          mode: :boolean,
          theme: :string,
          languages: :string,
          rtl: :string
        ],
        defaults: [design: true]
      }
    end

    @impl Igniter.Mix.Task
    def parse_argv(argv) do
      args = super(argv)
      Corex.Igniter.validate_opts!(args.options)
      args
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      Corex.Igniter.install(igniter, igniter.args.options)
    end
  end
else
  defmodule Mix.Tasks.Corex.Install do
    @moduledoc "Installs Corex into a Phoenix project. Run with: mix igniter.install corex"
    @shortdoc @moduledoc

    use Mix.Task

    def run(_argv) do
      Mix.shell().error("""
      The task 'corex.install' requires igniter.

      Run: mix igniter.install corex

      See https://hexdocs.pm/igniter
      """)

      Mix.raise("corex.install requires igniter")
    end
  end
end
