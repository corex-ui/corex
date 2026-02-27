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

    Generate living documentation for the installer:

        mix corex.install --scribe documentation/guides/installation.md

    ## Options

      * `--no-design` - skip copying Corex design files to assets/corex
      * `--designex` - include design tokens and build scripts in design/
      * `--mode` - enable light/dark mode (plug, script, toggle)
      * `--theme THEMES` - colon-separated themes (e.g. neo:uno). At least 2 values.
      * `--languages LANGUAGES` - colon-separated locales (e.g. en:fr:ar). At least 2 values.
      * `--rtl RTL` - RTL locale codes (e.g. ar)
      * `--no-daisy` - remove daisyUI CSS, vendor files, and theme switch script
    """
    use Igniter.Mix.Task

    @manual_lead_in """
    This guide walks you through installing Corex into a Phoenix project.
    You can run these steps manually or use `mix igniter.install corex` to apply them interactively.
    """

    @setup_project """
    Corex adds gettext if missing, runs `mix corex.design` to copy design assets,
    copies Phoenix generator templates (phx.gen.html, phx.gen.live, phx.gen.auth),
    and adds optional plugs and LiveView hooks for mode, theme, and locale.
    """

    @config_corex """
    Configures the `:corex` application in config/config.exs with gettext_backend,
    json_library, and optionally rtl_locales when using the --rtl option.
    """

    @app_js_esbuild """
    Patches assets/js/app.js to import Corex and register its LiveView hooks,
    and updates the esbuild config to use --format=esm --splitting.
    """

    @root_layout_helpers """
    Patches the root layout (script type, html data-theme/data-mode) and the web
    module to add `use Corex` for component helpers.
    """

    @app_css_daisy """
    Adds Corex CSS imports when using design, switches theme script to data-mode
    when applicable, and optionally removes daisyUI CSS and vendor files (--no-daisy).
    """

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
          daisy: :boolean,
          mode: :boolean,
          theme: :string,
          languages: :string,
          rtl: :string
        ],
        defaults: [design: true, daisy: true]
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
      igniter
      |> Igniter.Scribe.start_document("Manual Installation", @manual_lead_in, app_name: :my_app)
      |> Igniter.Scribe.section(
        "Setup project (gettext, design, templates, plugs)",
        @setup_project,
        fn igniter ->
          Igniter.Scribe.patch(igniter, fn igniter ->
            Corex.Igniter.run_setup_phase(igniter, igniter.args.options)
          end)
        end
      )
      |> Igniter.Scribe.section("Configure Corex", @config_corex, fn igniter ->
        Igniter.Scribe.patch(igniter, fn igniter ->
          Corex.Igniter.run_config_phase(igniter, igniter.args.options)
        end)
      end)
      |> Igniter.Scribe.section("Patch app.js and esbuild", @app_js_esbuild, fn igniter ->
        Igniter.Scribe.patch(igniter, fn igniter ->
          Corex.Igniter.run_assets_phase(igniter, igniter.args.options)
        end)
      end)
      |> Igniter.Scribe.section(
        "Patch root layout and HTML helpers",
        @root_layout_helpers,
        fn igniter ->
          Igniter.Scribe.patch(igniter, fn igniter ->
            Corex.Igniter.run_layout_phase(igniter, igniter.args.options)
          end)
        end
      )
      |> Igniter.Scribe.section("Patch app CSS and remove daisy", @app_css_daisy, fn igniter ->
        Igniter.Scribe.patch(igniter, fn igniter ->
          Corex.Igniter.run_css_phase(igniter, igniter.args.options)
        end)
      end)
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
