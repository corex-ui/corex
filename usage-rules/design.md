# Corex Design

Optional config-driven token generation and static component CSS for Corex.

## Hard rules

1. **No custom CSS in templates** — only `@import` lines and vendor-required fragments in `site.css` / `app.css`
2. **Flat BEM modifiers** — `class="accordion accordion--accent accordion--variant-ghost accordion--lg"`
3. **Tailwind for layout and sizing** — `max-w-md`, `w-full`, `rounded-lg`, `text-sm`, `flex`, `gap-4`. Named width steps use the Corex container ladder (`9xs` … `9xl`), linked via semantic dimension tokens.
4. **Never invent class names** or write `[data-scope=…]` in template CSS
5. **`.typo` on prose** — bare semantic tags inside `.typo`
6. **`corex_design` dependency** — default for `mix corex.new`; generates CSS into `assets/corex/`

## Setup

`mix corex.new` adds the dependency, config, and build aliases. For existing apps, see `corex:installation`.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components.css";
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
  semantics: nil,
  variants: nil
```

```bash
mix corex.design.build
```

## Modifier axes

| Axis | Examples | Notes |
|------|----------|-------|
| Semantic | `--accent`, `--brand`, `--success` | palette CSS variables on the host |
| Variant | `--variant-solid`, `--variant-ghost`, `--variant-outline` | surface treatment; subtle is default |
| Size | `--sm`, `--md`, `--lg`, `--xl` | padding, control height, and font size |
| Radius | `--rounded-sm`, `--rounded-xl` | corner radius on roundable surfaces |

Size scales text; there is no separate `--text-*` modifier axis. See the [modifier guide](modifiers.html). Use Tailwind `w-*` and `max-w-*` with the container ladder on layout components; each component also has an intrinsic default width in its CSS.

## Semantic ink tokens

Use `--color-ink-{semantic}` (wildcard `--color-ink-*` in recipe utilities) for semantic text and focus rings on **neutral** surfaces (`--color-ui`, transparent).

Use `--color-{semantic}` for borders without fill.

**Filled** semantic controls pair `background-color: --color-{semantic}` with `color: --color-{semantic}-ink` (wildcard `--color-*-ink` in recipe utilities).

Do not use `--color-ink-*` for text on a matching semantic fill; contrast is solved on `--color-*-ink` tokens.

Legacy bare `var(--color-{semantic}-ink)` names remain as aliases in generated theme CSS only.

## Demo panel pattern

```heex
<.floating_panel id="demo" class="floating-panel floating-panel--accent max-w-md">
  <.select id="theme" class="select select--sm" … />
  <.toggle id="mode" class="toggle toggle--sm" … />
</.floating_panel>
```

## Heroicons in components

No `class` on `<.heroicon>` inside Corex components or slots:

```heex
<.heroicon name="hero-chevron-down" />
```

## Anti-patterns

- Custom layout components instead of Tailwind (`<.stack>` with axis attrs)
- Invented modifier names (`accordion--ghost`, `accordion--semantic-accent`) — use `accordion--variant-ghost` and flat semantic roles (`accordion--accent`)
- Overriding `--color-*` in templates — use `data-theme` / `data-mode` or rebuild tokens
- Using `--color-ink-*` on filled semantic controls — use `--color-*-ink` instead
- Legacy bare `var(--color-{semantic}-ink)` in hand-authored CSS — prefer `--value(--color-*-ink, …)` or `--value(--color-ink-*, …)` by surface

## References

- https://hexdocs.pm/corex/design.html
- `design/README.md` in the Corex repository
