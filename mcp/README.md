# Corex MCP

Dev-only [Model Context Protocol](https://modelcontextprotocol.io) server for [Corex](https://hex.pm/packages/corex). Exposes read-only tools so AI agents can discover components, modifiers, and themes without grepping the source.

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

Point your MCP client at `http://localhost:4000/corex/mcp`.

### Cursor

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

Uses OTP `:json` (OTP 27+). On OTP 26, add `{:json_polyfill, "~> 0.2 or ~> 1.0"}` to the host app (the installer already does this for `--lang`).

See the [MCP guide](guides/MCP.md) for Claude Desktop, VS Code, Tableau Bandit wiring, tools, and security.

## License

Apache-2.0 (MCP protocol stack adapted from Tidewave). Corex itself remains MIT.
