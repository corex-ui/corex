---
title: "How Fast Is the Checkbox API? Play Tetrex and Find Out."
description: "I wanted to know what the Corex checkbox would do under abuse. So I made a small game out of 180 of them and watched it survive."
date: "2026-05-26 12:00:00 +0000"
permalink: /en/blog/how-fast-is-the-checkbox-api-play-tetrex-and-find-out/
tags:
  - Tetrex
  - Corex
  - Checkbox
  - Phoenix
  - LiveView
sitemap:
  priority: 0.8
  changefreq: monthly
---

I wanted to know what the Corex checkbox would do under abuse. Not in a benchmark, where you can game the numbers, but in a real screen where many checkboxes change state many times per second, with full keyboard support, full ARIA, full focus management, all of it running at the same time. I needed a test the eye could feel.

So I made a small game.

Tetrex is a 10 by 18 grid of Corex checkboxes pretending to be Tetris tiles. Every cell is a real `<.checkbox>` component, with a stable id, the same Zag machine that runs underneath every other checkbox in the library, and BEM modifiers chosen for the piece color (`ui-accent` for the accent piece, `ui-info` for the info piece, and so on). When a piece falls, the cells light up. When a line clears, the row collapses. When the game ends, the score lands in a leaderboard backed by Phoenix Presence and a per-game GenServer.

You can play it at [/en/showcases/tetrex](/en/showcases/tetrex). The game engine itself is plain JavaScript in `tetrex_engine.js`. The interesting part is not how the engine works. The interesting part is what happens to 180 accessible checkboxes when you treat the screen like a frame buffer.

## Why a game, instead of a benchmark

Benchmarks tell you what a component can do in isolation. They are useful in the same way that running a unit test is useful: necessary, but not sufficient. A real screen has many components, many keystrokes, many DOM patches, and a user who notices the moment any of those slow down by a few milliseconds in the wrong place.

A game has all of that on purpose. You play with arrow keys. You hold a piece while another falls. You clear lines while the music plays. If the checkbox hook is slow in any of those moments, you feel it before you can measure it. The eye is the harshest profiler I have ever used, and it does not care what your console says.

So Tetrex is not a contrived stress test. It is a stress test you can lose to.

## Two ways to drive a checkbox

Corex exposes two paths for setting checkbox state from outside the user clicking on it. They land at the same place in the machine. The difference is where the instruction comes from.

The server path is `Corex.Checkbox.set_checked/3` and the helpers around it. It pushes a hook event over the WebSocket. The hook receives the event in the browser and calls into the Zag machine. This is the path the API demo at [/en/checkbox/api](/en/checkbox/api) teaches, and it is the right path for most apps. It keeps the server in charge.

The client path is a DOM event the hook listens for on the root element. You dispatch a `corex:checkbox:set-checked` custom event with a `checked` detail, and the same hook reacts the same way, but the trip is local. No socket. No diff. No server hop.

```javascript
root.dispatchEvent(
  new CustomEvent("corex:checkbox:set-checked", {
    bubbles: false,
    detail: { checked: nextChecked }
  })
)
```

For Tetrex, every cell update on every frame uses the client path. There is no scenario where a falling piece can afford a round trip. The hook is right there, on the same element the engine wants to change. Skipping the socket is the only sensible thing to do.

## What still goes to the server

Gameplay is local. The score is not.

When a game ends, the engine sends a compact snapshot of frames to the LiveView. A per-game GenServer (`E2e.Tetrex.Session`) catches it. It appends to a replay tape, sampled and capped so a long game does not grow without bound. It broadcasts watcher updates on a `tetrex:session:<id>` topic, so spectators can subscribe. When the run qualifies for the top ten, it persists the score and the frames in the database.

So the split has a name: paint is local, *records* are server-owned. Anything you would want to share, replay, audit, or rank crosses the wire on a schedule the user does not notice.

That includes the replay route itself. If you ever finish a top-ten run, the server can hand you a deterministic frame list and the same `GameBoard` hook walks through history, dispatching the same `corex:checkbox:set-checked` events the live engine used. The replay button itself is a Corex toggle, driven through `corex:toggle:set-pressed` on the toggle root. Same client-event pattern, different component.

## Presence, GenServer, store, three live sources

The leaderboard merges three feeds.

A `Registry` keeps the list of active session ids and their current scores, so the lobby can show who is playing in real time.

`Phoenix.Presence` tracks who is in the lobby and who is watching which game, so spectator counts stay live.

A store keeps the persisted top ten plus their frame replays.

On game over, `Store.finalize/4` writes the game, trims to ten entries, and broadcasts `:leaderboard_updated`. Every LiveView watching the lobby patches its own table without a full page reload.

Each source has its own honest answer. Presence answers "who is live right now?" The GenServer answers "what happened in this game id?" The database answers "what are the best ten runs we kept?" The screen pulls all three together without confusing any of them.

## What this proves about the checkbox

What I really wanted to know, when I built Tetrex, was whether you can use a real accessible component at unusual cadence. The answer is yes, with one caveat: take the client path when you need cadence, and the server path when you need authority.

The 180 cells are all real components. They have the same focus rules, the same `aria-checked`, the same keyboard support a single checkbox would have. You can tab to one of them and toggle it manually if you want. The grid is not a `<canvas>` pretending to be accessible; it actually is. That part costs nothing extra at runtime, because the Zag machine does not care whether it is the only one on the page or the hundredth.

You also pay nothing for the API surface you do not use. The client and server paths are both there for every checkbox in your app. Tetrex just uses one of them harder than most apps will.

## A small note about cadence

There is a thing about Tetrex that I find useful as a reminder. The 180 checkboxes are not unusual scale. Many real dashboards have more interactive nodes on screen. The unusual part is the *rate* at which they change. Each frame can touch dozens of cells, and there are many frames per second. The pattern that survives that load is not "render the entire grid from HEEx on every tick". It is "let the machine know about each cell, then update the cells in place when the engine ticks".

If you ever build a Phoenix dashboard that updates many tiles per second, the same split will pay off. Render the cells once. Update them in place via the client path. Send the server the things you cannot afford to lose.

## How this connects to the rest of Corex

[Anatomy](/en/blog/anatomy-of-a-corex-component/) explains why each cell can be a regular checkbox with modifiers, not a custom invented element.

[Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/) explains how the machine and the server stay out of each other's way when both are interested in the same control.

[The Vanilla JS Machine](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) explains how the hook can take many calls per second without losing state, thanks to the `updateProps` capability that landed in Zag's vanilla adapter.

The [Checkbox API page](/en/checkbox/api) walks through the server-driven version of the same `setChecked` surface Tetrex calls from JavaScript.

If you are evaluating Corex for dashboards, games, or anything that flips a lot of control state per second, Tetrex is the blunt version of the question. Go play a round. See if it keeps up.
