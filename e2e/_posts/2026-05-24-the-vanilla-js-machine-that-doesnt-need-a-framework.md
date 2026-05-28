---
title: "The Vanilla JS Machine That Doesn't Need a Framework"
description: "Corex hinged on one line in a Zag changelog. Without it, machines could start but not take new props. With it, the whole Phoenix integration unlocked in an afternoon."
date: "2026-05-24 12:00:00 +0000"
permalink: /en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/
tags:
  - JavaScript
  - Corex
  - Phoenix
  - LiveView
sitemap:
  priority: 0.7
  changefreq: monthly
---

The version of this story that fits on a slide is short. I picked Zag.js as the behavioral layer for Corex, waited for one missing capability to land, and then the entire Phoenix integration unblocked itself in an afternoon. The longer version is the same story, with some context for why the unblock mattered, and what it makes possible now.

## Why state machines at all

I think a lot about who is allowed to own keyboard support. Most teams I have worked on get accessibility right exactly once: the day the designer cares about it, or the day the audit lands. Then it drifts. Tab order goes wrong because someone added a wrapper. Arrow keys stop working on a dropdown because someone refactored a slot. ARIA reverts to `false` because nobody remembers which attribute was supposed to be live.

State machines fix this by encoding behavior in one place and letting the rest of the app refuse to care. Zag.js is a library of those machines, written by Segun Adebayo, framework-agnostic at the core, with adapters for React, Solid, Vue and Svelte. The hard parts (focus rings, typeahead, roving tabindex, every keyboard shortcut a competent designer expects, the entire WAI-ARIA dictionary) live in pure TypeScript. They are battle-tested by thousands of teams who never had to think about them.

I had a conversation with Segun about it on YouTube. If you want to understand why Zag is a solid base, that video is the right place to start. Apologies for the mic quality on top of my accent.

<div class="blog__embed">
<iframe width="560" height="315" src="https://www.youtube.com/embed/D1To2_5o8e8?si=yPg6P6oL4dph6H_L" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

What brought me there was Corex. I was building accessible components for Phoenix LiveView and I did not want to ship behaviors that were 90% correct because I rewrote them myself.

## The vanilla adapter has its own opinions, deliberately

Zag's framework adapters do a specific job: they subscribe to a machine and tell their framework to re-render when state changes. React uses hooks. Vue uses refs. Svelte uses runes. Each adapter speaks the local reactivity dialect.

The vanilla adapter cannot lean on any of those. It has no reactivity model to subscribe to. It also has to do something the framework adapters do not do directly: touch the DOM itself. It reads positions, sets focus, writes `aria-*`, manages scroll. In React, the framework mediates all of that. Without a framework, you are the bridge between the machine and the document.

That is why `@zag-js/vanilla` is shaped the way it is. You get a class-based `VanillaMachine` with a clear `start()` / `stop()` lifecycle. You subscribe to state changes and write to the DOM yourself. The Zag repo ships a [full vanilla TypeScript example](https://github.com/chakra-ui/zag/tree/main/examples/vanilla-ts) that demonstrates the pattern.

For a static page that ships once and runs locally, this is wonderful. Set up the machine, the user interacts, done. Props go in once and the machine runs from there.

Phoenix LiveView has a different rhythm.

## What LiveView actually needs

LiveView renders HTML on the server and sends minimal DOM patches over a WebSocket whenever state changes. The browser applies the diff. No virtual DOM. No client-side component graph. Just the right HTML at the right moment.

For JavaScript interop, LiveView gives you hooks. Small objects you attach to DOM elements with `phx-hook`, receiving lifecycle callbacks: `mounted`, `updated`, `destroyed`, and a few more. From inside a hook you push events to the server, listen for events from the server, and read the DOM directly.

This is a genuinely good model. The server stays in charge of data. The client handles behavior. For accessible components, that split is exactly where you want the line: LiveView decides what the values are, Zag decides how the component behaves.

The catch is that LiveView can push updates to a hooked element at any time. A controlled select where the server pins the current option. A combobox where the server replaces every option on every keystroke. A dialog that the server closes from a timer or a Presence event. Each one requires telling the running machine: a prop just changed, please update yourself.

Early versions of `@zag-js/vanilla` could start a machine and run it well, but you could not change its props after initialization. The machine was effectively sealed once it started. For a static site this was fine. For LiveView, it was the one missing thing.

## A line in a changelog

One day a line landed in the Zag changelog:

> Fix issue where vanilla machines do not have the option to change their props during runtime.

That is the whole sentence. No announcement. No marketing. One fix.

What it actually meant was that `VanillaMachine` would now accept `updateProps` calls at any point after `start()`. Which meant that when LiveView fires `updated` on a hook, the hook could read the fresh `data-*` attributes from the patched element and pass them straight into the running machine. The machine reacts. ARIA updates. Controlled values sync. The server stays in charge and the user never notices.

The Phoenix integration went from "not really possible" to "let's build it" between that release and dinner.

## How Corex puts it together

When you place a Corex component in a template, the server renders the full markup: the right `data-scope` and `data-part` attributes, the right ARIA skeleton, and `phx-hook="ComponentName"` on the root.

On the client, three lifecycle callbacks do all the work.

`mounted` reads the serialized props from `data-*`, starts a `VanillaMachine`, subscribes to state transitions, and begins keeping the DOM in sync with whatever the machine decides.

`updated` reads the freshly patched props from the same root and calls `updateProps` on the machine. If the server changed `value`, the machine knows immediately. If an item became disabled, same thing. No remount. No lost focus. No interaction state thrown away.

`destroyed` calls `machine.stop()` for a clean teardown.

On top of that, Corex applies `JS.ignore_attributes` on each root at mount, so LiveView diffing does not strip the `data-state` and `aria-*` fields the hook just wrote. The patch and the machine end up writing to different attributes and politely staying out of each other's way.

The machine handles everything behavioral. LiveView handles the data. The hook is a small messenger that does no logic of its own.

## Two releases, one story

This is actually the second chapter of Corex. The first release shipped for static sites: Vite, Astro, Eleventy, anything where you write plain HTML with a bundler. That version works beautifully because static pages do not need runtime prop updates. You set props once, the machine runs, users interact.

The LiveView integration builds on everything that worked there, and adds the one thing LiveView specifically needs: machines that can stay in sync with a server that keeps changing its mind.

On the server side, you use Corex components like any HEEx component. On the client, the registration story is one import.

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})
```

That is the entire setup for most apps.

## Why a single import is not a heavy import

Corex ships dozens of interactive components. Each one pulls in a Zag machine, some DOM helpers, and a bit of shared collection logic. If every hook landed in one bundle, every page in your app would pay for date pickers, dialogs and comboboxes it never uses.

So the JavaScript is split on purpose. When Corex is built for Hex, esbuild compiles each hook as its own ESM entry (`accordion.mjs`, `combobox.mjs`, and so on) with `--splitting` enabled. Shared code between hooks lands in hashed chunks. Zag utilities and vanilla adapters are reused, not duplicated.

The default export from `corex` is not the full catalog inlined. It is a map of lazy stubs. Each one is a tiny `phx-hook` object created by `createLazyHook`. When LiveView mounts a hooked element, the stub runs a dynamic `import("corex/accordion")` (or whichever component matched), then forwards every later lifecycle call to the real hook. A route with only accordions and checkboxes never downloads combobox or dialog code.

For this to work end to end, your Phoenix app needs to participate. The esbuild args for `assets/js/app.js` must include `--format=esm --splitting`, and the script tag in the root layout must use `type="module"`. Without splitting, dynamic `import()` calls cannot become separate files and you lose the win. The [manual installation guide](https://hexdocs.pm/corex/manual_installation.html) has the exact flags.

If you want an even smaller graph, import only the hooks you actually render:

```javascript
import { hooks } from "corex/hooks"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})
```

Each value is a function returning `import()`. Esbuild emits chunks only for listed hooks. Unused components can be tree-shaken out of your bundle entirely. The keys match the `phx-hook` names rendered on the server.

## The point of the bridge

If you forget everything else in this post, the part worth keeping is this. Zag's machines do not know they are running inside Phoenix. They just run. They do not care whether the props came from React state or from a LiveView patch. The Corex hook is the small adapter that lets a Phoenix server change its mind about a value without dragging the user's interaction with it.

One line in a changelog. Months of work made possible. That is usually how these things go.

Once hooks are in place, [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/) styles the `data-part` skeleton the machines maintain, [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/) explains the runtime contract between assigns and machines, and [server-fed combobox search](/en/blog/nine-thousand-airports-one-hundred-rows/) is the pattern that stress-tests `updated` on every keystroke.
