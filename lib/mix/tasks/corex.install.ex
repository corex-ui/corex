if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Corex.Install do
    use Igniter.Mix.Task

    @shortdoc "Installs Corex into a Phoenix application (used via mix igniter.install corex)"

    @moduledoc """
    Patches a Phoenix project to use Corex: config, esbuild ESM, hooks, `use Corex`, and optional theme/mode plugs.

    This task is registered in group **`corex`** (see [Writing generators / task groups](https://hexdocs.pm/igniter/writing-generators.html)). When more than one installer could own the same flag, you may be asked to pass disambiguated options (for example `--corex.…`); follow the on-screen hint from `mix igniter.install`.

    Typically invoked as:

        mix igniter.install corex --yes

    Pass Corex flags like `--replace`, `--mode`, `--no-mcp`, and `--theme` the same way you would with `mix corex.new`:

        mix igniter.install corex@path:../corex --yes --corex.replace --corex.mode --corex.theme neo:uno

    If you are installing multiple packages and hit a flag conflict, Igniter will instruct you to disambiguate. See `mix help igniter.install`.

    If you are authoring or extending a generator, compare with `mix igniter.gen.task` and [Igniter — Writing generators](https://hexdocs.pm/igniter/writing-generators.html) rather than a plain Mix task.

    ## Terminal diffs, `--yes`, and `--dry-run`

    Igniter only prints the **interactive** file diff when it is *not* applying in fully non-interactive mode. With **global** `--yes`, the task skips the green diff in the TTY and applies after treating confirmation as "yes" (see Igniter’s `do_or_dry_run` / generator docs). To **review** changes in the terminal before they land, run **`mix igniter.install corex` without** `--yes` in a real terminal (a full TTY). Use **`--dry-run`** (global Igniter flag, when your Igniter version supports it) to preview without writing.

    ## Markdown walkthrough: `--scribe`

    For a **file-based** before/after record (and diffs in Markdown), not the terminal diff, use global **`--scribe path/to/doc.md`**. The pipeline uses `Igniter.Scribe` to structure sections. Example:

        mix igniter.install corex@path:../corex --yes --scribe docs/corex-install-walkthrough.md

    Adjust the path; the file is only written on success. This matches [Igniter — Writing generators](https://hexdocs.pm/igniter/writing-generators.html) and `Mix.Corex.Install.Pipeline`’s scribe layout.

    ## Flags

    * `--no-design` — skip running `mix corex.design` after install
    * `--designex` — pass `--designex` to `mix corex.design` (the scheduled task also passes `--force` for idempotent re-runs)
    * `--replace` — (default: off) replace the stock `Layouts.app` and home to use `toast_group`, optional theme/mode/lang assigns, and wrap the home template in `Layouts.app`. Greenfield `mix corex.new` turns this on; `mix igniter.install corex` does not, and instead adds `GET /corex` with `Layouts.corex`
    * `--mode` — add mode plug and session assigns
    * `--theme` — colon-separated themes (`neo`, `uno`, `duo`, `leo`); configures theme plug when more than one or with switching
    * `--lang` — (opt-in) adds [localize_web](https://hexdocs.pm/localize_web/readme.html), `Localize.Routes`, and `Localize.VerifiedRoutes` (`~q`), `LocalizeLayout`, language switcher in `Layouts.app`, and related plumbing; run `mix gettext.extract` / `mix gettext.merge` for catalogs.
    * **`--no-mcp`** — do not add `plug Corex.MCP` in `dev` in the web `Endpoint` (default: add)
    * **`--no-skills`** — do not add the [usage_rules](https://hexdocs.pm/usage_rules) dependency or `usage_rules/0` in the project `mix.exs` (default: add, so you can run `mix usage_rules.sync` for the Corex package skill under `.claude/skills/`)

    If `assets/js/app.js` was never patched (for example the installer stopped with a Mix error), re-run **`mix igniter.install corex --yes`** (with your usual Corex flags) to re-run the full installer.
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
          replace: false,
          mcp: true,
          skills: true,
          no_design: false,
          designex: false,
          mode: false,
          lang: false
        ],
        schema: [
          design: :boolean,
          designex: :boolean,
          no_design: :boolean,
          replace: :boolean,
          mode: :boolean,
          theme: :string,
          lang: :boolean,
          mcp: :boolean,
          skills: :boolean
        ]
      }
    end

    @impl true
    def igniter(igniter) do
      Mix.Corex.Install.Pipeline.igniter(igniter)
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
