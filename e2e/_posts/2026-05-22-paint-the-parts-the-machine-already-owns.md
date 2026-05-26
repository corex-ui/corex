---
title: "Paint the Parts the Machine Already Owns"
description: "Corex hooks own behavior and ARIA. Corex Design owns tokens, shared utilities, and BEM modifiers on the same data-part tree."
date: "2026-05-22 12:00:00 +0000"
permalink: /en/blog/paint-the-parts-the-machine-already-owns/
tags:
  - Corex
  - Design tokens
  - Accessibility
sitemap:
  priority: 0.8
  changefreq: monthly
---

Corex components work without bundled CSS. The hook still runs. The tree still gets `data-state` and `data-part`. You can ship accessible behavior first and worry about paint later.

I still reach for **Corex Design** on every real app, because behavior and look answer different questions. The machine does not read your `site.css`. It does not care whether the combobox input uses neo or uno tokens. Design targets the **body** the hook keeps updating: `[data-scope][data-part]` nodes with stable names.

[Anatomy](/en/blog/anatomy-of-a-corex-component/) is how much HEEx you write. [State machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/) and [vanilla JS](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) are how interaction stays correct. Design is what users see after mount.

## Why centralize instead of per-page CSS

Without Design, each form page grows its own rules. Combobox focus in `site.css`. Password padding tweaked for one campaign. A contrast fix on `native-input` never reaches the combobox input because they were different selectors written months apart.

Corex Design flips that:

- **Tokens** define ink, borders, spacing, radius once.
- **Shared utilities** (`ui-input`, `ui-trigger`, `ui-item`, `ui-content`) compose tokens into patterns.
- **Component CSS** `@apply`s those utilities onto the right `data-part`.
- **Modifiers** on the root (`combobox--accent`, `button--lg`) tune one instance.

Change `ui-input` once and every control that types through it moves together: `native-input`, combobox, password-input, pin-input, editable.

```css
.native-input [data-scope="native-input"][data-part="input"] {
  @apply ui-input;
}
```

Triggers use `ui-trigger` the same way (buttons, select triggers, dialog close, carousel arrows). List rows use `ui-item`. Floating surfaces use `ui-content`. You rarely add those classes in HEEx; component CSS composes them for you.

## Contrast lives in tokens, not one-off overrides

Palettes are generated with the [Adobe Leonardo](https://leonardocolor.io/) API against target contrast ratios. Token files record the result (for example **7.0:1** for primary ink on the page background). `--color-ink`, `--color-ink-muted`, `--color-border`, and semantic accents feed Tailwind utilities (`text-ink`, `border-border`) and the utilities above.

```corex-callout note
Contrast from day one

After upgrading Corex, run **`mix corex.design --force`** so `assets/corex/` matches the component CSS your hooks expect.

If a label fails audit, switch theme, mode, or a semantic modifier (`button--accent` vs `button--muted`) before adding overrides in `site.css`.
```

Because `ui-input` reads `var(--color-border)` and `var(--color-ink-muted)` for placeholders, a token fix propagates to every input-shaped part.

## Copy the design tree once

```bash
mix corex.design
```

Optional token authoring:

```bash
mix corex.design --designex
```

Files land under `assets/corex/`. Existing paths are skipped by default so local token work is not wiped accidentally. Use `--force` after a Hex upgrade when component CSS changed.

## Thin `site.css`, explicit imports

Templates stay thin: no new selectors on Corex internals.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/native-input.css";
@import "../corex/components/combobox.css";
@import "../corex/components/button.css";
```

Add one `@import "../corex/components/<name>.css"` per component on the page. Point Tailwind at the tree with `@source "../corex";`.

Set theme and mode on the document; typography and layout on the body:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

Themes **neo**, **uno**, **duo**, and **leo** each ship light and dark token files. Swap `data-theme` or `data-mode` on `<html>` and every component reading variables updates together.

If the app still loads daisyUI from stock `phx.new`, remove it. Two token systems fight for the same utilities.

## Modifiers on the root

Each styled component has a root class matching its name. Stack modifiers on that root:

```heex
<.accordion
  class="accordion accordion--accent accordion--lg accordion--rounded-lg"
  id="faq"
  items={@topics}
/>
```

```heex
<.combobox class="combobox combobox--accent combobox--lg" id="airport" items={@items}>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

Color (`--accent`, `--alert`), size (`--sm`, `--lg`), radius (`--rounded-xl`), and type (`--text-lg`) map to CSS variables through `@utility` blocks in each component file. They tint parts that already use shared utilities; they do not fork `ui-input`.

## `data-state` is not your job

**`data-state`**, **`data-highlighted`**, and open/closed attributes come from the machine, not from HEEx. Design CSS selects them on parts the hook maintains. You style what the brain already wrote.

## HEEx stays stable when design moves

Templates pass modifiers on the root and bare heroicons inside slots. No `class` on the heroicon. Parent CSS sizes icons. No per-page rule for “combobox on checkout.” If checkout needs alert styling, `combobox--alert` on the root is enough.

When behavior is correct and the look is wrong, change tokens, utilities, or modifiers, then refresh copied CSS from Hex if needed.

## What not to do in templates

- No new selectors in `site.css` that override `[data-scope]` internals
- No duplicate focus styles per LiveView
- No invented class names beside documented modifiers
- No `class` on heroicons inside Corex components

Corex Design does not change anatomy, hooks, or server events. It only changes appearance after mount.

---

Tokens define palette and scale. Utilities define inputs, triggers, items, and surfaces. Component CSS attaches utilities to `data-part`. Modifiers tune one instance on the root.

When the catalog outgrows the browser, [combobox scale](/en/blog/nine-thousand-airports-one-hundred-rows/) keeps the same visual language with server-fed `items`.
