# Tableau

## Introduction

You add [Corex](installation.html) to a [Tableau](https://hex.pm/packages/tableau) static site: HEEx templates, Esbuild, Tailwind, and lazy Corex hooks over `LiveSocket`. When you finish, you can render Corex components on static pages.

Optional follow-ups: [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), [Tableau Localize](tableau_localize.html). For Phoenix apps with cookies and plugs, see [Dark mode](dark_mode.html), [Theming](theming.html), and [Localize](localize.html).

Reference templates: [corex-ui/soonex](https://github.com/corex-ui/soonex) and [corex-ui/soonex_i18n](https://github.com/corex-ui/soonex_i18n).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Elixir ~> 1.15 | Match your Tableau version |
| Node.js | For Esbuild and npm deps |
| `mix tableau.new` | HEEx + Esbuild + Tailwind template |

## How it works

1. **`mix corex.design.build`** generates token and component CSS into `assets/corex/` via the `corex_design` dependency.
2. **Esbuild** bundles `assets/js/site.js` as ESM with splitting into `_site/js/`.
3. **`RootLayout`** loads CSRF meta, `site.css`, and `type="module"` for `site.js`.
4. **`LiveSocket`** registers only the Corex hooks you import (lazy factories keep chunks small).

<!-- tabs-open -->

### Create the site

```bash
mix tableau.new my_site --template heex --js esbuild --css tailwind
cd my_site
```

Add Corex and Corex Design to `mix.exs`:

```elixir
{:corex, "~> 0.1.0"},
{:corex_design, "~> 0.2", runtime: false, only: :dev},
```

```bash
mix deps.get
mix corex.design.build
```

Configure Esbuild in `config/config.exs` (ESM + splitting for dynamic hook imports):

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

Import Corex CSS in `assets/css/site.css`:

```css
@import "tailwindcss";

@import "../corex/main.css";
@import "../corex/theme/neo.css";

@import "../corex/components.css";
```

Add `typo` and `layout` classes on `<body>` in your root layout (see below).

### Hooks lazy

Import only the hooks you use. In `assets/js/site.js`:

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

### Hooks all

Load every Corex hook in one bundle:

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

<!-- tabs-close -->

## Root layout

Corex expects ESM and a CSRF token. In `lib/layouts/root_layout.ex`:

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

## Try a component

In a page template:

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "first", label: "First", content: "Panel one."],
    [value: "second", label: "Second", content: "Panel two."],
    [value: "third", label: "Third", content: "Panel three."]
  ])}
/>
```

## Optional: MCP on Bandit

Tableau has no Phoenix endpoint. Run [MCP](mcp.html) on a separate Bandit port (default `4004`).

`lib/my_app/mcp_plug.ex`:

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

`lib/my_app/application.ex`:

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

`config/dev.exs`:

```elixir
config :my_app, :mcp_enabled, true
config :my_app, :mcp_port, 4004
```

Point your MCP client at `http://localhost:4004`.

## Related

- [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), [Tableau Localize](tableau_localize.html)
- [Manual installation](manual_installation.html) — Esbuild, `corex_design`, `use Corex`
- [MCP](mcp.html) — plug behavior and Phoenix endpoint setup
- [Installation](installation.html) — `mix corex.new` for full Phoenix apps
