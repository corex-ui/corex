---
name: corex-events
description: >-
  Load when adding on_value_change, on_value_change_client, on_focus_change,
  on_open_change, handle_event for component interaction, controlled mode with
  value assign, ColocatedHook CustomEvent listeners, phx-update ignore on
  listener wrapper, or component Events doc pages. For Corex.* imperative helpers
  use corex-api skill instead.
---

# Corex events

Subscriptions when users interact — not imperative `Corex.*` pushes (**corex-api**).

## Server event

```heex
<.accordion id="faq" class="accordion" items={items} on_value_change="accordion_value_changed" />
```

```elixir
def handle_event("accordion_value_changed", %{"id" => id, "value" => value}, socket) do
  {:noreply, assign(socket, :open, value)}
end
```

## Controlled

```heex
<.accordion id="faq" controlled value={@open} on_value_change="faq_value_change" class="accordion" items={items} />
```

## Client event

`on_value_change_client="accordion-value-changed"` → `CustomEvent` on component root. Listener wrapper needs `phx-update="ignore"`.

Never invent event names — MCP `get_component` lists them per component.

Full checklist: sub-rule `corex:events`.
