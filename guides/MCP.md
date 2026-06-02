# Corex MCP

## Introduction

You expose Corex component metadata to AI tools (Cursor, Claude Desktop, VS Code) from your running app. The MCP server is self-hosted—no external SaaS.

Built on [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix) (Apache-2.0).

Do not enable MCP in production. The tools are read-only, but the endpoint still widens your attack surface. Use it only while developing locally (or in `:test` when generated apps include it for CI).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| `{:corex, "~> 0.1.0"}` | In `mix.exs` |
| Running HTTP server | Phoenix endpoint or Tableau Bandit child |

<!-- tabs-open -->

### Phoenix endpoint

Add `plug Corex.MCP` in `lib/my_app_web/endpoint.ex` **after** `Plug.Static` and **before** the code reloader block:

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

Start the app. MCP is available at `http://localhost:4000/corex/mcp` (adjust host and port).

**Cursor** — `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    }
  }
}
```

**Claude Desktop** — `claude_desktop_config.json`:

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

### Tableau Bandit

Tableau has no Phoenix endpoint. Run MCP on a separate Bandit port—see [Tableau](tableau.html) (MCP section).

Point your client at `http://localhost:4004` when using the default MCP port there.

<!-- tabs-close -->

## Tools

All tools are read-only.

| Tool | Purpose |
| ---- | ------- |
| `list_components` | All component ids (`accordion`, `date_picker`, …) |
| `get_component` | Module, slots, docs, `source_path` for one `id` |
| `installation_guide` | Install steps for new or existing projects (`scenario`: `new_project`, `existing_project`, `all`) |

Call `list_components` before `get_component` when you need a valid `id`.

## Security

| Setting | Default | Purpose |
| ------- | ------- | ------- |
| Loopback-only access | on | Non-loopback clients receive 403 unless you opt in |
| `allow_remote_access: true` | off | Allows non-loopback IPs; logs a warning at plug init. Restrict with a firewall or VPN. Never use in production. |
| `config :corex, mcp_verbose_errors: false` | off | Tool failures return a generic message to MCP clients; full exceptions stay in server logs |
| `config :corex, debug: true` | off | Enables verbose MCP JSON-RPC debug logging on `Corex.MCP.Server` |

Example for local debugging only:

```elixir
config :corex, debug: true, mcp_verbose_errors: true
```

Remote access (discouraged outside trusted networks):

```elixir
plug Corex.MCP, allow_remote_access: true
```

## Related

- [Installation](installation.html) — `mix corex.new` enables MCP in dev by default
- [Tableau](tableau.html) — Bandit MCP for static sites
