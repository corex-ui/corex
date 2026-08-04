---
name: corex-mcp
description: >-
  Load when adding {:corex_mcp, only: [:dev, :test]}, configuring plug Corex.MCP in
  endpoint.ex, editing .cursor/mcp.json or Claude Desktop mcpServers JSON,
  calling list_components get_component search_docs navigation_guide
  list_modifiers get_component_style list_themes design_guide installation_guide,
  or when MCP connection refused. Never enable MCP in production.
---

# Corex MCP

Dev/test only. Package: `{:corex_mcp, "~> 0.2", only: [:dev, :test]}`.

After `Plug.Static` in endpoint:

```elixir
if Mix.env() in [:dev, :test] do
  plug Corex.MCP
end
```

Cursor: `{ "corex": { "url": "http://localhost:4000/corex/mcp" } }` (`mix corex.new` writes `.cursor/mcp.json` when `--mcp`). Prefer `--no-mcp` for locked-down scaffolds.

Claude Desktop: `{ "transport": { "type": "http", "url": "…" } }`

Call order: `list_components` → `get_component` (kebab or snake ids; structured hook/events/api); `search_docs` / `navigation_guide` as needed; `list_modifiers` / `get_component_style` for `ui-*`; `list_themes` / `design_guide` for theming. Prompts: `corex_form`, `corex_controlled`, `corex_style`. Stale metadata → restart server.

Full checklist: sub-rule `corex:mcp`.
