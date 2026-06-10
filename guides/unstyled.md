# Unstyled

Corex ships **no CSS**. Accessibility, state machines, and component anatomy come from [Zag.js](https://zagjs.com). Visuals are entirely yours.

**Unstyled does not mean unmarked.** Every component participates in a shared styling contract so you always know which hooks to target.

## The styling contract

1. **Style attributes** (`semantic`, `size`, `radius`, …) express design intent. They are not inline styles and they do not load CSS.
2. Corex **translates non-nil attrs** into BEM modifiers on the host. Omitted attrs emit **no modifier** (block class only).
3. **Your stylesheet** (or [Corex Design](styled.html) base CSS) defines what the block and modifiers look like.

```heex
<.accordion semantic="accent" size="lg" class="accordion" … />
```

```html
<div class="accordion accordion--semantic-accent accordion--size-lg" data-scope="accordion" …>
```

Bare `class="accordion"` with no attrs emits only `accordion`. With Corex Design, recipe defaults are merged into the `.accordion` base rule in generated CSS.

Want ready-made rules instead? Skip authoring CSS and use [Corex Design](styled.html).

## Hexdocs snippets

On each component's Hexdocs page, **Anatomy** (and Events / Patterns / Form) show the shortest structural markup: slots, required a11y, and state attrs only. **Styling** shows the equivalent attribute-based and BEM class forms. Copy Anatomy when wiring behavior; copy Styling when applying the design contract.

## Attributes or classes

Both paths are equivalent:

```heex
<.accordion semantic="accent" size="md" class="accordion" … />
<.accordion class="accordion accordion--semantic-accent accordion--size-md" … />
```

Attributes keep templates readable. Classes help when you build `class` dynamically or copy examples from docs.

## Skip modifiers entirely

Pass `unstyled` to omit generated modifier classes and keep only what you put in `class`:

```heex
<.accordion unstyled class="my-accordion" … />
```

You can also style inner parts with `data-scope` and `data-part` selectors (listed on each component's Hexdocs page) without using BEM modifiers at all.

## Axis naming

| Component attr | BEM modifier on host |
| --- | --- |
| `semantic="accent"` | `accordion--semantic-accent` |
| `size="md"` | `accordion--size-md` |
| `text="lg"` | `accordion--text-lg` |
| `radius="md"` | `accordion--rounded-md` |
| `width="full"` | `accordion--w-full` |
| `max_width="md"` | `accordion--max-w-md` |

Always include the block class: `class="accordion accordion--semantic-accent"`, not `class="accordion--semantic-accent"` alone.

Layout components (`row`, `stack`, `box`, …) follow the same pattern: `gap="md"` with `class="row"`, or `class="row row--gap-md"`.

Layout attr values are design shorthand (`gap="md"`, `justify="between"`), not Tailwind utility strings.

## Allowed values

Step names are fixed in `Corex.Scales` (`sm`, `md`, `accent`, …). Hexdocs lists allowed steps for each attr (for example `padding="sm"` on [`Corex.Layout.Box`](Corex.Layout.Box.html)).

With [Corex Design](styled.html), optional `scales:` may **subset** those steps for smaller CSS. Theme `dimensions` tune how large `md` looks without renaming steps. Run `mix corex.design.lint` after subsetting ([Design config](design-config.html)).

Polymorphic components pick a look with `as`:

```heex
<.action as="button" semantic="accent" aria_label="Close">
  <.heroicon name="hero-x-mark" />
</.action>

<.tree_view as="navigation" class="tree-navigation" items={@items} />
<.dialog as="side" side="start" modal />
```

## Related

- [Styled](styled.html) — optional Corex Design CSS for these modifiers
- [Design config](design-config.html) — theme tokens and `:corex_design` keys
- [Installation](installation.html#how-styling-works) — short overview in the intro flow
