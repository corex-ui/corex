# Rules for working with Corex

## Understanding Corex

Corex is an accessible, unstyled Phoenix component library powered by Zag.js state machines. Every component exposes a **server API** (LiveView/socket helpers) and a **client API** (JS commands). Corex Design is optional token-based CSS with modifier classes such as `button--accent`.

Read documentation and call Corex MCP tools **before** guessing attrs, slots, or install steps.

Hexdocs: https://hexdocs.pm/corex

## Package layout

| Layer | Path | Consumer use |
|-------|------|--------------|
| Main rules | `usage-rules.md` | `:corex` in AGENTS.md config |
| Sub-rules | `usage-rules/<topic>.md` | `"corex:<topic>"` or `"corex:all"` |
| Pre-built skills | `usage-rules/skills/<name>/SKILL.md` | `package_skills: [:corex]` in mix.exs |

Sub-rules hold depth for AGENTS.md. Skills hold short triggers + examples for Cursor. Do not duplicate full sub-rules inside skills.

## Non-negotiables

1. **Never enable `plug Corex.MCP` in production.** Dev and test only.
2. **Call MCP before writing HEEx.** Add `corex_mcp`, then `list_components` → `get_component` (and design tools when styling) — never invent attrs, slots, or event names.
3. **Every API-driven component needs a stable `id`.**
4. **Esbuild must use ESM splitting.** `--format=esm --splitting`; load `app.js` with `type="module"`.
5. **Do not web-search Hexdocs.** Use `mix usage_rules.search_docs -p corex`.

## Doc lookup

```sh
mix usage_rules.search_docs "accordion set_value" -p corex
mix usage_rules.search_docs "on_value_change" -p corex --query-by title
```

## Sub-rules

| Sub-rule | When to read |
|----------|--------------|
| `corex:installation` | `mix corex.new`, manual install, esbuild, hooks, `use Corex`, `mix corex.design` |
| `corex:components` | HEEx wiring, MCP lookup, data builders, slots, hooks |
| `corex:design` | Modifiers, tokens, `.typo`, themes — no custom template CSS |
| `corex:mcp` | Dev MCP plug, `.cursor/mcp.json`, tool call order |
| `corex:api` | Imperative `Corex.*` helpers, `<.action>`, controlled mode |
| `corex:events` | `on_*_change` server and client event subscriptions |
| `corex:forms` | Phoenix `to_form` + Corex input components (no Form component) |
| `corex:navigation` | `<.navigate>`, `<.action>`, `redirect` on select/menu/combobox |

Include all: `"corex:all"` in AGENTS.md config.

## Three complementary tools

| Tool | Role |
|------|------|
| **usage_rules** | Static rules and skills from the `corex` dep |
| **Corex MCP** (`corex_mcp`) | Live `list_components`, `get_component`, design tools, `installation_guide` |
| **mix usage_rules.search_docs** | Hexdocs search |

## Agent skills

Enable pre-built skills:

```elixir
skills: [location: ".cursor/skills", package_skills: [:corex]]
```

Run `mix usage_rules.sync`. Do **not** also set `deps: [:corex]` — that creates a redundant `use-corex` skill.

Skills synced: `corex-installation`, `corex-components`, `corex-design`, `corex-mcp`, `corex-api`, `corex-events`, `corex-forms`, `corex-navigation`.

## Quick install

```sh
mix archive.install hex phx_new
mix archive.install hex corex_new
mix corex.new my_app
```

Existing app: see `corex:installation`. Design: `mix corex.design` then `corex:design`.
