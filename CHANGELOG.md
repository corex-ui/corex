# Changelog

## 0.2.0 - 2026-07-26

Design and MCP ship as separate Hex packages. Theming is config-driven through an Elixir CSS pipeline.

### Packages

- **`corex_design`** — optional Design package (`runtime: false`): tokens, themes, modes, and component CSS from `config :corex_design`.
- **`corex_mcp`** — optional MCP package (`only: [:dev, :test]`) for AI component and design discovery. Never enable in production.
- **`corex`** — unstyled Phoenix components and Zag.js hooks (unchanged role).
- **`mix corex.new`** — Design and MCP on by default (`--no-design` / `--no-mcp` to skip).

### Design

- Config-driven Elixir pipeline: declare themes, semantics, and modes, then generate CSS with `mix corex.design.build`.
- Shared `ui-*` modifiers for roles and variants (subtle / `ui-solid` / `ui-ghost`). `ui-outline` and per-component BEM modifiers are gone.
- Notable renames: `layer` → `surface`; public token names only (no `--theme-*` indirection).

### Components

- Several LiveView event and slot names are normalized (toast, toggle group, pagination, color picker, file upload).
- Form controls need an explicit `id` when you do not pass `field`.
- Multi-value datasets use JSON in the DOM.

### Requirements

- Elixir `~> 1.17`. OTP 27+ uses native `:json`; OTP 24–26 need `json_polyfill`.

See the [update guide](guides/update.md) when upgrading from 0.1.x.

## 0.1.2

### Bug fixes

- [pagination] Align link trigger `aria-label` with Connect SSR; omit labels on dead prev/next links ([#64](https://github.com/corex-ui/corex/pull/64))
- [menu] Fix trigger and items disabled state ([#61](https://github.com/corex-ui/corex/pull/61))
- [tooltip] Non-focusable trigger slot for composition (button/div triggers) ([#62](https://github.com/corex-ui/corex/pull/62))
- [deps] Widen `phoenix_live_view` to `~> 1.1` so generated apps on LiveView 1.1.x or 1.2.x resolve without forcing an upgrade ([#65](https://github.com/corex-ui/corex/pull/65))
- [installer] Join `NODE_PATH` env lists in `corex.new` config for Elixir 1.18 and tailwind 0.4.x
- [file-upload-live] Drop invalid `live_img_preview` sizing attrs; preview size comes from file-upload CSS

### Enhancements

- Integration tests: repeat all OTP / Elixir rows with pinned `phx_new 1.8.4` alongside latest

## 0.1.1

### Bug fixes

- [menu] Fix submenu leaks and LiveView drift on open menus ([#58](https://github.com/corex-ui/corex/issues/58))
- [menu] Scope server `set_open/3` to the targeted menu
- [combobox] Preserve custom item slots after LiveView updates
- [toast] Sanitize action URLs
- [data-table] Harden sort and selection params
- [pagination] Validate page URLs
- [redirect] Validate redirect schemes
- [date-picker] Reduce unnecessary re-renders

### Enhancements

- [menu] Item and trigger layout aligned with select, combobox, and listbox
- [combobox] Default `close_on_select` to `true`
- [docs] Restore `mix corex.new` on Hexdocs
- [mcp] Security hardening

Run `mix corex.design --force` in your app to refresh `assets/corex/` (CSS and tokens).

## 0.1.0

Initial Corex stable release.
