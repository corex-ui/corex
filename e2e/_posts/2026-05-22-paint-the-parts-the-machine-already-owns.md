---
title: "Paint the Parts the Machine Already Owns"
description: "Corex Design is the layer that doesn't ask the component anything. It paints what the behavior already exposes, on stable parts that never move."
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

There is a moment in the life of every Phoenix project where someone opens `site.css` and adds a rule. A combobox needs an extra pixel of padding to match a new design. Six weeks later somebody else opens the same file and adds a different rule on the same selector for a different page. Six weeks after that, a contrast audit fails on a screen nobody touched. The rules are still there. They are just no longer doing what anyone intended.

I have lived this loop on enough projects to recognize the smell. The shared piece (a combobox, a button, a focus ring) gets attacked from many different files, over many months, by many people, and slowly turns into an emergent compromise that nobody designed. Pre-Corex, this was the default outcome on every team I joined.

Corex Design is the part of the library that exists to make that loop optional. It is not the part that owns behavior. Behavior lives in Zag machines, attached to hooks, marking up `data-scope` and `data-part`. Corex Design owns appearance, and only that. It paints what the behavior layer already exposes.

This post is about how that separation works, why it stays clean even on big apps, and the few things you should never do inside it.

## Behavior and appearance are different problems

The hook does not read your `site.css`. It does not care whether your combobox input uses the neo or uno theme. It does not know what radius you set. It writes `data-state="open"`, it writes `aria-expanded="true"`, it moves focus when a key is pressed. That is its whole job.

CSS shows up after the fact, on a page that is already moving. The honest move, on a library that takes behavior seriously, is to let CSS aim at the parts the machine maintains. Components expose `[data-scope="combobox"][data-part="input"]`. Design says: that is where input styling goes. The names are stable across every Corex install and every page in your app.

That is the quiet contract underneath the whole design system. The selector you write today will still match next year, even if the markup grows wrappers, even if the design changes radius, even if the machine adds a new state. The names do not move.

## Tokens, utilities, modifiers, in three sentences

Tokens define the palette and scale once. Ink, borders, spacing, radius, type, every measurable thing the rest of the system reads.

Utilities are short class names that compose tokens into patterns: `ui-input` is everything inputs need. `ui-trigger` is everything triggers need. `ui-item` is everything list rows need. `ui-content` is the surface a floating panel sits on. You almost never write these classes by hand. Component CSS uses them inside `@apply` rules and aims them at the right `data-part`.

Modifiers are how you tune one instance without forking the whole system. They live on the root class. A button is `button`. An accent button is `button button--semantic-accent`. A large rounded button is `button button--semantic-accent button--size-lg button--rounded-lg`. The modifier system has four axes (color, size, radius, type), and they map directly to CSS variables under the hood.

```heex
<.accordion
  class="accordion accordion--semantic-accent accordion--size-lg accordion--rounded-lg"
  id="faq"
  items={@topics}
/>
```

If you ever feel the urge to invent a new class beside those modifiers, the system is telling you something. Either an existing modifier can cover the case (it usually can), or you have a real one-off and the right place is parent layout CSS, not a Corex internal.

## One change in `ui-input`, one move across the app

Here is the boring observation that makes the whole approach worth it. The same `ui-input` utility is composed into the input part of `native-input`, the input part of `combobox`, `password-input`, `pin-input`, `editable`. Five components, one definition. When the contrast on placeholders is off, you change the placeholder color token once. Every input on every page picks it up on the next reload.

Triggers are the same story. Buttons, select triggers, dialog close, carousel arrows all read `ui-trigger`. List rows in select, menu, listbox, combobox all read `ui-item`. The big floating panels (popover content, dialog content, menu content) all read `ui-content`.

There is a moment, the first time you change a token and watch the entire app shift in unison, where the appeal stops being academic. The design system stops being a folder of files and becomes a single object you can adjust.

## Contrast is a number, not a vibe

The four themes (`neo`, `uno`, `duo`, `leo`) ship with light and dark token files each. That is eight surface variants from one set of utilities and components, with a real guarantee underneath.

Palettes are generated through the [Adobe Leonardo](https://leonardocolor.io/) API against explicit contrast targets. Primary ink against the page background lands at 7.0:1. Muted ink against the page background lands above 4.5:1. Borders, accents, every named color in the system gets a number, not an eyeball.

That is what makes it possible to swap `data-theme` or `data-mode` on `<html>` and have the entire app stay readable.

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

You are not asking the palette to be pretty in two modes. You are asking it to clear an audit in two modes, and the generation pipeline is doing the work.

If a label ever fails an audit, the answer is almost always to switch a theme, switch a mode, or switch a modifier (`button--semantic-accent` vs `button--semantic-muted`), before reaching for any override. Tokens are the source. Overrides are the symptom.

## A thin `site.css`

The setup is small enough to fit in a paragraph. This example uses the **per-component vendoring** path: run `mix corex.design` once, files land under `assets/corex/`, and you import anatomy CSS per component. Phoenix apps with Tailwind 4 can instead compile `corex.tailwind.css` via `:corex_design` (see [Styled](https://hexdocs.pm/corex/styled.html)).

In `app.css`, import the Corex base, the theme files you want to expose, the typography, the layout, and one file per component you render. Point Tailwind at the copied directory. Set `data-theme` and `data-mode` on `<html>`. Set `class="typo layout"` on `<body>`. That is the whole story.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/accordion.css";
@import "../corex/components/combobox.css";
@import "../corex/components/button.css";
```

If your `app.css` still loads daisyUI from stock `phx.new`, remove it. Two token systems fighting for the same utility names is the most reliable way to make both unhappy.

## Things you should never do

This is short because the list is short.

Do not add a new selector in `site.css` that overrides a Corex internal. The selectors in component CSS already match your part. Adding a parallel one means two definitions, two contexts, two reasons the next change behaves oddly.

Do not duplicate focus styles per LiveView. The focus styles are in the design system. They already work. Re-implementing them per page is how focus rings start disagreeing with each other on adjacent screens.

Do not pass a `class` on a heroicon inside a Corex component. The parent component already styles icons inside its slots. Adding a class fights it.

Do not invent a class name next to a modifier. Either the modifier exists (use it), the modifier should exist (open an issue), or the page needs a layout class outside the component (write it in your own CSS, not on a `data-part`).

## What lives where, when you forget

It is easy to misplace a problem the first month. A quick lookup, when I am the one forgetting.

If the radius is wrong everywhere, it is a token. If the radius is right but only on one card, it is a modifier (`--rounded-lg`).

If focus jumps to a strange place, that is the machine, not the paint. Read about it in [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/).

If a label fails contrast, it is a theme or a mode or a semantic accent.

If the markup looks wrong, that is [anatomy](/en/blog/anatomy-of-a-corex-component/), not design.

If hover-style or open-style attributes flash and then disappear, the patch and the machine are arguing. See `JS.ignore_attributes` in the Two Brains post.

## The point

Design is the only layer that can change while behavior stands still. The right setup makes that change cheap. A token edit propagates everywhere. A modifier switch tunes one instance. A theme swap re-skins the whole app, with contrast guaranteed by a number that was checked before you opened the file.

When tokens are right, utilities behave. When utilities behave, components inherit. When components inherit, modifiers tune. And nothing in `site.css` ever needs to know what `[data-scope="combobox"]` actually means.

---

Once the paint is in place, [server-fed combobox search](/en/blog/nine-thousand-airports-one-hundred-rows/) is the pattern that proves the design language still holds when the data is too big for the browser. [Anatomy](/en/blog/anatomy-of-a-corex-component/) is what you author. [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/) is who owns state at runtime. Design is what users see while all of that runs underneath.
