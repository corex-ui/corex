# Corex MCP — Usage Guide

Corex ships with a built-in MCP (Model Context Protocol) server that exposes your component registry and documentation to AI tools (Cursor, Claude, VS Code, etc.).

This allows assistants to **discover, inspect, and generate UI code** based on your actual Corex components.

## 1. Enable MCP

Mount the MCP plug in development:

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

This exposes an HTTP endpoint:

```
http://localhost:4000/corex/mcp
```

---

## 2. Configure your MCP client

Add Corex as a server in your MCP-enabled tool.

### Cursor

`.cursor/mcp.json`

```json
{
  "servers": {
    "corex": {
      "url": "http://localhost:4000/corex_dev/mcp"
    }
  }
}
```

---

### Claude Desktop

```json
{
  "mcpServers": {
    "corex": {
      "transport": {
        "type": "http",
        "url": "http://localhost:4000/corex_dev/mcp"
      }
    }
  }
}
```

---

### VS Code (MCP extension)

```json
{
  "mcp.servers": {
    "corex": {
      "url": "http://localhost:4000/corex_dev/mcp"
    }
  }
}
```

---

### Generic MCP client

```json
{
  "name": "corex",
  "url": "http://localhost:4000/corex_dev/mcp"
}
```

---

## 3. Available tools

Corex MCP exposes tools to query your design system:

### `corex_list_components`

List all available component

### `corex_get_component`

Get documentation for a component

## 4. Notes

* Intended for **development only**
* Requires your Phoenix server running locally
* Corex MCP based of [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix/tree/main) and is distributed under the Apache License 2.0.

