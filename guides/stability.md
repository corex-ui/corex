# API stability (0.1.x)

With `{:corex, "~> 0.1.0"}` in `mix.exs`, Hex allows **0.1.x** releases without breaking changes until **0.2.0**.

| Version | Allowed changes |
|---------|-----------------|
| **0.1.x** | Bug fixes and **additive** API (new attrs, components, CSS modifiers) |
| **0.2.0** | Breaking renames or removals (with deprecation in 0.1.x when possible) |

## Public contract (frozen at 0.1.0)

| Surface | Source of truth | Convention |
|---------|-----------------|------------|
| Component ids | `lib/corex.ex` `@components` | `snake_case` atoms (`:date_picker`, `:signature_pad`) |
| Function components | same registry | `accordion_root/1`, `date_picker/1` |
| Elixir files | `lib/components/` | `snake_case` (`date_picker.ex`, `date_picker/connect.ex`) |
| `on_*` event attrs | each component module | Zag.js callback in `snake_case` (see below) |
| `phx-hook` | `assets/hooks/corex.ts` | PascalCase (`DatePicker`, `SignaturePad`) |
| npm exports | `package.json` | kebab-case (`corex/date-picker`) |
| Imperative API | `@doc type: :api` | `Corex.Accordion.set_value/2`, etc. |
| DOM / CSS | Zag + design | `data-scope="date-picker"`, `.select--accent`, `[data-readonly]` |
| URL slugs (e2e docs) | `E2eWeb.ZagScope` | kebab-case from registry id |

Internal (may change in 0.1.x without a major bump): `Connect`, `Anatomy`, translation file layout.

## Naming layers

| Layer | Example |
|-------|---------|
| Registry | `:signature_pad` |
| Module | `Corex.SignaturePad` |
| URL slug | `/signature-pad/api` |
| `data-scope` | `signature-pad` |
| npm | `corex/signature-pad` |

## Event attrs (Zag.js parity)

Do not assume every component uses `on_value_change`. Each attr mirrors the Zag callback:

| Zag callback | Elixir attrs |
|--------------|--------------|
| `onValueChange` | `on_value_change`, `on_value_change_client` |
| `onCheckedChange` | `on_checked_change`, `on_checked_change_client` |
| `onSelect` | `on_select`, `on_select_client` (menu) |
| `onSelectionChange` | `on_selection_change`, `on_selection_change_client` |
| `onExpandedChange` | `on_expanded_change`, `on_expanded_change_client` |
| `onPressedChange` | `on_pressed_change`, `on_pressed_change_client` |
| `onOpenChange` | `on_open_change`, `on_open_change_client` |
| `onPageChange` | `on_page_change`, `on_page_change_client` |
| `onPageSizeChange` | `on_page_size_change`, `on_page_size_change_client` |
| `onDrawEnd` | `on_draw_end`, `on_draw_end_client` |
| `onTick` / `onComplete` | `on_tick`, `on_complete`, … |

`data_table` `on_select` / `on_select_all` are Phoenix row events, not Zag menu `on_select`.

## Controlled state

| Component | Attr | Values |
|-----------|------|--------|
| Most Zag components | `controlled` | boolean |
| Editable | `controlled` | boolean (edit state) |
| Pagination | `controlled` | `false`, `true`, `:all`, `:page`, `:page_size` |

## Read-only

- Elixir attr: `read_only`
- Hook roots: `data-readonly`
- Native inputs: HTML `readonly` attribute

## Stable `id`

Pass an explicit `id` when using imperative APIs (`Corex.Accordion.set_value/2`, etc.) or when multiple instances need stable targeting. Otherwise components auto-generate an id via `assign_new/3`. Form `field={}` uses `field.id`.

## Upgrading

1. Bump `{:corex, "~> 0.1.0"}` and run `mix deps.get`
2. `mix corex.design --force` when design assets changed
3. Review `CHANGELOG.md`
4. Confirm hook imports in `assets/js/app.js`
