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

Point your MCP client at `http://localhost:4000/corex/mcp`. Prefer `--no-mcp` when scaffolding apps that should not expose the endpoint. Never set `allow_remote_access: true` casually.

### Cursor

`mix corex.new` / `mix corex.tableau.new` write `.cursor/mcp.json` when `--mcp` is on (default). Manual example:

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

Canonical guide (tools, security, Tableau Bandit): [MCP on Hexdocs](https://hexdocs.pm/corex/MCP.html) / repo [`guides/MCP.md`](https://github.com/corex-ui/corex/blob/main/guides/MCP.md).

## License

Apache-2.0 (MCP protocol stack adapted from Tidewave). Corex itself remains MIT.

## Next steps

- [MCP guide](https://hexdocs.pm/corex/MCP.html) / [corex_mcp Hexdocs](https://hexdocs.pm/corex_mcp)
- [Design](https://hexdocs.pm/corex/design.html) / [corex_design](https://hexdocs.pm/corex_design)
- [Updating Corex](https://hexdocs.pm/corex/update.html)
