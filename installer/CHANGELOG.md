# Changelog

## Unreleased

`mix corex.new` / `mix corex.tableau.new` no longer inject `:corex_design` into
`compilers`. Design CSS is rebuilt from `assets.build` / `assets.deploy` via
`mix corex.design.build`. The `corex_design` dep is `runtime: false` in every
Mix env (no `only: :dev`). `--a11y` apps that use `mix release` should add
`corex_design: :load` so Mix.Release keeps Accessibility helper BEAMs.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.1 - 2026-08-08

### Bug fixes

- Ship Tableau scaffold CSS/JS (`blog.css`, `prose.css`, `locale.js`,
  `heroicons.js`) under `priv/tableau` so `mix corex.tableau.new` works from
  the Hex mix archive (archives only keep `ebin` + `priv`, not `templates/`)

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.0 - 2026-08-07

Align `mix corex.new` / `mix corex.tableau.new` with Corex 0.2.0: Design and MCP
on by default (`--no-design` / `--no-mcp`), optional `--a11y`, and Cursor MCP
scaffold when MCP is enabled.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).
