# Unstyled

Corex ships **no CSS**. Accessibility, state machines, and component anatomy come from [Zag.js](https://zagjs.com). Visuals are entirely yours.

**Unstyled does not mean unmarked.** Every component participates in a shared styling contract so you always know which hooks to target.

## The styling contract

1. **Style attributes** (`semantic`, `size`, `radius`, …) express design intent. They are not inline styles and they do not load CSS.
2. By default, `:corex` does **not** emit BEM modifiers. Only your `class` assign appears on the host.
3. Opt in to BEM with `config :corex, emit_style_classes: true`, or install Corex Design (`config :corex, Corex.Design` enables BEM automatically).
4. **Your stylesheet** (or Corex Design CSS) defines what block and modifier classes look like.

With BEM enabled:

```heex
<.accordion semantic="accent" size="lg" class="accordion" … />
```

```html
<div class="accordion accordion--semantic-accent accordion--size-lg" data-scope="accordion" …>
```

With Corex Design, recipe defaults are merged into the `.accordion` base rule in generated CSS.

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

## BEM tiers

| Setup | BEM in `class` |
| --- | --- |
| `{:corex}` only (default) | Off |
| `config :corex, emit_style_classes: true` | On |
| `{:corex_design}` + `config :corex, Corex.Design` | On (automatic) |

Style each axis with **named attrs** (`semantic`, `size`, `gap`, `hide_below`, `as`, …) or equivalent BEM classes on `class`. There is no bundled `style={%{...}}` map attribute.

`:corex` accepts any style string and performs no validation. It maps attrs to BEM modifiers with fixed rules only. With [Corex Design](styled.html), `scales:` in design config drives generated CSS. Builtin step names are listed in [Design config](design-config.html). Theme `dimensions` tune how large `md` looks without renaming steps.

Polymorphic components pick a look with `as` (any string; known names use the component `looks` alias map):

```heex
<.action as="button" semantic="accent" aria_label="Close">
  <.heroicon name="hero-x-mark" />
</.action>

<.tree_view as="navigation" class="tree-navigation" items={@items} />
<.dialog as="side" side="start" modal />
<.row hide_below="lg" gap="md" />
```

`hide_below` and `hide_from` emit layout BEM modifiers (`row--hide-below-md`), not `data-hide-*` attributes.

## Related

- [Styled](styled.html) — optional Corex Design CSS for these modifiers
- [Design config](design-config.html) — theme tokens and `:corex_design` keys
- [Installation](installation.html#how-styling-works) — short overview in the intro flow
