# Corex MCP

Self-hosted read-only MCP via the **`corex_mcp`** Hex package. **Dev and test only — never production.**

`corex_mcp` soft-loads `corex` / `corex_design` from the host app (it does not depend on them).

## Dependency

```elixir
{:corex, "~> 0.2"},
{:corex_mcp, "~> 0.2", only: [:dev, :test]}
```

Optional: `{:corex_design, "~> 0.2", runtime: false, only: :dev}` for design tools and richer `get_component` fields.
## Phoenix mount

After `Plug.Static`, before code reloader in `endpoint.ex`:

```elixir
if Mix.env() in [:dev, :test] do
  plug Corex.MCP
end
```

URL: `http://localhost:4000/corex/mcp`

## Cursor

`.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    }
  }
}
```

## Claude Desktop

```json
{
  "mcpServers": {
    "corex": {
      "transport": {
        "type": "http",
        "url": "http://localhost:4000/corex/mcp"
      }
    }
  }
}
```

## Tools — call order

| Tool | When |
|------|------|
| `list_components` | First |
| `get_component` | Second — valid `id` only (attrs, slots, modifiers when design loaded) |
| `list_modifiers` / `get_component_style` | Styling / `ui-*` classes |
| `list_themes` / `design_guide` | Theme and design setup |
| `installation_guide` | Install questions — `scenario`: `new_project`, `existing_project`, `all` |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Connection refused | Start Phoenix (`mix phx.server`); check port |
| Tools empty / module missing | Add `{:corex_mcp, "~> 0.2", only: [:dev, :test]}` and `plug Corex.MCP` |
| Design tools error | Add `corex_design` and rebuild |
| Stale metadata | Restart server after Corex upgrade |
| Verbose logging | `config :corex_mcp, debug: true` in dev |

## Tableau

Separate Bandit port — default `http://localhost:4004`. See https://hexdocs.pm/corex/tableau.html

## References

- https://hexdocs.pm/corex_mcp/MCP.html
