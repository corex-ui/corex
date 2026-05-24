# Corex installation

## New project

```sh
mix archive.install hex phx_new
mix archive.install hex corex_new
mix corex.new my_app
mix corex.new my_app --mode --theme --lang --designex
```

Defaults: Corex Design, MCP in `:dev`/`:test` only.

| Flag | Effect |
|------|--------|
| `--no-design` | Skip design assets |
| `--no-mcp` | Skip MCP plug |
| `--designex` | Copy token sources |
| `--mode` / `--theme` / `--lang` | Mode, theme, localization |

Run `mix help corex.new`. Update generator: `mix local.corex`.

## Existing app — apply in order

Replace `my_app` with your OTP app name.

### 1. Dependency

```elixir
{:corex, "~> 0.1.0-rc.0"}
```

### 2. Esbuild ESM splitting

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

### 3. LiveSocket + hooks in assets/js/app.js

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import corex from "corex"

const csrfToken = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...corex },
})

liveSocket.connect()
```

Lazy hooks — keys are PascalCase (`Dialog`, `Accordion`):

```javascript
import { hooks } from "corex/hooks"

hooks: {
  ...colocatedHooks,
  ...hooks({
    Accordion: () => import("corex/accordion"),
    Dialog: () => import("corex/dialog"),
    Combobox: () => import("corex/combobox"),
  }),
}
```

### 4. Root layout

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

### 5. use Corex

```elixir
use Corex
use Corex, only: [:accordion], prefix: "ui"
```

### 6. Verify

```sh
mix compile && mix assets.build
```

## Design assets

```sh
mix corex.design
mix corex.design --force
```

When using mode/theme/lang pickers, also import:

```css
@import "../corex/components/toggle.css";
@import "../corex/components/select.css";
```

## Optional toast layout

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading><.heroicon name="hero-arrow-path" /></:loading>
  <:close><.heroicon name="hero-x-mark" /></:close>
</.toast_group>
```

## MCP (dev only)

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

After `Plug.Static`, before code reloader. See `corex:mcp`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Hooks not loading | `type="module"` on script tag; esbuild `--format=esm --splitting` |
| `import corex` fails | Check `NODE_PATH` includes deps in esbuild config |
| Hook no-op | Hook map key must match `phx-hook` case (`Dialog`, not `dialog`) |
| Stale JS | `mix assets.build` after hook changes |

## References

- https://hexdocs.pm/corex/manual_installation.html
