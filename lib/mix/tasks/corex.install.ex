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

    By default, Corex overrides root layout, layouts, and DaisyUI (convenient for new projects).
    Use `--preserve` to keep your layouts, app.css, app.js, and DaisyUI; Corex adds its own
    CorexLayouts, corex_app.css, corex_app.js, and /corex route.

    ## Options

      * `--no-design` - skip copying Corex design files (does not touch daisyUI or add data-theme/data-mode)
      * `--preserve` - keep your layouts, app.css, app.js, DaisyUI; create CorexLayouts, corex_app.css/js, get "/corex"
      * `--designex` - include design tokens and build scripts in design/
      * `--mode` - enable light/dark mode (plug, script, toggle)
      * `--theme THEMES` - colon-separated themes (e.g. neo:uno). At least 2 values.
      * `--languages LANGUAGES` - colon-separated locales (e.g. en:fr:ar). At least 2 values.
      * `--rtl RTL` - RTL locale codes (e.g. ar)
      * `--prefix PREFIX` - prefix for Corex components (e.g. ui for <.ui_accordion>)
      * `--only COMPONENTS` - colon-separated component names (e.g. accordion:checkbox:dialog)
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
          preserve: :boolean,
          mode: :boolean,
          theme: :string,
          languages: :string,
          rtl: :string,
          prefix: :string,
          only: :string
        ],
        defaults: [design: true, preserve: false]
      }
    end

    @impl Igniter.Mix.Task
    def parse_argv(argv) do
      args = super(argv)
      validate_opts!(args.options)
      args
    end

    defp validate_opts!(opts) do
      if theme = Keyword.get(opts, :theme) do
        themes = String.split(theme, ":", trim: true)

        if length(themes) < 2 do
          Mix.raise("--theme requires at least 2 values (e.g. neo:uno), got: #{inspect(theme)}")
        end
      end

      if languages = Keyword.get(opts, :languages) do
        list = String.split(languages, ":", trim: true)

        if length(list) < 2 do
          Mix.raise(
            "--languages requires at least 2 values (e.g. en:fr:ar), got: #{inspect(languages)}"
          )
        end
      end

      if prefix = Keyword.get(opts, :prefix) do
        if prefix == "" or (is_binary(prefix) and String.trim(prefix) == "") do
          Mix.raise("--prefix must be non-empty, got: #{inspect(prefix)}")
        end
      end

      if only_str = Keyword.get(opts, :only) do
        parts = String.split(only_str, ":", trim: true)
        valid = Corex.component_keys() |> Enum.map(&to_string/1)
        invalid = Enum.reject(parts, &(&1 in valid))

        if invalid != [] do
          Mix.raise(
            "--only contains invalid components: #{inspect(invalid)}. Valid: #{inspect(valid)}"
          )
        end
      end
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      Corex.Igniter.install(igniter, igniter.args.options)
    end

    @impl Mix.Task
    def run(argv) do
      super(argv)
      Mix.Task.reenable("format")
      Mix.Task.run("format")
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
