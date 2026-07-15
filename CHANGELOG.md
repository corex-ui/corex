# Changelog

## Unreleased

### Breaking changes

- **`mix corex.code` renamed to `mix corex.design.code`.** Update scripts and docs that call the old task name.
- **Multi-value datasets use JSON** (`["a","b"]`) for `data-value` / `data-default-value` (and tree expanded/selected defaults). Comma-separated lists are no longer emitted.
- **`FormField.assign_form_field/2` leaves `invalid` off by default.** Pass `auto_invalid` to derive alert borders from visible changeset errors (`used_input?/1`), or set `invalid={true}` / `invalid={false}` explicitly (explicit wins).
- **`form_field` / `field_used` are no longer public attrs** on select/combobox; they remain private assigns set by `field={...}`.
- **MCP moved to Hex package `corex_mcp`.** Add `{:corex_mcp, "~> 0.2", only: :dev}` and keep `plug Corex.MCP`. Config keys are under `config :corex_mcp` (`mcp_root`, `mcp_verbose_errors`, `debug`). Tools expanded: enriched `get_component` (attrs/slots/modifiers), plus `list_modifiers`, `get_component_style`, `list_themes`, `design_guide`.
- **Form components require `:id` when no `:field`:** form controls no longer auto-generate random ids via `System.unique_integer`. Pass `id` explicitly, or use `field={@form[:name]}` so Phoenix `FormField.id` is used (Ecto changesets with `to_form/1` provide stable ids). Non-form components (accordion, dialog, tabs, etc.) still auto-generate ids when omitted. Random default `name-*` values on form controls were also removed (`name` defaults to `nil`).
See the [update guide](guides/update.html) for migration notes.

### Internal

- **JSON via OTP `:json`:** `corex`, `corex_design`, and `corex_mcp` no longer depend on Jason. Use OTP 27+ or add `json_polyfill` on OTP 26.
- Shared `Corex.Connect.ItemNav` for item `to` / redirect / new_tab dataset attrs.
- Split `Corex.Helpers` into `Corex.Attrs`, `Corex.List.Normalize`, and `Corex.ValueBinding` (Helpers re-exports).
- DocParity anatomy mapping uses explicit markers (`Corex.DocParity.Markers` and optional `# @parity anatomy:` comments on demos).
- Demo id guard test ensures form `*_example` openings pass `id` or `field`.

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
