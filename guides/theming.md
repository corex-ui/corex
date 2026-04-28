# Theming

Corex can expose a small set of named themes (skins) and keep **`data-theme`** on **`<html>`** in sync with cookies, storage, and UI controls.

## Enable with the installer

**New app:**

```bash
mix corex.new my_app --theme
```

**Existing app:**

```bash
mix igniter.install corex --yes --corex.theme
```

The **`--theme`** flag turns on the full theme set the installer supports (neo, uno, duo, leo). See [Installation](installation.html).

## Theme names

Valid theme ids match the design packs Corex ships with, typically **`neo`**, **`uno`**, **`duo`**, and **`leo`**. The default when nothing is stored is usually **`neo`** (see generated **`Plugs.Theme`** and layout defaults).

## What the installer wires

With **`--theme`**, Corex typically:

1. Adds **`YourAppWeb.Plugs.Theme`** on the **browser** pipeline after **`fetch_live_flash`**. The plug reads the **`phx_theme`** cookie (defaulting to **`neo`** when unset) and assigns **`theme`** / session so SSR matches the picker.
2. Sets **`data-theme`** on **`<html>`** from **`@theme`** in the root layout.
3. Extends the same **root** bridge script used for mode (when present) to sync **`localStorage`** key **`phx:theme`**, **`phx_theme`**, **`data-theme`**, and to handle **`phx:set-theme`** events from Corex select/toggle components.

## Design system CSS

Import the generated theme layer that matches your selection (for example **`theme/neo.css`**) from **`mix corex.design`** output. Select component styles are pulled in when you enable theme (and locale) with design — keep **`assets/css/app.css`** imports aligned with [Manual installation](manual_installation.html).

## Changing the default theme

Adjust the fallback in **`Plugs.Theme`** and the **`data-theme`** default in the root layout to the theme id you want when no cookie is set. Keep **`validThemes`** in the bridge script aligned if you customize the list.

## Related

- [Dark mode](dark_mode.html) — light/dark **`data-mode`** alongside themes.
- [Installation](installation.html) — **`--theme`** and **`--mode`** together.
