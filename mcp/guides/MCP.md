# Corex MCP

Package Hexdocs: [corex_mcp](https://hexdocs.pm/corex_mcp).

## Introduction

You expose Corex component and design metadata to AI tools (Cursor, Claude Desktop, VS Code) from your running app. The MCP server is self-hosted: no external SaaS.

Do not enable MCP in production. The tools are read-only, but the endpoint still widens your attack surface. Use it only while developing locally (or in `:test` when generated apps include it for CI). `plug Corex.MCP` raises at boot in `:prod` unless you pass `force: true` (discouraged).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| `{:corex, "~> 0.2"}` | Host app dependency (MCP soft-loads it; not a dep of `corex_mcp`) |
| `{:corex_mcp, "~> 0.2", only: [:dev, :test]}` | This package (`plug` only; uses OTP `:json`) |
| OTP 27+ (or `json_polyfill` on OTP 26) | Stdlib `:json` on OTP 27+; on OTP 26 add `{:json_polyfill, "~> 0.2 or ~> 1.0"}` to the host app |
| `{:corex_design, "~> 0.2", runtime: false, only: :dev}` | Optional host dep; enables design tools and richer `get_component` fields |
| Running HTTP server | Phoenix endpoint or Tableau Bandit child |

## Mount the endpoint

<!-- tabs-open -->

### Phoenix

Add `plug Corex.MCP` in `lib/my_app_web/endpoint.ex` **after** `Plug.Static` and **before** the code reloader block:

```elixir
if Mix.env() in [:dev, :test] do
  plug Corex.MCP
end
```

Start the app. MCP is available at `http://localhost:4000/corex/mcp` (adjust host and port).

### Tableau Bandit

Tableau has no Phoenix endpoint. Run MCP on a separate Bandit port; see the Corex [Tableau](https://hexdocs.pm/corex/tableau.html) guide (MCP section).

Default URL: `http://localhost:4004`.

<!-- tabs-close -->

## Connect your editor

Point any client that supports streamable HTTP MCP at the running URL above.

### Cursor

Create or edit `.cursor/mcp.json` in your project:

```json
{
  "mcpServers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    }
  }
}
```

For Tableau Bandit, use `http://localhost:4004` (or your configured port) instead.

### Claude Desktop

Add an entry to `claude_desktop_config.json`:

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

### VS Code and other HTTP MCP clients

Use the same URL (`http://localhost:4000/corex/mcp` for Phoenix, or your Tableau Bandit URL). Configure the client for streamable HTTP MCP and omit an `Origin` header on requests (see Security).

## Tools

All tools are read-only.

| Tool | Purpose |
| ---- | ------- |
| `list_components` | All component ids (`accordion`, `date_picker`, …) |
| `get_component` | Module, attrs/slots, docs, design modifiers when available, `source_path` |
| `list_modifiers` | Shared `ui-*` vocabulary (optional `axis` filter) |
| `get_component_style` | CSS id, axes, examples, layout for one id (needs `corex_design`) |
| `list_themes` | Theme presets and modes (needs `corex_design`) |
| `design_guide` | Setup / modifiers / theming / dark mode copy-paste (`topic`) |
| `installation_guide` | Install steps (`scenario`: `new_project`, `existing_project`, `tableau_new`, or omit for `all`) |

Call `list_components` before `get_component` when you need a valid `id`. Invalid tool arguments return an MCP error instead of being silently ignored.

## Security

- **Loopback by default.** Only requests from localhost are accepted unless you set `allow_remote_access: true` on the plug (discouraged outside trusted networks).
- **Origin header.** `POST /corex/mcp` and `GET /corex/config` reject requests that include an `Origin` header. Clients such as Cursor typically omit it.
- **Read-only tools.** No code evaluation, SQL, or log access. Component ids are allowlisted before lookup.
- **Never production.** Mount in `:dev` / `:test` only. The plug refuses to initialize in `:prod` unless `force: true` is passed.
- Corex MCP does not modify your app's Content-Security-Policy or `X-Frame-Options` headers.

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
config :corex_mcp, mcp_root: "/path/to/project"
```

`mcp_root` sets the directory used to relativize `source_path` in `get_component` (defaults to `File.cwd!()`).

Verbose MCP logging:

```elixir
config :corex_mcp, debug: true
```

| Setting | Default | Purpose |
| ------- | ------- | ------- |
| Loopback-only access | on | Non-loopback clients receive 403 unless you opt in |
| `allow_remote_access: true` | off | Allows non-loopback IPs; logs a warning at plug init |
| `config :corex_mcp, mcp_verbose_errors: false` | off | Tool failures return a generic message to clients |
| `config :corex_mcp, debug: true` | off | Verbose MCP JSON-RPC debug logging |

## Related

- [Corex installation](https://hexdocs.pm/corex/installation.html) — `mix corex.new` enables MCP in dev by default
- [Corex Design](https://hexdocs.pm/corex_design) — tokens and `ui-*` modifiers
