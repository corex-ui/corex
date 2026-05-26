---
name: corex-design
description: >-
  Load when styling with button--accent timer--rounded-xl accordion--sm
  sm:accordion--md responsive modifiers, editing site.css app.css @import
  @source "../corex", data-theme data-mode on html, typo layout on body, or
  when tempted to add custom BEM CSS in templates. Never invent class names.
---

# Corex Design

## Rules

No custom CSS in templates — modifiers only. `.typo layout` on body. Remove daisyUI.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@source "../corex";
```

## Responsive modifiers

```heex
<.accordion class="accordion accordion--accent accordion--sm sm:accordion--md lg:accordion--xl" … />
<.timer class="timer timer--accent timer--text-lg sm:timer--text-xl lg:timer--text-5xl timer--rounded-xl" … />
```

No `class` on `<.heroicon>` inside Corex components.

Full checklist: sub-rule `corex:design`.
