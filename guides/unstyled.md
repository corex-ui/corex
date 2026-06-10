# Unstyled

Corex ships **no CSS**. Accessibility, state machines, and component anatomy come from [Zag.js](https://zagjs.com). Visuals are entirely yours.

**Unstyled does not mean unmarked.** Every component participates in a shared styling contract so you always know which hooks to target.

## The styling contract

1. **Style attributes** (`semantic`, `size`, `radius`, …) express design intent. They are not inline styles and they do not load CSS.
2. Corex **translates** those attrs into BEM classes on the host: `accordion`, `accordion--semantic-accent`, `accordion--size-lg`.
3. **Your stylesheet** defines what those classes look like.

```heex
<.accordion semantic="accent" size="lg" class="accordion" … />
```

```html
<div class="accordion accordion--semantic-accent accordion--size-lg" data-scope="accordion" …>
```

Write rules for `.accordion--semantic-accent` in your CSS. The attrs and classes are hooks; your stylesheet is the paint.

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

Hexdocs lists allowed steps for each attr (for example `padding="sm"` on [`Corex.Layout.Box`](Corex.Layout.Box.html)). Those lists come from your app config when Corex compiles:

1. **`config :corex, scales:`** defines step names per axis (`size`, `radius`, `gap`, `space`, …).
2. **`config :corex, semantics:`** defines role names for `semantic=` attrs.
3. At compile time, each component bakes the lists into `attr(..., values: [...])`.
4. Phoenix validates attrs when you render. An unknown step fails validation.

Published Hexdocs show Corex built-in defaults. After you change config, **recompile** your app. New steps also need matching token values if you use [Corex Design](styled.html) ([Design config](design-config.html)).

### Vocabulary config

| Concern | Config | Key | Affects |
| --- | --- | --- | --- |
| Axis step names | `:corex` | `:scales` | `size=`, `radius=`, `gap=`, layout padding, etc. |
| Semantic roles | `:corex` | `:semantics` | `semantic=` on components |
| Polymorphic looks | `:corex` | `:recipe_looks` | `action` / `navigate` (`as="button"` / `"link"`), `tree_view`, `dialog` |

Example:

```elixir
config :corex,
  semantics: ~w(accent brand alert info success selected promo)a,
  scales: [radius: ~w(none sm md lg xl full)a],
  recipe_looks: [
    button: %{
      base: "button",
      axes: [semantic: :semantic, variant: :visual, size: :size, shape: :shape, radius: :radius]
    }
  ]
```

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
