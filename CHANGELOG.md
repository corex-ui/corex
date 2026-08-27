# Changelog

## Unreleased

### Design CSS pipeline

- Design CSS is an **asset build step** only (`mix corex.design.build` on `assets.build` / `assets.deploy`). The optional `Mix.Tasks.Compile.CorexDesign` compiler is removed; do not add `:corex_design` to `compilers`.
- `mix corex.new` / `mix corex.tableau.new` add `{:corex_design, "~> 0.2", runtime: false}` in every Mix env (no `only: :dev`) so `MIX_ENV=prod mix assets.deploy` can run the Mix task.
- After changing `config :corex_design`, re-run `mix corex.design.build` (or `mix assets.build`). `mix compile` does not regenerate Design CSS.
- `--a11y` plugs call `Corex.Design.Accessibility` (cookie → `data-*`); they do not rebuild CSS. `runtime: false` means Design is not started as an OTP app. Apps that use `mix release` with `--a11y` must add `corex_design: :load` so Mix.Release keeps those BEAMs.

## 0.2.1 - 2026-08-08

### Bug fixes

- [installer] Ship Tableau scaffold CSS/JS (`blog.css`, `prose.css`, `locale.js`, `heroicons.js`) under `priv/tableau` so `mix corex.tableau.new` works from the Hex mix archive (archives only keep `ebin` + `priv`, not `templates/`)
- [packaging] Keep Dialyzer PLTs out of Hex `priv` ([#87](https://github.com/corex-ui/corex/pull/87))

## 0.2.0 - 2026-08-07

Design and MCP ship as separate Hex packages. Theming is config-driven through an Elixir CSS pipeline.

### Packages

- **`corex_design`** — optional Design package (`runtime: false`, **MIT**): tokens, themes, modes, and component CSS from `config :corex_design`. Hex only (CSS is built in the app with `mix corex.design.build`).
- **`corex_mcp`** — optional MCP package (`only: [:dev, :test]`, **Apache-2.0**) for AI component and design discovery. Never enable in production. License differs from the MIT siblings because the HTTP MCP stack follows Tidewave’s Apache-2.0 lineage.
- **`corex`** — unstyled Phoenix components and Zag.js hooks (**MIT**); npm package ships built hooks under `priv/static` only.
- **`mix corex.new`** — Design and MCP on by default (`--no-design` / `--no-mcp` to skip). Scaffolds `.cursor/mcp.json` when MCP is enabled; optional **`--a11y`** wires accessibility preference CSS.

### Security

- Strip leading C0/space before URL scheme checks in `Corex.Url` and the JS redirect helper so prefixed `javascript:` / `data:` cannot bypass allowlists (same class as LiveView CVE-2026-58228). See [SECURITY.md](SECURITY.md).
- Require Phoenix LiveView **≥ 1.2.7** and Phoenix **≥ 1.8.9** for upstream link/navigation fixes.

### Design

- Config-driven Elixir pipeline: declare themes, semantics, and modes, then generate CSS with `mix corex.design.build`.
- Shared `ui-*` modifiers for roles and variants (subtle / `ui-solid` / `ui-ghost`). `ui-outline` and per-component BEM modifiers are gone.
- Notable renames: `layer` → `surface`; public token names only (no `--theme-*` indirection).
- Optional accessibility preference CSS (`--a11y` / design accessibility emit). `accessibility: true` enables all six axes; `Corex.Design.Accessibility` is documented on Hexdocs.

### Components

- Several LiveView event and slot names are normalized (toast, toggle group, pagination, color picker, file upload, marquee). See the [update guide](guides/update.md) rename table.
- Form controls need an explicit `id` when you do not pass `field`. Opt into `auto_invalid` for alert borders on used invalid fields.
- Multi-value datasets use JSON in the DOM (`Corex.Dataset.encode_json/1`).
- `button_group` removed; compose buttons with shared `ui-*` modifiers.
- Marquee: push payload uses `id` (was `marquee_id`); `auto_fill` defaults for clone settling.

### MCP

- Design and guides tools (`list_modifiers`, `get_component_style`, `list_themes`, `design_guide`, installation/guides helpers).
- Cursor protocol negotiation; richer component discovery prompts.

### Requirements

- Elixir `~> 1.17`.
- Phoenix LiveView `>= 1.2.7`, Phoenix `>= 1.8.9` recommended.

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

After upgrading within 0.1.x, refresh design CSS with `mix corex.design.build` (the old `mix corex.design` task is retired in 0.2.0).

## 0.1.0

Initial Corex stable release.
