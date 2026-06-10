---
name: corex-design
description: >-
  Load when styling with button--semantic-accent timer--rounded-xl accordion--size-sm
  sm:accordion--size-md responsive modifiers, editing site.css app.css @import
  corex.tailwind.css, data-theme data-mode on html, typo layout on body, or
  when tempted to add custom BEM CSS in templates. Never invent class names.
---

# Corex Design

## Rules

No custom CSS in templates — modifiers only. `.typo layout` on body. Remove daisyUI.

```css
@import "./corex.tailwind.css";
```

Point Tailwind at generated output if needed:

```css
@source "./recipes";
```

## Responsive modifiers

```heex
<.accordion class="accordion accordion--semantic-accent accordion--size-sm sm:accordion--size-md lg:accordion--size-xl" … />
<.timer class="timer timer--semantic-accent timer--text-lg sm:timer--text-xl lg:timer--text-5xl timer--rounded-xl" … />
```

No `class` on `<.heroicon>` inside Corex components.

Full checklist: sub-rule `corex:design`.
