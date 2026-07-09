---
name: corex-installation
description: >-
  Load when running mix corex.new, adding {:corex} and {:corex_design} to mix.exs,
  configuring esbuild --format=esm --splitting, LiveSocket with csrfToken and
  hooks: { ...colocatedHooks, ...corex } in assets/js/app.js, use Corex in
  lib/*_web.ex, type="module" on app.js script tag, toggle.css select.css for
  mode/theme pickers, or toast_group layout in root layout.
---

# Corex installation

## New project

```sh
mix corex.new my_app
```

## Existing app — order matters

1. `{:corex, "~> 0.1.0"}` and `{:corex_design, "~> 0.2", runtime: false, only: :dev}` → esbuild ESM splitting → LiveSocket + hooks → `type="module"` script → `use Corex` → `mix assets.build`

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...corex },
})
```

Lazy hooks: PascalCase keys (`Dialog: () => import("corex/dialog")`).

## Design + optional toast

```sh
mix corex.design.build
```

Import `toggle.css` / `select.css` when using mode/theme/lang pickers.

MCP: `plug Corex.MCP` in dev only — see **corex-mcp**.

Full checklist: sub-rule `corex:installation`. MCP `installation_guide` when server is running.
