# Corex MCP

Corex includes a self-hosted [Model Context Protocol](https://modelcontextprotocol.io/) (MCP) server, allowing you to securely serve Corex component registry and documentation to AI-powered tools like Cursor, Claude, and VS Code directly from your Phoenix app with no external dependencies or cloud services.

Corex MCP is based of [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix) which is under Apache [Licence 2](https://github.com/tidewave-ai/tidewave_phoenix/blob/main/LICENSE)

## 1. Install Corex

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-beta.1"}
  ]
end
```

```bash
mix deps.get
```

## 2. Mount the MCP plug

Add `plug Corex.MCP` to `lib/my_app_web/endpoint.ex` **before** the `if code_reloading? do` block, and after `Plug.Static` 

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

## 4. Configure your MCP client

Use `http://localhost:4000/corex/mcp` (same host and port as the running Phoenix server).

### Cursor

`.cursor/mcp.json` at the root of your project:

```json
{
  "servers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    }
  }
}
```

### Claude Desktop

`~/Library/Application Support/Claude/claude_desktop_config.json` add to `mcpServers`:

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

### VS Code

`settings.json`:

```json
{
  "mcp.servers": {
    "corex": {
      "url": "http://localhost:4000/corex/mcp"
    }
  }
}
```

### Generic MCP client

```json
{
  "name": "corex",
  "url": "http://localhost:4000/corex/mcp"
}
```

## 5. Available tools

Corex MCP exposes the following tools

### `list_components`

### `get_component`

### `installation_guide`

