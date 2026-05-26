# Corex Design

Corex components work without any bundled CSS. You style them with your own rules, usually by targeting `data-scope` and `data-part` on the rendered markup (each component’s Hexdocs page lists those selectors).

**Corex Design** is optional: token-based CSS, ready-made themes, and modifier classes such as `button--accent` or `dialog--lg`. It ships inside the `corex` package; you copy assets into your app and import only what you use.

## Commands

| What you want | Command |
|---------------|---------|
| New app **with** design (default) | `mix corex.new my_app` |
| New app **without** design | `mix corex.new my_app --no-design` |
| New app + **Designex** token sources | `mix corex.new my_app --designex` |
| Copy design CSS into an existing app | `mix corex.design` |
| Also copy token sources for [Designex](https://hex.pm/packages/designex) | `mix corex.design --designex` |
| Refresh assets after upgrading Corex | `mix corex.design --force` (or `--designex --force`) |

`mix corex.design` writes to `assets/corex/`. By default it **skips** paths that already exist; use `--force` to overwrite.

`--designex` adds the `designex` dependency, `config :designex`, and runs `designex corex` in `assets.build` / `assets.deploy` so you can edit tokens under `assets/corex/design/` and rebuild CSS locally. You do not need Designex to **use** Corex Design in an app—only to **author** or change tokens.

Related installer flags (all imply design): `--mode` (light/dark), `--theme` (neo, uno, duo, leo). See [Dark mode](dark_mode.html) and [Theming](theming.html).

## Setup in an existing app

1. Copy assets:

```bash
mix corex.design
```

2. Import layers in `assets/css/app.css`. At minimum:

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
```

Add one `@import "../corex/components/<name>.css"` per component you render (for example `accordion.css`, `button.css`, `dialog.css`).

3. Point Tailwind at the copied tree (Phoenix 1.8+ example):

```css
@source "../corex";
```

4. Set theme and mode on `<html>` and base classes on `<body>`:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

Use a `data-theme` value that matches a theme file you imported (`neo`, `uno`, `duo`, `leo`). See [Theming](theming.html) and [Dark mode](dark_mode.html) for pickers and persistence.

If `app.css` still loads **daisyUI** from stock `phx.new`, remove it when using Corex Design—the two token systems conflict.

For Esbuild, hooks, and `use Corex`, follow [Manual installation](manual_installation.html).

## Modifier classes

Each styled component has a **root class** with the same name as the component (`accordion`, `button`, `dialog`, …). Modifiers follow:

```text
<root> <root>--<modifier> …
```

Example:

```heex
<.accordion
  id="faq"
  class="accordion accordion--accent accordion--lg accordion--rounded-lg"
  items={Corex.Content.new([
    [value: "lorem", label: "Lorem", content: "Lorem panel content."],
    [value: "duis", label: "Duis", content: "Duis panel content."],
    [value: "donec", label: "Donec", content: "Donec panel content."]
  ])}
/>
```

Common modifier axes (not every component has every axis—check that component’s Hexdocs **Corex Design** section):

| Axis | Examples | Effect |
|------|----------|--------|
| Color | `button--accent`, `timer--success` | Semantic palette from tokens |
| Size | `button--sm`, `dialog--lg` | Spacing and type scale |
| Radius | `accordion--rounded-xl` | Corner radius |
| Type | `accordion--text-lg` | Font size on parts |

Stack modifiers on the root `class` attribute. Do not invent new class names; use only modifiers defined for that component in `assets/corex/components/<name>.css`.

## Shared utilities

Component styles build on shared utilities in `assets/corex/utilities.css` (pulled in via `main.css`). You rarely add these classes yourself—they are composed inside component CSS—but they explain how parts look:

| Utility | Used for |
|---------|----------|
| `ui-trigger` | Buttons, triggers, icon controls (hover, focus, disabled, open state) |
| `ui-trigger--square` / `ui-trigger--circle` / `ui-trigger--ghost` | Icon-only and subtle triggers |
| `ui-trigger--*` | Size and color variants (`sm`, `accent`, …) |
| `ui-input` | Text fields, combobox input, similar controls |
| `ui-item` | Menu, listbox, select options |
| `ui-content` | Popovers, panels, floating surfaces |
| `ui-label` | Field labels |
| `ui-icon` | Heroicons inside components |
| `ui-link` | Link-styled controls |
| `ui-root` | Vertical/horizontal stacks |

Example: `button.css` applies `ui-trigger` to `.button`; `button--accent` maps to token colors via `@utility button--*`.

## Tokens and themes

`main.css` loads semantic tokens (`--color-ink`, `--spacing-space`, `--text-base`, `--radius-md`, …). Theme files under `assets/corex/theme/` switch palettes and fonts when `data-theme` and `data-mode` change on `<html>`.

Tailwind utilities such as `text-ink`, `bg-layer`, `gap-space-lg`, and `rounded-xl` map to the same tokens. Prefer **modifier classes** on Corex components and **semantic utilities** in layout markup; avoid overriding CSS variables in templates.

## Icons

Inside Corex components (or their slots), use bare heroicons—parent CSS sizes them:

```heex
<.heroicon name="hero-chevron-down" />
```

Avoid extra `class` on `<.heroicon>` when it sits inside another Corex component.

## Without Corex Design

Skip `mix corex.design`. Style with your own CSS targeting `data-scope` / `data-part`, or another system. Component behavior and the LiveView/JS API are unchanged.

## See also

- [Manual installation](manual_installation.html) — Esbuild, hooks, optional toast layout
- [Theming](theming.html) — `data-theme` and theme picker
- [Dark mode](dark_mode.html) — `data-mode` and mode toggle
- Component Hexdocs — anatomy, API, and per-component Design examples
