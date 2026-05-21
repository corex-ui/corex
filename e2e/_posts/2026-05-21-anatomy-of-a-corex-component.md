---
title: "Anatomy of a Corex component"
description: "Corex adds interactive Phoenix components with a fixed HTML shape and client hooks. Anatomy is how much HEEx you write for that shape; behavior lives in the hook."
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

You use Corex inside a normal Phoenix app. Its pieces are [function components](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html): the same `<.accordion />` style calls you already write in HEEx. They help with interactive controls. Accordions, selects, and checkboxes are tedious to build by hand. Keys, focus, accessibility, and open/closed state are where mistakes pile up. Corex ships that behavior so you do not reinvent it on every screen.

This post is about one choice only. For the same component, how much HEEx do you still write yourself? That choice is what we call **Anatomy**. How the component behaves on the client is a separate topic: [state machines](/en/blog/state-machines/). How it looks is separate too: [Corex Design](/en/blog/corex-design-a11y/).

If you already use LiveView, the data flow stays familiar. The LiveView holds **assigns**. Function components turn those assigns into HTML. The browser updates when the server sends a patch. The [Phoenix guides](https://hexdocs.pm/phoenix/overview.html) cover routing, controllers, and LiveView in full. We will not repeat that here. You still call Corex from HEEx, for example `<.accordion id="faq" items={@topics} />`, with `@topics` set in `mount/3` or `handle_event/3`. What Corex adds is a predictable HTML shape and a **client hook** on the root for the hard interaction work.

That hook is standard Phoenix. See [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html). You pass a **`hooks`** map into **`LiveSocket`**. You mark the root with **`phx-hook`** and a unique **`id`**. LiveView calls **`mounted`**, **`updated`**, and the other lifecycle callbacks when the DOM changes. Corex provides those hooks. Inside them, a **Zag.js** state machine drives open panels, focus, and keyboard moves. Your HEEx supplies attrs, slots, `items`, and classes. The hook and machine handle what happens after render.

**Anatomy** is only the HEEx half. Moduledocs use the same names on every component. **Minimal** is one call plus a list. **With slots** repeats one slot on every row. **Custom slots** use `:let` when each row looks different. **Manual Slots** and **compound** are for layouts that are not a simple list. The machine stays the same. Only the HTML it attaches to changes. Compare levels on the [accordion anatomy demo](/en/accordion/anatomy), and the same idea on [select](/en/select/anatomy), [tabs](/en/tabs/anatomy), and [checkbox](/en/checkbox/anatomy). Full snippets stay in the docs and on those pages. Here we focus on when to pick each level.

## Assigns and change tracking

**Anatomy** attrs (`items`, slots, **`compound`**) are ordinary assigns from the caller’s perspective. The component may **`assign`** derived values (panel lists, `ctx` for `:let`) before it renders. How assigns flow through HEEx and how only dynamic regions re-render is defined in [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html); read that guide for **`attr`**, **`slot`**, and change tracking rather than repeating it here.

Conventions that matter when a list feeds a hook-backed component:

- Build **`items`** in **`mount/3`** or **`handle_event/3`**, then pass **`items={@topics}`**. Do not load data inside the template.
- Use **`assign/2`** and **`update/3`** in the LiveView. Avoid **`Map.put/3`** on assigns inside a function component.
- Prefer explicit attrs over **`{assigns}`** into children so patches stay granular.

Choosing an anatomy level does not replace **`phx-hook`** or the Zag machine; it only shapes the HTML those callbacks attach to. **`value`**, **`controlled`**, **`on_value_change`**, and **`pushEvent`** are [bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) and hook APIs: see [state machines](/en/blog/state-machines/) and [vanilla JS](/en/blog/vanilla-js/), not this post.

## Setup

Register Corex in the **`hooks`** option on **`LiveSocket`** as in [Client hooks via `phx-hook`](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook):

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})

liveSocket.connect()
```

Import CSS per component you render, or use Corex Design with `mix corex.design`. Behavior does not depend on bundled CSS.

## Minimal: `items` only

List-driven accordions and tabs take **`items`**. The value is a list from `Corex.Content.new/1`. Each map needs **`label`** and **`content`**. Optional fields: **`value`** (stable id), **`disabled`**, **`meta`** (extras for custom slots).

```heex
<.accordion
  class="accordion"
  id="faq"
  items={
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  }
/>
```

Corex renders a trigger from each `label` and a panel from each `content`. You get keyboard support, default open behavior, and the `data-scope` / `data-part` tree for the hook. Add BEM classes on the root, for example `class="accordion accordion--accent"`. Anatomy does not change attrs; it changes how many child nodes you declare.

From the database, build the list in the LiveView and pass it in. The attribute is always **`items`**, not a special socket assign unless you put the list in assigns yourself:

```elixir
items =
  Corex.Content.new(
    Enum.map(rows, fn row ->
      %{
        value: row.slug,
        label: row.title,
        content: row.body,
        disabled: row.archived
      }
    end)
  )
```

```heex
<.accordion class="accordion" id="faq" items={items} />
```

## Shared slot on every row

Keep the same `items` list and add one `<:indicator>` slot. Corex repeats it per item. Open and keyboard behavior are unchanged. Moduledocs call this **With Indicator** anatomy.

```heex
<.accordion
  class="accordion"
  id="faq"
  items={
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  }
>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

## Custom Slots: `:let` per row

When each row needs different markup, keep `items` and use `:let={item}` on the slots you override. Put per-row data in **`meta`**. This is **Custom Slots** anatomy.

```heex
<.accordion
  class="accordion"
  id="faq"
  value="lorem"
  items={
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
  <:content :let={item}>
    <p>{item.content}</p>
  </:content>
  <:indicator :let={item}>
    <.heroicon name={item.meta.indicator} />
  </:indicator>
</.accordion>
```

Inside each slot, `item` has `label`, `content`, `value`, `disabled`, and `meta`. You can override only `:trigger` or only `:content`.

## Manual Slots

For a few fixed panels with rich HTML in each body, omit `items` and declare slots with the same **`value`** on `:trigger`, `:content`, and optional `:indicator`.

```heex
<.accordion class="accordion" id="faq" value="lorem">
  <:trigger value="lorem">
    <.heroicon name="hero-chevron-right" />
    Lorem ipsum dolor sit amet
  </:trigger>
  <:content value="lorem">
    <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
  </:content>
  <:indicator value="lorem">
    <.heroicon name="hero-chevron-down" />
  </:indicator>

  <:trigger value="duis">
    <.heroicon name="hero-chevron-right" />
    Duis dictum gravida odio ac pharetra?
  </:trigger>
  <:content value="duis">
    <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
  </:content>
  <:indicator value="duis">
    <.heroicon name="hero-chevron-down" />
  </:indicator>

  <:trigger value="donec">
    <.heroicon name="hero-chevron-right" />
    Donec condimentum ex mi
  </:trigger>
  <:content value="donec">
    <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
  </:content>
  <:indicator value="donec">
    <.heroicon name="hero-chevron-down" />
  </:indicator>
</.accordion>
```

Use `items` for many uniform rows from data; use **Manual Slots** when the list shape is wrong. Each slot `value` ties trigger to panel, same as `value` in an `items` map.

## compound

When slots cannot produce the DOM you need, use **`compound`** on `<.accordion>` with `:let={ctx}` and sub-components: `accordion_root`, `accordion_item`, `accordion_trigger`, `accordion_content`, `accordion_indicator`.

Hand-placed items:

```heex
<.accordion :let={ctx} compound class="accordion" id="faq">
  <.accordion_root ctx={ctx}>
    <.accordion_item :let={item} ctx={ctx} value="lorem">
      <.accordion_trigger item={item}>
        Lorem ipsum dolor sit amet
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
      </.accordion_content>
    </.accordion_item>
    <.accordion_item :let={item} ctx={ctx} value="duis">
      <.accordion_trigger item={item}>
        Duis dictum gravida odio ac pharetra?
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
      </.accordion_content>
    </.accordion_item>
    <.accordion_item :let={item} ctx={ctx} value="donec">
      <.accordion_trigger item={item}>
        Donec condimentum ex mi
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
      </.accordion_content>
    </.accordion_item>
  </.accordion_root>
</.accordion>
```

With a list in assigns, use `:for`:

```heex
<.accordion :let={ctx} compound id="faq" class="accordion">
  <.accordion_root ctx={ctx}>
    <.accordion_item :for={entry <- @entries} :let={item} ctx={ctx} value={entry.value}>
      <.accordion_trigger item={item}>
        {entry.label}
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>{entry.content}</p>
      </.accordion_content>
    </.accordion_item>
  </.accordion_root>
</.accordion>
```

Try `items` and slots first. Use compound when you need wrappers between items or a DOM shape slots cannot emit.

## Select: `Corex.List.new`

`<.select>` takes **`items`** as options (`label` + `value`), not trigger and body. Use `Corex.List.new/1`. Optional **`group`** on each map for section headers.

**Minimal** select: list plus a chevron in the trigger slot:

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra", disabled: true},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.select>
```

Grouped options used the same `items` list with a `group` field on each map:

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Netherlands", value: "nld", group: "Europe"},
      %{label: "Switzerland", value: "che", group: "Europe"},
      %{label: "Austria", value: "aut", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"},
      %{label: "Thailand", value: "tha", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"},
      %{label: "Canada", value: "can", group: "North America"},
      %{label: "Mexico", value: "mex", group: "North America"}
    ])
  }
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.select>
```

Custom option rows: keep `items` and add `<:item :let={item}>` (accordion uses `:trigger` for the row face):

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }
>
  <:label>Country of residence</:label>
  <:item :let={item}>
    <.heroicon name="hero-globe-alt" />
    {item.label}
  </:item>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" />
  </:item_indicator>
</.select>
```

Placeholder: `translation={%Corex.Select.Translation{placeholder: "Choose a country"}}`.

## Tabs: same `items`, different parts

`<.tabs>` uses `Corex.Content.new/1` like accordion. Minimal anatomy is `items` only:

```heex
<.tabs
  class="tabs"
  id="settings-tabs"
  value="lorem"
  items={
    Corex.Content.new([
      %{label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
  }
/>
```

Shared sliding indicator: boolean **`indicator`** on `<.tabs>`, not a slot per tab:

```heex
<.tabs
  class="tabs"
  id="settings-tabs"
  indicator
  value="lorem"
  items={
    Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
  }
/>
```

Custom tab labels and panels: `:trigger` and `:content` with `:let={item}`.

## Checkbox: slots on one control

`<.checkbox>` has **no `items` list**. Use `<:label>`, `<:indicator>`, `<:error>`, `<:indeterminate>`.

```heex
<.checkbox class="checkbox" id="terms">
  <:label>Accept the terms</:label>
</.checkbox>
```

With a custom check icon:

```heex
<.checkbox class="checkbox" id="terms">
  <:label>Accept the terms</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
</.checkbox>
```

Validation and custom error markup:

```heex
<.checkbox
  class="checkbox checkbox--accent"
  id="subscribe"
  invalid
  checked
  errors={["Required"]}
>
  <:label>Subscribe to updates</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" />
    {msg}
  </:error>
</.checkbox>
```

Indeterminate state (for example a table “select some” header):

```heex
<.checkbox class="checkbox" id="select-all" checked={:indeterminate}>
  <:label>Select some rows</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
  <:indeterminate>
    <.heroicon name="hero-minus" />
  </:indeterminate>
</.checkbox>
```

Same slot idea as the accordion. The shape was one control instead of a collection.

## Core Components vs Corex from Hex

Phoenix **Core Components** are files you edit. Corex ships from Hex: customize with attrs and slots, do not copy the module and wrap the root. The hook expects a stable tree.

On one LiveView you can mix anatomy per call. There is no global mode for the app.

## Open state from outside the component

To open a panel from another control, use the API (keep the same `items` list in the template):

```elixir
def handle_event("open-faq", _params, socket) do
  Corex.Accordion.set_value(socket, "faq", "lorem")
  {:noreply, socket}
end
```

The `id` on `<.accordion id="faq" ...>` must match the first argument to `set_value`. Panel `value` strings come from `items` maps or manual slot `value` attributes. Under the hood that uses **`Phoenix.LiveView.push_event/3`** and the hook’s **`handleEvent`**, the same client/server path documented in [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html#handling-server-pushed-events).

## Choosing anatomy on a call

Use the lightest option that matches your data and markup:

- **Minimal** (`items` only): uniform rows, default trigger and panel text is enough.
- **Shared slot** (one `<:indicator>` or tabs `indicator`): same chrome on every row, list unchanged.
- **Custom Slots** (`:let={item}`): different icons, layout, or panel HTML per row; still driven by `items`.
- **Manual Slots**: small fixed set of panels; bodies are not a single string per row.
- **compound**: you need sub-components to control the DOM tree (wrappers, non-standard item structure).

Accordion and tabs use `Corex.Content.new` because each row has `label` and `content`. Select and combobox use `Corex.List.new` because each row is an option (`label` + `value`). Checkbox has no list: one component, region slots only.

You can use different anatomy on different calls in the same LiveView. There is no app-wide setting. The hook and attrs API stay the same; only the HEEx you write changes.

Start with **Minimal** on every new screen. Move to **Custom Slots** when one row needs a different icon or panel layout. Reserve **Manual Slots** and **compound** for marketing blocks or layouts where `items` maps would fight the design. The demos under `/en/<component>/anatomy` on this site show each level side by side; compare HTML size and maintainability before committing to compound for a whole app.

## Comprehensions, `:key`, and list-driven anatomy

When you render many similar rows with **`:for`**, LiveView can track entries by index or by **`:key`**. Corex list-driven **`items`** expand to a stable internal structure; for custom slot loops you author yourself, follow the [comprehensions guidance](https://hexdocs.pm/phoenix_live_view/assigns-eex.html#comprehensions): use **`:key={item.value}`** when rows can be reordered or inserted so patches stay minimal.

Manual Slots and **compound** are for when the DOM is not a uniform list. You trade a single **`items`** assign for explicit slot content. The machine still expects the **`data-part`** tree documented in moduledoc **Anatomy**.

## What anatomy does not include

Anatomy is first-render template shape. It does not replace:

- Controlled `value` and `on_value_change`
- `Corex.Accordion.set_value/2` from another control
- Server-side combobox search (`filter={false}`, `on_input_value_change`)
- Client event attrs for DOM-only listeners

Those are state and data flow, not template shape.

---

Start with `items` and `Corex.Content.new` or `Corex.List.new`. Add slots when the default markup is not enough. Use **Manual Slots** or **compound** only when `items` and `:let` cannot match the layout.

The next posts in this series cover [state machines](/en/blog/state-machines/) (assigns and controlled mode), [vanilla JS](/en/blog/vanilla-js/) (`LiveSocket` and hooks), [design](/en/blog/corex-design-a11y/) (tokens on `data-part`), and [combobox scale](/en/blog/combobox-thousands-of-items/) (server-fed lists). Anatomy is the foundation: get the HEEx tree right and the hook has something reliable to enhance.
