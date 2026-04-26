# Manual installation (Corex in a new Phoenix app)

This guide is the step-by-step **hand** install for a greenfield Phoenix project. It matches the intent of `mix igniter.install corex` (see `Mix.Corex.Install.Pipeline` in the Corex repo) so you can agree on the same order of operations before changing the generator. It does **not** cover `mix corex.new` or the `corex_new` archive.

## 1. Version requirements

- **Elixir** `1.17` or newer (Corex declares `~> 1.17`).
- **Phoenix** compatible with **Phoenix `~> 1.8.1`** and **phoenix_live_view `~> 1.1.0`** (as in Corex’s `mix.exs`). Use a current `phx_new` for Phoenix 1.8 when you run `mix phx.new`.
- **Node** (or your asset toolchain) whatever your Phoenix version documents for the asset pipeline.
- **Igniter** is optional. You only need it if you will run `mix igniter.install corex` later; it is not required to follow the steps below.

## 2. Create a new Phoenix app

```bash
mix phx.new my_app
cd my_app
```

Use the same flags your team standardizes on (for example database choice). The steps below assume a default Phoenix 1.8+ layout and `assets/` tree.

## 3. Add Corex to `mix.exs` and fetch deps

In the `deps/0` function, add Corex, for example from the GitHub or Hex version you use:

```elixir
{:corex, path: "../corex", override: true}   # example: local dev
# or: {:corex, "~> 0.1.0", repo: "hexpm"}
```

Add **Jason** as the JSON library for Phoenix if the generated app does not already include it. Then:

```bash
mix deps.get
```

The installer’s dependency phase also runs `igniter.add_extension` with `phoenix` when you use Igniter; for a fully manual path you can skip that, but the Corex and Phoenix versions must remain compatible with Corex’s `mix.exs` constraints.

## 4. Minimal Phoenix configuration

`mix igniter.install corex` applies roughly the following via `PhoenixConfig.configure_phoenix_defaults/2` (and related helpers):

- In `config/config.exs`, set **`config :phoenix, :json_library, Jason`** (if not already set).
- Set **`config :phoenix, :gettext_backend, MyAppWeb.Gettext`** to your app’s Gettext module (the installer resolves `MyAppWeb` from the web module). Phoenix 1.8+ generators often already set this; keep it in sync with your `*_web` module.

You do **not** need `config :my_app, :themes` for the minimal path unless you adopt optional theme/mode wiring later.

`runtime.exs` and **localize** configuration apply only if you add localization (out of scope for this document’s first pass). See the “Out of scope” section at the end.

## 5. Esbuild: ESM and splitting

Corex’s JavaScript expects **ES modules** and **code splitting** so `import("corex/…")` works. The automatic patch in Corex is implemented in `Mix.Corex.Install.EsbuildFlags.insert_into_config/1` (replaces the first `esbuild` `args` that contain `--bundle` with something that includes both flags):

- Ensure `args` for your main app build include: **`--format=esm`** and **`--splitting`**.

In a typical `config/config.exs` entry for `config :esbuild`, that means the `:my_app` or `default` target’s `args` list should contain those flags alongside `--bundle` and your entrypoints.

## 6. `assets/js/app.js`: Corex import and LiveView hooks

- Add **`import corex from "corex"`** after your existing imports (convention: after the `phoenix_live_view` import when present).
- In the `new LiveSocket(..., { hooks: { ... } })` options, include **`...corex`** in the `hooks` object with your colocated or stock hooks, for example:

  `hooks: { ...colocatedHooks, ...corex }`

Corex can patch this automatically via `Mix.Corex.Install.PatchAssetsJs` (and optionally the **igniter_js** codemods in development when that dependency is present; otherwise regex fallbacks are used). The behavior to aim for is: Corex is imported once and the hooks object spreads both colocated hooks and `corex`.

## 7. Root layout: load `app.js` as a module and clean theme scripts

Edit **`lib/my_app_web/components/layouts/root.html.heex`** (paths follow your app name).

1. **Script type** – The `phx-track-static` app script must load as an ES module:

   - Change `type="text/javascript"` to `type="module"`, or add `type="module"` if the attribute was missing, matching the logic in `Mix.Corex.Install.Layouts.patch_root_layout/4`.

2. **Remove the stock inline Phoenix/daisy theme script** when you see the `phx:theme` / `data-theme` block that only exists for the default non-Corex design path. The installer removes it in `strip_stock_phx_daisy_theme_script/1` so it does not fight optional Corex design or assign-based themes.

3. **`<html>` tag** – For the **minimal** path, you can leave a plain `lang="en"` (or your default) on `<html>` if you are not using Corex Design yet. When you enable the **optional** Design system (section 10), set defaults such as `data-theme` and `data-mode` in line with the installer: for a static default without plugs, a common result is `lang="en" data-theme="neo" data-mode="light"`. If you add theme and mode from assigns (when using the full installer with `--mode` and themes), the `html` tag and optional bridge script follow `Layouts.patch_root_layout` and `maybe_insert_theme_mode_bridge/3` in the Corex source. Those are **out of scope** in the “minimal” checklist; section 10 covers Design defaults.

## 8. `use Corex` in the web module (HTML imports)

In **`lib/my_app_web.ex`** (or the module your Phoenix app uses as `web.ex`), find **`defp html_helpers`**. Inside the `quote` block, after the usual `import Phoenix.Component` and `import Phoenix.HTML`, add:

```elixir
use Corex
```

This matches `Mix.Corex.Install.Codemods.patch_web_module/3`: the macro must live inside the same `quote` that powers HEEx, not in an unrelated module.

## 9. Verify

```bash
mix compile
mix assets.build
```

Start the app and open a page that uses a simple Corex component, or a route you add for a smoke test. If assets fail, re-check the esbuild flags and that `import "corex"` resolves (path dependency and `package.json` / `assets` layout must match the Phoenix+esbuild setup for your app).

## 10. Optional: Corex Design system

Use this block when you want the packaged Corex **design tokens, themes, and CSS entrypoints** instead of building skin-only styles yourself.

1. **Generate design assets in `assets/corex`**

   Run the Corex design task (the installer usually schedules it with `mix corex.design --force`; add `--designex` only if you use the Designex path documented in `Mix.Corex.Install`):

   ```bash
   mix corex.design --force
   ```

2. **Append the design import block in `assets/css/app.css`**

   The content to add is the same as `priv/installer/design_imports_block.css` in Corex, including the marker comment `/* corex:design-imports */` and `@import` lines for `../corex/main.css`, a theme (for example `../corex/theme/neo.css`), and `../corex/components/typo.css`. The automatic installer applies this through `Mix.Corex.Install.Design.patch_assets_app_css_for_corex_design/1`.

3. **Remove daisyUI and conflicting Tailwind @plugin usage**

   Corex Design and **daisyUI** are not meant to be mixed in the same `app.css` the installer produces: strip the daisyUI `@plugin` region and the embedded daisyUI theme plugin blocks, as in `strip_daisy_plugin_region_from_app_css/1` and related helpers in `Mix.Corex.Install.Design`, and remove vendor copies of `daisyui` from `assets/vendor/` if the installer would delete them.

4. **`<html>` and theme / mode for Design**

   When Design is on and you are not yet using assign-based theme/mode, set a static default on `<html>` (for example `data-theme="neo" data-mode="light"`) per `patch_root_layout` and add the **theme/mode bridge script** when the full installer’s options require it (see `maybe_insert_theme_mode_bridge/3` in the same module).

## 11. Optional: Toast group instead of `flash_group`

The stock Phoenix layout often renders **`<.flash_group flash={@flash} />`**. Corex’s “replace” layout path swaps that for the **Corex toast** components and related wiring so flashes surface through the Corex pattern. The exact HEEx and `Layouts` changes mirror `replace_flash_group_with_toast` and `Templates.app_level_toast_block/0` in the Corex installer. Adopt this only when you want a single, Corex-aligned global notification model; the minimal path can keep Phoenix’s `flash_group` until you are ready to migrate.

## 12. What the automated installer also does (reference)

`mix igniter.install corex` (see `Mix.Corex.Install.Pipeline` and `Mix.Tasks.Corex.Install`) can additionally:

- Patch the **dev endpoint** (for example `Corex.MCP` in `dev` unless `--no-mcp`), add **optional plugs** and **router** changes for **theme and mode** session cookies, and add a **demo route** or replace **home** when using `--replace`.
- Schedule **`mix corex.design`**, and optionally add **usage_rules** or **localize** when the corresponding flags are on.
- Add **i18n**-related modules and `Localize` wiring when `--lang` is set.

## 13. Out of scope for this document (next iterations)

- **Theme and mode switcher UI** in the app layout, and the full **router/plug** story, unless you follow the same flags as the installer and the corresponding `Layouts` / `Router` / `Plugs` sources.
- **`lang` / `localize_web`**, `Localize` routes, and verified-routes changes (`--lang`).
- **`corex_new` / `mix corex.new`** and archive-based generators.

For interactive installs and a Markdown log of file diffs, you can still use **`mix igniter.install corex --scribe path/to/output.md`** once you align the Igniter task with the manual you agree on here.
