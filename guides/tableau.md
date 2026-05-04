# Tableau

This guide adds [Corex](installation.html) to a **[Tableau](https://hex.pm/packages/tableau)** static site generated with HEEx, Esbuild, and Tailwind.

## Create the site

```bash
mix tableau.new my_site --template heex --js esbuild --css tailwind
cd my_site
```


What `tableau.new` already gives you

- **`mix.exs`**: `tableau`, `tailwind`, `phoenix_live_view`, and `esbuild`
- **`config/config.exs`**: Esbuild profile **`default`** bundles **`assets/js/site.js`** into **`_site/js`**, with **`NODE_PATH`** pointing at **`deps/`** so npm-style imports from Hex dependencies resolve. Tailwind compiles **`assets/css/site.css`** to **`_site/css/site.css`**.
- **`lib/layouts/root_layout.ex`**: stylesheet at **`/css/site.css`**, script at **`/js/site.js`** (plain script tag, no CSRF meta).
- **`assets/js/site.js`**: empty in a fresh project.
- **`assets/css/site.css`**: typically only `@import "tailwindcss"`.

## 1. Elixir and the `corex` dependency

```elixir
{:corex, "~> 0.1.0-beta.2"}
```

Then:

```bash
mix deps.get
```

## 2. Esbuild: ESM, splitting, and `_site/js`

Corex’s client uses **dynamic `import()`** for hook chunks. Follow [Manual installation §2](manual_installation.html#2-esbuild): enable **`--format=esm`**, **`--splitting`**, and a modern **`--target`** (for example **`es2022`**). Keep Tableau’s output directory so URLs stay **`/js/site.js`** and chunks live next to that file under **`_site/js`**.

Replace the stock **`config :esbuild, ... default:`** args with something like:

```elixir
config :esbuild,
  version: "0.25.5",
  default: [
    args:
      ~w(js/site.js --bundle --format=esm --splitting --target=es2022 --outdir=../_site/js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
```

## 3. Corex design assets

Copy packaged design CSS into your app:

```bash
mix corex.design
```

That creates **`assets/corex/`** from the **`corex`** package (see **`Mix.Tasks.Corex.Design`**). Use **`--force`** to overwrite, **`--designex`** to also copy token sources if you use [Designex](https://hex.pm/packages/designex) later.

## 4. Tailwind entry: import Corex CSS

After **`@import "tailwindcss"`** (or your Tailwind v4 entry), import design layers. At minimum: **`main.css`**, a **theme** (here **`neo`**), **typography** and **layout**, plus **one stylesheet per component family** you render. Example:

```css
@import "tailwindcss";

@import "../corex/main.css";
@import "../corex/theme/neo.css";

@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/accordion.css";
```

Add **`typo`** and **`layout`** classes on **`<body>`**

## 5. Root layout

Corex’s JS is **ESM** and Phoenix **`LiveSocket`** expects a **CSRF** token in the page.

In your **`Tableau.Layout`** module (for example **`lib/layouts/root_layout.ex`**):

1. **`import Phoenix.Controller, only: [get_csrf_token: 0]`**
2. Inside **`<head>`**, add:

   ```heex
   <meta name="csrf-token" content={get_csrf_token()} />
   ```

3. Replace the default script tag that loads **`/js/site.js`** with a **module** script:

   ```heex
   <script type="module" src="/js/site.js" />
   ```

4. Add **`use Corex`** next to **`use Phoenix.Component`** so Corex function components are available in the layout template.

## 6. Corex hooks

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

`import corex from "corex"` registers **every** Corex hook and keeps the full lazy registry in your bundle graph. To register **only** some hooks **without** pulling that full table into your app bundle, import **`hooks`** from **`corex/hooks`** and pass **lazy factories** (object keys must match **`phx-hook`** names, e.g. **`Dialog`**):

```javascript
import { hooks } from "corex/hooks"

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...colocatedHooks,
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Dialog: () => import("corex/dialog"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})
```

## Try a component

After **`mix compile`** and your usual Tableau asset build (for example **`mix tableau.build`** or watch tasks from **`config :tableau, :assets`**), use a component in a page template.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [trigger: "First", content: "Panel one."],
    [trigger: "Second", content: "Panel two."]
  ])}
/>
```

## Related

- [Installation](installation.html) — **`mix corex.new`**, first components, next steps.
- [Manual installation](manual_installation.html) — Esbuild details, **`mix corex.design`**, **`type="module"`**, **`use Corex`**, toasts, MCP, and Phoenix-only layout notes.
