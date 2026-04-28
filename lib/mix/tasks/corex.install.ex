if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Corex.Install do
    use Igniter.Mix.Task

    alias Mix.Corex.Install.Pipeline, as: CorexInstallPipeline

    @shortdoc "Installs Corex into a Phoenix application (used via mix igniter.install corex)"

    @moduledoc """
    Installs Corex into an existing Phoenix application: dependencies, Phoenix defaults, Esbuild ESM and splitting, `assets/js/app.js` hooks, `use Corex` in the web module, root layout, optional Corex Design assets, and optional layout and endpoint changes.

    Registered as an [Igniter](https://hexdocs.pm/igniter) task in group **`corex`**. Invoke it through Igniter, for example:

        mix igniter.install corex --yes
        mix igniter.install corex --mode --theme --lang --yes

    Corex flags are uniquely named and **do not conflict** with `phx.new` or Igniter switches, so you can pass them bare (no `--corex.` prefix). A path dependency is written as `mix igniter.install corex@path:../corex`.

    For the same setup without the installer, see the **Manual installation** guide in the docs.

    ## Flags

    * `--design` / **`--no-design`** — install the Corex Design system: copy assets into `assets/corex/`, strip stock daisy/Tailwind plugins, and replace `assets/css/app.css` with the Corex design entry. **Default: on**. With `--no-design`, the stock Phoenix Tailwind/daisy setup is left untouched and `assets/corex/` is not created.
    * `--designex` — also copy the design token sources into `assets/corex/design/`; implies `--design`. To refresh design assets to a newer Corex version, remove `assets/corex/` and re-run with `--design`.
    * **`--mode`** — generate `Plugs.Mode`, mode toggle, and `data-mode` bridge in the root layout. **Implies `--design`** (with a notice).
    * **`--theme`** — enable themes (Neo/Uno/Duo/Leo), `Plugs.Theme`, theme toggle, and `data-theme` bridge. **Implies `--design`** (with a notice).
    * **`--lang`** — set up Localize + Gettext (`Plugs.Path`, locale-aware router helpers, layout `lang/dir` and `language_switch` component). Does **not** imply `--design`.
    * `--mcp` / **`--no-mcp`** — add the Corex MCP plug under `Mix.env() == :dev`. **Default: on**.

    ## Layout patching

    The installer always patches `Layouts.app` and `home.html.heex`:

    * If they match a stock Phoenix 1.8 template, they are fully replaced with the Corex layout.
    * Otherwise (already touched by Corex or by you), only the missing flag-driven pieces are added (switchers, attrs, declarations). User customizations are preserved.

    If an anchor cannot be found for an additive insertion, the installer prints a notice with the exact snippet to add manually.

    ## Idempotency

    Re-running `mix igniter.install corex` with the same flags makes no diffs to the project. Re-running with new UI flags (e.g. add `--lang` later) only adds the new bits; previously enabled features are preserved.

    If the install stopped early (for example before `assets/js/app.js` was updated), run **`mix igniter.install corex --yes`** again with the same options.
    """

    @impl true
    def supports_umbrella?, do: true

    @impl true
    def info(_argv, _source) do
      %Igniter.Mix.Task.Info{
        group: :corex,
        example: "mix igniter.install corex --yes --mode",
        composes: ["igniter.add_extension"],
        defaults: [
          mcp: true,
          design: true,
          designex: false,
          mode: false,
          theme: false,
          lang: false
        ],
        schema: [
          design: :boolean,
          designex: :boolean,
          mode: :boolean,
          theme: :boolean,
          lang: :boolean,
          mcp: :boolean
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
