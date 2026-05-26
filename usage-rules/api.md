# Corex component API

Imperative **push** API — socket helpers and JS commands. For **subscriptions** (`on_*_change`), see `corex:events`.

Search: `mix usage_rules.search_docs "set_value" -p corex --query-by title`

## Stable id

Required on every API-driven component:

```heex
<.accordion id="faq" class="accordion" items={…} />
```

## Client — `<.action>` and JS commands

Prefer `<.action>` over raw buttons for Corex Design:

```heex
<.action class="button" phx-click={Corex.Accordion.set_value("faq", ["first"])}>
  Open first panel
</.action>
```

Pattern: `Corex.<Name>.<action>("<id>", …args)`

## Server — socket helpers

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "faq", ["first"])}
end
```

Pattern: `Corex.<Name>.<action>(socket, "<id>", …args)` — socket first.

## Controlled mode

Server owns state. Pair with `on_value_change` — see `corex:events`:

```heex
<.accordion id="faq" controlled value={@open} on_value_change="faq_value_change" class="accordion" items={…} />
```

```elixir
def handle_event("faq_value_change", %{"value" => value}, socket) do
  {:noreply, assign(socket, :open, value)}
end
```

## Async loading

```heex
<.async_result :let={data} assign={@accordion}>
  <:loading><.accordion_skeleton count={3} class="accordion" /></:loading>
  <.accordion id="async" class="accordion" items={data.items} value={data.value} />
</.async_result>
```

Use `assign_async/3` in `mount/3`.

## Toast layout

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading><.heroicon name="hero-arrow-path" /></:loading>
  <:close><.heroicon name="hero-x-mark" /></:close>
</.toast_group>
```

Programmatic: `Corex.Toast.create/5`, `update/3`, `remove/2`, `dismiss/2`.

## Discovery

1. MCP `get_component { id: "<name>" }`
2. Hexdocs `Corex.<Name>` API section
3. `mix usage_rules.search_docs "<name> set_value" -p corex`

Never invent helper names.

## References

- https://hexdocs.pm/corex/manual_installation.html
