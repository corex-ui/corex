# Changelog

## 0.2.0

### Breaking changes

- Retired `mix corex.design`, `--designex`, and vendored `installer/priv/corex_design/`
- Default `mix corex.new` adds `{:corex_design, "~> 0.2"}` and runs `mix corex.design.build`
- Removed `color-scope.css`; theme tokens generated under `priv/css/tokens/themes/`
- Semantic ink tokens standardized to `--color-ink-{semantic}` (legacy `--color-{semantic}-ink` aliases remain in generated token CSS only)
- [form_field] Controlled mode no longer applies to all inputs; limited to select, radio, switch, checkbox

### Enhancements

- New optional **`corex_design`** Hex package with config-driven tokens and themes
- Design v2 token architecture and bundle layout
- Build-time bundle filtering via `components:`, `semantics:`, `variants:` in `config :corex_design`
- E2e style pages: file-upload, floating-panel, password-input; dialog semantic styling
- [tabs] Disabled items support
- [select] Controlled mode and examples
- [combobox] Example updates

### Bug fixes

- [toast] Align event and listener names
- [design] Clipboard copied feedback uses border and text only

Add `corex_design`, configure `config :corex_design`, patch asset aliases, then run `mix corex.design.build`. See [update guide](guides/update.html).

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
