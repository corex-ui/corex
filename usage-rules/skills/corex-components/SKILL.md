---
name: corex-components
description: >-
  Load when adding Corex HEEx in lib/*_web/, registering phx-hooks in app.js,
  importing assets/corex/components/*.css, Corex.Content.new Corex.List.new
  Corex.Tree.new Corex.Image.new, compound slots with meta: and :let={item},
  or accordion combobox dialog timer select tabs. Call MCP list_components and
  get_component before guessing attrs or slots.
---

# Corex components

## MCP-first

1. `list_components` → 2. `get_component { id: "<id>" }`

## Data builders

| Builder | Components |
|---------|------------|
| `Corex.Content.new/1` | accordion, tabs |
| `Corex.List.new/1` | select, combobox, menu |
| `Corex.Tree.new/1` | tree-view |
| `Corex.Image.new/2` | carousel |

## Compound slots

```heex
<.accordion id="faq" class="accordion ui-accent ui-size-sm sm:ui-size-md" items={Corex.Content.new([…])}>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
</.accordion>
```

Hooks: **PascalCase** (`Accordion`, `Dialog`). Stable `id` required.

Full checklist: sub-rule `corex:components`.
