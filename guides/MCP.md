# Corex MCP

## Introduction

You expose Corex component metadata to AI tools (Cursor, Claude Desktop, VS Code) from your running app. The MCP server is self-hosted—no external SaaS.

Built on [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix) (Apache-2.0). Corex MCP keeps Tidewave's HTTP transport and security model but ships read-only component tools only. When upgrading Corex, compare `lib/mcp/` against the reference Tidewave version noted in `lib/mcp/server.ex`.

Do not enable MCP in production. The tools are read-only, but the endpoint still widens your attack surface. Use it only while developing locally (or in `:test` when generated apps include it for CI). `plug Corex.MCP` raises at boot in `:prod` unless you pass `force: true` (discouraged).

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
| `get_component` | Module, slots, docs, repo-relative `source_path` for one `id` |
| `installation_guide` | Install steps for new or existing projects (`scenario`: `new_project`, `existing_project`, or omit for `all`) |

Call `list_components` before `get_component` when you need a valid `id`. Invalid tool arguments return an MCP error instead of being silently ignored.

## Security

Corex MCP follows the Tidewave dev-server security model:

- **Loopback by default.** Only requests from localhost are accepted unless you set `allow_remote_access: true` on the plug (discouraged outside trusted networks).
- **Origin header.** `POST /corex/mcp` and `GET /corex/config` reject requests that include an `Origin` header. Clients such as Cursor typically omit it.
- **Read-only tools.** No code evaluation, SQL, or log access. Component ids are allowlisted before lookup.
- **Never production.** Mount in `:dev` / `:test` only. The plug refuses to initialize in `:prod` unless `force: true` is passed.

Unlike Tidewave, Corex MCP does **not** modify your app's Content-Security-Policy or `X-Frame-Options` headers. Tidewave weakens CSP globally because its landing page loads an embedded browser client; Corex serves static HTML only.

## Configuration

```elixir
plug Corex.MCP,
  allow_remote_access: false,
  force: false
```

| Option | Default | Description |
| ------ | ------- | ----------- |
| `allow_remote_access` | `false` | Allow non-loopback clients when `true` |
| `force` | `false` | Allow mounting in `:prod` when `true` (discouraged) |

Optional application config:

```elixir
config :corex, mcp_root: "/path/to/project"
```

`mcp_root` sets the directory used to relativize `source_path` in `get_component` (defaults to `File.cwd!()`). Useful in umbrella apps or CI.

Verbose MCP logging:

```elixir
config :corex, debug: true
```

## Security

| Setting | Default | Purpose |
| ------- | ------- | ------- |
| Loopback-only access | on | Non-loopback clients receive 403 unless you opt in |
| `allow_remote_access: true` | off | Allows non-loopback IPs; logs a warning at plug init. Restrict with a firewall or VPN. Never use in production. |
| `config :corex, mcp_verbose_errors: false` | off | Tool failures return a generic message to MCP clients; full exceptions stay in server logs |
| `config :corex, debug: true` | off | Enables verbose MCP JSON-RPC debug logging in server logs |

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
