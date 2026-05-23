# Corex events

**Events** = subscribe to user interaction via `on_*_change` attrs.

**API** (`corex:api`) = imperative commands (`Corex.Accordion.set_value/3`, `<.action phx-click={…}>`).

Event names and payloads differ per component. Always read Hexdocs **Events** section or MCP `get_component` — never invent attrs.

## Server events (LiveView)

Attr value is the `handle_event` name:

```heex
<.accordion
  id="faq"
  class="accordion"
  items={items}
  on_value_change="accordion_value_changed"
/>
```

```elixir
def handle_event("accordion_value_changed", %{"id" => id, "value" => value}, socket) do
  {:noreply, assign(socket, :open, value)}
end
```

Common pattern: `on_focus_change`, `on_select`, `on_open_change` — names vary by component.

## Client events (browser)

Fires a `CustomEvent` on the component root:

```heex
<.accordion
  id="demo"
  class="accordion"
  items={items}
  on_value_change_client="accordion-value-changed"
/>
```

Listen with a ColocatedHook on a wrapper with **`phx-update="ignore"`**:

```heex
<div id="demo-listener" phx-hook=".DemoListener" phx-update="ignore">
  <script :type={Phoenix.LiveView.ColocatedHook} name=".DemoListener">
    export default {
      mounted() {
        const el = document.getElementById("demo")
        el?.addEventListener("accordion-value-changed", (event) => {
          const d = event.detail
          this.pushEvent("accordion_client_changed", { id: d.id, value: d.value })
        })
      }
    }
  </script>
</div>
```

Use client events for Motion/JS animations (`animation="custom"`), analytics, or bridging to LiveView without a full round trip on every keystroke.

## Controlled vs uncontrolled

| Mode | Who owns UI state | Events |
|------|-------------------|--------|
| **Uncontrolled** (default) | Zag machine in hook | Optional `on_value_change` for side effects |
| **Controlled** | LiveView assign | Required `controlled` + `value` + `on_value_change` |

```heex
<.accordion
  id="faq"
  controlled
  value={@open}
  on_value_change="faq_value_change"
  class="accordion"
  items={items}
/>
```

Pick one authority — do not fight the machine with unmanaged assign updates.

## Rules

- Never invent event attr names — MCP `get_component` lists them
- Client listener parent needs `phx-update="ignore"` or listeners duplicate on re-render
- Events **notify**; **navigation** `redirect` attr **navigates** — different concerns
- For imperative server pushes without user click, use `Corex.*` socket helpers (`corex:api`)

## References

- https://hexdocs.pm/corex — per-component Events sections
- e2e: `AccordionEventsLive`, component **Events** doc pages
