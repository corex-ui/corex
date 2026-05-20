---
title: "Corex with Vanilla JS"
description: "Register Corex hooks from npm on any Phoenix LiveView app, or use the same machines outside Phoenix."
date: "2026-05-24 12:00:00 +0000"
permalink: /en/blog/vanilla-js/
tags:
  - JavaScript
  - Corex
  - Node.js
sitemap:
  priority: 0.7
  changefreq: monthly
---

Phoenix LiveView enables rich, real-time experiences with server-rendered HTML. Client/server interaction goes through a **`LiveSocket`**: a persistent connection after the first HTTP render, with updates sent as DOM diffs rather than full page reloads. See the [Welcome](https://hexdocs.pm/phoenix_live_view/welcome.html) guide for that model.

Corex sits in the **JavaScript interoperability** layer: the same **client hooks** described in [Client hooks via `phx-hook`](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook), backed by Zag.js state machines. Phoenix supplies the markup and serialized props. The hook supplies behavior.

## LiveSocket and the `hooks` option

To enable LiveView client/server interaction, you instantiate a `LiveSocket`. A typical Phoenix 1.8 `app.js` looks like this:

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }
})
liveSocket.connect()
```

LiveView-specific options include **`hooks`**: a reference to a user-defined hooks namespace containing client callbacks for server/client interop. Corex registers there:

```javascript
import corex from "corex"

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...corex }
})

liveSocket.connect()
```

Spreading **`...corex`** maps every export (`Accordion`, `Combobox`, `Select`, `Dialog`, …) into that namespace. The string on **`phx-hook`** must match the export name exactly.

For a page with one control, import a single hook module:

```javascript
const { Accordion } = await import("corex/hooks/accordion")

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { Accordion }
})
```

Keep the **corex** npm package version aligned with the Hex **corex** release. The Elixir side serializes attrs to `data-*` on the root; the hook reads that shape on `mounted` and `updated`.

## Client hooks via `phx-hook`

From the [JavaScript interoperability guide](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook):

> To handle custom client-side JavaScript when an element is added, updated, or removed by the server, a hook object may be provided via `phx-hook`.

Corex components render a root element similar to:

```heex
<div
  id={@id}
  phx-hook="Accordion"
  data-loading
  {Connect.props(...)}
>
```

When using **`phx-hook`**, a **unique DOM `id` must always be set**. LiveView uses it to find the hook instance across patches.

### Lifecycle callbacks

`phx-hook` must point to an object with these callbacks (Corex implements all of them on interactive components):

| Callback | When it runs |
|----------|----------------|
| **`mounted`** | The element has been added to the DOM and its server LiveView has finished mounting |
| **`beforeUpdate`** | The element is about to be updated in the DOM (synchronous; cannot be deferred) |
| **`updated`** | The element has been updated in the DOM by the server |
| **`destroyed`** | The element has been removed from the page |
| **`disconnected`** | The parent LiveView disconnected from the server |
| **`reconnected`** | The parent LiveView reconnected |

Inside each callback, hooks have access to:

- **`this.el`**: the bound DOM node
- **`this.liveSocket`**: the `LiveSocket` instance
- **`this.pushEvent(event, payload)`**: push an event from the client to the LiveView, like a `phx-click` binding
- **`this.pushEventTo(selectorOrTarget, event, payload)`**: target a specific LiveView or LiveComponent
- **`this.handleEvent(event, callback)`**: handle events pushed from the server

Corex wires server attrs such as `on_value_change` to **`pushEvent`**, and server **`push_event`** / `handle_event` on the hook to machine APIs.

### Hooks outside a LiveView

The LiveView docs note: when using hooks **outside** the context of a LiveView, **`mounted` is the only callback invoked**, and only elements on the page at DOM ready are tracked. For dynamic add/remove/update of hooked nodes, you need a LiveView (or a minimal `LiveSocket` connection) so **`updated`** and **`destroyed`** run when the server patches the tree.

That is why static FAQ pages still load `phoenix_live_view` and call `liveSocket.connect()` even when most of the page is plain HTML.

## What happens in `mounted`

On **`mounted`**, a Corex hook:

1. Reads **`data-*` props** from `this.el` (open state, controlled mode, event names, collection metadata).
2. Constructs the TypeScript wrapper (`new Accordion(this.el, { … })`).
3. Starts the Zag **`VanillaMachine`** and subscribes so each transition re-renders ARIA and `data-state` onto `[data-part="…"]` nodes.
4. Registers **`handleEvent`** listeners for server-pushed events and internal DOM events.

Until **`mounted`** completes, the root is mostly static HTML plus `data-loading`. After it, the machine is the brain; **`render`** keeps the DOM in sync with state.

## What happens in `updated`

LiveView declaratively re-renders when **assigns** change, then pushes a DOM patch. For hooked roots, **`updated`** runs after the server changes the element.

Corex reads fresh serialization from the root (`data-value`, `data-controlled`, disabled flags, layout attrs) and calls **`updateProps`** on the machine. In **controlled** mode, the server `value` assign must match what the hook passes into the machine, or the UI will disagree after the next patch.

This is the client half of [change tracking](https://hexdocs.pm/phoenix_live_view/assigns-eex.html): LiveView only re-sends template **dynamic** parts when assigns change. The hook reacts to what landed on the root as `data-*`, not to `@assigns` directly.

## What happens in `destroyed`

When the element is removed, the hook tears down listeners and calls **`machine.stop()`**. No duplicate machines if LiveView remounts the same `id` later.

## DOM patching and attributes the machine owns

LiveView [DOM patching](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching) can use `phx-update` with values such as `replace`, `stream`, or **`ignore`**. Containers with **`ignore`** skip replacing inner DOM so client libraries (or hooks) can own subtrees.

Corex uses **`phx-mounted`** with `Phoenix.LiveView.JS.ignore_attributes/1` so LiveView does not clobber machine-written attributes (`data-state`, `aria-*`, focus metadata) on each patch. Item-level **`JS.ignore_attributes`** on accordion parts play the same role for triggers and panels.

In other words: **LiveView patches the shell; the hook and machine refresh behavior inside it.**

## Handling server-pushed events

When the server uses **`Phoenix.LiveView.push_event/3`**, the event is dispatched in the browser with the **`phx:`** prefix. For example `push_event(socket, "corex:set-theme", %{theme: "neo"})` becomes a `phx:corex:set-theme` event.

Hook **`handleEvent`** can listen and call into the Zag API (`setValue`, etc.). Corex helpers such as **`Corex.Accordion.set_value/2`** use the same path from Elixir without reimplementing keyboard logic in HEEx.

Events pushed from the server are **global** on `window`. If you need to target one component, include an **`id`** in the payload and filter in the listener, as shown in the [js-interop guide](https://hexdocs.pm/phoenix_live_view/js-interop.html#handling-server-pushed-events).

## Bindings vs Corex event attrs

[Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) attach behavior to DOM nodes: `phx-click`, `phx-change`, `phx-submit`, and others. On the server, bindings are handled in **`handle_event/3`**, which returns **`{:noreply, socket}`** to re-render without a full reload.

Corex interactive components use parallel **data attributes** on the root, for example `data-on-value-change`, which the hook turns into **`pushEvent`** when the machine fires `onValueChange`. Same split of responsibilities:

- **Bindings / Corex server attrs** → LiveView process, assigns, `handle_event`
- **Hook + machine** → focus, open state, ARIA, keys inside the widget

You can combine both on one page: `phx-click` on a plain button, `phx-hook="Accordion"` on a Corex root.

## Colocated hooks vs the Corex bundle

Phoenix 1.8 supports [**colocated hooks**](https://hexdocs.pm/phoenix_live_view/js-interop.html#colocated-hooks-colocated-javascript) via `Phoenix.LiveView.ColocatedHook` next to function components. Corex instead ships a single **`corex`** npm package that mirrors `mix corex.install`: one import, all machines. Choose colocated hooks for app-specific DOM tweaks; choose Corex hooks for shared accessible components.

## Debugging

The `LiveSocket` exposes **`enableDebug()`** and **`disableDebug()`** to log life-cycle and payload events between client and server. Exposing `window.liveSocket = liveSocket` in development makes it easy to turn on from the browser console, as described in the [js-interop guide](https://hexdocs.pm/phoenix_live_view/js-interop.html#debugging-client-events).

## Static markup checklist

For non-LiveView HTML, mirror the moduledoc **Anatomy** tree:

- Root `id` and `phx-hook="ComponentName"`
- `data-scope` and `data-part` on each node the machine expects
- Initial `data-*` props if you need specific starting state

Server-driven combobox search still requires something to assign new **`items`** on each input change. That is **`handle_event`** on a LiveView, not something hooks invent on their own.

---

Corex on npm is **JavaScript interoperability** for Corex: the same **`phx-hook`** modules Phoenix uses, running the same Zag machines. **`LiveSocket`** connects the page; **`mounted`**, **`updated`**, and **`destroyed`** connect each component root to runtime behavior. Understand that pipeline and you can use Corex on LiveView pages, hybrid pages, or static HTML with a minimal socket.
