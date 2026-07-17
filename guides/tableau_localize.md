# Tableau Localize

## Introduction

Visitors switch locale with a Corex `<.select redirect>`. Choosing a language navigates to the matching permalink (`/<locale>/...` for every locale, including the default; `/` is a root alias for the default locale). Gettext drives copy; `locale.js` (from install wiring) persists the visitor's choice and syncs the language select.

Localized pages also set `lang` and `dir` on `<html>` from `MyApp.Locale` so screen readers, font shaping, and bidi text work. For Phoenix apps with `localize_web` and router scopes, see [Localize](localize.html).

## Install first

Wire Gettext, `MyApp.Locale`, permalink `Module.create` pages, layout `data-locale*` attributes, and `locale.js` before you drop this UI into a layout:

- New site: `mix corex.tableau.new my_site --lang`
- Existing site: [Tableau: optional locale wiring](tableau.html#optional-locale-wiring)

Example site: [corex-ui/soonex_i18n](https://github.com/corex-ui/soonex_i18n). Baseline without locale: [corex-ui/soonex](https://github.com/corex-ui/soonex).

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Deps | `gettext`, `gettext_sigils`, `localize_web` (CLDR display names and RTL); `extra_applications: [:localize]` |
| Gettext | `MyApp.Gettext` with string locales `en` / `fr` / `ar` |
| Locale module | `MyApp.Locale` with `locales/0`, `swap_path/2`, `language_select_items/1`, `lang/1`, `dir/1`, `selected_path/2` |
| Layout | `lang` / `dir` / `data-locale*` on `<html>`; Gettext locale put in `RootLayout` |
| JS | `import "./locale.js"` in `site.js`; `Select` hook registered |
| Pages | One `Tableau.Page` per locale via `Module.create` at `/<locale>/...`, plus root `/` |

Full deps / `locale.js` / `Module.create` paste lives in [Tableau: optional locale wiring](tableau.html#optional-locale-wiring).

## Language select

`redirect` navigates to `item.to`. The URL is authoritative; `corex:set-locale` updates `localStorage` for other tabs.

```heex
<.select
  id="corex-language-switch"
  class="select ui-size-sm max-w-6xs"
  dir={MyApp.Locale.dir(@locale)}
  items={MyApp.Locale.language_select_items(MyApp.Locale.current_path(@page))}
  value={MyApp.Locale.language_select_value(MyApp.Locale.current_path(@page), @locale)}
  redirect
  on_value_change_client="corex:set-locale"
  positioning={%Corex.Positioning{same_width: true}}
>
  <:label class="sr-only">{~t"Language"}</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger>
    <.heroicon name="hero-language" class="icon" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" class="icon" />
  </:item_indicator>
</.select>
```

Items use `Corex.List.Item` so value, label, and destination stay aligned. Keep `id="corex-language-switch"` so `locale.js` can sync the control.

## Layout placement

Render the select where it belongs in the shell (header, menu, footer). Ensure the page assign (`@page`) and `:locale` from `RootLayout` are available:

```heex
<.select
  id="corex-language-switch"
  ...
/>
```

With [Tableau Theming](tableau_theming.html) and [Tableau Mode](tableau_mode.html), also set `data-theme` / `data-mode` on `<html>`; head scripts stay as documented in [Tableau](tableau.html).

After changing strings, extract and merge catalogs:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Fill `priv/gettext/<locale>/LC_MESSAGES/default.po`.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Switcher missing or empty | `Locale.locales/0` matches supported locales; `Select` hook registered |
| Wrong page after switch | Permalink exists for that locale (`Module.create` page); `swap_path/2` output matches |
| Labels look like `EN` / `AR` | CLDR data downloaded (`mix localize.download_locales en fr ar`) |
| `dir` wrong for RTL | `Locale.dir/1` and root `dir={MyApp.Locale.dir(@locale)}` |
| Select does not sync | `locale.js` imported; `id="corex-language-switch"`; `data-locale-selected-path` on `<html>` |

## Related

- [Tableau](tableau.html#optional-locale-wiring): deps, Gettext, `locale.js`, and permalink pages
- [Localize](localize.html): Phoenix `localize_web` and router scopes
- [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html): picker UI when combined with locale
