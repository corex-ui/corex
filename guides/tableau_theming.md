# Tableau Theming

## Introduction

Visitors pick a Corex Design theme (neo, uno, duo, leo) from a Corex `<.select>`. The choice updates `data-theme` on `<html>` without a server round-trip, and persists across reloads via `localStorage`.

Theme is independent from light/dark mode. Corex Design combines them as `[data-theme="neo"][data-mode="dark"]`. Mode is covered in [Tableau Mode](tableau_mode.html). For Phoenix apps with `Plugs.Theme` and cookies, see [Theming](theming.html).

## Install first

Wire the picker allowlist, `Theme.head_script/0`, and `phx:set-theme` listeners in `site.js` before you drop this UI into a layout:

- New site: `mix corex.tableau.new my_site --theme`
- Existing site: [Tableau: optional theme wiring](tableau.html#optional-theme-wiring)

Which theme CSS the design build emits is separate (`config :corex_design`). See [Design](design.html) and [Configuration](configuration.html). Keep the picker list a subset of the themes you build. Run `mix corex.design.options` for allowed build values.

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Config | `config :my_app, :themes, ~w(neo uno duo leo)` (first entry is the default) |
| Module | `MyApp.Theme` with `head_script/0`, `current/1`, `theme_toggle/1` |
| Layout | `data-theme={@theme}` on `<html>`; `{MyApp.Theme.head_script()}` in `<head>` |
| site.js | `Select` hook; `phx:set-theme` listener writes `localStorage` + `data-theme` |
| CSS | `@import "../corex/corex.css"` and `select` in `components:` when you use Design |

Full Elixir / `site.js` paste lives in [Tableau: optional theme wiring](tableau.html#optional-theme-wiring).

## Theme picker

`id="theme-select"` matches the scaffolded component. Place in your header or toolbar:

```heex
<MyApp.Theme.theme_toggle theme={@theme} />
```

`Theme.theme_toggle/1` (from install wiring) renders:

```heex
<.select
  id="theme-select"
  class="select ui-size-sm w-auto"
  items={select_items()}
  value={[@theme]}
  positioning={%Corex.Positioning{same_width: false}}
  on_value_change_client="phx:set-theme"
>
  <:label class="sr-only">Theme</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger>
    <.heroicon name="hero-swatch" class="icon" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" class="icon" />
  </:item_indicator>
</.select>
```

`on_value_change_client="phx:set-theme"` fires a browser event the `site.js` listener handles. Keep item values in sync with `config :my_app, :themes` and with the `themes` array in that listener.

## Layout placement

Ensure `RootLayout` assigns `:theme` (install wiring) and passes it into shells that render the picker:

```heex
<MyApp.Theme.theme_toggle theme={@theme} />
```

With [Tableau Mode](tableau_mode.html), also pass `:mode`. With [Tableau Localize](tableau_localize.html), set `lang` and `dir` from your locale module instead of fixed `en` / `ltr`. In `<head>`, call `Mode.head_script()` then `Theme.head_script()` when both exist.

## CSS

```css
@import "../corex/corex.css";
```

`corex.css` loads utilities, configured themes, and `components.css`. Include `select` in `components:` when you use a theme picker. For layered imports, see [Design](design.html).

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Picker does nothing | `site.js` listens for `phx:set-theme`; `Select` hook is registered |
| Wrong theme selected | `value={[@theme]}` matches an item `value`; layout receives `:theme` |
| Theme flashes then resets | Listener `themes` / `defaultTheme` match config and picker items |
| Styles missing for a theme | That theme is in `config :corex_design` and you rebuilt with `mix corex.design.build` |

## Related

- [Tableau](tableau.html#optional-theme-wiring): `head_script`, config, and `site.js` listeners
- [Configuration](configuration.html): build vs picker vs generators
- [Design](design.html): `config :corex_design` theme CSS
- [Tableau Mode](tableau_mode.html): `data-mode`; call `Mode.head_script()` then `Theme.head_script()` in `<head>` when both are used
- [Theming](theming.html): Phoenix plug and cookie flow
