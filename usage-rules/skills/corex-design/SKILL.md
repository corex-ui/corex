---
name: corex-design
description: >-
  Load when styling with ui-accent ui-solid ui-size-lg ui-rounded-xl
  modifiers, editing site.css app.css @import @source "../corex",
  data-theme data-mode on html, typo layout on body, or when tempted to
  add custom BEM CSS in templates. Never invent class names.
---

# Corex Design

## Rules

No custom CSS in templates — modifiers only. `.typo layout` on body. Remove daisyUI.

```css
@import "../corex/corex.css";
@source "../corex";
```

## Responsive modifiers

```heex
<.accordion class="accordion ui-accent ui-size-sm sm:ui-size-md lg:ui-size-xl" … />
<.timer class="timer ui-accent ui-size-lg ui-rounded-xl" … />
```

No `class` on `<.heroicon>` inside Corex components.

Full checklist: sub-rule `corex:design`.
