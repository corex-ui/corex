# MCP

MCP (Model Context Protocol) lets an editor/agent connect to external tools (for example browser automation, design tools, or a running application) through a standard interface.

## In this project

- Corex includes MCP-related tooling in the `e2e/` app (used to validate documentation and demos).
- If you are using Cursor agents, MCP is how the agent can interact with the environment beyond static code edits (when enabled).

## Practical usage

1) Start the relevant app (for example the `e2e` demo app).
2) Use the MCP integration for the tool you need (browser, app eval, docs lookup, etc.).
3) Prefer the MCP tool over guessing runtime output.

If you’re working on Corex documentation, a good workflow is:

- Keep examples in component module docs (`lib/components/...`) aligned with the `e2e` demo pages.
- Use the running `e2e` app to verify examples and interaction flows.

