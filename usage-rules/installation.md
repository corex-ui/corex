# Corex installation

## New project

```sh
mix archive.install hex phx_new
mix archive.install hex corex_new
mix corex.new my_app
mix corex.new my_app --mode --theme --lang
```

Defaults: Corex Design, `corex_mcp` + MCP plug in `:dev`/`:test` only.

| Flag | Effect |
|------|--------|
| `--no-design` | Skip corex_design dependency and design CSS |
| `--no-mcp` | Skip `corex_mcp` dep and MCP plug |
| `--mode` / `--theme` / `--lang` | Mode, theme, localization |

Run `mix help corex.new`. Update generator: `mix local.corex`.

## Existing app — apply in order

Replace `my_app` with your OTP app name.

### 1. Dependency

```elixir
{:corex, "~> 0.2.0"}
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

Add `{:corex_design, "~> 0.2", runtime: false, only: :dev}`, configure `config :corex_design`, add `/assets/corex/` to `.gitignore`, then:

```sh
mix corex.design.build
```

Do not commit `assets/corex/`. If already tracked: `git rm -r --cached assets/corex` after adding the ignore rule.

When using mode/theme/lang pickers, include `toggle` and `select` in `components:` in `config :corex_design` so they appear in the generated `components.css` entry.

## Optional toast layout

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading><.heroicon name="hero-arrow-path" /></:loading>
  <:close><.heroicon name="hero-x-mark" /></:close>
</.toast_group>
```

## MCP (dev only)

```elixir
{:corex_mcp, "~> 0.2", only: :dev}
```

```elixir
if Mix.env() in [:dev, :test] do
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
