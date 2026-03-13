# Tidewave MCP

This project has Tidewave available in development. Prefer Tidewave for Elixir and Hex interactions instead of guessing or simulating.

- **get_docs** — Elixir/Hex documentation; use instead of web search.
- **project_eval** — Run Elixir code in the app context; use instead of inferring results.
- **get_source_location** — Find module/function definitions; use instead of guessing.
- **search_package_docs** — Hex package docs; use instead of fetching Hex docs manually.
- **get_logs** — Application logs; use when debugging.

When Ecto is used: **get_models** and **execute_sql_query** for schema and data.

Do not guess or simulate Elixir/Hex behaviour — look up or evaluate via Tidewave.

The app serves Tidewave at `/tidewave` in development; point Cursor MCP at `http://localhost:PORT/tidewave/mcp`.
