# API

**Goal:** change a Corex component from code (open a dialog, set a slider, expand an accordion) instead of only waiting for clicks inside the component.

Related: [Events](events.html) when you need to **listen** for user-driven changes.

Imperative helpers and **`corex:*` `CustomEvent`s** target one mounted instance via the **`id`** on that component's DOM root. Elixir arity-`…/2` helpers and **`document.getElementById/1`** must use the same **`id`**. Omitting **`id`** leaves nothing for the client hook to address.

---

## Three ways to send the same command

Each component documents exact names; the pattern is always the same.

**Server API.** In LiveView, call the `…/3` (or higher) function that takes **`socket`** first, then the component **`id`**, then arguments. Return `{:noreply, …}` from `handle_event`, or use the socket wherever it is already in scope.

**Client Binding API.** In HEEx, pass the **`…/2`** helper (no `socket`) into **`phx-click`** or another LiveView binding. LiveView forwards that to the hook on the client.

**Client JS API.** In JavaScript, call **`dispatchEvent`** on the DOM node with your **`id`**, passing a **`CustomEvent`**. The event type is always a **`corex:…`** string and the payload **`detail`** is spelled out on that component's Hexdocs page.

---

## Finding the right helper and event name

- **Elixir:** browse [`Corex.Accordion`](Corex.Accordion.html), [`Corex.Dialog`](Corex.Dialog.html), [`Corex.AngleSlider`](Corex.AngleSlider.html), and so on. Each module has an **API** section with tables.
- **JavaScript:** the DOM event type always looks like `corex:…` on that component's page.

---

## Reading state back (`respond_to`)

Some helpers **read** the current state (for example which accordion panels are open). They ask the hook in the browser, then deliver the answer in one or two places. The option is always **`respond_to:`**

- **`:server`** (default)  -  LiveView receives **`pushEvent`** with a fixed event name.
- **`:client`**  -  the hook root dispatches a DOM event you listen for in JavaScript.
- **`:both`**  -  LiveView and the DOM both get an answer.

Names and payload shapes differ by component. Below uses **[`Corex.Accordion`](Corex.Accordion.html)** and **`value/2`** so you have a full copy-paste story.

### Answer in LiveView only (`:server`)

**Client Binding API** (button in the template):

```heex
<.accordion id="faq" class="accordion" items={@items} />
<.action phx-click={Corex.Accordion.value("faq")}>Read open panels</.action>
```

**`handle_event`** (name and string keys are fixed for this component):

```elixir
def handle_event("accordion_value_response", %{"id" => id, "value" => open}, socket) do
  {:noreply, assign(socket, :faq_open, {id, open})}
end
```

`open` is a list of string panel ids (or `null` in edge cases; see the Accordion module doc).

**Server API** (same response, no button: you already have `socket`):

```elixir
def handle_event("read_faq", _params, socket) do
  {:noreply, Corex.Accordion.value(socket, "faq")}
end
```

### Answer in the browser only (`:client`)

Still use the helper on **`phx-click`**, but pass **`respond_to: :client`**. No LiveView **`handle_event`** is required for the answer; handle it in JS.

```heex
<.accordion id="faq" class="accordion" items={@items} />
<.action phx-click={Corex.Accordion.value("faq", respond_to: :client)}>
  Read open panels (browser only)
</.action>
```

```javascript
const root = document.getElementById("faq")
root?.addEventListener("accordion-value", (event) => {
  const { id, value } = event.detail
  console.log(id, value)
})
```

Register the listener once (for example in your app hook or a small `phx:mounted` script) so it is ready before the user clicks.

### Answer in LiveView and the browser (`:both`)

```heex
<.action phx-click={Corex.Accordion.value("faq", respond_to: :both)}>
  Read open panels (server + browser)
</.action>
```

Implement **`handle_event("accordion_value_response", ...)`** as in the LiveView-only example **and** keep an **`accordion-value`** listener if you still want **`event.detail`** in JavaScript on the same click.

### Other components

[`Corex.AngleSlider`](Corex.AngleSlider.html), [`Corex.Dialog`](Corex.Dialog.html), and others follow the same **`:server` / `:client` / `:both`** idea. Open that module's **API** table for the helper name, then its **Events** section for the LiveView event name and DOM event name.
