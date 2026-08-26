# Corex MCP

Self-hosted read-only MCP via the **`corex_mcp`** Hex package. **Dev and test only — never production.**

`corex_mcp` soft-loads `corex` / `corex_design` from the host app (it does not depend on them).

## Dependency

```elixir
{:corex, "~> 0.2"},
{:corex_mcp, "~> 0.2", only: [:dev, :test]}
```

Optional: `{:corex_design, "~> 0.2", runtime: false}` for design tools and richer `get_component` fields.
## Phoenix mount

After `Plug.Static`, before code reloader in `endpoint.ex`:

```elixir
if Mix.env() in [:dev, :test] do
  plug Corex.MCP
end
```

URL: Phoenix `http://localhost:4000/corex/mcp`; Tableau Bandit `http://localhost:4004/corex/mcp` (path always `/corex/mcp`).

## Cursor

Project `.cursor/mcp.json` is written by `mix corex.new` / `mix corex.tableau.new` when `--mcp` (single URL for that app). For a **user-level** `~/.cursor/mcp.json` when you use both Phoenix and Tableau:

```json
{
  "mcpServers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    },
    "corex-tableau": {
      "url": "http://localhost:4004/corex/mcp"
    }
  }
}
```

Prefer `--no-mcp` for locked-down scaffolds. Never set `allow_remote_access: true` casually.

## Claude Desktop

Same two servers in `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "corex": {
      "transport": {
        "type": "http",
        "url": "http://localhost:4000/corex/mcp"
      }
    },
    "corex-tableau": {
      "transport": {
        "type": "http",
        "url": "http://localhost:4004/corex/mcp"
      }
    }
  }
}
```

Other streamable HTTP clients: configure Phoenix on **4000** and Tableau on **4004** the same way.

## Tools — call order

| Tool | When |
|------|------|
| `list_components` | First — ids plus `form_capable` |
| `get_component` | Second — structured hook/events/api/data_builders/form/attrs/slots (optional `include_docs`) |
| `search_docs` | Usage-rules / Hexdocs search in-process |
| `navigation_guide` | Links, actions, redirect-on-select patterns |
| `list_modifiers` / `get_component_style` | Styling / `ui-*` classes |
| `list_themes` / `design_guide` | Theme and design setup |
| `installation_guide` | Install questions — `scenario`: `new_project`, `existing_project`, `tableau_new`, or omit for `all` |

Prompts: `corex_form`, `corex_controlled`, `corex_style`.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Connection refused | Start the host (`mix phx.server` on 4000, or Tableau MCP Bandit on 4004); check which MCP server URL your client uses |
| Tools empty / module missing | Add `{:corex_mcp, "~> 0.2", only: [:dev, :test]}` and `plug Corex.MCP` |
| Design tools error | Add `corex_design` and rebuild |
| Stale metadata | Restart server after Corex upgrade |
| Verbose logging | `config :corex_mcp, debug: true` in dev |

## Tableau

Separate Bandit — default `http://localhost:4004/corex/mcp`. Register alongside Phoenix (`4000`) in shared MCP client configs. See https://hexdocs.pm/corex/tableau.html

## References

- https://hexdocs.pm/corex_mcp/MCP.html
