---
title: "Two Brains: LiveView Assigns and Zag Machines"
description: "Every Corex screen has two minds running at the same time. Most of the time they cooperate. The interesting decisions happen when they don't."
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

There is a kind of bug I used to find embarrassing, because I could not name it. I would click a tab and see it open, then close half a second later, then open again. I would type into a combobox and watch my cursor jump to a position from two keystrokes ago. The component was not broken. The HTML was right. The CSS was right. Two things just disagreed about which value should be live, and the user was watching them argue.

Once you have seen that bug once, you see it everywhere. It is what happens when two systems both think they own a piece of state and neither knows about the other. In a Phoenix LiveView app that uses Corex, those two systems have names. One is the LiveView process on the server, with its assigns and its `handle_event`. The other is a Zag state machine running in the browser, inside a hook. This post is about deciding, for every piece of state, which of them you want to win.

## The two minds running every page

The LiveView process is the brain you already know. It receives events over a WebSocket, updates assigns in `handle_event/3`, and re-renders the parts of HEEx that changed. It is the canonical Phoenix story, and it is wonderful at what it does: holding data that the server is the truth about, and pushing minimal patches to the client when that data moves.

The Zag machine is the brain you can ignore for weeks at a time, until something flickers. It lives inside the `phx-hook` on the root of each Corex component. It knows what state the accordion or the combobox is in: which item is highlighted, which panel is open, where focus is, what `aria-*` attributes belong on each part right now. It listens for keystrokes and pointer events directly in the browser, without any round trip.

Both of those brains are doing useful work. The trick is that they have overlapping vocabularies. The accordion has a value. The combobox has a value. The select has a value. So does the assign on the server. When the user clicks something, the machine updates its value immediately. The server might not even hear about it. When the server pushes new HTML, it might include a different value than the one the user just clicked. Now what?

## Three layers, in different files

If you sketch a Corex screen, it splits into three honest layers. They live in different files, in different runtimes, and they answer different questions.

The HEEx template is the structure. It declares the parts, sets ids, and serializes data into `data-*` attributes the machine will read on mount. It does not run logic. It is markup and labels.

The hook is the bridge. It runs in the browser, attaches to the root on mount, starts a machine, listens for transitions, listens for patches from the server, and forwards each side's news to the other. It is short and has no opinion of its own.

The machine is the behavior. It decides what to highlight next when a key is pressed. It manages focus. It writes the right `aria-expanded`. It does the part nobody enjoys writing by hand, exactly the same way every time.

The server has none of those concerns and one of its own: the data. What items exist. What is selected. What is valid. The argument this post is really about is between *the server's data* and *the machine's behavior*.

## Uncontrolled, by default

By default, every Corex component is uncontrolled. You may pass an initial `value`, but after the first render the machine keeps the value in memory. The user clicks. The machine reacts. The screen updates. The server does not hear about it unless you specifically ask.

That sounds like a compromise. It is actually the right default for most of the page. A FAQ accordion does not need the server to know which panel is open. A disclosure on a marketing page does not need a round trip to expand. Tabs on a settings page are private to that page. Uncontrolled state is the local memory of the component, and almost all UI state is local.

```heex
<.accordion id="faq" items={@topics} />
```

That accordion has full keyboard support, full focus management, full ARIA, and zero traffic over the WebSocket while the user is reading. If you want to react in a small way, attach `on_value_change` to a server event. The machine still leads. The server listens.

## Controlled, when the server has to be the source of truth

There are screens where the server simply cannot let go. A validated form. A multi-step wizard where step three depends on a choice made on step one. A panel that has to mirror across tabs through Phoenix Presence. Anything where being out of sync, even for a frame, is wrong.

For those screens you opt in to controlled mode. You pass `controlled`, you bind the current value to an assign, and you handle every change on the server.

```heex
<.accordion
  id="faq"
  controlled
  value={@open}
  on_value_change="faq_value_change"
  items={@topics}
/>
```

```elixir
def handle_event("faq_value_change", %{"value" => value}, socket) do
  {:noreply, assign(socket, :open, Corex.Accordion.validate_value!(value))}
end
```

The loop is the same every time. The user acts. The hook pushes the event to the server. The server updates the assign and re-renders. LiveView patches the DOM. The hook detects the patch and tells the machine the value is now this. The machine accepts it. ARIA updates. The screen reflects the truth.

The important word in that paragraph is *accepts*. The machine can take new props after it has already started running. It was not always able to do that, and the day it became able to is the day Phoenix Corex went from a sketch to a release. There is a [whole post](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) about that one change.

## The contract: one writer per piece of state

The whole reason for the controlled/uncontrolled split is to make sure exactly one of the two brains is the writer for each piece of state. If both write, you flicker. If neither writes, nothing happens. Almost every production bug I have seen in Corex lives in screens where someone left the writer ambiguous.

Pick the writer per piece of state, not per component. A combobox can be controlled for its selected value (the form needs to know) and uncontrolled for its open state (the user does not need the server's permission to open a menu). A dialog can be controlled for whether it is open (analytics, deep links) and uncontrolled for which tab is focused inside it. Most components let you mix.

When in doubt, leave it uncontrolled. The default fits the screen far more often than people expect, because most state on most pages is not server-critical.

## How patches and machine writes coexist

There is a piece of plumbing that quietly makes all of this work. When LiveView patches the DOM, it does not blindly overwrite every attribute. The Corex root marks the attributes the machine owns (`data-state`, `aria-expanded`, and so on) so they are left alone during a patch. The hook reads the patch, hands the new props to the machine, and the machine writes its own attributes back.

If you do not know that this exists, it just feels like things work. If you do know it exists, it is the thing standing between you and a constant flicker every time the server breathes. Corex applies `JS.ignore_attributes` on each root at mount. Server diffs merge with machine output instead of arguing with it.

## When something looks wrong

If you ever see a Corex component behave strangely after a server change, three questions usually find it.

The value the user just chose: is the assign actually being updated in `handle_event`? Forgetting to `assign(socket, :open, …)` is the boring answer, and it is correct more often than not.

The DOM patch: did LiveView actually run on this change? If only unrelated assigns moved, change tracking may have decided nothing in that area of the page changed. That is Phoenix doing its job, not a bug.

The id on the hooked element: is it stable across re-renders? If the id changes, the hook unmounts and remounts, the machine starts over, and you lose interaction state. Stable ids matter more here than anywhere else in LiveView.

## The mental model

I keep coming back to the same image. The server is the source of truth for data. The machine is the source of truth for interaction. The hook is a small, polite messenger between them. Anatomy is the HTML that lets the messenger find its way. Design (which lives in [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/)) paints what the machine maintains. Server-fed catalogs (like in [Nine Thousand Airports](/en/blog/nine-thousand-airports-one-hundred-rows/)) are the case where the data really is too big to ship and the messenger has to work hard.

The decision you make, every time you place a Corex component on a page, is which of those two brains owns this particular piece of state. Once you make that call honestly, the bugs I described at the start of this post simply stop happening. The two brains stop arguing because you told them which one was speaking.

---

Next in the series, the hook itself, in [The Vanilla JS Machine That Doesn't Need a Framework](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). Then [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/) for the paint that sits on top of these brains. Then [Nine Thousand Airports](/en/blog/nine-thousand-airports-one-hundred-rows/) for the screen that pushes the contract the hardest.
