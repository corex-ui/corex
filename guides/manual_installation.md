# Manual installation

This guide describes how to add Corex to an existing Phoenix application without using `mix corex.new`. It covers the minimum needed to render Corex components in your templates: the dependency, an ESM Esbuild build, the Corex JS hooks, the root layout `<script type="module">`, and `use Corex` in your web layer. Later sections cover optional features (design, toasts, dark mode, theming, localization).

If you are creating a new project instead, see the [Installation guide](installation.html).

For light/dark mode, theming, and localization, follow the dedicated guides after this minimal install:

- [Dark mode](dark_mode.html)
- [Theming](theming.html)
- [Localize](localize.html)

## Requirements

- **Elixir** `~> 1.17`
- **Phoenix** and **LiveView** versions compatible with Corex (see the [`corex` package](https://hex.pm/packages/corex))
- A standard **Esbuild** asset pipeline (the one `phx.new` configures)

## 1. Add the dependency

Add `corex` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-beta.1"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

## 2. Esbuild: ESM and code splitting

Corex's JavaScript ships as ECMAScript modules with dynamic `import()`. Each component hook loads its own chunk on demand, so a component that never appears on a page is never fetched.

This requires two Esbuild flags on your main app target: **`--format=esm`** and **`--splitting`**. In `config/config.exs`:

```elixir
config :esbuild,
  version: "0.25.4",
  my_app: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]
```

The key changes from the stock `phx.new` config are `--format=esm`, `--splitting`, `--target=es2022`, and the `--outdir=.../js` (a directory, not a single file — code splitting needs a directory output).

## 3. `assets/js/app.js`

Import Corex and merge its hooks into the `LiveSocket`. After your existing LiveView and `colocatedHooks` imports, add:

```javascript
import corex from "corex"
```

Then merge `...corex` into the `hooks` map:

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...corex }
})
```

`import corex from "corex"` registers **every** Corex hook. That's fine in development — chunks load on demand anyway — but in production you can opt into the named export to register only the hooks you actually use:

```javascript
import { hooks } from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...hooks(["Accordion", "Combobox", "Dialog"]) }
})
```

## 4. Root layout: load `app.js` as a module

The Corex JS bundle is ESM, so the browser must load it as a module. In `lib/my_app_web/components/layouts/root.html.heex`, set `type="module"` on the `<script>` tag that loads `assets/js/app.js`:

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

If your root layout already uses `type="text/javascript"` (the `phx.new` default), replace `text/javascript` with `module`. If it has no `type` at all, add `type="module"` next to `phx-track-static`.

## 5. `use Corex`

In your web module (typically `lib/my_app_web.ex`), add `use Corex` inside the `quote` block of `defp html_helpers`, alongside the other imports that apply to HEEx templates:

```elixir
defp html_helpers do
  quote do
    use Gettext, backend: MyAppWeb.Gettext
    import Phoenix.HTML
    import MyAppWeb.CoreComponents
    use Corex
    alias Phoenix.LiveView.JS
    alias MyAppWeb.Layouts
    unquote(verified_routes())
  end
end
```

By default this imports every Corex function component (`accordion/1`, `combobox/1`, `dialog/1`, …). If you want a smaller surface area or to avoid name collisions with other components, narrow it with `only:` / `except:` and an optional `prefix:`:

```elixir
use Corex, only: [:accordion], prefix: "ui"
```

```heex
<.ui_accordion id="my-accordion" class="accordion">
  ...
</.ui_accordion>
```

## 6. Verify

Compile and rebuild assets:

```bash
mix compile
mix assets.build
```

Fix any Esbuild or module-resolution errors before continuing. If you see `error: No matching export in "corex"`, double-check that `--format=esm --splitting` made it into the `:esbuild` args.

## 7. Optional: Corex Design

The Corex Design system ships generated CSS under `assets/corex` (themes, typography, layout, and per-component stylesheets). Install the assets with:

```bash
mix corex.design
```

Pass `--designex` to also copy the design token sources (`assets/corex/design/`). By default `mix corex.design` **skips** any tree that already exists. Pass `--force` to overwrite — useful when refreshing design assets to a newer Corex version.

Then import the design layers from `assets/css/app.css`. The minimum is `main.css`, a theme, and the components you use:

```css
/* corex:design-imports */
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/accordion.css";
/* corex:design-imports */
```

Keep the `/* corex:design-imports */` markers — they're the agreed-upon block Corex generators recognize when updating imports later.

If your `app.css` still imports the stock **daisyUI** plugin from `phx.new`, remove or isolate it. Mixing daisyUI tokens with Corex Design tokens leads to duplicated reset rules and conflicting CSS variables.

Finally, give the `<body>` the `typo` and `layout` classes so the design system's base typography and layout container apply:

```heex
<body class="typo layout">
  {@inner_content}
</body>
```

## 8. Optional: Phoenix flash with Toast

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

See `Corex.Toast` for `create_toast/5`, `push_toast/6`, and the rest of the toast API.

## 9. Add your first component

After the install, every Corex function component is available in your templates. The `id` attribute is required for any component you want to drive from the API.

### Basic

`Corex.Content.new/1` builds a list of items. The `id` is auto-generated when missing; you can also flag an item as `disabled`.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### With indicator

The optional `:indicator` slot adds an icon after each trigger.

```heex
<.accordion
  id="indicator-accordion"
  class="accordion"
  items={Corex.Content.new([
    [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

### Custom

Use `:trigger`, `:content`, and `:indicator` together with `:let={item}` for fully custom rendering, including per-item `meta`.

```heex
<.accordion
  id="custom-accordion"
  class="accordion"
  items={
    Corex.Content.new([
      [
        id: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      ],
      [
        trigger: "Duis dictum gravida?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      ],
      [
        id: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      ]
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.data.meta.icon} />{item.data.trigger}
  </:trigger>
  <:content :let={item}>{item.data.content}</:content>
  <:indicator :let={item}>
    <.heroicon name={item.data.meta.indicator} />
  </:indicator>
</.accordion>
```

### Controlled (server-driven)

Pass `controlled` and `value`, and update the value from `on_value_change`. The event payload is a map with the key `value` (a list of strings) and the accordion `id`.

```elixir
defmodule MyAppWeb.AccordionLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, ["lorem"])}
  end

  def handle_event("on_value_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, :value, value)}
  end

  def render(assigns) do
    ~H"""
    <.accordion
      id="controlled-accordion"
      controlled
      value={@value}
      on_value_change="on_value_change"
      class="accordion"
      items={Corex.Content.new([
        [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
        [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."]
      ])}
    />
    """
  end
end
```

### Async (loading state)

When the data is not available on mount, drive the component from `Phoenix.LiveView.assign_async/3`. `Corex.Accordion.accordion_skeleton/1` renders a placeholder while the async result is pending.

```elixir
defmodule MyAppWeb.AccordionAsyncLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign_async(socket, :accordion, fn ->
        items =
          Corex.Content.new([
            [id: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
            [id: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
            [id: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
          ])

        {:ok, %{accordion: %{items: items, value: ["duis", "donec"]}}}
      end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.async_result :let={accordion} assign={@accordion}>
      <:loading>
        <.accordion_skeleton count={3} class="accordion" />
      </:loading>

      <:failed>There was an error loading the accordion.</:failed>

      <.accordion
        id="async-accordion"
        class="accordion"
        items={accordion.items}
        value={accordion.value}
      />
    </.async_result>
    """
  end
end
```

## 10. Driving components from the API

Every Corex component exposes JS commands for client-side control and matching `socket` helpers for server-side control. You need an `id` on the component.

**Client-side**, push commands inline from any element:

```heex
<button type="button" phx-click={Corex.Accordion.set_value("welcome-accordion", ["1"])}>
  Open the first panel
</button>
```

**Server-side**, return the modified socket from a `handle_event/3` (or call it anywhere a `socket` is in scope):

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "welcome-accordion", ["1"])}
end
```

The same pattern applies to every component — see each component's module docs for the available commands.

## What's next

This is the minimum required to use Corex. From here, layer on the optional features one at a time:

- [Dark mode](dark_mode.html) — `Plugs.Mode`, the cookie/localStorage bridge script, and a `<.toggle_group>` toggle.
- [Theming](theming.html) — `Plugs.Theme`, theme-aware bridge script, and a `<.select>` theme picker.
- [Localize](localize.html) — `localize_web` dep, locale-aware routes, `MyAppWeb.Path`, `MyAppWeb.Plugs.Path`, `MyAppWeb.Locale`, and `<.language_switch>` (RTL via CLDR in `Locale.dir/0`).
- [MCP](mcp.html) — Corex MCP for AI tooling in development.
- [Production](production.html) — prod build and run.
