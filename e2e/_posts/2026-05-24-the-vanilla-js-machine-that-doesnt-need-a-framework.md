---
title: "The Vanilla JS Machine That Doesn't Need a Framework"
description: "Zag.js vanilla machines in LiveView hooks, runtime updateProps, and esbuild splitting so each component loads only when it mounts on the page."
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

Zag.js is one of those libraries that genuinely changes how you think about UI. State machines for accessible components, completely framework-agnostic at the core, with adapters for React, Solid, Vue and Svelte. Segun (the creator) has done something rare: the hard logic of focus management, keyboard navigation, ARIA attributes, open/close transitions, all of it lives in pure TypeScript that any framework can consume.

I got to talk with Segun about it on YouTube, and if you want to understand why Zag is such a solid foundation, that conversation is a good place to start (sorry for the mic quality on top of my accent 😅).

<div class="blog__embed">
<iframe width="560" height="315" src="https://www.youtube.com/embed/D1To2_5o8e8?si=yPg6P6oL4dph6H_L" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

What brought me there was Corex. I was building accessible UI components for Phoenix LiveView, and Zag was the obvious choice for the behavioral layer. The machines are already battle-tested. The accessibility is already correct. I didn't want to rewrite any of that.

How much HEEx you write for each widget is a separate choice: [anatomy](/en/blog/anatomy-of-a-corex-component/). Who owns runtime state on the server vs in the machine is another: [state machines](/en/blog/two-brains-liveview-assigns-and-zag-machines/). Connecting Zag to LiveView turned out to be more interesting than I expected.

## The Right Layer for Every Framework

Zag ships adapters for the big JS frameworks because each one has its own reactivity model. `@zag-js/react` uses `useMachine` and hooks. `@zag-js/vue` leans on refs and watchers. `@zag-js/svelte` plugs into runes. These adapters are what make a machine "come alive" inside each framework: they subscribe to state transitions and re-render components automatically.

Vanilla JS is a different story, and deliberately so. A vanilla adapter can't make assumptions about reactivity. It also has to do something the framework adapters don't: directly touch the DOM. Machines need to read element positions, manage focus, set `aria-*` attributes, handle scroll. In React, the framework mediates all of that. Without a framework, you're connecting the machine to the actual document yourself.

That's why `@zag-js/vanilla` is opinionated. It gives you a class-based `VanillaMachine` wrapper with a clear `start()` / `stop()` lifecycle, and you subscribe to state changes and update the DOM yourself. Zag even ships a full [vanilla TypeScript example](https://github.com/chakra-ui/zag/tree/main/examples/vanilla-ts) to show exactly how this works in practice.

For a static page, this model is wonderful. Set up the machine, let the user interact, done. Props come in once and the machine runs from there.

Phoenix LiveView, though, has a different rhythm.

## What LiveView Actually Needs

LiveView renders HTML on the server and sends minimal DOM patches over a WebSocket when state changes. The browser applies the diff. No virtual DOM, no client-side component tree. Just the right HTML at the right moment.

For JavaScript interop, LiveView has hooks: small objects you attach to DOM nodes with `phx-hook`. They receive lifecycle callbacks: `mounted`, `updated`, `destroyed`. From inside a hook you can push events to the server and listen for events coming back.

This is a genuinely good model. It means the server stays in control of data, and the client handles behavior. For accessible widgets that's exactly the right split: LiveView manages what the values are, and Zag manages how the widget behaves.

The challenge is that LiveView can push updates to a hooked element at any time. A controlled Select where the server sets the current value. A Combobox where the server filters items on every keystroke. A Dialog that the server can close programmatically. All of these require telling the running machine: something changed, update yourself.

Early versions of `@zag-js/vanilla` started the machine and ran it well, but there was no way to update props after initialization. The machine was effectively sealed once it started. For static pages this was fine. For LiveView, it was the one thing missing.

## A Quiet Fix with a Big Consequence

Then a line appeared in the Zag changelog:

> Fix issue where vanilla machines do not have the option to change their props during runtime.

That's all it said. No announcement. One fix.

But it meant `VanillaMachine` could now accept `updateProps` calls after the machine had started. Which meant that when LiveView fires `updated` on a hook, I could read the fresh `data-*` attributes from the patched element and pass them straight into the running machine. The machine reacts. ARIA updates. Controlled values sync. The server stays in charge.

The Phoenix integration went from "not really possible" to "let's build it."

## How Corex Puts It Together

Corex wraps `VanillaMachine` inside Phoenix hook objects. When you write:

```heex
<.accordion id="faq" on_value_change="accordion_changed">
  ...
</.accordion>
```

Corex renders the full HTML anatomy (root, triggers, panels, the right `data-part` attributes, the correct ARIA skeleton) and attaches `phx-hook="Accordion"` to the root element.

On the client, three lifecycle callbacks do the work:

`mounted` reads serialized props from `data-*` attributes, starts a `VanillaMachine`, subscribes to state transitions, and begins keeping the DOM in sync with whatever the machine decides.

`updated` reads the new props from the freshly patched element and calls `updateProps` on the machine. If the server changed `value`, the machine knows immediately. If an item became disabled, same thing. No remount, no lost interaction state.

Corex also uses `JS.ignore_attributes` on mount so LiveView patches do not strip `data-state` and ARIA fields the hook just wrote. Server diffs merge with machine output instead of fighting it.

`destroyed` calls `machine.stop()` for a clean teardown.

The machine handles everything behavioral: keyboard navigation, ARIA roles and states, open/closed transitions, controlled vs uncontrolled modes, focus management. LiveView handles the data. The hook is the bridge.

## Split chunks, load on mount

Corex ships dozens of interactive components. Each one pulls in Zag machines, DOM helpers, and often shared collection logic. If every hook shipped in one fat bundle, every page would pay for dialogs, date pickers, and comboboxes it never renders.

We split the JavaScript on purpose.

When Corex is built for Hex, esbuild compiles each hook as its own ESM entry (`accordion.mjs`, `combobox.mjs`, and so on) with **`--splitting`** enabled. Shared code between hooks lands in hashed chunks under `priv/static/chunks/`. Zag utilities and vanilla adapters are reused instead of duplicated in every file.

The default export from `corex` is not that full catalog inlined. It is a map of **lazy hook shells**: thin `phx-hook` objects created by `createLazyHook`. On `mounted`, the shell runs a dynamic `import("corex/accordion")` (or whichever component matched the root), then forwards `updated`, `destroyed`, `beforeUpdate`, and the rest to the real hook. The fetch happens in the background while the rest of the page is already alive. A route with only accordions and checkboxes never downloads combobox or dialog code.

```javascript
import corex from "corex"

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...corex }
})
```

Spreading `...corex` registers every component name LiveView might need, but the browser only requests the chunks for hooks that actually mount.

Your Phoenix app must participate in the same model. In `config/config.exs`, the Esbuild args for `assets/js/app.js` need **`--format=esm`** and **`--splitting`**, and the script tag in the root layout must use **`type="module"`**. Without splitting, dynamic `import()` calls cannot become separate files and you lose the performance win. The [manual installation guide](https://hexdocs.pm/corex/manual_installation.html) walks through the exact flags.

If you want a smaller build graph, import only the hooks you render:

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

Each value is a function returning `import()`. Esbuild emits chunks only for listed hooks, so unused components can be tree-shaken out of your app bundle entirely. Keys must match `phx-hook` names on the server (`Accordion`, `Combobox`, …).

In production, `mix assets.deploy` minifies and digests the same entry plus per-hook chunks you already had in dev. See the [production guide](https://hexdocs.pm/corex/production.html) for the deploy flow.

Smaller initial JS, shared chunks between widgets, lazy load when a hooked node appears: that is how Corex stays usable on content-heavy LiveView apps without treating every page like a component catalog download.

## Two Releases, One Story

This is actually the second chapter. The first release of Corex was for static sites: Vite, Astro, Eleventy, any setup where you're writing plain HTML with a JS bundler. That version works beautifully precisely because static pages don't need runtime prop updates. You set props once, the machine runs, users interact.

The LiveView integration builds on everything that worked there, and adds the one thing LiveView specifically needs: machines that can stay in sync with a server that keeps changing its mind.

On the server side, you use Corex components like any other HEEx component. The `import corex from "corex"` setup above is the whole client registration story for most apps.

The Zag machines underneath don't know or care that they're running inside Phoenix. They just run, keeping widgets correct and accessible, while LiveView does what it does best: an efficient server update when we need it.

One small fix in a changelog. Months of work made possible. That's how it usually goes.

Once hooks are in place, [Corex Design](/en/blog/paint-the-parts-the-machine-already-owns/) styles the `data-part` tree they maintain, and [server-fed combobox search](/en/blog/nine-thousand-airports-one-hundred-rows/) is the pattern that stress-tests `updated` on every keystroke.

