# Corex components

## MCP-first workflow

1. `list_components` — valid ids
2. `get_component { id: "<id>" }` — attrs, slots, events, docs, hook name

Never guess. Fallback: `mix usage_rules.search_docs "<id>" -p corex`.

## Wiring checklist

| Step | File | Action |
|------|------|--------|
| CSS | `assets/css/app.css` | `@import "../corex/corex.css"` (trim via `components:` / themes in `config :corex_design`) |
| Hook | `assets/js/app.js` | Register if component uses `phx-hook` |
| HEEx | `lib/*_web/` | `<.<id> id="stable-id" class="<id> …">` |

## Data builders

| Builder | Use for |
|---------|---------|
| `Corex.Content.new/1` | accordion, tabs, data-list |
| `Corex.List.new/1` | select, combobox, listbox, menu |
| `Corex.Tree.new/1` | tree-view |
| `Corex.Image.new/2` | carousel |

```heex
items={Corex.List.new([
  %{label: "France", value: "fra"},
  %{label: "Belgium", value: "bel", disabled: true}
])}
```

## Content.new + compound slots

List-driven:

```heex
<.accordion id="faq" class="accordion" items={Corex.Content.new([…])} />
```

Custom slots with `meta:`:

```heex
<.accordion
  id="faq"
  class="accordion ui-accent ui-size-sm sm:ui-size-md lg:ui-size-xl"
  items={
    Corex.Content.new([
      %{value: "q1", label: "Question?", content: "Answer.", meta: %{icon: "hero-chat-bubble-left-right"}}
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
  <:content :let={item}><p>{item.content}</p></:content>
  <:indicator><.heroicon name="hero-chevron-right" /></:indicator>
</.accordion>
```

## Hooks

Register keys matching `phx-hook` on the component — **PascalCase** (`Accordion`, `Select`, `Dialog`). Verify hook name from MCP `get_component`.

## Anatomy

```html
<div data-scope="accordion" data-part="root">…</div>
```

Target these only in Corex component CSS — never in template CSS.

## use Corex scoping

```elixir
use Corex
use Corex, only: [:accordion, :dialog], prefix: "ui"
```

## Common mistakes

- Missing stable `id`
- Wrong hook case (`dialog` vs `Dialog`)
- Guessing slots/events instead of MCP
- Hand-rolling markup without checking `list_components`

## References

- https://hexdocs.pm/corex/mcp.html
