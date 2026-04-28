# Corex MCP — Usage Guide

Corex ships with a built-in MCP (Model Context Protocol) server that exposes your component registry and documentation to AI tools (Cursor, Claude, VS Code, etc.).

This allows assistants to **discover, inspect, and generate UI code** based on your actual Corex components.

## 1. Install Corex

Add Corex to an existing Phoenix application’s dependencies in `mix.exs`, then fetch deps:

```elixir
{:corex, "~> 0.1.0-beta.1"}
```

```bash
mix deps.get
```

Complete the usual Corex setup (Esbuild, `assets/js/app.js`, `use Corex`, and so on). See the [Installation](installation.html) guide and [Manual installation](manual_installation.html) for the full checklist.

- **New Phoenix app with Corex:** use `mix corex.new my_app` after installing the `corex_new` archive. Options are documented under **`Mix.Tasks.Corex.New`** (`mix help corex.new`).
- **Existing app:** run `mix igniter.install corex` (Igniter must be available). Options are documented under **`Mix.Tasks.Corex.Install`** (`mix help igniter.install` when the Corex Igniter task is loaded).

---

## 2. Enable MCP

Mount the MCP plug in development:

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

This exposes an HTTP endpoint:

```
http://localhost:4005/corex/mcp
```

---

## 3. Configure your MCP client

Add Corex as a server in your MCP-enabled tool.

### Cursor

`.cursor/mcp.json`

```json
{
  "servers": {
    "corex": {
      "url": "http://localhost:4005/corex/mcp"
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
        "url": "http://localhost:4005/corex/mcp"
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
      "url": "http://localhost:4005/corex/mcp"
    }
  }
}
```

---

### Generic MCP client

```json
{
  "name": "corex",
  "url": "http://localhost:4005/corex/mcp"
}
```

---

## 4. Start the Phoenix server

From your application directory (replace `my_app` with your app name):

```bash
cd my_app
mix phx.server
```

The MCP endpoint is only available while the dev server is running.

---

## 5. Available tools

Corex MCP exposes tools for components and installation commands:

### `corex_list_components`

List all registered Corex component ids (kebab-style keys).

### `corex_get_component`

Return module metadata and English docs for one component by id.

### `corex_installation`

Read-only JSON with commands for **new projects** (`mix corex.new` after installing the Igniter and `corex_new` archives) and **existing projects** (`mix igniter.install corex`). Optional `scenario`: `new_project`, `existing_project`, or `all` (default). Does not run shell commands.

## 6. Notes

* Intended for **development only**
* Requires your Phoenix server running locally
* Corex MCP is based on [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix/tree/main) and is distributed under the Apache License 2.0.
