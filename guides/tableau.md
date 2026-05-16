# Tableau

This guide adds [Corex](installation.html) to a **[Tableau](https://hex.pm/packages/tableau)** static site built with HEEx, Esbuild, and Tailwind.

## Ready-made templates

For a production-oriented Tableau stack with Corex already wired up, start from **[corex-ui/soonex](https://github.com/corex-ui/soonex)** (English, theme and mode switches) or **[corex-ui/soonex\_i18n](https://github.com/corex-ui/soonex\_i18n)** (multiple locales, RTL, per-locale permalinks, language switch). Each README describes `mix tableau.server`, assets, MCP, and CI.

Rough map of how those repos layer behavior:

| Area | Soonex | Soonex i18n |
|------|--------|-------------|
| Root layout | `lib/*/layouts/root_layout.ex` | Same pattern with `Locale`, `hreflang`, and `data-locale*` on `<html>` |
| Theme | `Theme` module with `head_script/0`; `assets/js/theme.js`; `<html data-theme data-themes data-default-theme>` | Same split under `SoonexI18n.Theme` |
| Mode | `Mode` module with `head_script/0`; `assets/js/mode.js`; `data-mode` | Same under `SoonexI18n.Mode` |
| Locale | — | Gettext backend, `Locale`, `locale.js`, `<.select redirect>` |

The manuals below mirror that split when you integrate Corex yourself.

## Manual path after `tableau.new`

Follow **[Tableau static + Corex: theming](tableau_theming.html)**, **[Tableau static + Corex: mode](tableau_mode.html)**, and **[Tableau static + Corex: localize](tableau_localize.html)** only when you need multi-theme picker, light/dark, or locales. **[Dark mode](dark_mode.html)**, **[Theming](theming.html)**, and **[Localize](localize.html)** explain the Phoenix plug and cookie flows that static HTML approximates.

The rest of this page is the **minimum** dependency, layout, and hooks path with no theme, mode, or locale hooks.

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
{:corex, "~> 0.1.0"}
```

Then:

```bash
mix deps.get
```

## 2. Esbuild: ESM, splitting, and `_site/js`

Corex’s client uses **dynamic `import()`** for hook chunks. Follow **[Manual installation - Esbuild](manual_installation.html#2-esbuild)** (`--format=esm`, `--splitting`, a modern **`--target`** such as **`es2022`**). Keep Tableau’s output directory so URLs stay **`/js/site.js`** and chunks stay next to that file under **`_site/js`**.

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

After **`@import "tailwindcss"`** (or your Tailwind v4 entry), import design layers. For the accordion demo later, import **`main.css`**, one **theme**, **typography**, **layout**, and **`accordion.css`**. Extra component CSS (`select`, `toggle-group`, and more theme files) belongs in **[Tableau static + Corex: theming](tableau_theming.html)** and **[Tableau static + Corex: mode](tableau_mode.html)** when you add those controls.

```css
@import "tailwindcss";

@import "../corex/main.css";
@import "../corex/theme/neo.css";

@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/accordion.css";
```

Each `theme/*.css` file scopes tokens under `[data-theme="<name>"]`. With a single import, set **`data-theme="neo"`** on `<html>` if you add mode-only UI later, or rely on the default in the theme file’s scope.

Add **`typo`** and **`layout`** classes on **`<body>`**.

## 5. Root layout

Corex’s JS is **ESM** and Phoenix **`LiveSocket`** expects a **CSRF** token in the page. This layout does not set `data-theme`, `data-mode`, or locale attributes; add those from the optional guides when needed.

In your **`Tableau.Layout`** module (typically **`lib/layouts/root_layout.ex`**):

```elixir
defmodule MyApp.RootLayout do
  import Phoenix.Controller, only: [get_csrf_token: 0]

  use Tableau.Layout
  use Phoenix.Component
  use Corex

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" dir="ltr">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>{assigns[:page_title] || "MyApp"}</title>
        <link rel="stylesheet" href="/css/site.css" />
        <script type="module" src="/js/site.js" />
      </head>
      <body class="layout typo">
        <main class="layout__main">
          <div class="layout__content">
            {render(@inner_content)}
          </div>
        </main>
      </body>
    </html>
    """
    |> Phoenix.HTML.Safe.to_iodata()
  end
end
```

Invariant pieces:

1. **`<meta name="csrf-token" content={get_csrf_token()} />`** — required by `Phoenix.LiveSocket`.
2. **`<script type="module" src="/js/site.js" />`** — Corex’s bundle is ESM.
3. **`use Corex`** — exposes Corex function components inside the layout template.

## 6. Corex hooks

Import the **lazy `hooks`** helper from **`corex/hooks`** and pass one zero-argument factory per hook you actually use. Object keys must match the **`phx-hook`** names. With **`--format=esm --splitting`** from **2. Esbuild**, Esbuild emits chunks **only** for listed hooks.

In **`assets/js/site.js`**:

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
    }),
  },
})

liveSocket.connect()
```

Add **`Select`**, **`Toggle`**, and separate **`theme.js`** / **`mode.js`** / **`locale.js`** imports when you follow the Tableau extras linked below.

If you'd rather pull in **every** Corex hook at once:

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...corex },
})
```

Each lazy factory in the **`hooks({...})`** form is a **zero-argument function** returning the same dynamic `import()` your bundler would emit.

## Optional: theming, mode, and localization

- **[Tableau static + Corex: theming](tableau_theming.html)** — `data-theme`, theme list, `Theme.head_script/0`, theme picker, `theme.js`.
- **[Tableau static + Corex: mode](tableau_mode.html)** — `data-mode`, `Mode.head_script/0`, toggle group, `mode.js` (works with a **fixed** theme when you do not use the theming guide).
- **[Tableau static + Corex: localize](tableau_localize.html)** — Gettext, Localize, per-locale pages, language select, `locale.js`.

If you use **both** theme and mode, call **`MyApp.Theme.head_script()`** then **`MyApp.Mode.head_script()`** inside `<head>` in that order so the first paint matches both stored keys.

## MCP via Bandit (optional)

**`mix corex.new`** for Phoenix wires the **MCP plug** into the endpoint. Tableau builds static HTML and has no endpoint, so MCP runs as a **separate Bandit child** in the application supervisor on a dedicated port (default **`4004`**).

For what that plug exposes and how editors use it, see [MCP](mcp.html).

### The plug

```elixir
defmodule MyApp.McpPlug do
  use Plug.Builder

  plug Corex.MCP
  plug :not_found

  defp not_found(conn, _) do
    if conn.halted? do
      conn
    else
      conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(404, "Not found")
    end
  end
end
```

The **MCP plug** halts the conn for the routes it handles; **`:not_found`** returns 404 for everything else.

### The supervisor child

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:my_app, :mcp_enabled, false) do
        [
          {Bandit,
           plug: MyApp.McpPlug,
           scheme: :http,
           port: Application.get_env(:my_app, :mcp_port, 4004)}
        ]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

Add **`{:bandit, "~> 1.0"}`** to your deps if needed, and point **`mod:`** in **`mix.exs`** at **`{MyApp.Application, []}`** so the supervisor starts.

### Per-environment config

Enable in **`config/dev.exs`** (and **`config/test.exs`** if needed):

```elixir
config :my_app, :mcp_enabled, true
config :my_app, :mcp_port, 4004
```

Production keeps **`:mcp_enabled`** falsey by default. With Tableau's dev server on **`:4999`** and MCP on **`:4004`**, point your MCP client at **`http://localhost:4004`**.

## Try a component

After **`mix compile`** and your usual Tableau asset build (for example **`mix tableau.build`** or watch tasks from **`config :tableau, :assets`**), use a component in a page template.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [label: "First", content: "Panel one."],
    [label: "Second", content: "Panel two."]
  ])}
/>
```

## Related

- [Installation](installation.html) — **`mix corex.new`**, first components, next steps.
- [Manual installation](manual_installation.html) — Esbuild details, **`mix corex.design`**, **`type="module"`**, **`use Corex`**, toasts, MCP, Phoenix layout notes.
- [Tableau static + Corex: theming](tableau_theming.html), [Tableau static + Corex: mode](tableau_mode.html), [Tableau static + Corex: localize](tableau_localize.html) — static counterparts to [Theming](theming.html), [Dark mode](dark_mode.html), [Localize](localize.html).
- [MCP](mcp.html) — MCP plug behavior and Phoenix integration.
