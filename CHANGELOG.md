# Changelog

## 0.2.0

### Breaking changes

- **Shared modifier classes** replace per-component BEM modifiers: `ui-accent`, `ui-solid`, `ui-size-lg`, `ui-rounded-xl` (stack on any component host)
- **Removed variants:** `ghost` and `outline`; only subtle (default) and `ui-solid`
- **Removed per-component palette/variant/size utilities** from component CSS; modifiers live once in `utilities.css`
- **Token renames:** `{role}-ink` → `{role}-contrast`, `ink-{role}` → `{role}-text`; removed `selected-*` and `--theme-color-*` aliases
- **Single bundle import:** `@import "../corex/corex.css"` replaces separate main/theme/components imports (layered imports remain optional)
- **Removed** `config :corex_design, variants:`; filter with `components:` and `semantics:` only
- **Design packaging:** retired `mix corex.design`, `--designex`, and vendored `installer/priv/corex_design/`; apps depend on Hex **`corex_design`** and run `mix corex.design.build`
- Default `mix corex.new` adds `{:corex_design, "~> 0.2"}` and runs the design build
- Generated Design CSS under `assets/corex/` is gitignored (installer adds `/assets/corex/` when design is on)
- Removed `color-scope.css`; theme tokens generate under `priv/css/tokens/themes/`
- [form_field] Controlled mode no longer applies to all inputs; limited to select, radio, switch, checkbox

See the [update guide](guides/update.html) for the 0.1 → 0.2 class and config migration.

### Enhancements

- New optional **`corex_design`** Hex package with config-driven tokens and themes
- Design v2 token architecture and bundle layout
- Build-time bundle filtering via `components:` and `semantics:` in `config :corex_design`
- E2e style pages: file-upload, floating-panel, password-input; dialog semantic styling
- [tabs] Disabled items support
- [select] Controlled mode and examples
- [combobox] Example updates

### Bug fixes

- [toast] Align event and listener names
- [design] Clipboard copied feedback uses border and text only

Add `corex_design`, configure `config :corex_design`, patch asset aliases, then run `mix corex.design.build`.

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

Run `mix corex.design.build` in your app to refresh `assets/corex/` (CSS and tokens).

## 0.1.0

Initial Corex stable release.
