# Corex MCP

Corex ships a self-hosted [Model Context Protocol](https://modelcontextprotocol.io/) (MCP) server. Your running Phoenix app exposes the component registry and docs to tools such as Cursor, Claude Desktop, or VS Code, without an external SaaS.

The server builds on [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix) (Apache License 2.0).

## 1. Install Corex

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-beta.4"}
  ]
end
```

```bash
mix deps.get
```

## 2. Mount the MCP plug

In `lib/my_app_web/endpoint.ex`, add `plug Corex.MCP` **after** `Plug.Static` and **before** the `if code_reloading? do` block.

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

## 3. Run the app

MCP listens on the same host and port as Phoenix (for example `http://localhost:4000`). Start the server before connecting a client.

## 4. Configure your MCP client

Use `http://localhost:4000/corex/mcp` (adjust host and port to match your app).

### Cursor

Project file `.cursor/mcp.json`:

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

In `~/Library/Application Support/Claude/claude_desktop_config.json`, under `mcpServers`:

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

In `settings.json`:

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

All tools are read-only and safe to call repeatedly.

### `list_components`

Returns every Corex component id from the package registry (strings such as `accordion` or `date_picker`). Use this before `get_component` when you need a valid id.

**Arguments:** none (empty object).

**Result:** JSON with a `components` array of id strings.

### `get_component`

Returns metadata for one component: Elixir module, function component names and arity, Markdown module documentation when available, `source_path` when known, and `docs_note` when docs are missing or not Markdown.

Pass `id` exactly as returned by `list_components`.

**Arguments:**

- `id` (string, required)  -  e.g. `accordion`, `data_table`

**Result:** JSON object with the registry payload plus `docs`, `docs_note`, `source_path`, and related fields.

### `installation_guide`

Returns copy-paste steps for installing Corex on a new project (`mix corex.new`), an existing Phoenix app, or both. It does **not** run shell commands.

**Arguments:**

- `scenario` (string, optional)  -  one of `new_project`, `existing_project`, or `all` (default `all`).

**Result:** JSON with structured steps, commands, and reference URLs (`hexdocs_corex`, `manual_installation`, `repository`).
