# Manual installation

This guide is the Phoenix **wiring home** for Corex in an existing app: dependency, ESM Esbuild, hooks, root layout module script, use Corex, plus optional **Design**, **Theme**, **Mode**, **Accessibility**, and **Locale** plumbing (plugs, config, bridge scripts, `lang`/`dir`, and related hooks).

Picker UI (theme select, mode toggle, language switcher, accessibility panel) lives in the dedicated guides after you finish the wiring here:

- [Theming](theming.html)
- [Dark mode](dark_mode.html)
- [Accessibility](accessibility.html)
- [Localize](localize.html)

If you are creating a new project instead, see the [Installation guide](installation.html).

## Requirements

- **Elixir** `~> 1.17`
- **Phoenix** and **LiveView**
- A standard **Esbuild** asset pipeline

## 1. Add the dependency

Add `corex` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.2.0"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

## 2. Esbuild

Corex's JavaScript ships as ECMAScript modules with dynamic `import()`. Each component hook loads its own chunk on demand, so a component that never appears on a page is never fetched.

This requires two Esbuild flags on your main app target: **`--format=esm`**, **`--splitting`** and **`--outdir=../priv/static/assets/js`**. In `config/config.exs`:

```elixir
config :esbuild,
  version: "0.25.12",
  my_app: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]
```

## 3. Phoenix Hooks

<!-- tabs-open -->

### All Corex hooks

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import corex from "corex"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...corex },
})

liveSocket.connect()
```

Merge with `colocatedHooks` when your app uses them:

```javascript
hooks: { ...colocatedHooks, ...corex },
```

### Eager chrome + lazy extras {: #eager-chrome-lazy-extras}

Static-import chrome that exists on every page (toast, theme/language select, mode toggle, accessibility panel). Keep page-local components lazy. Keep `longPollFallbackMs` for real LiveView apps; do not call `disableDebug()` (Tableau sites do that separately).

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import { Toast } from "corex/toast"
import { Select } from "corex/select"
import { Toggle } from "corex/toggle"
import { Dialog } from "corex/dialog"
import { ToggleGroup } from "corex/toggle-group"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    Toast,
    Select,
    Toggle,
    Dialog,
    ToggleGroup,
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})

liveSocket.connect()
```

Omit chrome imports you do not render in the root layout. Merge with colocated hooks:

```javascript
hooks: {
  ...colocatedHooks,
  Toast,
  Select,
  Toggle,
  ...hooks({
    Accordion: () => import("corex/accordion"),
  }),
},
```

### Lazy hooks only

Import only the hooks you render. Keys must match `phx-hook` names (`Dialog`, `Accordion`, …). Prefer the eager-chrome tab above when theme, mode, language, accessibility, or toast live in the root layout; lazy chrome waits on a second chunk before those controls respond.

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Dialog: () => import("corex/dialog"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})

liveSocket.connect()
```

Each value is a zero-argument function returning a dynamic `import()`. Esbuild emits chunks only for listed hooks.

<!-- tabs-close -->

## 4. Root layout: load app.js as a module

The Corex JS bundle is ESM, so the browser must load it as a module. In `lib/my_app_web/components/layouts/root.html.heex`, set `type="module"` on the `<script>` tag that loads `assets/js/app.js`:

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

If your root layout already uses `type="text/javascript"` (the `phx.new` default), replace `text/javascript` with `module`. If it has no `type` at all, add `type="module"` next to `phx-track-static`.

## 5. Import Corex

In your web module (typically `lib/my_app_web.ex`), add use Corex inside the `quote` block of `defp html_helpers`, alongside the other imports that apply to HEEx templates:

```elixir
defp html_helpers do
  quote do
    use Gettext, backend: MyAppWeb.Gettext
    import Phoenix.HTML
    use Corex
    alias Phoenix.LiveView.JS
    alias MyAppWeb.Layouts
    unquote(verified_routes())
  end
end
```

Do not keep Phoenix `CoreComponents` in a Corex app. Use Corex components and scaffold with `mix corex.gen.html` / `mix corex.gen.live` instead of `mix phx.gen.*`.

By default this imports every Corex function component (`accordion/1`, `combobox/1`, `dialog/1`, …). If you want a smaller surface area or to avoid name collisions with other components, narrow it with `only:` / `except:` and an optional `prefix:`:

```elixir
use Corex, only: [:accordion], prefix: "ui"
```

```heex
<.ui_accordion
  id="my-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "first", label: "First", content: "First panel."],
    [value: "second", label: "Second", content: "Second panel."],
    [value: "third", label: "Third", content: "Third panel."]
  ])}
/>
```

Compile and rebuild assets:

```bash
mix compile
mix assets.build
```

## 6. Optional: Corex Design

Add the `corex_design` dependency to `mix.exs`:

```elixir
{:corex_design, "~> 0.2", runtime: false},
```

Keep `runtime: false` so the Mix task is available in every Mix env (including `MIX_ENV=prod mix assets.deploy`) without starting Design as an OTP app. That flag is not “rebuild CSS while serving traffic.” Do not use `only: :dev`.

Add `"corex.design.build"` to your `assets.build` and `assets.deploy` aliases in `mix.exs` (same layer as Tailwind and esbuild). Design CSS is an asset build step, not part of `mix compile`.

Add to `config/config.exs` (build-time CSS only; see [Configuration](configuration.html)):

```elixir
config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  themes: nil,
  scales: [],
  components: ~w(button dialog accordion typo layout-heading)a,
  semantics: nil
```

`default_theme` / `default_mode` / `themes` control which theme CSS the design build emits. They are not the runtime picker allowlist (`config :my_app, :themes`). `components:` lists the component recipes to emit. Omit the key or set `nil` for the full catalog. `semantics:` trims unused palette roles and `ui-{role}` utilities when you need a smaller bundle. List allowed keys with `mix corex.design.options`. After changing this config, re-run `mix corex.design.build` (or `mix assets.build`).

Ignore the generated output in git (rebuild with `mix corex.design.build`):

```gitignore
/assets/corex/
```

If that tree was already committed, stop tracking it without deleting files on disk:

```bash
git rm -r --cached assets/corex
git commit -m "Stop tracking generated Corex Design CSS"
```

Generate CSS:

```bash
mix deps.get
mix corex.design.build
```

Then import from `assets/css/app.css`. Prefer the single umbrella entry:

```css
@import "../corex/corex.css";
@source "../corex";
```

Layered imports (`main.css` + `theme/neo.css` + `components.css`) still work if you filter themes yourself. `components.css` is generated from the `components:` list in `config :corex_design`.

If your `app.css` still imports the stock **daisyUI** plugin from `phx.new`, remove or isolate it. Mixing daisyUI tokens with Corex Design tokens leads to duplicated reset rules and conflicting CSS variables.

Finally, set **`data-theme`** and **`data-mode`** on **`<html>`** so token files such as `theme/neo.css` and light/dark palettes apply. Use values that match your imports and toggles (for example `data-theme="neo"` when you import `../corex/theme/neo.css`, and `data-mode="light"` or `data-mode="dark"`). Sections [8](#8-optional-theme-wiring) and [9](#9-optional-mode-wiring) wire these from plugs and bridge scripts; the picker UI is in [Theming](theming.html) and [Dark mode](dark_mode.html).

Give **`<body>`** the **`typo`** class so base typography applies (use Tailwind utilities for page layout):

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo">
    {@inner_content}
  </body>
</html>
```

See the [Design guide](design.html) for commands, modifiers, bundle filtering, and themes.

## 7. Optional: Phoenix flash with Toast

To render Phoenix flash (and LiveView flash) as Corex toasts instead of the default `<.flash_group>`, render a `<.toast_group>` in your app layout and pass it `flash={@flash}`. In `lib/my_app_web/components/layouts.ex`, replace the flash group inside `def app/1` with:

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading>
    <.heroicon name="hero-arrow-path" />
  </:loading>
  <:close>
    <.heroicon name="hero-x-mark" />
  </:close>
</.toast_group>
```

Optionally, add the connection-state toasts so users see feedback when the socket drops or the server errors out:

```heex
<.toast_client_error
  toast_group_id="layout-toast"
  title={gettext("We can't find the internet")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
<.toast_server_error
  toast_group_id="layout-toast"
  title={gettext("Something went wrong!")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
```

Make sure every LiveView and controller view that uses this layout passes `flash={@flash}` into it (e.g. `<Layouts.app flash={@flash} ...>`).

See `Corex.Toast` for `create/5`, `create/6`, `update/3`, `update/4`, `remove/2`, `remove/3`, and `dismiss/2` / `dismiss/3`. Pass `action: %{label: "…", js: %Phoenix.LiveView.JS{}}` on **server** `create/6` / `update/4` only (client bindings ignore `:action`). Compose `js` with `JS.push`, `JS.patch`, or `JS.navigate`.

## Optional: Theme wiring {: #optional-theme-wiring}

Runtime theme picker allowlist in `config/config.exs` (first entry is the default):

```elixir
config :my_app, :themes, ~w(neo uno duo leo)
```

This list is for the picker and plug validation only. Trim emitted CSS with `config :corex_design, themes:` (build-time). Keep the picker list a subset of the themes you build.

Create `lib/my_app_web/plugs/theme.ex` that reads `phx_theme` cookie, validates against `:themes`, and assigns `:theme` / `:themes`. Put `plug MyAppWeb.Plugs.Theme` in the browser pipeline (after `:fetch_live_flash`; after locale plugs when you use `--lang`).

On `<html>`:

```heex
<html lang="en" data-theme={assigns[:theme] || "neo"} data-mode={assigns[:mode] || "light"}>
```

Add the before-paint bridge and register the `Select` hook, then render the picker UI:

- Bridge + checklist details: [Theming](theming.html#bridge)
- Picker UI: [Theming](theming.html)

## Optional: Mode wiring {: #optional-mode-wiring}

Create `MyAppWeb.Plugs.Mode` that reads `phx_mode` cookie (`light` / `dark`) and assigns `:mode`. Put it in the browser pipeline with Theme (Mode before Theme is fine).

Ensure root `<html>` has `data-mode={assigns[:mode] || "light"}`.

Add the before-paint bridge and register the `Toggle` hook, then render the toggle UI:

- Bridge + checklist: [Dark mode](dark_mode.html#bridge)
- Toggle UI: [Dark mode](dark_mode.html)

Include `toggle` in `config :corex_design, components:` when you use a mode switcher.


## Optional: Accessibility wiring {: #optional-accessibility-wiring}

Enable preference CSS in Design, then wire the plug, LiveView assign, root `data-*` attrs, and FOUC bridge. Full steps (including the panel UI) are in [Accessibility](accessibility.html).

Short path with the installer:

```bash
mix corex.new my_app --a11y
```

Or by hand:

1. Set `config :corex_design, accessibility: true` (or an axis list) and rebuild with `mix corex.design.build`
2. Add `MyAppWeb.Plugs.Accessibility` to the browser pipeline and a LiveView `on_mount` that assigns `:a11y`
3. Apply `a11y_data_attrs/1` on `<html>` and merge the `phx:a11y` bridge into the same `<head>` IIFE as theme/mode
4. Render an accessibility panel once in the root layout; register `Dialog` and `ToggleGroup` hooks
5. If you ship with `mix release`, add `corex_design: :load` so Mix.Release keeps Accessibility helper BEAMs (`runtime: false` apps are omitted otherwise). See [Accessibility](accessibility.html#mix-release).

Scaffolding is also available as `mix corex.new --a11y` (default off) and `mix corex.tableau.new --a11y`. Preference CSS is still a design **build**; the plug only sets `data-*` on `<html>`.

## Optional: Locale wiring {: #optional-locale-wiring}

Routing and layout wiring for Gettext + Localize. The language switcher UI is in [Localize](localize.html).

1. Add `localize_web` and `gettext_sigils`; align Gettext `locales:` with `config :localize, supported_locales:`.
2. Run `mix localize.download_locales` after changing locales.
3. Set VerifiedRoutes `path_prefixes: [{MyAppWeb.Locale, :current, []}]`.
4. `use Localize.Routes` in the router; put locale plugs **immediately after** `:fetch_live_flash` (Mode/Theme plugs after `Localize.Plug.PutSession`).
5. Implement `MyAppWeb.Locale` helpers (`lang/0`, `dir/0`, `current/0`) and root `<html lang={…} dir={…}>`.
6. For LiveViews, `on_mount` a layout hook so locale and `current_path` stay in sync.

`mix corex.new my_app --lang` scaffolds this shape. Full switcher markup: [Localize](localize.html).


## 8. Add your first component

After the install, every Corex function component is available in your templates. The `id` attribute is required for any component you want to drive from the API.

`Corex.Content.new/1` builds a list of items. Each item's `value` is auto-generated when missing; you can also flag an item as `disabled`.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### Driving components from the API

Every component documents its helpers under **`Corex.<Name>`** in Hexdocs (see **API** and **Events** on each module page). You need a stable **`id`** on the root.

**Client-side** (inline binding):

```heex
<button type="button" phx-click={Corex.Accordion.set_value("welcome-accordion", ["1"])}>
  Open the first panel
</button>
```

**Server-side** (`handle_event/3`):

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "welcome-accordion", ["1"])}
end
```

For custom slots, controlled values, async loading, and the full API, see [Corex.Accordion](Corex.Accordion.html).

## What's next

Wiring done? Add the picker UI:

- [Theming](theming.html) theme `<.select>`
- [Dark mode](dark_mode.html) mode `<.toggle>`
- [Accessibility](accessibility.html) preference panel (also `mix corex.new --a11y`)
- [Localize](localize.html) language switcher

Also:

- [Design](design.html) modifiers, bundle filtering, and themes
- [Forms](forms.html) `field`, validation, and `auto_invalid`
- [MCP](https://hexdocs.pm/corex_mcp/MCP.html) AI tooling in development (`mix corex.new` writes `.cursor/mcp.json`; use `--no-mcp` to skip)
- [Corex Admin](https://hexdocs.pm/corex_admin/installation.html) optional staff admin (`{:corex_admin, "~> 0.1"}`, then `mix corex.admin.install`)
- [Production](production.html) prod build and run
- [Updating Corex](update.html) migrate an existing app

### Logger parameter filtering

Phoenix only filters params containing `"password"` by default. Expand the filter for tokens and secrets:

```elixir
config :phoenix, :filter_parameters, ["password", "secret", "token", "otp", "_key", "api_key"]
```
