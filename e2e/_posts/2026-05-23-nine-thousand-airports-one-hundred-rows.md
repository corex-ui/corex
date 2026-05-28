---
title: "Nine Thousand Airports, One Hundred Rows"
description: "Big catalogs don't need a different component. They need a different feed. One flag and one event handler is how a Corex combobox keeps its head while the server holds the catalog."
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

The screen was supposed to be simple. A form field that takes a flight origin. A combobox you can search by name or by IATA code, with city groups, with disabled rows for the inactive entries, with all the usual ARIA the Zag machine takes care of. The list, at the start of the project, was meant to be "every airport in the world".

That list is around nine thousand rows on a good day. Some maps count military strips. Some count seaplane bases. The number does not matter once it crosses a couple of thousand: the browser is going to feel it.

I tried the lazy way first. I sent the full list as `items` on mount and let the combobox filter on the client, which is the Corex default. First paint was fine. The hook attached fine. Then I typed a single letter and watched the dropdown try to lay out seven thousand options in a single frame. Scrolling stuttered. Focus rings showed up half a beat late. On a phone, the whole tab dropped frames for half a second.

The fix was not a different component. It was a different *feed* for the same one.

## The default is right for one kind of list

Client-side filtering is the right default for a country picker. For an enum of payment methods. For a list of tags that fits in someone's head. The browser keeps the full list in memory, narrows it on each keystroke, never asks the server anything. Latency is invisible because there is no network in the loop.

That model breaks the moment the catalog stops fitting comfortably in a single DOM. Nine thousand rows is past that point, and so is anything that touches a real backing table where you are doing partial matches, accent folding, ranking, anything more than a literal substring check.

The interesting thing is that the part of the combobox that hurts in those cases is not the part you would assume. Filtering nine thousand rows in JavaScript is fast. Rendering nine thousand DOM rows is what kills you. The keyboard, the highlight, the typeahead, the ARIA all live on a few visible rows. They do not care how many invisible rows exist behind them. So if you can keep the visible slice small, the machine never even notices that the catalog grew.

## One flag, one event handler

The whole switch is a single attribute on the component and a single event handler in the LiveView.

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

`filter={false}` says: do not narrow the list yourself. Take what the server gave you in `items` and show it. The machine still owns highlight, open state, keyboard, focus, ARIA. None of those move. The only thing that moves is who decides which rows exist in `items` right now.

The event name attached to `on_input_value_change` is what the hook fires when the typed value changes. You handle it on the server like any other LiveView event. The payload carries a `value` (what the user typed) and a `reason` (`input-change`, `clear-trigger`, `item-select`, in roughly that order of usefulness).

## A LiveView that breathes with the user

The handler is short. Build the initial slice on `mount`. On every keystroke, search the database with a bounded limit, wrap the result in `Corex.List.new/1`, assign it. On clear, restore the initial slice. On select, do nothing (the machine already updated its own value; you only need to react if you are running controlled).

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

The number you pick for `@page_size` is the most important part of this code, and it is also the most boring. 120 is what worked for me on this project. It is large enough that "the top hundred matches" feels generous to a user typing fast. It is small enough that the browser never stutters. And it is small enough that the SQL is cheap on a properly indexed table.

If your data store is slow, debounce inside `handle_event` and cancel stale work so the third keystroke does not race the first one back to the user. Out-of-order responses make a combobox look haunted.

## Why this still feels like one component, not two

There is a quiet thing happening every time the user types a letter. The hook pushes the value to the server. The server runs the query and replaces `items`. LiveView diffs the DOM. The machine sees the new `items` via `updateProps` and reconciles internally. Highlight, focus, open state, none of them reset. The user typed a letter, a hundred rows quietly swapped under the cursor, and everything else stood still.

That works because the runtime contract between the machine and the patch is solid. None of this would survive if every patch threw the machine away and remounted. The whole reason the [vanilla adapter accepts `updateProps`](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) is to keep what the user is in the middle of doing intact while props change underneath.

That is what makes server-fed feel like client-fed. The same Zag machine. The same ARIA. The same keyboard. Different source for which rows exist this frame.

## A handful of things to not do

A few patterns to avoid, learned the slow way.

Sending thousands of `items` on mount and leaving `filter` on is the most common one. The combobox will technically work. The phone will not.

Rebuilding `items` inside `render/1` is the second. Items belong in assigns. The template reads. It never computes large lists per frame.

Ignoring `reason` is the third. Handle `clear-trigger` explicitly, otherwise hitting the clear button leaves the user looking at a slice from two queries ago, which feels broken even if it is technically correct.

And `Corex.List.new/1` is not decorative. It tags the list as something the combobox knows how to consume. Raw maps in assigns will not survive the patch cleanly.

## When the slice itself becomes a feature

Once you have the pattern, you can do things that would have felt extravagant before. The initial slice can be the user's most-used airports, learned from their booking history. The empty-query response can be a curated "near you" set. The search can be ranked by something more interesting than a literal substring. None of that changes the contract on the client. The machine sees a bounded `items` list and renders a usable combobox. The server quietly does whatever it wants underneath.

This is the part of the pattern I keep coming back to. Server-fed combobox is not just a performance escape hatch. It is a way to put real backend judgment behind a component the user already knows how to operate.

## The point

Big catalogs do not need a different component. They need a different feed. Turn off the client filter. Send a bounded slice on each keystroke. Wrap it in `Corex.List.new/1`. Let the machine keep the highlight, the keyboard, and the ARIA. Let the server keep the catalog.

You can see this running against a real airport table at [/en/combobox/patterns](/en/combobox/patterns). Same Zag machine you would get on a country picker, served from a table you would never want in the DOM.

---

Styling that listbox is [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/). Wiring the hook is [The Vanilla JS Machine](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). Picking the right shape for the template is [anatomy](/en/blog/anatomy-of-a-corex-component/). Owning the value on the server is [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/).
