---
name: corex-api
description: >-
  Load when using Corex.Accordion.set_value, Corex.Dialog.open, phx-click with
  Corex.* JS commands, socket helpers Corex.*(socket, id, …), controlled mode
  with value assign, assign_async with accordion_skeleton, toast_group flash,
  or mix usage_rules.search_docs set_value -p corex. For on_*_change subscriptions
  use corex-events skill instead.
---

# Corex API

Imperative push API — not event subscriptions (`on_*_change` → **corex-events**).

## Client — `<.action>`

```heex
<.action class="button" phx-click={Corex.Accordion.set_value("faq", ["first"])}>
  Open first
</.action>
```

## Server — socket helper

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "faq", ["first"])}
end
```

## Controlled mode

Pair `controlled`, `value`, and `on_value_change`:

```heex
<.accordion id="faq" controlled value={@open} on_value_change="faq_value_change" class="accordion" items={…} />
```

## Discovery

MCP `get_component { id: "<name>" }` → API section, or `mix usage_rules.search_docs "set_value" -p corex`.

Full checklist: sub-rule `corex:api`.
