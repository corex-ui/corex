# Manual installation

Use this guide when you want the same Corex setup as the installer, but you are not using `mix igniter.install corex`. The steps cover the dependency, Esbuild as ESM with splitting, the Corex client bundle, LiveView hooks, the root layout script, and `use Corex` in your web layer.

For the generator flow and CLI flags, see [Installation](installation.html).

## Requirements

- Elixir `~> 1.17`
- Phoenix and LiveView versions compatible with Corex (see the [Corex package](https://hex.pm/packages/corex))
- Node (or your toolchain) as required by your Phoenix version for assets

## 1. Add the dependency

In `mix.exs`:

```elixir
{:corex, "~> 0.1.0-beta.1"}
```

Then:

```bash
mix deps.get
```

Advanced archive installs or non-Hex sources are covered by **`mix help`** and **`Mix.Tasks.Corex.Install`** — not duplicated here.

## 2. Esbuild: ESM and code splitting

Corex’s JavaScript ships as ECMAScript modules with dynamic imports. Your main Esbuild target must build as **ESM** with **splitting** enabled.

In the `:esbuild` configuration (often in `config/config.exs`), ensure the `args` for your app entry include **`--format=esm`** and **`--splitting`** alongside your usual `--bundle` and entrypoints.

## 3. `assets/js/app.js`

After your LiveView client import (and other imports you rely on), add:

```javascript
import corex from "corex"
```

When you create the `LiveSocket`, merge Corex’s hooks into `hooks` together with any hooks you already use:

```javascript
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...corex },
})
```

Use your real hook object name if it is not `colocatedHooks`.

## 4. Root layout script

In `lib/my_app_web/components/layouts/root.html.heex` (adjust paths for your app), load the Phoenix bundle as a module so the ESM graph resolves:

- On the `phx-track-static` script tag for `assets/js/app.js`, use **`type="module"`**.

## 5. `use Corex`

In your web module (for example `lib/my_app_web.ex`), inside the `quote` block of **`defp html_helpers`**, add:

```elixir
use Corex
```

Keep it alongside your other `use` / `import` lines that apply to HEEx templates.

## 6. Verify

```bash
mix compile
mix assets.build
```

Fix any Esbuild or resolution errors before continuing.

## 7. Optional: Corex Design

Design adds generated CSS under `assets/corex` and ties it into your main stylesheet.

1. Generate design assets:

   ```bash
   mix corex.design
   ```

   Run again with `--force` if you need to refresh existing files. Use `--designex` only when your workflow matches `mix help corex.design`.

2. Import design CSS in **`assets/css/app.css`**. Add a block that pulls in the generated theme and component layers, for example:

   ```css
   /* corex:design-imports */
   @import "../corex/main.css";
   @import "../corex/theme/neo.css";
   @import "../corex/components/typo.css";
   @import "../corex/components/layout.css";
   @import "../corex/components/accordion.css";
   /* corex:design-imports */
   ```

   Adjust theme (`neo` above) or component files to match what you need. Keep the `/* corex:design-imports */` markers if you want to replace or extend this block later without hunting through the whole file.

3. If your app still includes **daisyUI** or other stacks that conflict with Corex Design, remove or isolate those plugins so `app.css` reflects one design approach.

4. Ensure your root layout loads the bundled CSS the way your Phoenix app already does (typically `assets/css/app.css` via your JS bundle). No extra `<link>` is required beyond what `phx.new` sets up once `app.css` imports the design layers.

When you enable light/dark mode, theme switching, or localization, you may need extra design component CSS (toggle group, select, and so on). See [Dark mode](dark_mode.html), [Theming](theming.html), and [Localize](localize.html).

## 8. Optional: Toast layout

If you want Corex’s global toast pattern instead of Phoenix’s default flash group in the app shell, align your root and app layouts with the Corex installer output (toast components and layout assigns). The minimal path above can keep the stock `flash_group` until you choose to switch.

If you are adding localization with Gettext and `localize_web`, see [Localize](localize.html).
