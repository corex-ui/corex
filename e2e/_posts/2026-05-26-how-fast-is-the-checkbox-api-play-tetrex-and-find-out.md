---
title: "How Fast Is the Checkbox API? Play Tetrex and Find Out."
description: "Tetrex is a LiveView showcase where 180 Corex checkboxes form the board. Client-side API updates keep play and replay instant; Presence and a GenServer handle the leaderboard."
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

I wanted a stress test that felt like a game, not a benchmark page. Something you could play for a minute and intuitively understand whether Corex hooks keep up when state changes fast and often.

Tetrex is that showcase: a 10×18 grid of Corex checkboxes pretending to be Tetris tiles. Same Zag machine as every other checkbox. Same `data-part` tree. Different scale.

Play it at [/en/showcases/tetrex](/en/showcases/tetrex). The point is not the game engine (plain JavaScript in `tetrex_engine.js`). The point is how we drive **many** checkbox instances without turning every frame into a LiveView round trip.

## A board made of checkboxes

Each cell is a real `<.checkbox>` with a stable id and BEM modifiers for piece color (`checkbox--accent`, `checkbox--info`, …). During play, the `GameBoard` hook updates those roots directly so LiveView does not re-render the grid on every tick.

That gives you 180 accessible controls on screen. Keyboard play, focus rules, and checked state all go through the same Checkbox hook documented on [/en/checkbox/api](/en/checkbox/api). Tetrex just calls the API aggressively.

When a piece moves or locks, the `GameBoard` hook recomputes cell state in the client and updates tiles in place. No `phx-click` per cell. No `handle_event` per coordinate.

## Client-side API: instant play and replay

Corex exposes two ways to move checkbox state from outside the control:

- **Server path**: `Corex.Checkbox.set_checked/3` and friends, which `push_event` to the hook (what the API demo teaches).
- **Client path**: a DOM event the hook listens for on the root element.

Tetrex uses the client path for anything that must feel instantaneous:

```javascript
root.dispatchEvent(
  new CustomEvent("corex:checkbox:set-checked", {
    bubbles: false,
    detail: { checked: nextChecked }
  })
)
```

The Checkbox hook registers `corex:checkbox:set-checked` and calls `zagCheckbox.api.setChecked(checked)` directly. `applyCell` also syncs `data-state` on the control part and skips work when nothing changed, so repeated frames do not thrash the DOM.

On every move, line clear, or lock, `afterChange` runs `applyCells` over the full render list. Replay does the same per frame, optionally with Motion animations on clearing rows. The machine stays correct; the API updates stay local.

That is the performance story: **batch many checkbox updates in the browser**, not **many LiveView diffs over the wire**.

## What still goes to the server

Gameplay logic runs in the browser after the first paint. The LiveView seeds the session, shows the cabinet, and listens for coarse events.

When the local engine advances, the hook occasionally `pushEvent("sync", …)` with a compact client snapshot. A per-game **GenServer** (`E2e.Tetrex.Session`) receives those syncs:

- Appends frames for replay (capped and sampled so long games stay bounded)
- Broadcasts watcher updates on `tetrex:session:<id>` with a cell patch list
- On game over, persists score and frames if the run qualifies for the top ten

So the split is deliberate: **checkbox paint is client-local**; **score, replay tape, and lobby state are server-owned**.

Watch mode subscribes to the session topic and applies the same `game_apply` cell patches spectators need, still without re-rendering 180 checkboxes from HEEx on each tick.

## Leaderboard, Presence, and top-ten replays

The index at [/en/showcases/tetrex](/en/showcases/tetrex) merges three live sources:

- **Registry** for active session ids and scores
- **Phoenix Presence** on `tetrex:lobby` for who is playing or watching (watcher counts per game)
- **Store** for the persisted top ten, names, and frame JSON

When a high score lands, `Store.finalize/4` writes the game, trims to ten entries, and broadcasts `:leaderboard_updated`. LiveViews refresh the table without a full page reload.

Qualifying runs expose a **replay** route. The server loads stored frames, pushes `replay_init` once, and the same `GameBoard` hook steps through history with `corex:checkbox:set-checked` again. Play/pause uses Corex toggles via `corex:toggle:set-pressed` on the replay controls.

Presence answers “who is live right now?” The GenServer answers “what happened in this game id?” The database answers “what are the best ten runs we kept?”

## How this connects to the rest of Corex

- [Anatomy of a Corex Component](/en/blog/anatomy-of-a-corex-component/): each cell is a checkbox with modifiers, not custom markup.
- [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/): play mode keeps interaction authority on the client; sync and game over hand results to the server.
- [Vanilla JS](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/): Checkbox is a lazy-loaded hook chunk; Tetrex adds a custom `GameBoard` hook beside `…corex`.
- [Checkbox API](/en/checkbox/api): the server-driven version of the same `setChecked` surface Tetrex calls from JavaScript.

If you are evaluating Corex for dashboards, games, or any UI that flips a lot of control state per second, Tetrex is the blunt test: hundreds of checkbox updates, smooth replay, and Phoenix still owns the leaderboard.

Go play a round. See if the board keeps up with your fingers.
