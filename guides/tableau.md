# Tableau + Corex

This guide adds [Corex](installation.html) to a **[Tableau](https://hex.pm/packages/tableau)** static site generated with HEEx, Esbuild, and Tailwind. It assumes you are **not** using `mix corex.new` (Phoenix app). For a full Phoenix app, use [Installation](installation.html) or [Manual installation](manual_installation.html).

## Create the site

```bash
mix tableau.new my_site --template heex --js esbuild --css tailwind
cd my_site
```

The rest of this page describes what that generator already provides, then the **minimum changes** to use Corex.

## What `tableau.new` already gives you

- **`mix.exs`**: `tableau`, `tailwind`, `phoenix_live_view`, and `esbuild` (no `corex` yet).
- **`config/config.exs`**: Esbuild profile **`default`** bundles **`assets/js/site.js`** into **`_site/js`**, with **`NODE_PATH`** pointing at **`deps/`** so npm-style imports from Hex dependencies resolve. Tailwind compiles **`assets/css/site.css`** to **`_site/css/site.css`**.
- **`lib/layouts/root_layout.ex`**: stylesheet at **`/css/site.css`**, script at **`/js/site.js`** (plain script tag, no CSRF meta).
- **`assets/js/site.js`**: empty in a fresh project.
- **`assets/css/site.css`**: typically only `@import "tailwindcss"`.

Exact filenames may differ if Tableau’s template changes; adjust paths to match your tree.

## 1. Elixir and the `corex` dependency

Corex requires **Elixir `~> 1.17`**. A new Tableau app may still declare **`elixir: "~> 1.15"`** in **`mix.exs`** — bump the requirement before adding Corex.

Add Corex to **`deps/0`** (pin matches [Hex](https://hex.pm/packages/corex) or your lockfile):

```elixir
{:corex, "~> 0.1.0-beta.2"}
```

Then:

```bash
mix deps.get
```

For local development against a Corex checkout, you can use **`{:corex, path: "../path/to/corex"}`**. With a **`path:`** dependency you may import the JS entry with a **relative path** to that checkout instead of the package name. With a **Hex** dependency, use **`import corex from "corex"`** as below.

## 2. Esbuild: ESM, splitting, and `_site/js`

Corex’s client uses **dynamic `import()`** for hook chunks. Follow [Manual installation §2](manual_installation.html#2-esbuild): enable **`--format=esm`**, **`--splitting`**, and a modern **`--target`** (for example **`es2022`**). Keep Tableau’s output directory so URLs stay **`/js/site.js`** and chunks live next to that file under **`_site/js`**.

Replace the stock **`config :esbuild, ... default:`** args with something like:

```elixir
config :esbuild,
  version: "0.25.5",
  default: [
    args:
      ~w(js/site.js --bundle --format=esm --splitting --target=es2022 --outdir=../_site/js --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
```

Drop the **`--external:/fonts/*`** and **`--external:/images/*`** lines if your JS never imports those URL patterns (see the same section in [Manual installation](manual_installation.html)).

**Do not** point **`--outdir`** at Phoenix’s **`priv/static/...`** — that belongs to a standard Phoenix asset pipeline, not Tableau’s **`_site`** output.

## 3. Corex design assets

Copy packaged design CSS into your app:

```bash
mix corex.design
```

That creates **`assets/corex/`** from the **`corex`** package (see **`Mix.Tasks.Corex.Design`**). Use **`--force`** to overwrite, **`--designex`** to also copy token sources if you use [designex](https://hex.pm/packages/designex) later.

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

If you use Corex Design’s base layout helpers, add **`typo`** and **`layout`** classes on **`<body>`** as in [Manual installation §7](manual_installation.html#7-optional-corex-design).

## 5. Root layout: CSRF, module script, `use Corex`

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

Any **`Tableau.Page`** module that renders **`<.dialog>`**, **`<.accordion>`**, and so on also needs **`use Corex`** (and **`use Phoenix.Component`** if not already present).

## 6. `assets/js/site.js`: `LiveSocket` and Corex hooks

Author a small entry module. Minimal shape (extend with your own hooks as needed):

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
    }),
  },
})

liveSocket.connect()
```

**`/live`** is the default LiveView websocket path used with Tableau’s dev tooling; keep it aligned with how you run the site.

Use **`corex/hooks`** for **`hooks`** so your entry does not import the full **`corex`** registry. Pass **`() => import("corex/<name>")`** per component you use. See [Manual installation §3](manual_installation.html#3-phoenix-hooks). **`import corex from "corex"`** plus **`{ ...corex }`** still registers every hook.

## Try a component

After **`mix compile`** and your usual Tableau asset build (for example **`mix tableau.build`** or watch tasks from **`config :tableau, :assets`**), use a component in a page template. Example (**`id`** is required when driving the component from the API):

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

More examples: [Installation — Try your first component](installation.html#try-your-first-component).

## Optional: Designex and larger sites

For **token-driven** themes and a heavier pipeline (custom palette scripts, **`designex corex`** in **`mix`** aliases), compare a mature Tableau site’s **`mix.exs`** **`build`** alias, **`config :designex`**, **`assets/css/site.css`** imports, and root layout. Older sites may still use a **simpler Esbuild** line without splitting; **this guide recommends ESM + splitting** as the supported baseline for Corex.

## Related

- [Installation](installation.html) — **`mix corex.new`**, first components, next steps.
- [Manual installation](manual_installation.html) — Esbuild details, **`mix corex.design`**, **`type="module"`**, **`use Corex`**, toasts, MCP, and Phoenix-only layout notes.
