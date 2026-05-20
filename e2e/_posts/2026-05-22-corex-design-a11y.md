---
title: "Corex Design: an accessibility-first design system"
description: "Leonardo contrast targets, token pipelines, and BEM modifiers so AA and AAA are built in, not patched later."
date: "2026-05-22 12:00:00 +0000"
permalink: /en/blog/corex-design-a11y/
tags:
  - Corex
  - Design tokens
  - Accessibility
sitemap:
  priority: 0.8
  changefreq: monthly
---

Corex components work without bundled CSS. The hook still runs the machine; the tree still gets `data-state` and `data-part`. Design is how that **body** looks.

The machine does not read your `site.css`. Component CSS targets **`[data-scope][data-part]`** nodes the hook maintains. Shared utilities (`ui-input`, `ui-trigger`) centralize how fields and buttons look; modifiers on the root (`combobox--accent`, `button--lg`) tune one instance.

**Corex Design** copies tokens and component CSS into `assets/corex/`. You import what you use. Change `ui-input` once and every control that composes it moves together. That is separate from anatomy (HEEx) and separate from state (machine vs assigns), but it sits on the same DOM the brain keeps updating.

When LiveView [patches the DOM](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching), the hook re-applies machine state onto **`[data-part]`** nodes. Design CSS targets those parts, not your LiveView module. A token change does not require relearning bindings or assigns; it requires re-importing or regenerating `assets/corex/` after `mix corex.design`.

## Why centralize

Without Design, each form page tends to accumulate its own rules. Combobox focus rings in `site.css`. Password field padding in a LiveView-specific stylesheet. Pin input borders tweaked for one campaign. A contrast fix on `native-input` never reached the combobox input because they were different selectors written months apart.

Corex Design flips that. **Tokens** define ink, borders, spacing, and radius once. **Shared utilities** compose those tokens into patterns (`ui-input`, `ui-trigger`, `ui-item`). **Component CSS** applies the utilities to the right `data-part`. **Modifiers** on the root shift semantic color and size for that instance. Change the shared layer and every component that `@apply ui-input` moves together.

## One input style, every control that types

Text-like controls do not each own a copy of border, focus, placeholder, and disabled styles. They pull from `ui-input` in `assets/corex/utilities.css` (imported via `main.css`).

`native-input` applies it to the field part:

```css
.native-input [data-scope="native-input"][data-part="input"] {
  @apply ui-input;
}
```

The same utility appears on combobox, password-input, editable, pin-input, and clipboard inputs in their component files. To change focus treatment or touch height for all fields, edit tokens and `ui-input`, then `mix corex.design --force` after a Corex upgrade if needed. Every component that `@apply ui-input` updates together.

**Centralize the primitive, specialize only where the DOM differs.** Triggers use `ui-trigger` the same way (buttons, select triggers, dialog close controls, carousel arrows). List rows use `ui-item`. Floating surfaces use `ui-content`. You rarely add those classes in HEEx; component CSS composes them for you.

A useful way to read the repo: open `assets/corex/utilities.css` for primitives, then `assets/corex/components/<name>.css` for how that primitive attaches to parts. If two components look inconsistent, the fix is almost never “add CSS on the LiveView.” It is “check whether both parts `@apply` the same utility” or “align their modifiers to the same semantic axis (`--accent`, `--lg`).”

| Utility | Role | Examples in component CSS |
|---------|------|---------------------------|
| `ui-input` | Text fields and input-shaped parts | `native-input`, `combobox`, `password-input`, `pin-input`, `editable`, `clipboard` |
| `ui-trigger` | Clickable controls and icon buttons | `button`, `select`, `dialog`, `carousel`, `file-upload` |
| `ui-item` | Options in lists and menus | `select`, `combobox`, `menu` |
| `ui-content` | Panels and popover surfaces | `dialog`, `combobox`, `select` |
| `ui-label` | Field labels | `native-input`, form-adjacent layouts |

Component-specific CSS only adds what the Zag tree needs: extra padding on a pin cell, layout for combobox control chrome, indicator slots on accordion triggers. The baseline look still comes from the shared utility.

**`data-state`** and **`data-highlighted`** on parts come from the machine, not from your HEEx. Design CSS uses attribute selectors on those hooks-owned states, for example styling an open combobox content part when **`data-state="open"`**. You rarely set those attrs in templates; you style what the brain already maintains.

## Contrast and color live in tokens, not in pages

Palettes are generated with the [Adobe Leonardo](https://leonardocolor.io/) API against target contrast ratios. Token files record the result (for example **7.0:1** for primary ink on the page background). `--color-ink`, `--color-ink-muted`, `--color-border`, and semantic accents feed both Tailwind utilities (`text-ink`, `border-border`) and the utilities above.

```corex-callout note
Contrast from day one

Design tokens are versioned with the Hex package. After upgrading Corex, run **`mix corex.design --force`** so `assets/corex/` matches the component CSS your hooks expect.

Treat contrast like spacing: choose tokens and modifiers on purpose. If a label fails audit, switch theme, mode, or a semantic modifier (`button--accent` vs `button--muted`) before adding one-off overrides in `site.css`.
```

Because `ui-input` reads `var(--color-border)` and `var(--color-ink-muted)` for placeholders, a token fix propagates to every input-shaped part. Accessibility and visual consistency stay tied to the same source.

## Copy the design tree once

```bash
mix corex.design
```

Optional token authoring:

```bash
mix corex.design --designex
```

Files land under `assets/corex/`. After a Corex upgrade, refresh with `--force` so component CSS and utilities stay aligned with the Hex release. Existing paths are skipped by default so local token work is not wiped accidentally.

## Imports: main, theme, then only what you render

`site.css` stays thin. No new selectors on Corex internals.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/native-input.css";
@import "../corex/components/combobox.css";
@import "../corex/components/button.css";
```

Add one `@import "../corex/components/<name>.css"` per component on the page. `main.css` already pulls in `utilities.css` where `ui-input` and `ui-trigger` live.

Point Tailwind at the same tree:

```css
@source "../corex";
```

Set theme and mode on the document; typography and layout on the body:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

Themes **neo**, **uno**, **duo**, and **leo** each ship light and dark token files. Change `data-theme` or `data-mode` on `<html>` and every component reading tokens updates without duplicate CSS files per theme.

If the app still loads **daisyUI** from stock `phx.new`, remove it. Two token systems fight for the same utilities.

## Tokens Studio to CSS variables

Design tokens live in **Tokens Studio JSON**. **Style Dictionary** emits Tailwind v4 variables under `assets/corex/`. With `--designex`, `assets.build` and `assets.deploy` can run `designex corex` so you edit under `assets/corex/design/` and rebuild locally. You do not need Designex to **use** Design in production, only to **change** tokens.

| Token family | Examples | Use in markup |
|--------------|----------|----------------|
| Ink | `--color-ink`, `--color-ink-muted` | `text-ink`, `text-ink-muted` |
| Surfaces | `--color-layer`, `--color-root` | `bg-layer`, page background |
| Spacing | `--spacing-space`, `--spacing-space-lg` | `gap-space`, `p-space-lg` |
| Type | `--text-base`, `--text-lg` | `.typo` on body, `--text-lg` modifiers |
| Radius | `--radius-md`, `--radius-xl` | `rounded-md`, `accordion--rounded-xl` |

Prefer these names over magic numbers in HEEx so layout and components stay on the same scale when tokens change.

## Modifiers on the component root

Each styled component has a root class matching its name (`accordion`, `select`, `combobox`, `button`). Modifiers stack on that root:

```text
<component> <component>--<axis> …
```

Example accordion with color, size, and radius from tokens:

```heex
<.accordion
  class="accordion accordion--accent accordion--lg accordion--rounded-lg"
  id="faq"
  items={
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  }
/>
```

| Axis | Examples | Effect |
|------|----------|--------|
| Color | `button--accent`, `combobox--alert` | Semantic palette from tokens |
| Size | `button--sm`, `dialog--lg` | Spacing and type scale |
| Radius | `accordion--rounded-xl` | Corner radius on parts |
| Type | `tabs--text-lg` | Font size on triggers and content |

Modifiers map to CSS variables through `@utility` blocks in each component file. They do not fork `ui-input`; they tint the component’s parts that already use shared utilities.

## How component CSS targets the tree

Hooks set **`data-scope`** and **`data-part`**. Component CSS selects those nodes and applies shared utilities:

```css
[data-scope="combobox"][data-part="input"] {
  @apply ui-input;
}
[data-scope="combobox"][data-part="control"] {}
[data-scope="combobox"][data-part="content"] {}
[data-scope="combobox"][data-part="item"] {}
```

You normally never write these selectors in the app. They explain why a combobox input and a `native-input` field look related: same utility, different part names.

## HEEx stays stable when design moves

Templates pass modifiers on the root and bare heroicons inside slots:

```heex
<.combobox
  class="combobox combobox--accent combobox--lg"
  id="airport"
  items={@items}
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

```heex
<.native_input class="native-input native-input--accent" id="email" type="email" />
```

No `class` on the heroicon. Parent CSS sizes icons. No per-page rule for “combobox on checkout.” If checkout needs alert styling, `combobox--alert` on the root is enough.

## Typography and layout on the body

**`.typo`** and **`.layout`** on `<body>` style headings, paragraphs, lists, and page rhythm from tokens. Marketing copy uses semantic tags; interactive controls use component roots.

```heex
<body class="typo layout">
  <main>
    <h1>Account</h1>
    <p>Profile and billing share the same input and button language.</p>
    <.native_input class="native-input" id="name" />
    <.button class="button button--accent">Save</.button>
  </main>
</body>
```

## Theme picker without new CSS per screen

Flip theme at the root; components follow via variables:

```heex
<.select
  class="select select--accent"
  id="theme-picker"
  items={
    Corex.List.new([
      %{label: "Neo", value: "neo"},
      %{label: "Uno", value: "uno"},
      %{label: "Duo", value: "duo"},
      %{label: "Leo", value: "leo"}
    ])
  }
  value={[@current_theme]}
  on_value_change="theme_changed"
/>
```

```elixir
def handle_event("theme_changed", %{"value" => [theme]}, socket) do
  {:noreply, push_event(socket, "corex:set-theme", %{theme: theme})}
end
```

Dark mode is the same mechanism: `data-mode="dark"` on `<html>`, same variable names, different theme file values.

## A typical change, end to end

Example: larger fields and lighter placeholders.

1. Edit spacing and type tokens in the token source; rebuild with Designex if you use it.
2. Confirm `ui-input` maps `min-height` to `var(--spacing-size)` and placeholders to `var(--color-ink-muted)`.
3. `native_input`, combobox, password fields, and pin cells update together.
4. For one error page only, add `combobox--alert` on that instance instead of forking `ui-input`.

The same applies to triggers: change `ui-trigger` once, buttons and select chevrons follow.

HEEx stays stable: `class="combobox combobox--accent"` and `class="native-input"` survive token updates. Refresh copied CSS from Hex when a component gains new parts or modifier axes.

## What not to do in templates

- No new selectors in `site.css` that override `[data-scope]` internals
- No duplicate focus styles per LiveView
- No invented class names beside documented modifiers
- No `class` on heroicons inside Corex components

Corex Design does not change anatomy, hooks, or server events. It only changes appearance after mount. When behavior is correct and the look is wrong, change tokens, utilities, or modifiers, then `mix corex.design --force` after a Corex upgrade if needed.

## Optional: tokens only, or skip Design

Import `main.css` and themes and write your own rules against `data-scope` / `data-part`. Or skip Design entirely and use another system. Zag and Phoenix components do not depend on the CSS layer.

---

Tokens define palette and scale. Shared utilities define inputs, triggers, items, and surfaces. Component CSS attaches utilities to `data-part`. Modifiers tune one instance on the root. Update `ui-input` once and every control that composes it moves together.
