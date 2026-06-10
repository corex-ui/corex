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

1. `{:corex, "~> 0.2"}` + `{:corex_design, "~> 0.2"}` → esbuild ESM splitting → LiveSocket + hooks → `type="module"` script → `use Corex` → `mix compile` → `mix assets.build`

```javascript
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...colocatedHooks, ...corex },
})
```

Lazy hooks: PascalCase keys (`Dialog: () => import("corex/dialog")`).

## Design + optional toast

Add `{:corex_design}`, register the `:corex_design` compiler, set `config :corex_design`, then:

```sh
mix compile
```

Import `./corex.tailwind.css` in `assets/css/app.css`.

MCP: `plug Corex.MCP` in dev only — see **corex-mcp**.

Full checklist: sub-rule `corex:installation`. MCP `installation_guide` when server is running.
