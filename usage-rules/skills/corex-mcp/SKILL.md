---
name: corex-mcp
description: >-
  Load when configuring plug Corex.MCP in endpoint.ex, editing .cursor/mcp.json
  or Claude Desktop mcpServers JSON, calling list_components get_component
  installation_guide, config :corex debug true, or when MCP connection refused.
  Never enable MCP in production.
---

# Corex MCP

Dev/test only. After `Plug.Static` in endpoint:

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

Cursor: `{ "corex": { "url": "http://localhost:4000/corex/mcp" } }`

Claude Desktop: `{ "transport": { "type": "http", "url": "…" } }`

Call order: `list_components` → `get_component`. Stale metadata → restart server.

Full checklist: sub-rule `corex:mcp`.
