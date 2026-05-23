# Corex Design

Copy assets with `mix corex.design` — see `corex:installation`.

## Hard rules

1. **No custom CSS in templates** — only `@import` lines and vendor-required fragments in `site.css` / `app.css`
2. **Modifiers are the styling API** — `class="accordion accordion--accent accordion--lg"`
3. **Never invent class names** or write `[data-scope=…]` in template CSS
4. **`.typo layout` on body** — bare semantic tags first
5. **Remove daisyUI** when using Corex Design

## Setup

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/accordion.css";
@source "../corex";
```

```heex
<html data-theme="neo" data-mode="light">
  <body class="typo layout">
```

One `components/<name>.css` import per rendered component.

## Modifier stacking

Stack on root class. Responsive prefixes on modifiers:

```heex
<.accordion
  class="accordion accordion--accent accordion--sm sm:accordion--md lg:accordion--xl"
  …
/>

<.timer
  class="timer timer--accent timer--text-lg sm:timer--text-xl lg:timer--text-5xl timer--rounded-xl"
  …
/>
```

| Axis | Examples |
|------|----------|
| Color | `--accent`, `--success`, `--info`, `--alert` |
| Size | `--sm`, `--md`, `--lg`, `--xl` |
| Radius | `--rounded-md`, `--rounded-xl`, `--rounded-full` |
| Type | `--text-lg`, `--text-2xl` |

## Demo panel pattern

```heex
<.floating_panel id="demo" class="floating-panel floating-panel--accent">
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

- Custom BEM sections in template CSS (e.g. `.home__section { … }`) — use token utilities
- Redundant heading utilities under `.typo` (`<h2 class="font-display text-2xl">`)
- Modifiers mixed with layout on same element — wrap with layout utilities if needed
- Overriding `--color-*` in templates — use `data-theme` / `data-mode`

## References

- https://hexdocs.pm/corex/design.html
- https://hexdocs.pm/corex/theming.html
