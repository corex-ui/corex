# Corex Design

Optional styling for Corex components. Components render unstyled by default; load
generated CSS to apply tokens and recipes.

## Hard rules

1. **No custom CSS in templates** — only `@import` lines and vendor-required fragments in `site.css` / `app.css`
2. **Modifiers are the styling API** — `class="accordion accordion--semantic-accent accordion--size-lg"`
3. **Never invent class names** or write `[data-scope=…]` in template CSS
4. **`.typo layout` on body** — bare semantic tags first
5. **Remove daisyUI** when using Corex Design

## Setup (Elixir pipeline)

Add `:corex_design` to deps, configure themes, register the compiler, then import
the generated stylesheet once.

```elixir
# mix.exs — Phoenix apps
compilers: [:phoenix_live_view] ++ Mix.compilers() ++ [:corex_design]

# mix.exs — other apps
compilers: Mix.compilers() ++ [:corex_design]
```

Requires OTP 27+ (Elixir 1.18+ recommended).

```elixir
config :corex_design,
  default_theme: :neo,
  default_mode: :light
```

```elixir
config :corex_design,
  my_app: [output: "assets/css/corex.tailwind.css"]
```

Run `mix compile` (or `mix compile.corex_design`) to write the bundle.

```css
@import "tailwindcss" source(none);
@import "./corex.tailwind.css";
```

```heex
<html data-theme="neo" data-mode="light">
  <body class="layout">
```

Use `.typo` on markdown or prose wrappers only (for example blog articles). App UI uses typography components (`<.h1>`, `<.p>`, `<.lead>`, and so on), not body-level `.typo`.

Full setup: https://hexdocs.pm/corex/styled.html

Compiler recipes may split variants (`dialog_modal`, `dialog_side`, `tree_navigation`) that share `.dialog` / `.tree-view` roots in generated `recipes/`.

Validate theme config: `mix corex.design.validate`. List recipe ids: `mix corex.design.list`.

## Modifier stacking

Stack on root class. Responsive prefixes on modifiers:

```heex
<.accordion
  class="accordion accordion--semantic-accent accordion--size-sm sm:accordion--size-md lg:accordion--size-xl"
  …
/>

<.timer
  class="timer timer--semantic-accent timer--text-lg sm:timer--text-xl lg:timer--text-5xl timer--rounded-xl"
  …
/>
```

| Axis | Examples |
|------|----------|
| Color | `--semantic-accent`, `--semantic-success`, `--semantic-info`, `--semantic-alert` |
| Size | `--size-sm`, `--size-md`, `--size-lg`, `--size-xl` |
| Radius | `--rounded-md`, `--rounded-xl`, `--rounded-full` |
| Type | `--text-lg`, `--text-2xl` |

## Authoring (attrs or BEM)

Component attrs merge BEM modifiers into `class`. You can write the same modifiers directly:

```heex
<.action semantic="accent" size="lg">Save</.action>
<.action class="button button--semantic-accent button--size-lg">Save</.action>
```

Style attrs always merge BEM modifiers into `class`; generated CSS targets those BEM selectors.

| Attribute | BEM class |
|-----------|---------------------|
| `semantic="accent"` | `accordion--semantic-accent` |
| `size="lg"` | `accordion--size-lg` |
| `radius="xl"` | `accordion--rounded-xl` |
| `text="lg"` | `accordion--text-lg` |
| `max_width="md"` | `accordion--max-w-md` |

A component only exposes the axes declared in its `use Corex.Variants` list.
Not every stamped axis has recipe CSS; see component-driven contract below.

| Registry id | BEM root / vendored CSS |
|-------------|-------------------------|
| `action` | `button` / `button.css` |
| `navigate` | `link` / `link.css` |
| `list` | `list` / `typo.css` + recipe `list.css` |
| `badge` | `badge` / `badge.css` |

## Demo panel pattern

```heex
<.floating_panel id="demo" class="floating-panel floating-panel--semantic-accent">
  <.select id="theme" class="select select--size-sm" … />
  <.toggle id="mode" class="toggle toggle--size-sm" … />
</.floating_panel>
```

## Heroicons in components

No `class` on `<.heroicon>` inside Corex components or slots:

```heex
<.heroicon name="hero-chevron-down" />
```

## Anti-patterns

- Custom BEM sections in template CSS (e.g. `.home__section { … }`) — use token utilities
- Redundant heading utilities under `.typo` (`<h2 class="font-display text-2xl">`)
- Modifiers mixed with layout on same element — wrap with layout utilities if needed
- Overriding `--color-*` in templates — use `data-theme` / `data-mode`

## Elixir design pipeline

- `mix compile` runs `Compile.CorexDesign` when `config :corex_design` is set.
- Output: `corex.tailwind.css` shim plus `layers/`, `recipes/{id}.css`, and `aggregates/recipes.css` under `assets/css/`.

### Layout components

```heex
<.container size="lg">
  <.stack gap="lg">
    <.row gap="md" justify="between">
      <span>Left</span>
      <.spacer />
      <span>Right</span>
    </.row>
    <.divider />
    <.grid columns="3" gap="lg">…</.grid>
  </.stack>
</.container>
```

Layout merges BEM modifiers on `class` (`row row--gap-md`). Pass `unstyled` to skip layout styling output.

Generated CSS writes `layers/`, `recipes/{id}.css`, and `aggregates/` under `assets/css/`, re-exported by `corex.tailwind.css`. Main modifiers live in `@layer components` BEM; prefixed axes use `@utility` wildcards (`accordion--rounded-*`).

## Customization contract (upgrade-safe overrides)

1. **Tokens** (global). Override themes in `config :corex_design`.
2. **Variants** (per instance). Component attrs or BEM on `class`.
3. **CSS override** (anything else). Unlayered app CSS after `corex.tailwind.css`.
4. **Recipe override**. `Corex.Design.RecipeSource` modules merged by `:id`.

**Component contract:** axes and defaults live in each component's
`use Corex.Variants` declaration (sourced from `Corex.Scales`). Recipes are
optional styling; they may not style every axis a component stamps.

**Stability promise:** BEM `<base>--<mod>`, `[data-scope][data-part]`, and `[data-state]` are the public CSS API for Tailwind apps.

## References

- https://hexdocs.pm/corex/unstyled.html
- https://hexdocs.pm/corex/styled.html
- https://hexdocs.pm/corex/design-config.html
- https://hexdocs.pm/corex/theming.html
