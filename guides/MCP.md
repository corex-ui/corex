# Corex MCP

Corex ships a built-in [Model Context Protocol](https://modelcontextprotocol.io/) server that exposes your component registry and documentation to AI tools (Cursor, Claude, VS Code, …).

This lets assistants **discover, inspect, and generate UI code** based on the components actually installed in your project — not stale snapshots from training data.

It is intended for **development only**. Mount it in `dev` (and optionally `test`), never in `prod`.

## 1. Install Corex

If you generated the project with `mix corex.new`, the MCP plug is already wired and you can skip to step 3. Otherwise, follow [Installation](installation.html) or [Manual installation](manual_installation.html) to get Corex into your app:

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

The MCP server is part of the `:corex` package — no extra dependency is needed.

## 2. Mount the MCP plug

In `lib/my_app_web/endpoint.ex`, mount Corex MCP inside a `dev`-only block. Place it after the `Plug.Static` line (or, if you prefer, after the `socket` declarations) so it does not interfere with static asset serving:

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

This exposes a small HTTP surface under `/corex`:

- `GET /corex` — JSON registry summary
- `GET /corex/config` — generator config snapshot
- `POST /corex/mcp` — JSON-RPC endpoint speaking the MCP protocol

The default development port is whatever your endpoint listens on (`4000` for `phx.new`, `4005` for the Corex `e2e` app, …) — substitute it everywhere below.

## 3. Verify

Start the server and hit the registry endpoint:

```bash
mix phx.server
```

```bash
curl http://localhost:4000/corex
```

A successful response is JSON with a `components` key listing every Corex function component the app knows about. If you get `404`, the plug isn't mounted; if you get HTML, the request hit your router's catch-all instead of the MCP plug — make sure `plug Corex.MCP` is **above** any catch-all in the endpoint.

## 4. Configure your MCP client

Add Corex as an HTTP MCP server in whichever AI tool you use. The URL is always `http://localhost:<port>/corex/mcp`.

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

`~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) — add to `mcpServers`:

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

### VS Code (MCP extension)

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

Most clients that speak the HTTP transport need just the name and URL:

```json
{
  "name": "corex",
  "url": "http://localhost:4000/corex/mcp"
}
```

## 5. Available tools

Corex MCP exposes the following tools over JSON-RPC. The names are stable; the arguments and return shapes are documented per-tool below.

### `corex_list_components`

Returns every registered Corex component id in kebab-case (e.g. `accordion`, `combobox`, `date-picker`). Use this to discover what's available before drilling into a specific component.

### `corex_get_component`

Returns module metadata and English docs for **one** component, looked up by the kebab-case id from `corex_list_components`. The payload includes attributes, slots, and rendered moduledoc — enough for an assistant to write a correct `<.component …>` invocation without guessing.

### `corex_installation`

Read-only JSON describing how to install Corex into:

- A **new project** — the `mix archive.install hex corex_new && mix corex.new my_app` flow.
- An **existing project** — `mix igniter.install corex` flow.

Pass `scenario: "new_project"`, `"existing_project"`, or `"all"` (default). The tool never executes shell commands; it only returns the recommended steps.

## Notes

- Intended for **development only** — do not mount Corex.MCP in `prod`.
- Requires your Phoenix server running locally so AI tools can reach `localhost`.
- Corex MCP is based on [Tidewave Phoenix](https://github.com/tidewave-ai/tidewave_phoenix) and is distributed under the Apache License 2.0. See `LICENSES/TIDWAVE_MCP_BASELINE.md` in the repo for the upstream-tracking notes.
