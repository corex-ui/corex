# Manual installation

Use this guide when you want to wire Corex into a Phoenix app yourself instead of running `mix igniter.install corex`. The steps below match what you need for components to run: Esbuild as ESM with splitting, the Corex client bundle, LiveView hooks, and `use Corex` in your web layer.

## Requirements

- Elixir `~> 1.17`
- Phoenix and LiveView versions compatible with Corex (see the [Corex package](https://hex.pm/packages/corex) on Hex for current constraints)
- Node (or your toolchain) as required by your Phoenix version for assets

## 1. Add the dependency

In `mix.exs`, add Corex from Hex (example version):

```elixir
{:corex, "~> 0.1.0-beta.1"}
```

Add **Jason** if your app does not already depend on it as the JSON library. Then:

```bash
mix deps.get
```

## 2. Phoenix defaults

In `config/config.exs`:

- Set `config :phoenix, :json_library, Jason` if it is not already set.
- Set `config :phoenix, :gettext_backend, MyAppWeb.Gettext` to your app’s Gettext module name (replace `MyAppWeb` with your web namespace).

## 3. Esbuild: ESM and code splitting

Corex’s JavaScript loads as ECMAScript modules with dynamic imports. Your main Esbuild target must build as **ESM** with **splitting** enabled.

In the `:esbuild` configuration (often in `config/config.exs`), ensure the `args` for your app entry include **`--format=esm`** and **`--splitting`** alongside your usual `--bundle` and entrypoints.

## 4. `assets/js/app.js`

- After your existing imports (for example after the LiveView client import), add:

  ```javascript
  import corex from "corex"
  ```

- When you create the `LiveSocket`, spread Corex’s hooks into the `hooks` option together with any hooks you already use:

  ```javascript
  let liveSocket = new LiveSocket("/live", Socket, {
    longPollFallbackMs: 2500,
    params: { _csrf_token: csrfToken },
    hooks: { ...colocatedHooks, ...corex },
  })
  ```

  Use your real hook object name if it is not `colocatedHooks`.

## 5. Root layout script

In `lib/my_app_web/components/layouts/root.html.heex` (adjust the path to your app), load the Phoenix asset bundle as a module so the ESM graph resolves:

- On the `phx-track-static` script tag for `assets/js/app.js`, use **`type="module"`** (not `type="text/javascript"`).

## 6. `use Corex`

In your web module (for example `lib/my_app_web.ex`), inside the `quote` block of **`defp html_helpers`**, add:

```elixir
use Corex
```

Place it with your other `use` / `import` lines that apply to HEEx templates.

## 7. Check the build

```bash
mix compile
mix assets.build
```

Fix any Esbuild or resolution errors before continuing.

## Optional: Corex Design

Design adds generated CSS under `assets/corex` and ties it into your main stylesheet.

1. Generate design assets:

   ```bash
   mix corex.design
   ```

   Run again with `--force` if you need to refresh files that already exist. Use `--designex` only if you follow the Designex workflow described in `mix help corex.design`.

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

4. Ensure your root layout **loads the bundled CSS** the way your Phoenix app already does (typically the main CSS entry is imported from `assets/css/app.css` into the JS bundle or the asset pipeline your project uses). No extra `<link>` is required beyond what `phx.new` already sets up once `app.css` imports the design layers.

## Optional: Toast layout

If you want Corex’s global toast pattern instead of Phoenix’s default flash group in the app shell, align your root and app layouts with the Corex installer output (toast components and layout assigns). The minimal path above can keep the stock `flash_group` until you choose to switch.
