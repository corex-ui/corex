# Corex MCP

Corex ships a built-in [Model Context Protocol](https://modelcontextprotocol.io/) server that exposes your component registry and documentation to AI tools (Cursor, Claude, VS Code, …).

This lets assistants **discover, inspect, and generate UI code** based on the components actually installed in your project — not stale snapshots from training data.

It is intended for **development only**, never in `prod`.

## 1. Install Corex

If you generated the project with `mix corex.new`, the MCP plug may already be wired; otherwise follow [Installation](installation.html) or [Manual installation](manual_installation.html):

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

The MCP implementation lives in the `:corex` package.

## 2. Mount the MCP plug

Add `plug Corex.MCP` to `lib/my_app_web/endpoint.ex` **before** the `if code_reloading? do` block, and after `Plug.Static` (and sockets) so static files and MCP routing behave correctly.

```elixir
if Mix.env() == :dev do
  plug Corex.MCP
end
```

Use `Mix.env() in [:dev, :test]` instead if you want `ConnCase` tests to hit `/corex/...` without extra setup.

MCP is served by the **same** HTTP server and **same port** as your Phoenix app. URLs use your endpoint port (often `4000`, or whatever `PORT` sets).

Routes:

- `GET /corex` — MCP landing page (HTML)
- `GET /corex/config` — generator config snapshot (JSON)
- `POST /corex/mcp` — JSON-RPC for MCP

## 3. Verify

```bash
mix phx.server
```

```bash
curl http://localhost:4000/corex
```

Use your real dev port if it is not `4000`. You should see HTML mentioning Corex MCP. If you get `404`, the plug is not mounted or sits below a catch-all—keep `plug Corex.MCP` above parsers and the router’s catch-all.

## 4. Configure your MCP client

Use `http://localhost:<your-phoenix-port>/corex/mcp` (same host and port as the running Phoenix server).

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

```json
{
  "name": "corex",
  "url": "http://localhost:4000/corex/mcp"
}
```

## 5. Available tools

Corex MCP exposes the following tools over JSON-RPC. Clients discover names via `tools/list`; arguments use JSON objects as described below.

### `list_components`

No arguments.

Returns JSON `{ "components": ["accordion", "date_picker", …] }` — stable ids stringified from the Corex registry. Call this before `get_component` when you need the allowed ids.

### `get_component`

Arguments: `{ "id": "<string>" }` — use an id from `list_components`.

Returns JSON including:

- `id`, `module`, `function_components` — registry metadata (`function_components` lists `{ "name", "arity" }` entries you import via `use Corex`).
- `docs` — markdown module documentation when available (`Code.fetch_docs/1`), prefixed with `# ModuleName`; otherwise `null`.
- `docs_note` — short explanation when `docs` is absent or not markdown-shaped (for example hidden `@moduledoc`).
- `source_path`, `source_line` — primary module source path and annotation line when available.

Slot and attribute introspection beyond what appears in markdown is not exposed yet.

### `installation_guide`

Optional argument: `{ "scenario": "new_project" | "existing_project" | "all" }` (default `all`).

Read-only JSON with archive commands for greenfield apps (`mix corex.new`) and `minimal_steps` for existing Phoenix apps (deps, Esbuild ESM hooks, layout script module, `use Corex`, verify commands, optional MCP plug). Full prose guides remain on Hexdocs; use `reference_urls` when you need links.

The tool never executes shell commands.

## Notes

- Intended for **development only** — do not mount `Corex.MCP` in `prod`.
- Requires the Phoenix dev server running locally so clients can reach `localhost` on your app port.
- Third-party notices for adapted MCP-related code are listed in the repository `LICENSE` file. Corex MCP is distributed under the Apache License 2.0.
