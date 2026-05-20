---
title: "Corex and State Machines"
description: "How Zag.js machines drive Corex components, how LiveView assigns and DOM patching interact with controlled mode, and why the HEEx shell stays thin."
date: "2026-05-25 12:00:00 +0000"
permalink: /en/blog/state-machines/
tags:
  - State Machines
  - Zag.js
  - Corex
sitemap:
  priority: 0.7
  changefreq: monthly
---

A LiveView is a **process** that receives events, updates its state, and renders updates to the page as **diffs**. State lives in the **socket** under **`assigns`**. The programming model is declarative: events may change state; once state changes, LiveView re-renders the relevant parts of its HEEx template and pushes the result to the browser. See [Welcome to Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/welcome.html).

Corex adds a second state layer on the client: a **Zag.js** state machine inside each **`phx-hook`**. The HEEx you write is still a [function component](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) shell. The machine is the brain that decides open panels, selected options, and focus.

## Three layers

| Layer | Responsibility |
|-------|----------------|
| **HEEx / function component** | Static structure, `data-scope` / `data-part`, slots, `items={…}`, serializing props to `data-*` |
| **LiveView hook** | `mounted`, `beforeUpdate`, `updated`, `destroyed`; bridge between DOM and machine |
| **Zag `VanillaMachine`** | State, transitions, ARIA; `subscribe` → `render` → `spreadProps` on parts |

**Anatomy** is how much HEEx you write per call (items, slots, compound). **Runtime state** is what the machine and, in controlled mode, your LiveView **assigns** own.

## Assigns, HEEx, and change tracking

All data in a LiveView is stored in the socket. In templates you read **`@name`** instead of `socket.assigns.name`. When you first render a template, LiveView sends static and dynamic parts to the client. On later renders it only re-sends **dynamic** parts when the underlying **assign** changed.

From [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html):

> The tracking of changes is done via assigns. If the `@title` assign changes, then LiveView will execute the dynamic parts of the template … If `@title` is the same, nothing is executed and nothing is sent.

**Data loading should never happen inside the template.** Assign lists in `mount/3` or `handle_event/3`, then pass them as attrs:

```elixir
assign(socket, :topics, Corex.List.new([...]))
```

```heex
<.accordion id="faq" items={@topics} />
```

The same guide warns against local variables in HEEx that break change tracking. Prefer **`assign/2`**, **`assign/3`**, **`update/3`**, and **`assign_new/3`** in LiveViews and function components. Corex components follow that: computed props go through **`assign`** in `accordion/1`, not bare `Map.put/3` on `assigns` inside the template.

### Pitfall: passing all assigns

Passing **`{assigns}`** into child function components disables fine-grained change tracking and re-renders children on every parent change. Prefer explicit attrs (`items={@topics}`, `value={@open}`) as in the [assigns guide](https://hexdocs.pm/phoenix_live_view/assigns-eex.html#the-assigns-variable).

## Bindings and Corex event attrs

[Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) connect DOM events to the server. For example:

```heex
<button phx-click="inc_temperature">+</button>
```

```elixir
def handle_event("inc_temperature", _params, socket) do
  {:noreply, update(socket, :temperature, &(&1 + 1))}
end
```

Corex roots do not require you to wire `phx-click` on every internal part. Instead, attrs such as **`on_value_change`** serialize to **`data-on-value-change`**. The hook listens to the machine and **`pushEvent`** with that name. Your LiveView still implements **`handle_event/3`** and returns **`{:noreply, socket}`**.

| Phoenix binding | Corex analogue |
|-----------------|----------------|
| `phx-click="event"` | `on_*` attrs → `data-on-*` → hook `pushEvent` |
| `phx-value-*` | Payload built by machine + hook |
| `handle_event/3` | Same callback; update assigns |
| `{:noreply, socket}` | Re-render; patch DOM; hook **`updated`** |

For forms, LiveView documents **`phx-change`**, **`phx-submit`**, debounce, and throttle. Corex inputs (combobox, select, native-input) follow the same **server assign** pattern: the template reflects `@value` or `@items`; events update assigns; the next diff updates `data-*` on the root.

## First render, then the persistent connection

Every LiveView is first rendered as part of a regular **HTTP request** (fast first paint, SEO-friendly HTML). Then **`liveSocket.connect()`** establishes the WebSocket; **`mount/3`** runs in the LiveView process and the client hook’s **`mounted`** runs on the root element.

Corex ships **static HTML** in that first response: correct `data-scope`, `data-part`, and initial `data-*` props. After connect, the machine enhances behavior without replacing the whole page.

## Controlled vs uncontrolled

**Uncontrolled** (default): the machine keeps value in memory. HEEx may set **`value`** for the initial render only (`data-default-value` on the wire). User interaction does not require a LiveView round-trip unless you opt into server callbacks.

**Controlled**: you set **`controlled`** and **`value={@assign}`**. The machine treats the server as source of truth. On each user change the hook **`pushEvent`**; **`handle_event`** updates the assign; LiveView patches the root; **`updated`** passes the new value into **`machine.api.setValue`**.

Two writers without coordination cause flicker or “stuck” UI:

1. LiveView assigns (`value`, `items`, …)
2. Zag state after local interaction

Pick one authority for each piece of state. Use **controlled** when validation, permissions, or cross-component logic live on the server. Use **uncontrolled** for local UI (accordion FAQ, disclosure panels) with optional **`on_value_change`** for analytics.

Example controlled accordion:

```elixir
def handle_event("faq_value_change", %{"value" => value}, socket) do
  {:noreply, assign(socket, :open, Corex.Accordion.validate_value!(value))}
end
```

```heex
<.accordion
  id="faq"
  controlled
  value={@open}
  on_value_change="faq_value_change"
  items={@topics}
/>
```

## DOM patching and the hook

When assigns change, LiveView computes a diff and patches the DOM. For elements with **`phx-hook`**, **`beforeUpdate`** and **`updated`** run around that patch.

Corex marks machine-owned attributes with **`JS.ignore_attributes`** on **`phx-mounted`** so LiveView does not overwrite `data-state`, `aria-expanded`, and similar fields the hook just wrote. That matches the [bindings guide](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching): **`ignore`** skips wholesale inner updates; **data attribute** changes can still merge through to the hook.

If you change **`items`** or **`value`** in `handle_event`, expect **`updated`** to refresh machine props. If you only change unrelated assigns, the accordion subtree may not re-execute dynamic template parts, which is exactly what change tracking optimizes.

## Server → client: `push_event`

Sometimes the server must command the UI without a user click, for example theme toggles or programmatic **`set_value`**. Use **`Phoenix.LiveView.push_event/3`** from a LiveView or LiveComponent. The client receives **`phx:event-name`**; the hook’s **`handleEvent`** calls the machine API.

Helpers like **`Corex.Accordion.set_value/2`** wrap that pattern so you do not duplicate event names in every template.

## Form bindings and Corex inputs

LiveView form bindings ([form bindings guide](https://hexdocs.pm/phoenix_live_view/form-bindings.md)) use **`phx-change`** and **`phx-submit`** on a `<form>` or inputs. Corex **`native-input`**, **`combobox`**, and **`select`** still participate in forms: hidden or visible values update through **`controlled`** + **`value`** + **`on_value_change`**, or through standard **`name`** attrs where the component exposes them.

The split remains: **form events** update assigns and changesets on the server; **machines** keep listbox and field behavior consistent on the client. For a combobox inside **`to_form`**, treat **`on_value_change`** like any other event that must **`assign`** the selected value before the next render.

## Streams vs list assigns

For very long **static** lists rendered with **`phx-update="stream"`**, LiveView can append and patch rows without holding the full collection in memory on the server. Corex **`data_table`** integrates streams on tbody rows. Interactive widgets like accordion and combobox instead take **`items={Corex.List.new(...)}`** as a single assign the hook serializes to the root. Scale comboboxes by **bounding `items` per query**, not by streaming nine thousand DOM nodes into one listbox.

## Combobox: server-fed `items`

Large lists belong in **assigns**, not in the HEEx template as ad-hoc queries. A typical flow:

1. **`mount`**: `assign(socket, :items, Corex.List.new([...]))`
2. **`on_input_value_change`**: `handle_event` filters or loads rows, `assign(socket, :items, new_list)`
3. Template: `items={@items}`, optionally **`filter={false}`** when filtering runs on the server

The machine handles keyboard navigation and selection; the LiveView owns **which rows exist**. That separation scales to thousands of rows without shipping the full dataset on every keystroke in the template itself.

## LiveComponent and targeted events

**`Phoenix.LiveComponent`** runs in the same BEAM process as the parent LiveView but has its own **`handle_event/3`**. Corex attrs on a component template behave the same: **`on_value_change`** events hit the component callback when the hooked root is rendered there.

If you build custom hooks alongside Corex, **`pushEventTo(selectorOrTarget, event, payload)`** from the [js-interop guide](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook) can target a specific LiveView or LiveComponent. Corex hooks use **`pushEvent`** with names you declare on **`data-on-*`** attrs instead.

For shared event logic across LiveViews, Phoenix documents **`Phoenix.LiveView.attach_hook/4`** to reuse **`handle_event`** clauses without duplicating modules. That is orthogonal to Zag: hooks attach to LiveView callbacks; **`phx-hook`** attaches to DOM nodes.

## What you do not reimplement in HEEx

Zag already encodes:

- Open/closed, expanded/collapsed, checked/unchecked
- Roving tabindex and arrow keys
- Typeahead and collection indexing
- ARIA roles and properties on each **`data-part`**

Your HEEx supplies **structure** and **data**. The hook subscribes once:

```typescript
this.accordion = new Accordion(this.el, { props: this.getProps(), name: "Accordion" })
this.accordion.machine.subscribe(() => {
  this.accordion.render()
})
this.accordion.init()
```

After **`init`**, treat the machine as authoritative for interaction inside the root unless you are in **controlled** mode.

## Mental model for debugging

1. **Wrong or stale UI after interaction**: controlled assign out of sync with machine? Missing **`handle_event`**?
2. **Server change ignored**: is `value` / `items` actually assigned? Did change tracking skip the dynamic part you expected?
3. **Attributes flash then revert**: conflict between LiveView patch and machine `render`; check **`ignore_attributes`** on the root and parts.
4. **Hook never updates**: missing unique **`id`** on `phx-hook` element? Hook used outside LiveView without connect?

Read [Client hooks](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook) for **`pushEvent`** and **`handleEvent`**. Read [Assigns and HEEx](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) for what re-renders. Read [Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) for server events.

## JS commands on mount

LiveView **`Phoenix.LiveView.JS`** commands run on the client when bindings fire. Corex uses them on **`phx-mounted`** so the first patch does not strip loading or machine attributes. For example accordion roots use **`JS.ignore_attributes(["data-loading"])`** and **`Connect.ignore_root/1`** so **`data-state`** on parts survives server diffs.

That is the same idea as [JS commands](https://hexdocs.pm/phoenix_live_view/bindings.html#js-commands) in the bindings guide: compose client effects without a round trip. Corex hides most of that inside **`Connect`**; you opt into **`animation="js"`** when height transitions need coordinated JS.

## Compartmentalization summary

Phoenix recommends three levels ([Welcome](https://hexdocs.pm/phoenix_live_view/welcome.html)):

| Mechanism | Use when |
|-----------|----------|
| **Function components** (`<.accordion>`) | Reuse markup; Corex is this layer |
| **LiveComponent** | Extra state + events in the same process |
| **Nested LiveView** | Hard isolation and crash boundaries |

Corex targets function components first. Reach for LiveComponent when a combobox or accordion is a reusable island with its own **`handle_event`** clauses. Reach for nested LiveView only when failure domains require separate processes.

## Series order

1. **State machines** (this post): assigns, bindings, controlled mode  
2. **[Vanilla JS](/en/blog/vanilla-js/)**: `LiveSocket`, hook lifecycle, `push_event`  
3. **[Anatomy](/en/blog/anatomy-of-a-corex-component/)**: how much HEEx you write  
4. **[Design](/en/blog/corex-design-a11y/)**: CSS on `data-part` trees  
5. **[Combobox scale](/en/blog/combobox-thousands-of-items/)**: server-fed **`items`**

---

**Anatomy** is the HEEx and function-component surface. **State machines** are runtime behavior inside **`phx-hook`**. **LiveView** owns process state in **assigns**, **bindings** (or Corex `on_*` attrs), and **DOM diffs**. Keep those roles separate and Corex stays predictable from FAQ accordions to server-driven comboboxes.

When in doubt, read the official guides in that order: [Welcome](https://hexdocs.pm/phoenix_live_view/welcome.html) for the process model, [Assigns and HEEx](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) for templates, [Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) for events, [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html) for hooks, and [`Phoenix.Component`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) for function components. Corex is a thin, typed layer on top of those primitives.
