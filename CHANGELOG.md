# Changelog

## 0.1.0-rc.1

### Added

- **Design tokens**: Semantic `--max-height-*` and `--min-height-*` scales (`7xs` through `7xl`, aligned with container width tokens). Regenerate app CSS with `mix corex.design` to pick up `dimension.css` / `dimension.json`.
- **Color picker**: `color-picker--*` color and size modifiers (e.g. `color-picker--accent`, `color-picker--lg`).

### Changed

- **Data table**: Default scroll host uses `max-height: var(--container-md)` (was `--container-3xs`). Host docs describe overriding height with the new utilities (`max-h-2xs`, `max-h-none`, `min-h-md`, `h-full`, etc.).

### Fixed

- **corex_new**: Gettext template catalogs ship in the Hex archive (`installer/priv/gettext`), so `mix corex.new --lang` works when installing from Hex.
- **Color picker**: Scoped alpha channel input styling so the compact control bar and panel channel inputs no longer share the same sizing rules.
- **Date picker**: Existing dates show again on edit forms: the hook hydrates Zag from the hidden value input / `data-value` when the client machine starts empty; `field=` respects an explicit `value` assign.
- **Tabs**: RTL layout uses the shared `getDir` helper (document `dir` / locale) instead of treating `data-dir` as a raw Zag direction string.
- **Tags input** and **Signature pad**: Empty array placeholders only get a `name` when Phoenix `used_input?/1` is true, restoring correct `data-empty` / `data-field-used` behavior after internal `field_used` attrs were removed.
- **Data table**: Sticky header/action cells no longer stack above an open row dialog; z-index is lowered for the table while a dialog backdrop is open.

## 0.1.0-rc.0

Initial release candidate of Corex.
