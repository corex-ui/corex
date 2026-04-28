if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Corex.Install do
    use Igniter.Mix.Task

    alias Mix.Corex.Install.Pipeline, as: CorexInstallPipeline

    @shortdoc "Installs Corex into a Phoenix application (used via mix igniter.install corex)"

    @moduledoc """
    Installs Corex into an existing Phoenix application: dependencies, Phoenix defaults, Esbuild ESM and splitting, `assets/js/app.js` hooks, `use Corex` in the web module, root layout, optional Corex Design assets, and optional layout and endpoint changes.

    Registered as an [Igniter](https://hexdocs.pm/igniter) task in group **`corex`**. Invoke it through Igniter, for example:

        mix igniter.install corex --yes

    Pass Corex-specific options with the `--corex.*` prefix when Igniter asks you to disambiguate (see `mix help igniter.install`). A path dependency can be written as `mix igniter.install corex@path:../corex`.

    For the same setup without the installer, see the **Manual installation** guide in the docs.

    ## Flags

    * `--no-design` — skip running `mix corex.design` after install
    * `--designex` — pass `--designex` to `mix corex.design`
    * **`--replace` / `--no-replace`** — control whether the stock home and app layout are switched to the Corex-oriented layout and toast pattern (`--replace` is the default for `mix corex.new`); with `--no-replace`, a separate `/home` demo route and `Layouts.corex` are added instead
    * **`--no-mcp`** — do not add the Corex MCP plug in `dev` on the web endpoint (default is to add it)
    * **`--refresh-templates`** — overwrite an existing generated Corex starter HEEx file if present (default: keep existing files)

    Additional Corex-related switches exist; see **`mix help igniter.install`** when multiple installers share option names.

    If the install stopped early (for example before `assets/js/app.js` was updated), run **`mix igniter.install corex --yes`** again with the same options.
    """

    @impl true
    def supports_umbrella?, do: true

    @impl true
    def info(_argv, _source) do
      %Igniter.Mix.Task.Info{
        group: :corex,
        example: "mix igniter.install corex --yes --corex.replace --corex.mode",
        composes: ["igniter.add_extension"],
        defaults: [
          replace: true,
          mcp: true,
          design: true,
          designex: false,
          mode: false,
          theme: false,
          lang: false,
          refresh_templates: false
        ],
        schema: [
          design: :boolean,
          designex: :boolean,
          replace: :boolean,
          mode: :boolean,
          theme: :boolean,
          lang: :boolean,
          mcp: :boolean,
          refresh_templates: :boolean
        ]
      }
    end

    @impl true
    def igniter(igniter) do
      CorexInstallPipeline.igniter(igniter)
    end
  end
else
  defmodule Mix.Tasks.Corex.Install do
    use Mix.Task

    @moduledoc """
    Installs Corex into a Phoenix project via `mix igniter.install corex`.

    This build of the `corex` package was compiled without the [Igniter](https://hexdocs.pm/igniter) dependency, so the Igniter task interface is not available. Add `{:igniter, "~> 0.6", only: [:dev, :test]}` (or similar), then run `mix igniter.install corex` from a dev/test build so this module is compiled with Igniter present.
    """

    @shortdoc "Installs Corex into a Phoenix application (requires Igniter)"

    def run(_args) do
      Mix.shell().error("""
      `mix igniter.install corex` requires the Igniter task implementation.

      Add `{:igniter, "~> 0.6", only: [:dev, :test]}` to your deps, ensure `MIX_ENV` is `dev` or `test` for that compile, and run:

          mix archive.install hex igniter_new
          mix igniter.install corex
      """)

      exit({:shutdown, 1})
    end
  end
end
