---
title: "Anatomy of a Corex Component"
description: "Corex anatomy is the ladder from one HEEx call to full compound markup. Same Zag machine at every step; only the HTML you author changes."
date: "2026-05-21 12:00:00 +0000"
permalink: /en/blog/anatomy-of-a-corex-component/
tags:
  - Corex
  - Phoenix
  - Anatomy
sitemap:
  priority: 0.9
  changefreq: monthly
---

The first time I wired up a Corex accordion, I typed `<.accordion id="faq" items={@topics} />` and moved on. Keyboard support worked. ARIA was correct. Panels opened and closed without me thinking about `aria-expanded`.

A week later the design asked for a custom icon on every trigger, a different chevron per row, and one panel that was mostly layout, not a plain paragraph. Same component. Same hook. Suddenly I was staring at slots, `:let`, and eventually `compound`.

That gap is what Corex calls **anatomy**: for one component, how much HEEx do you still write yourself? Behavior lives in the Zag machine and the `phx-hook` on the root. Anatomy is only the markup shell the hook attaches to.

If you want the runtime story (controlled mode, assigns, when the server and machine disagree), read [Two Brains: LiveView Assigns and Zag Machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/). If you want hooks and `updateProps`, read [The Vanilla JS Machine That Doesn't Need a Framework](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). This post stays on template shape.

## One machine, many shells

Every Corex interactive component follows the same split:

- **HEEx** renders `data-scope`, `data-part`, slots, and serialized props on `data-*` attributes.
- **The hook** starts a `VanillaMachine`, subscribes to transitions, and keeps the DOM in sync.
- **Your LiveView** supplies data: `items`, `value`, labels, disabled flags.

Change anatomy and you change the HTML tree. You do not change which hook runs or how arrow keys behave. Compare levels side by side on the [accordion anatomy demo](/en/accordion/anatomy), or the same idea on [select](/en/select/anatomy), [tabs](/en/tabs/anatomy), and [checkbox](/en/checkbox/anatomy).

Register hooks once:

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})
```

Import component CSS per widget you render, or pull in Corex Design with `mix corex.design`. Anatomy does not depend on bundled styles.

## The ladder

Moduledocs name five steps. Think of them as cost vs control.

| Level | When to use it |
|-------|----------------|
| **Minimal** | Uniform rows from data; default trigger and panel text is enough |
| **With slots** | Same list, shared chrome on every row (one indicator, tabs `indicator` flag) |
| **Custom slots** | Per-row markup via `:let={item}` and `meta` |
| **Manual slots** | Small fixed set of panels; bodies are not one string per row |
| **Compound** | You need wrappers or a DOM shape slots cannot emit |

Start at the bottom of the ladder. Climb only when the design forces you.

## Minimal: pay once

List-driven accordions and tabs take `items` from `Corex.Content.new/1`. Each map needs `label` and `content`. Optional: `value`, `disabled`, `meta`.

```heex
<.accordion
  class="accordion accordion--accent"
  id="faq"
  items={
    Corex.Content.new([
      %{label: "Shipping", content: "We ship within 3 business days."},
      %{label: "Returns", content: "30-day returns on unused items."}
    ])
  }
/>
```

Build the list in `mount/3` or `handle_event/3`, then pass `items={@topics}`. The component renders triggers and panels; the hook does the rest.

Select and combobox use `Corex.List.new/1` instead (`label` + `value`, optional `group`). Checkbox has no list: one control, region slots only.

## With slots: repeat the chrome

Keep `items` and add a slot every row shares, for example `<:indicator>` on an accordion:

```heex
<.accordion class="accordion" id="faq" items={@topics}>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

Tabs can use the boolean `indicator` attribute for a sliding highlight without a per-tab slot. Open state and keyboard behavior are unchanged.

## Custom slots: `:let` per row

When each row needs different markup, keep `items` and override slots with `:let={item}`. Put per-row extras in `meta`:

```heex
<.accordion class="accordion" id="faq" items={@topics}>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
  <:indicator :let={item}>
    <.heroicon name={item.meta.indicator} />
  </:indicator>
</.accordion>
```

Inside a slot, `item` exposes `label`, `content`, `value`, `disabled`, and `meta`. Override only what differs.

## Manual slots: fixed panels

For three FAQ panels with rich HTML in each body, skip `items`. Declare matching `value` on `:trigger`, `:content`, and optional `:indicator`:

```heex
<.accordion class="accordion" id="faq" value="shipping">
  <:trigger value="shipping">Shipping</:trigger>
  <:content value="shipping">
    <p>We ship within <strong>3 business days</strong>.</p>
  </:content>
  <:trigger value="returns">Returns</:trigger>
  <:content value="returns">
    <p>30-day returns on unused items.</p>
  </:content>
</.accordion>
```

Use manual slots when the list shape fights the layout. Use `items` when you have many uniform rows from the database.

## Compound: own the tree

When slots cannot produce the DOM you need, set `compound` and compose sub-components: `accordion_root`, `accordion_item`, `accordion_trigger`, `accordion_content`, `accordion_indicator`. Pass `ctx` from `:let={ctx}` on the parent.

Try `items` and slots first. Compound is the escape hatch for marketing blocks and odd wrappers between items. The [accordion anatomy demo](/en/accordion/anatomy) shows compound beside minimal so you can compare HTML size before committing.

## Select anatomy in one line

`<.select>` uses `Corex.List.new/1` for options, not `label` + `content`. Group with `group` on each map. Custom rows use `<:item :let={item}>`. Placeholder via `translation={%Corex.Select.Translation{placeholder: "Choose…"}}`. Same ladder, different slot names.

## What anatomy is not

Anatomy is first-render template shape. It does not cover:

- Controlled `value` and `on_value_change` ([state machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/))
- Server-fed combobox search with `filter={false}` ([combobox scale](/en/blog/nine-thousand-airports-one-hundred-rows/))
- Tokens and modifiers on `data-part` ([Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/))

Those layers sit on the same tree. Get anatomy right and the hook has something reliable to enhance.

## Open a panel from elsewhere

To open a panel from another control, keep the same `items` in the template and call the API:

```elixir
def handle_event("open-faq", _params, socket) do
  Corex.Accordion.set_value(socket, "faq", "shipping")
  {:noreply, socket}
end
```

The `id` on `<.accordion id="faq" …>` must match the first argument to `set_value/3`.

---

Pick the lightest anatomy that matches your data and markup. The machine does not care whether you chose minimal or compound. Your future self cares how much HEEx you maintain.

Next in the series: [state machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/) for assigns and controlled mode, then [vanilla JS](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) for the hook bridge, [design](/en/blog/paint-the-parts-the-machine-already-owns/) for how it looks, and [combobox scale](/en/blog/nine-thousand-airports-one-hundred-rows/) when the server owns the option list.
