---
title: "How to render 9000+ items in a Combobox?"
description: "Keep client rendering, turn off client filter, and let the server refill items on each query."
date: "2026-05-23 12:00:00 +0000"
permalink: /en/blog/combobox-thousands-of-items/
tags:
  - Combobox
  - LiveView
  - Performance
sitemap:
  priority: 0.8
  changefreq: monthly
---

A combobox has the same split as every Corex component. The **machine** keeps listbox behavior on the client: open menu, highlight row, keys, ARIA. Your **LiveView** supplies **data**: which options exist in `items` at this moment.

With a few hundred rows, default client filter is fine: the hook holds the list and filters locally. With thousands, you stop shipping the catalog in every patch. You keep the brain; you change the feed.

Pass a small **`items`** list from the server on each query (`filter={false}`, `on_input_value_change`). Trigger, empty state, and custom option rows are still anatomy choices on the same component.

## Assigns, change tracking, and `handle_event`

LiveView stores **`items`** in the socket as an assign. The template binds **`items={@items}`**. When you **`assign(socket, :items, Corex.List.new(rows))`** inside **`handle_event/3`**, only the dynamic parts of the combobox subtree that depend on `@items` are re-sent to the client. The hook’s **`updated`** callback reads the new `data-*` collection metadata and refreshes the machine without you retyping options in HEEx.

From [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html): do not build `items` with a database call inside the template. Do not define `rows = …` at the top of **`render/1`** and expect fine-grained updates. Load and filter in **`mount/3`**, **`handle_event/3`**, or **`handle_info/2`**, then assign.

**`on_input_value_change`** is the combobox equivalent of a [form binding](https://hexdocs.pm/phoenix_live_view/bindings.html): the client pushes an event name you declare, and the server responds with **`{:noreply, socket}`**. That is the same contract as **`phx-change`** on a form, except the hook originates the event from the Zag machine when the input value changes.

For expensive search, you can debounce on the server (timer in **`handle_event`**) or rely on client-side [rate limiting](https://hexdocs.pm/phoenix_live_view/bindings.html#rate-limiting-events-with-debounce-and-throttle) on other bindings on the same page. Combobox input events are not the same as **`phx-debounce`** on a plain `<input>`, because the Corex root owns the input part; debouncing belongs in your **`handle_event`** when you call the database.

## Small lists: client filter (default)

With `filter={true}` (the default), the hook keeps the full `items` list in the DOM and filters by the input string locally. Use this for country pickers, tags, and enums that fit in memory.

```heex
<.combobox
  id="country"
  class="combobox combobox--accent"
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
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

Past a few hundred rows, mount payloads grow and each keystroke filters the whole DOM. Switch pattern before users hit lag.

### What the client still does with `filter={false}`

Turning off filter does **not** move listbox behavior to the server. The hook still:

- Opens and closes the menu
- Moves highlight with arrow keys
- Sets ARIA roles on **`[data-part="item"]`** rows
- Fires **`on_input_value_change`** when the typed value changes

The server only answers: “given this query string, which rows should exist in **`items`** right now?” That is the same division as [bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) elsewhere: client interaction, server state in **assigns**.

## Large lists: `filter={false}` and server search

Pass **`filter={false}`** and handle **`on_input_value_change`** on the LiveView. Search the database or index on each change; assign a new list. The hook still owns highlight, open state, and listbox semantics.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent combobox--lg"
  placeholder="Search airports…"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
>
  <:empty>No results</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
  <:clear_trigger>
    <.heroicon name="hero-backspace" />
  </:clear_trigger>
</.combobox>
```

The payload includes **`value`** and **`reason`**. Handle **`input-change`**, **`clear-trigger`**, and **`item-select`** explicitly so assigns stay aligned with the machine.

| `reason` | Typical server action |
|----------|------------------------|
| `input-change` | Run search; **`assign`** new **`items`** |
| `clear-trigger` | Reset input slice (e.g. first 120 rows) |
| `item-select` | Often no-op for **`items`**; update **`value`** via **`on_value_change`** if controlled |

Returning **`{:noreply, socket}`** without updating **`items`** on select is correct when the picked row is already in the list. After select, you may shrink **`items`** to the chosen row only if your UX requires it.

## LiveView module (in-memory list first)

Start with an in-memory list, then swap the filter for SQL.

```elixir
defmodule MyAppWeb.AirportComboboxLive do
  use MyAppWeb, :live_view

  defp all_rows do
    [
      %{value: "LHR", label: "London Heathrow (LHR)"},
      %{value: "CDG", label: "Paris Charles de Gaulle (CDG)"},
      %{value: "JFK", label: "New York John F. Kennedy (JFK)"},
      %{value: "NRT", label: "Tokyo Narita (NRT)"},
      %{value: "SYD", label: "Sydney Kingsford Smith (SYD)"}
    ]
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :items, Corex.List.new(all_rows()))}
  end

  def handle_event("filter_airports", %{"reason" => "clear-trigger"}, socket) do
    {:noreply, assign(socket, :items, Corex.List.new(all_rows()))}
  end

  def handle_event("filter_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
    q = value |> String.trim() |> String.downcase()

    rows =
      if q == "" do
        all_rows()
      else
        Enum.filter(all_rows(), fn r ->
          String.contains?(String.downcase(r.label), q)
        end)
      end

    {:noreply, assign(socket, :items, Corex.List.new(rows))}
  end

  def handle_event("filter_airports", _params, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <.combobox
      id="airport-combobox"
      class="combobox combobox--accent"
      placeholder="Search airports…"
      items={@items}
      filter={false}
      on_input_value_change="filter_airports"
    >
      <:empty>No results</:empty>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:clear_trigger>
        <.heroicon name="hero-backspace" />
      </:clear_trigger>
    </.combobox>
    """
  end
end
```

## Database query with a limit

Replace `Enum.filter/2` with a bounded query. Always return `Corex.List.new/1`:

```elixir
def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
  q = String.trim(value)

  rows =
    if q == "" do
      Airports.list_first(120)
    else
      Airports.search(q, limit: 120)
    end

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
      end)
    )

  {:noreply, assign(socket, :items, items)}
end
```

Use a **limit** on every query. Debounce in the LiveView if the datastore needs it.

## Initial slice on mount

You do not need `items={[]}`. A first page of results improves discoverability:

```elixir
def mount(_params, _session, socket) do
  rows = Airports.list_first(120)

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
      end)
    )

  {:ok, assign(socket, :items, items)}
end
```

On **`clear-trigger`**, restore that slice instead of an empty list.

## Grouped options

Set **`group`** on each map:

```heex
<.combobox
  id="airport-combobox-grouped"
  class="combobox combobox--accent"
  placeholder="Search by city…"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports_grouped"
>
  <:empty>No results</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

```elixir
def handle_event("filter_airports_grouped", %{"value" => value}, socket)
    when is_binary(value) do
  rows = Airports.search_grouped(value, limit: 80)

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{
          value: row.iata_code,
          label: "#{row.name} (#{row.iata_code})",
          group: row.city_name
        }
      end)
    )

  {:noreply, assign(socket, :items, items)}
end
```

Group headers render from the `group` field on each map.

## Custom option rows

Keep `filter={false}` and add **`<:item :let={item}>`** when rows need icons or extra markup. Server search logic is unchanged.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
>
  <:item :let={item}>
    <.heroicon name="hero-globe-alt" />
    {item.label}
  </:item>
  <:item_indicator>
    <.heroicon name="hero-check" />
  </:item_indicator>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

## Controlled selection

Use `value` and `on_value_change` with **`controlled`** when the form must own the picked value:

```heex
<.combobox
  id="airport-combobox"
  class="combobox"
  items={@items}
  filter={false}
  controlled
  value={@selected}
  on_input_value_change="filter_airports"
  on_value_change="airport_selected"
/>
```

```elixir
def handle_event("airport_selected", %{"value" => values}, socket) do
  {:noreply, assign(socket, :selected, values)}
end
```

## Placeholder and translations

Use **`translation`** for placeholder, empty state, and related aria strings:

```heex
<.combobox
  id="airport-combobox"
  class="combobox"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
  translation={%Corex.Combobox.Translation{placeholder: "Search airports…"}}
>
  <:empty>No airports match your search</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

## Debounce heavy queries

If each keystroke hits the database, debounce in the LiveView:

```elixir
def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
  ref = Process.send_after(self(), {:run_airport_search, value}, 200)
  {:noreply, assign(socket, :search_timer, ref)}
end

def handle_info({:run_airport_search, value}, socket) do
  items = Airports.search_items(value, limit: 120)
  {:noreply, assign(socket, :items, items)}
end
```

Cancel or ignore stale timers so out-of-order responses do not flash old results.

## Controlled value vs search

| Assign / event | Role |
|----------------|------|
| `items` | Options in the listbox (from server search) |
| `value` + `on_value_change` | Selected option(s) for the form |
| `on_input_value_change` | Input text drives search |

## Payload size and change tracking

Each **`assign(socket, :items, …)`** re-renders dynamic template parts that reference **`@items`**. LiveView sends a diff for the combobox subtree. Keeping **`limit: 120`** (or similar) bounds both database work and wire size.

If unrelated assigns change on the same LiveView (flash, sidebar, counters), change tracking ensures the combobox dynamic parts run only when **`@items`**, **`@selected`**, or other attrs you pass into **`<.combobox>`** change. Avoid passing **`{assigns}`** into wrapper components around the combobox; pass **`items={@items}`** explicitly.

## LiveComponent inside the form

When the combobox lives in a **`live_component`**, **`on_input_value_change`** still routes to that component’s **`handle_event/3`** if the root is in the component template. **`pushEventTo`** from custom hooks targets by selector; Corex uses the event name you provide on the root. Keep **`id`** stable per component instance.

## Anti-patterns

- Thousands of `items` on mount with `filter={true}`
- Rebuilding `items` in `render/1` without an input event
- Ignoring `reason` after clear or select
- Raw maps in assigns without `Corex.List.new/1`

Virtualized lists help huge **client-side** datasets. Here you keep the combobox and cap **`items`** per query.

## `Corex.List.new/1` and the wire format

Server assigns must use **`Corex.List.new/1`** (or **`Corex.Content.new/1`** where applicable), not bare lists of maps. The helper normalizes labels, values, disabled flags, and **`group`** for serialization onto the combobox root. The hook reads that shape on **`mounted`** and **`updated`**.

Each search **`handle_event`** should produce a fresh **`Corex.List.new(...)`** even when zero rows match, so the empty slot (**`<:empty>`**) can render. An empty list is valid; an assign left stale after a failed search is not.

## Testing server search

In **`Phoenix.LiveViewTest`**, render the LiveView, then **`render_click`** or **`render_change`** on the combobox input depending on how your test helpers target the control. Assert on **`html`** containing expected labels after **`handle_event`** runs. For **`on_input_value_change`**, use **`render_hook`** on the combobox root id with the event name and payload map the hook sends (see component **Events** in HexDocs for field names).

Keep tests focused on assign outcomes: given input `"lon"`, **`@items`** includes Heathrow, not on internal `data-highlighted` indices. The machine owns highlight; the assign owns catalog membership.

## Observability

Log query duration inside **`handle_event`**, not in HEEx. If patches feel slow, check how large **`items`** diffs are and whether unrelated parent assigns invalidate the whole template. Tight assigns and explicit attrs to **`<.combobox>`** keep combobox dynamic sections from re-running on every parent tick.

The combobox patterns playground on this site runs the same flow against a large airport table.

---

Turn off client filter. Refill **`items`** with `Corex.List.new/1` on each query. The hook keeps keyboard and ARIA behavior; the server keeps the catalog size bounded.

That pattern matches how Phoenix expects scalable UIs: **assigns** and **`handle_event`** own data, [change tracking](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) owns what re-renders, and **client hooks** own interaction inside the combobox root. Pair this post with [state machines](/en/blog/state-machines/) for controlled selection and with [anatomy](/en/blog/anatomy-of-a-corex-component/) for **`<:item :let={item}>`** customization.
