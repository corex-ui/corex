# Corex Design

Optional config-driven token generation and static component CSS for Corex.

## Hard rules

1. **No custom CSS in templates** — only `@import` lines and vendor-required fragments in `site.css` / `app.css`
2. **Shared `ui-*` modifiers** — `class="accordion ui-accent ui-size-lg"`
3. **Tailwind for layout and sizing** — `max-w-md`, `w-full`, `rounded-lg`, `text-sm`, `flex`, `gap-4`. Named width steps use the Corex container ladder (`9xs` … `9xl`), linked via semantic dimension tokens.
4. **Never invent class names** or write `[data-scope=…]` in template CSS
5. **`.typo` on prose** — bare semantic tags inside `.typo`
6. **`corex_design` dependency** — default for `mix corex.new`; generates CSS into `assets/corex/` (gitignored; rebuild with `mix corex.design.build`)

## Setup

`mix corex.new` adds the dependency, config, and build aliases. For existing apps, see `corex:installation`.

```css
@import "../corex/corex.css";
@source "../corex";
```

```heex
<html data-theme="neo" data-mode="light">
  <body class="typo">
```

## Custom tokens

Configure in `config/config.exs`:

```elixir
config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  themes: nil,
  scales: [],
  components: nil,
  semantics: nil
```

```bash
mix corex.design.build
```

## Modifier axes

| Axis | Examples | Notes |
|------|----------|-------|
| Semantic | `ui-accent`, `ui-brand`, `ui-success` | palette roles on the host |
| Variant | `ui-solid` | surface treatment; subtle is default (no class) |
| Size | `ui-size-sm`, `ui-size-md`, `ui-size-lg`, `ui-size-xl` | padding, control height, and font size |
| Radius | `ui-rounded-sm`, `ui-rounded-xl` | corner radius on roundable surfaces |

Size scales text; there is no separate text modifier axis. See the [modifier guide](modifiers.html). Use Tailwind `w-*` and `max-w-*` with the container ladder on layout components; each component also has an intrinsic default width in its CSS.

## Semantic ink tokens

Use `--color-ink-{semantic}` (wildcard `--color-ink-*` in recipe utilities) for semantic text and focus rings on **neutral** surfaces (`--color-ui`, transparent).

Use `--color-{semantic}` for borders without fill.

**Filled** semantic controls pair `background-color: --color-{semantic}` with `color: --color-{semantic}-ink` (wildcard `--color-*-ink` in recipe utilities). Prefer `{role}-contrast` / `{role}-text` naming in new token work where the design package exposes those names.

Do not use `--color-ink-*` for text on a matching semantic fill; contrast is solved on fill/ink pair tokens.

## Demo panel pattern

```heex
<.floating_panel id="demo" class="floating-panel ui-accent max-w-md">
  <.select id="theme" class="select ui-size-sm" … />
  <.toggle id="mode" class="toggle ui-size-sm" … />
</.floating_panel>
```

## Heroicons in components

No `class` on `<.heroicon>` inside Corex components or slots:

```heex
<.heroicon name="hero-chevron-down" />
```

## Anti-patterns

- Custom layout components instead of Tailwind (`<.stack>` with axis attrs)
- Invented modifier names (`accordion--ghost`, `accordion--accent`) — use shared `ui-*` roles (`ui-accent`, `ui-solid`)
- Overriding `--color-*` in templates — use `data-theme` / `data-mode` or rebuild tokens
- Using `--color-ink-*` on filled semantic controls — use on-fill contrast tokens instead
- Documenting or configuring `variants:` — removed in 0.2; only subtle + `ui-solid`

## References

- https://hexdocs.pm/corex/design.html
- https://hexdocs.pm/corex/modifiers.html
