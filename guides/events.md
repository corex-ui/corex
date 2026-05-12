# Events

**Goal:** run your own code when something **happens inside** a Corex component (user opens a panel, changes a value, closes a dialog).

Related: [API](api.html) when you need to **push** a change from a button or script instead.

---

## Example: LiveView hears an accordion change

1. Give the event a **name** you choose (a string).
2. Pass it to the `on_…` attribute on the component.
3. Handle that name in `handle_event/3`.

```heex
<.accordion
  id="faq"
  class="accordion"
  items={@items}
  on_value_change="faq_opened"
/>
```

```elixir
def handle_event("faq_opened", %{"id" => id, "value" => open}, socket) do
  {:noreply, assign(socket, :last_open, {id, open})}
end
```

The keys inside the second argument (`"id"`, `"value"`, …) depend on the component. Copy the shape from the **Events** section of that component’s Hexdocs page.

---

## Example: browser-only reaction (`*_client`)

Sometimes you want to animate or sync `localStorage` **without** sending every movement to the server. Assign attributes that end with `_client` and give your own event name string. The browser fires a `CustomEvent` with that name. Your script listens on `window` or on the element.

```heex
<.accordion
  id="faq"
  class="accordion"
  items={@items}
  on_value_change_client="my-accordion-changed"
/>
```

```javascript
window.addEventListener("my-accordion-changed", (e) => {
  console.log(e.detail)
})
```

The `detail` object is documented per component (often camelCase in JS).

---

## Controlled mode (short version)

When LiveView must **own** the value after each user interaction (forms, validation, server truth), use **`controlled`** on the component and wire **`on_value_change`** (or the close equivalent) so assigns stay in sync. See each component’s **Anatomy** or **Form** examples.

---

## Answers to “read” commands (API)

If you used a helper from [API](api.html) to **read** state, the hook may send the answer back to LiveView, to the DOM, or both, depending on `respond_to`. Event names for those answers are listed under **Events** on the same module page as the helper.

---

## Names you choose vs names Corex defines

- **`on_value_change="faq_opened"`**  -  you picked `faq_opened`. Use any string.
- **`corex:accordion:set-value`**  -  fixed by Corex for DOM commands; use the exact string from docs.
- Response events after `value` / `focused` / similar  -  fixed names on each module (for example accordion value response).

When in doubt, open the component’s Hexdoc and search the **Events** section.
