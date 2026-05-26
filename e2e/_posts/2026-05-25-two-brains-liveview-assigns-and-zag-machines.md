---
title: "Two Brains: LiveView Assigns and Zag Machines"
description: "A LiveView process owns assigns. A Zag machine owns interaction inside the hook. Controlled mode is how you pick who wins."
date: "2026-05-25 12:00:00 +0000"
permalink: /en/blog/two-brains-liveview-assigns-and-zag-machines/
tags:
  - State Machines
  - Zag.js
  - Corex
sitemap:
  priority: 0.7
  changefreq: monthly
---

Every Corex screen has two brains.

The first is familiar: a LiveView **process** with **assigns**. Events land in `handle_event/3`. State changes. LiveView re-renders dynamic parts of HEEx and patches the DOM over the WebSocket.

The second is easy to miss until something flickers: a **Zag.js** state machine inside `phx-hook`. It decides which panel is open, which option is highlighted, where focus goes, and which `aria-*` attributes belong on each `data-part`.

Your HEEx is the skeleton. The machine is the nervous system. [Anatomy](/en/blog/anatomy-of-a-corex-component/) is how much skeleton you build. This post is who owns runtime state, and how to keep them from fighting.

## Three layers, one root

| Layer | Owns |
|-------|------|
| HEEx function component | Structure, `data-scope` / `data-part`, slots, `items={…}`, props on `data-*` |
| LiveView hook | `mounted`, `beforeUpdate`, `updated`, `destroyed`; bridge to the machine |
| `VanillaMachine` | Transitions, keyboard, ARIA; `updateProps` when the server patches |

The hook subscribes once, re-renders parts on each transition, and on `updated` reads fresh props from the patched element. That lifecycle is the subject of [The Vanilla JS Machine That Doesn't Need a Framework](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). Here we stay on the contract between assigns and machine state.

## Uncontrolled: the machine leads

By default, Corex components are **uncontrolled**. You may set `value` for the initial render. After that, the machine keeps open panels and selection in memory. Users interact without a round trip unless you opt in.

That fits local UI: FAQ accordions, disclosure panels, tabs that only matter on this page. Optional `on_value_change` still fires if you want analytics or a light server reaction.

## Controlled: the server leads

When validation, permissions, or cross-widget logic live on the server, use **`controlled`** with **`value={@assign}`** and **`on_value_change`**.

The flow is a loop:

1. User acts inside the widget.
2. Hook `pushEvent`s with the event name from `data-on-value-change`.
3. `handle_event/3` updates the assign.
4. LiveView patches the root; `updated` passes the new value into the machine.

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

Two writers without coordination cause flicker or stuck UI: the assign and the machine both think they own `value`. Pick one authority per piece of state.

## Patches without stepping on the machine

When assigns change, LiveView diffs the DOM and runs `beforeUpdate` / `updated` on hooked roots. Corex marks machine-owned attributes so patches do not wipe `data-state`, `aria-expanded`, and similar fields the hook just wrote. Roots use `JS.ignore_attributes` on `phx-mounted` so server diffs merge with client state instead of fighting it.

If you change `items` or `value` in `handle_event`, expect `updated` to refresh machine props. If only unrelated assigns change, change tracking may skip the combobox subtree entirely. That is Phoenix doing its job.

## Server commands without a click

Sometimes the server must move the UI: theme toggles, closing a dialog from a timer, opening a panel from a banner. **`Phoenix.LiveView.push_event/3`** reaches the hook’s `handleEvent`. Helpers like **`Corex.Accordion.set_value/3`** wrap the same pattern so you do not invent event names per template.

## Combobox: machine behavior, server catalog

Large option lists are still one assign: **`items`**. The machine handles highlight, open state, and keys. The LiveView handles **which rows exist**.

Typical flow:

1. `mount`: `assign(socket, :items, Corex.List.new([...]))`
2. `on_input_value_change`: search the database, assign a bounded list
3. Template: `items={@items}`, **`filter={false}`** when filtering runs on the server

The full pattern is in [Nine Thousand Airports, One Hundred Rows](/en/blog/nine-thousand-airports-one-hundred-rows/). Try it live on [/en/combobox/patterns](/en/combobox/patterns).

## What you do not reimplement in HEEx

Zag already encodes open/closed, roving tabindex, typeahead, collection indexing, and ARIA on each part. Your template supplies structure and data. The hook subscribes and calls `render` after transitions.

If something looks wrong after interaction, ask:

1. Controlled assign out of sync with the machine? Missing `handle_event`?
2. Server change ignored: did `value` or `items` actually get assigned?
3. Attributes flash then revert: patch vs machine `render`; check ignore attributes on the root.
4. Hook never updates: stable **`id`** on the hooked element?

## Mental model

**Anatomy** is the HEEx surface. **State machines** are runtime behavior inside `phx-hook`. **LiveView** owns process state in assigns and events. **Design** ([Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/)) paints `data-part` nodes the machine already maintains.

Keep those roles separate and Corex stays predictable from a FAQ accordion to a server-driven airport search.
