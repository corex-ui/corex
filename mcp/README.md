# Corex MCP

Dev-only [Model Context Protocol](https://modelcontextprotocol.io) server for [Corex](https://hex.pm/packages/corex). Exposes read-only tools so AI agents can discover components, modifiers, and themes without grepping the source.

Never enable in production. Upgrading from 0.1.x: [Updating Corex](https://hexdocs.pm/corex/update.html).

## Requirements

- **Elixir** `~> 1.17`

## Packages

| Package | Kind | Purpose | `mix corex.new` |
|---------|------|---------|-----------------|
| [`corex`](https://hex.pm/packages/corex) | Hex dep | Unstyled Phoenix components, hooks, LiveView API | Always |
| [`corex_design`](https://hex.pm/packages/corex_design) | Hex dep (`runtime: false`) | Config-driven tokens, themes, and component CSS ([Design](https://hexdocs.pm/corex/design.html)) | On by default; `--no-design` to skip |
| [`corex_mcp`](https://hex.pm/packages/corex_mcp) | Hex dep (`only: [:dev, :test]`) | Dev MCP server for AI component and design discovery ([MCP](https://hexdocs.pm/corex/MCP.html)); never enable in `:prod` | On by default; `--no-mcp` to skip |
| [`corex_new`](https://hex.pm/packages/corex_new) | Mix archive | Greenfield generator (`mix corex.new`) | Install once with `mix archive.install hex corex_new` |

## Installation

`corex_mcp` does not depend on `corex` or `corex_design`. Add those in the host app (the installer does this by default):

```elixir
def deps do
  [
    {:corex, "~> 0.2"},
    {:corex_design, "~> 0.2", runtime: false, only: :dev},
    {:corex_mcp, "~> 0.2", only: [:dev, :test]}
  ]
end
```

Mount in your Phoenix endpoint after `Plug.Static` and before the code reloader:

```elixir
if Mix.env() in [:dev, :test] do
  plug Corex.MCP
end
```

Point your MCP client at Phoenix `http://localhost:4000/corex/mcp` or Tableau `http://localhost:4004/corex/mcp`. Prefer `--no-mcp` when scaffolding apps that should not expose the endpoint. Never set `allow_remote_access: true` casually.

### Cursor / Claude Desktop / other clients

`mix corex.new` / `mix corex.tableau.new` write a **project** `.cursor/mcp.json` with the single URL for that app when `--mcp` is on (default). For a **user-level / shared** config (Cursor, Claude Desktop, VS Code, etc.) when you use both hosts, register both servers:

Cursor `mcp.json`:

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

Claude Desktop uses the same two URLs under `transport.type: "http"`. Other streamable HTTP clients: configure Phoenix on **4000** and Tableau on **4004**; path is always `/corex/mcp`.

Canonical guide (tools, security, Tableau Bandit): [MCP on Hexdocs](https://hexdocs.pm/corex/MCP.html) / repo [`guides/MCP.md`](https://github.com/corex-ui/corex/blob/main/guides/MCP.md).

## License

Apache-2.0 (MCP protocol stack adapted from Tidewave). Corex itself remains MIT.

## Become a sponsor

Corex is open source. If you rely on it in production or want to help sustain development, [become a sponsor on GitHub](https://github.com/sponsors/corex-ui).

<p>
<a href="https://netoum.com"><img src="images/netoum.svg" alt="Netoum" height="40"></a>
</p>
