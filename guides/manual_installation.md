# Manual installation

This guide describes how to add Corex to an existing Phoenix application without using `mix corex.new`. It covers the minimum needed to render Corex components in your templates: the dependency, an ESM Esbuild build, the Corex JS hooks, the root layout `<script type="module">`, and `use Corex` in your web layer. Later sections cover optional features (design, toasts, dark mode, theming, localization).

Corex ships **no CSS** by default. Style attributes on components (`semantic`, `size`, …) declare the look you want; Corex turns them into BEM classes such as `accordion--semantic-accent` that **you** style. Optionally, [Corex Design](styled.html) provides ready-made CSS for those classes. See [How styling works](installation.html#how-styling-works) in the installation guide for the full picture.

If you are creating a new project instead, see the [Installation guide](installation.html).

For light/dark mode, theming, and localization, follow the dedicated guides after this minimal install:

- [Dark mode](dark_mode.html)
- [Theming](theming.html)
- [Localize](localize.html)

## Requirements

- **Elixir**
- **Phoenix** and **LiveView** 
- A standard **Esbuild** asset pipeline

## 1. Add the dependency

Add `corex` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0"}
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
  version: "0.25.4",
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

### Lazy hooks only

Import only the hooks you render. Keys must match `phx-hook` names (`Dialog`, `Accordion`, …):

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

See the [Styled guide](styled.html) for the full setup, modifiers, shared utilities, and themes.

Corex Design CSS is **generated at compile time** by the `:corex_design` compiler. The default Phoenix path writes into `assets/css/`. Requires **OTP 27+**. Add the dependency, register the compiler, and configure output:

```elixir
# mix.exs deps
{:corex_design, "~> 0.2"}

# mix.exs project/0 (Phoenix)
compilers: [:phoenix_live_view] ++ Mix.compilers() ++ [:corex_design]
```

```elixir
# config/config.exs
config :corex_design,
  default_theme: :neo,
  default_mode: :light,
  my_app: [
    output: "assets/css/corex.tailwind.css"
  ]
```

Replace `:my_app` with your OTP app name. Omit `:themes` to use built-in presets. Then:

```bash
mix deps.get
mix compile
mix assets.build
```

Import the generated bundle from `assets/css/app.css`:

```css
@import "./corex.tailwind.css";
```

If your `app.css` still imports the stock **daisyUI** plugin from `phx.new`, remove or isolate it. Mixing daisyUI tokens with Corex Design tokens leads to duplicated reset rules and conflicting CSS variables.

Set **`data-theme`** and **`data-mode`** on **`<html>`** so theme and light/dark palettes apply. [Dark mode](dark_mode.html) and [Theming](theming.html) show how to wire these from plugs or client scripts after you add mode and theme pickers.

Give **`<body>`** the **`typo`** and **`layout`** classes so base typography and the layout shell apply:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

## 7. Optional: Phoenix flash with Toast

To render Phoenix flash (and LiveView flash) as Corex toasts instead of the default `<.flash_group>`, render a `<.toast_group>` in your app layout and pass it `flash={@flash}`. In `lib/my_app_web/components/layouts.ex`, replace the flash group inside `def app/1` with:

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading>
    <.heroicon name="hero-arrow-path" class="icon" />
  </:loading>
  <:close>
    <.heroicon name="hero-x-mark" class="icon" />
  </:close>
</.toast_group>
```

Optionally, add the connection-state toasts so users see feedback when the socket drops or the server errors out:

```heex
<.toast_client_error
  toast_group_id="layout-toast"
  title={gettext("We can't find the internet")}
  description={gettext("Attempting to reconnect")}
  toast_type={:error}
  visible_duration={:infinity}
/>
<.toast_server_error
  toast_group_id="layout-toast"
  title={gettext("Something went wrong!")}
  description={gettext("Attempting to reconnect")}
  toast_type={:error}
  visible_duration={:infinity}
/>
```

Make sure every LiveView and controller view that uses this layout passes `flash={@flash}` into it (e.g. `<Layouts.app flash={@flash} ...>`).

See `Corex.Toast` for `create/5`, `create/6`, `update/3`, `update/4`, `remove/2`, `remove/3`, and `dismiss/2` / `dismiss/3`. Pass `action: %{label: "…", js: %Phoenix.LiveView.JS{}}` with `JS.push`, `JS.patch`, or `JS.navigate` composed in `js`.

## 8. Add your first component

After the install, every Corex function component is available in your templates. The `id` attribute is required for any component you want to drive from the API.

### Basic

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

### With indicator

The optional `:indicator` slot adds an icon after each trigger.

```heex
<.accordion
  id="indicator-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
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
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      ],
      [
        label: "Duis dictum gravida?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      ],
      [
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      ]
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />{item.label}
  </:trigger>
  <:content :let={item}>{item.content}</:content>
  <:indicator :let={item}>
    <.heroicon name={item.meta.indicator} />
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
        [value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
        [value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."]
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
            [value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.", disabled: true],
            [value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
            [value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
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

## 9. Driving components from the API

Every component documents its own helpers under **`Corex.<Name>`** in Hexdocs (see **API** and **Events** on each module page). You need a stable **`id`** on the root.

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

## What's next

To upgrade an existing app, see [Updating Corex](update.html).

### Configuration

- [Unstyled](unstyled.html) — modifier classes, axis vocabulary, `config :corex`
- [Styled](styled.html) — Corex Design CSS setup
- [Design config](design-config.html) — themes, validation, part-tree overrides
- [Installation](installation.html) — generator options (`config :corex, :generators`)
- [Localize](localize.html) — Gettext backend for translated component labels

This is the minimum required to use Corex. From here, layer on the optional features one at a time:

- [Dark mode](dark_mode.html)  -  `Plugs.Mode`, the cookie/localStorage bridge script, and a `<.toggle>` mode switcher.
- [Theming](theming.html)  -  `Plugs.Theme`, theme-aware bridge script, and a `<.select>` theme picker.
- [Localize](localize.html)  -  `localize_web` dep, locale-aware routes, `MyAppWeb.Locale`, `Locale.swap_path/2`, `<.language_switch>`, and **`on_mount MyAppWeb.Hooks.Layout`** after **`use Phoenix.LiveView`** when using LiveViews with **`--lang`** (RTL via CLDR in `Locale.dir/0`).
- [MCP](mcp.html)  -  Corex MCP for AI tooling in development.
- [Production](production.html)  -  prod build and run.
