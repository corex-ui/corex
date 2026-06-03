# Usage rules and agent skills

Corex ships eight agent skills that sync into your project via [usage_rules](https://github.com/ash-project/usage_rules). For live component attrs and slots, also set up [Corex MCP](mcp.html).

## Setup

Add the dependency:

```sh
mix igniter.install usage_rules
```

Or in `mix.exs`:

```elixir
{:usage_rules, "~> 1.1", only: [:dev]}
```

Add to `project/0`:

```elixir
def project do
  [app: :my_app, ..., usage_rules: usage_rules()]
end

defp usage_rules do
  [
    skills: [
      location: ".cursor/skills",
      package_skills: [:corex]
    ]
  ]
end
```

Sync and restart Cursor:

```sh
mix deps.get
mix usage_rules.sync
```

You get eight skills: `corex-installation`, `corex-components`, `corex-design`, `corex-mcp`, `corex-api`, `corex-events`, `corex-forms`, `corex-navigation`.

Re-run `mix usage_rules.sync` after upgrading Corex.

Do **not** also set `deps: [:corex]` in usage_rules config — that creates a redundant auto-generated `use-corex` skill.

## AGENTS.md (optional)

To also write Corex rules into `AGENTS.md`:

```elixir
defp usage_rules do
  [
    file: "AGENTS.md",
    usage_rules: [:corex, "corex:all"],
    skills: [
      location: ".cursor/skills",
      package_skills: [:corex]
    ]
  ]
end
```

Sub-rules cover installation, components, design, MCP, API (imperative helpers), events (`on_*_change`), forms, and navigation.

## Search Hexdocs

```sh
mix usage_rules.search_docs "accordion set_value" -p corex
```

## See also

- [MCP](mcp.html)
- [Installation](installation.html)
- [Design](design.html) — styling overview
- [Unstyled](unstyled.html) — attrs and BEM modifiers
- [Styled](styled.html) — Corex Design CSS
