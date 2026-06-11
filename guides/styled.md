# Styled (Corex Design)

**Corex Design** is optional CSS for the BEM modifiers Corex already stamps on components. Style attrs and classes work the same as in [Unstyled](unstyled.html); this library fills in the rules so you do not write them yourself.

It includes design tokens, built-in themes (neo, uno, duo, leo), light/dark modes, and Tailwind-based styles per component. CSS is **generated at compile time** into `assets/css/` by the `:corex_design` compiler (same pipeline as `mix corex.new`).

`mix corex.new` installs Corex Design by default. Use `--no-design` to stay on the [Unstyled](unstyled.html) path only.

## Commands

| What you want | Command |
|---------------|---------|
| New app **with** design (default) | `mix corex.new my_app` |
| New app **without** design | `mix corex.new my_app --no-design` |
| Validate theme tokens | `mix corex.design.validate` |

Related installer flags (all imply design): `--mode` (light/dark), `--theme` (neo, uno, duo, leo). See [Dark mode](dark_mode.html) and [Theming](theming.html).

Recipe ids such as `dialog_modal`, `dialog_side`, and `tree_navigation` are compiler splits that share `.dialog` / `.tree-view` roots in generated `recipes/`.

## Setup

### 1. Dependencies

Add both packages to `mix.exs`:

```elixir
def deps do
  [
    {:corex, "~> 0.2"},
    {:corex_design, "~> 0.2"}
  ]
end
```

### 2. Compiler

Register the design compiler in `project/0`. Requires **OTP 27+**. Phoenix apps:

```elixir
def project do
  [
    app: :my_app,
    version: "0.1.0",
    elixir: "~> 1.18",
    compilers: [:phoenix_live_view] ++ Mix.compilers() ++ [:corex_design],
    deps: deps()
  ]
end
```

Non-Phoenix apps:

```elixir
compilers: Mix.compilers() ++ [:corex_design]
```

### 3. Config

In `config/config.exs`:

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css",
  on_invalid_style: :raise
```

Omit `:themes` to use built-in presets (neo, uno, duo, leo). Full key reference: [Design config](design-config.html).

### 4. Compile

Generates CSS under `assets/css/` (run before Tailwind builds):

```bash
mix deps.get
mix compile
```

Output includes:

- `corex.tailwind.css` (entry shim)
- `layers/theme.css`, `layers/base.css`, `layers/tokens.css`, `layers/utilities.css`
- `recipes/{id}.css` (one file per component recipe)
- `aggregates/recipes.css` (imports all recipes)

### 5. Import in `assets/css/app.css`

```css
@import "./corex.tailwind.css";
```

One import replaces the old `main.css` plus per-theme and per-component list. Phoenix Tailwind's existing `@source "../css"` picks up generated utilities.

If `app.css` still loads **daisyUI** from stock `phx.new`, remove it when using Corex Design. The two token systems conflict.

### 6. HTML

Set theme and mode on `<html>` and base classes on `<body>`:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="layout">
    {@inner_content}
  </body>
</html>
```

Use `.typo` on markdown or prose wrappers only. App pages use typography components (`<.h1>`, `<.p>`, `<.lead>`, and so on).

Use a `data-theme` value from your config (`neo`, `uno`, `duo`, `leo`). See [Theming](theming.html) and [Dark mode](dark_mode.html) for pickers and persistence.

### 7. Dev watcher (optional)

Mirror e2e in `config/dev.exs` for live CSS rebuilds:

```elixir
reloadable_compilers: [:gettext] ++ Mix.compilers() ++ [:corex_design],
watchers: [
  corex_design: {Corex.Design, :install_and_run, [~w(--watch)]}
]
```

For Esbuild, hooks, and `use Corex`, follow [Manual installation](manual_installation.html).

After upgrading Corex, run `mix deps.get` and `mix compile` to refresh generated CSS.

## Modifier classes

Each component has a **root class** with the same name as the component (`accordion`, `button`, `dialog`, …). Modifiers follow:

```text
<root> <root>--<modifier> …
```

Example:

```heex
<.accordion
  id="faq"
  class="accordion accordion--semantic-accent accordion--size-lg accordion--rounded-lg"
  items={Corex.Content.new([
    [value: "lorem", label: "Lorem", content: "Lorem panel content."],
    [value: "duis", label: "Duis", content: "Duis panel content."],
    [value: "donec", label: "Donec", content: "Donec panel content."]
  ])}
/>
```

Or use style attrs; Corex merges the same modifiers into `class`:

```heex
<.accordion semantic="accent" size="lg" radius="lg" class="accordion" … />
```

Common modifier axes (not every component has every axis; check that component's Hexdocs page):

| Axis | Examples | Effect |
|------|----------|--------|
| Color | `button--semantic-accent`, `timer--semantic-success` | Semantic palette from tokens |
| Size | `button--size-sm`, `dialog--size-lg` | Spacing and type scale |
| Radius | `accordion--rounded-xl` | Corner radius |
| Type | `accordion--text-lg` | Font size on parts |

Stack modifiers on the root `class` attribute. Do not invent new class names; use only modifiers defined for that component in generated `assets/css/recipes/<name>.css`.

Omitted style attrs emit block class only; recipe `default_variants` merge into base CSS. Invalid style attrs raise at render time when `on_invalid_style: :raise` (installer default). After changing `scales:`, run `mix corex.design.validate` ([Design config](design-config.html)).

## Shared utilities

Component styles build on shared utilities in the generated layer CSS (pulled in via `corex.tailwind.css`). You rarely add these classes yourself. They are composed inside component CSS:

| Utility | Used for |
|---------|----------|
| `ui-trigger` | Buttons, triggers, icon controls (hover, focus, disabled, open state) |
| `button--shape-square` / `button--variant-ghost` | Icon-only and subtle host triggers |
| `ui-trigger--*` | Size and color variants (`sm`, `accent`, …) |
| `ui-input` | Text fields, combobox input, similar controls |
| `ui-item` | Menu, listbox, select options |
| `ui-content` | Popovers, panels, floating surfaces |
| `ui-label` | Field labels |
| `ui-icon` | Heroicons inside components |
| `ui-link` | Link-styled controls |
| `ui-root` | Vertical/horizontal stacks |

Example: `button.css` applies `ui-trigger` to `.button`; `button--semantic-accent` maps to token colors via `@utility button--*`.

## Tokens at runtime

Generated layers load semantic tokens (`--color-ui-ink`, `--spacing-space`, `--text-base`, `--radius-md`, …). Theme rules switch palettes and fonts when `data-theme` and `data-mode` change on `<html>`.

Tailwind utilities such as `text-ui-ink`, `bg-layer`, `gap-space-lg`, and `rounded-xl` map to the same tokens. Prefer **modifier classes** on Corex components and **semantic utilities** in layout markup; avoid overriding CSS variables in templates.

Custom theme definitions live in [Design config](design-config.html).

## Icons

Inside Corex components (or their slots), use bare heroicons. Parent CSS sizes them:

```heex
<.heroicon name="hero-chevron-down" />
```

Avoid extra `class` on `<.heroicon>` when it sits inside another Corex component.

## Related

- [Unstyled](unstyled.html) — attrs, BEM hooks, and your own CSS
- [Design config](design-config.html) — custom themes, validation, recipe overrides
- [Theming](theming.html) — `data-theme` and theme picker
- [Dark mode](dark_mode.html) — `data-mode` and mode toggle
- Component Hexdocs — anatomy, API, and per-component examples
