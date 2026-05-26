# Corex MCP

Self-hosted read-only MCP. **Dev and test only — never production.**

## Phoenix mount

After `Plug.Static`, before code reloader in `endpoint.ex`:

```elixir
if Mix.env() == :dev do
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
| `get_component` | Second — valid `id` only |
| `installation_guide` | Install questions — `scenario`: `new_project`, `existing_project`, `all` |

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Connection refused | Start Phoenix (`mix phx.server`); check port |
| Tools empty | Verify `plug Corex.MCP` in dev endpoint |
| Stale metadata | Restart server after Corex upgrade |
| Verbose logging | `config :corex, debug: true` in dev |

## Tableau

Separate Bandit port — default `http://localhost:4004`. See https://hexdocs.pm/corex/tableau.html

## References

- https://hexdocs.pm/corex/MCP.html
