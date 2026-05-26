---
title: "Nine Thousand Airports, One Hundred Rows"
description: "Turn off client filter, refill items from the server on each query, and let the Zag machine keep listbox behavior on a bounded slice."
date: "2026-05-23 12:00:00 +0000"
permalink: /en/blog/nine-thousand-airports-one-hundred-rows/
tags:
  - Combobox
  - LiveView
  - Performance
sitemap:
  priority: 0.8
  changefreq: monthly
---

I needed a combobox over every airport in the dataset. Thousands of IATA codes, long labels, grouped by city. The default Corex combobox happily filters on the client: it keeps the full `items` list in the DOM and narrows locally on each keystroke.

That is perfect for country pickers and short enums. It is the wrong tool when the catalog does not fit in memory or in a LiveView patch.

The fix is not a different component. It is a different **feed**: same Zag machine, same hook, same keyboard and ARIA. The server sends a small `items` slice on each query. Anatomy choices ([custom `<:item>` rows](/en/blog/anatomy-of-a-corex-component/), grouped options) still apply on the same root.

See it running against a real airport table on [/en/combobox/patterns](/en/combobox/patterns).

## What stays on the client

`filter={false}` does **not** move listbox behavior to the server. The hook still:

- Opens and closes the menu
- Moves highlight with arrow keys
- Sets ARIA on `[data-part="item"]` rows
- Fires **`on_input_value_change`** when the typed value changes

The server only answers: given this query string, which rows should exist in **`items`** right now?

## What moves to the server

Pass **`filter={false}`** and handle **`on_input_value_change`** in the LiveView. Search the database or index on each change; assign a new list wrapped in **`Corex.List.new/1`**.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent combobox--lg"
  placeholder="Search airports…"
  items={@items}
  filter={false}
  on_input_value_change="search_airports"
>
  <:empty>No results</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

The payload includes **`value`** and **`reason`**. Handle **`input-change`**, **`clear-trigger`**, and **`item-select`** explicitly so assigns stay aligned with the machine.

| `reason` | Typical server action |
|----------|------------------------|
| `input-change` | Run search; assign new `items` |
| `clear-trigger` | Restore initial slice (e.g. first 120 rows) |
| `item-select` | Often no-op for `items`; update `value` via `on_value_change` if controlled |

## A minimal LiveView

Build `items` in `mount/3` and `handle_event/3`, never inside the template.

```elixir
defmodule MyAppWeb.AirportComboboxLive do
  use MyAppWeb, :live_view

  @page_size 120

  def mount(_params, _session, socket) do
    rows = Airports.list_first(@page_size)
    {:ok, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", %{"reason" => "clear-trigger"}, socket) do
    rows = Airports.list_first(@page_size)
    {:noreply, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports", %{"value" => value}, socket) when is_binary(value) do
    rows =
      if String.trim(value) == "" do
        Airports.list_first(@page_size)
      else
        Airports.search(value, limit: @page_size)
      end

    {:noreply, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", _params, socket), do: {:noreply, socket}

  defp format_rows(rows) do
    Enum.map(rows, fn row ->
      %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
    end)
  end
end
```

Use a **limit** on every query. Debounce in `handle_event` or `handle_info` if the datastore needs it, and cancel stale timers so out-of-order responses do not flash old results.

## Controlled selection

When the form must own the picked value, add **`controlled`**, **`value={@selected}`**, and **`on_value_change`** alongside server search. [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/) explains the controlled loop; search and selection are separate assigns.

## Anti-patterns

- Thousands of `items` on mount with `filter={true}`
- Rebuilding `items` in `render/1` without an input event
- Ignoring `reason` after clear or select
- Raw lists in assigns without `Corex.List.new/1`

Virtualized lists help huge **client-side** datasets. Here you keep the combobox and cap **`items`** per query.

---

Turn off client filter. Refill **`items`** with `Corex.List.new/1` on each query. The hook keeps keyboard and ARIA; the server keeps the catalog bounded.

Styling that listbox is [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/). Wiring the hook is [vanilla JS](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). Getting the HEEx tree right is [anatomy](/en/blog/anatomy-of-a-corex-component/).
