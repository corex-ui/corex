# Tableau

## Introduction

[Corex](installation.html) on a [Tableau](https://hex.pm/packages/tableau) static site: HEEx templates, Esbuild, Tailwind, and Corex hooks over `LiveSocket`.

Install the archives once, then scaffold:

```bash
mix archive.install hex tableau_new
mix archive.install hex corex_new
mix corex.tableau.new my_site
# optional: --mode --theme --lang --a11y --mcp
```

- `--theme` / `--mode` / `--lang` / `--a11y` scaffold the same ideas as Phoenix (`data-theme`, `data-mode`, locale, accessibility), without plugs.
- Picker UI after wiring: [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), [Tableau Localize](tableau_localize.html). Accessibility panel steps match [Accessibility](accessibility.html).

Run **`mix help corex.tableau.new`** or see **`Mix.Tasks.Corex.Tableau.New`**.

## Requirements

| Requirement | Notes |
| ----------- | ----- |
| Elixir `~> 1.17` | Match Corex; Tableau may allow other floors for Tableau itself |
| Node.js | Esbuild and npm |
| `tableau_new` + `corex_new` | Or an existing Tableau HEEx site |

## How it works

1. **`mix corex.design.build`** writes CSS into `assets/corex/` via `corex_design`.
2. **Esbuild** bundles `assets/js/site.js` as ESM with splitting into `_site/js/`.
3. **Root layout** loads CSRF meta, `site.css`, and `type="module"` `site.js`.
4. **`LiveSocket`** registers Corex hooks (lazy factories keep chunks small). Tableau has no LiveView endpoint: omit `longPollFallbackMs` and call `liveSocket.disableDebug()`.

## Manual install

Add deps:

```elixir
{:corex, "~> 0.2"},
{:corex_design, "~> 0.2", runtime: false, only: :dev},
```

```bash
mix deps.get
mix corex.design.build
```

Esbuild (ESM + splitting) in `config/config.exs`:

```elixir
config :esbuild,
  version: "0.25.12",
  default: [
    args:
      ~w(js/site.js --bundle --format=esm --splitting --target=es2022 --outdir=../_site/js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
```

CSS:

```css
@import "tailwindcss";
@plugin "../vendor/heroicons";
@import "../corex/corex.css";
```

Hooks (eager chrome + lazy pages):

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import { Toast } from "corex/toast"
import { Select } from "corex/select"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    Toast,
    Select,
    ...hooks({
      Accordion: () => import("corex/accordion"),
    }),
  },
})

liveSocket.disableDebug()
liveSocket.connect()
```

Or `hooks: { ...corex }` with `import corex from "corex"` for every hook.

## Root layout

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
  end
end
```

For theme / mode / locale / accessibility attributes and before-paint scripts, use `mix corex.tableau.new` with the matching flags, or follow the Tableau picker guides and [Accessibility](accessibility.html). Prefer `Corex.Json.encode!/1` (or OTP `:json`) when embedding JSON in head scripts—do not add Jason for Corex.

## Try a component

```heex
<.accordion
  id="welcome"
  class="accordion"
  items={Corex.Content.new([
    [label: "Hello", content: "Corex on Tableau."]
  ])}
/>
```

## Optional: MCP on Bandit

Tableau has no Phoenix endpoint. Run MCP on a separate Bandit port; see [MCP](MCP.html) and `mix corex.tableau.new --mcp`.

## Related

- [Installation](installation.html) / [Manual installation](manual_installation.html) (Phoenix)
- [Tableau Theming](tableau_theming.html) / [Tableau Mode](tableau_mode.html) / [Tableau Localize](tableau_localize.html)
- [Design](design.html) / [Configuration](configuration.html) / [Updating Corex](update.html)
