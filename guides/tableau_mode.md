# Tableau Mode

## Introduction

Visitors switch light and dark appearance with a Corex `<.toggle>`. The choice updates `data-mode` on `<html>` without a server round-trip, drives Corex Design tokens, and matches what they chose on the last visit.

There is no OTP allowlist for mode (only `light` / `dark`). `config :corex_design, default_mode:` is a build-time default for generated CSS, not the runtime control. See [Configuration](configuration.html) and [Design](design.html). For Phoenix apps with `Plugs.Mode` and cookies, see [Dark mode](dark_mode.html).

## Install first

Wire `Mode.head_script/0` and `phx:set-mode` listeners in `site.js` before you drop this UI into a layout:

- New site: `mix corex.tableau.new my_site --mode`
- Existing site: [Tableau: optional mode wiring](tableau.html#optional-mode-wiring)

| Setup | `<html>` | `<head>` script order |
| ----- | -------- | --------------------- |
| Mode only | Fixed `data-theme` (or design default) + `data-mode={@mode}` | `Mode.head_script()` only |
| With [Tableau Theming](tableau_theming.html) | `data-theme` from theming | `Mode.head_script()` then `Theme.head_script()` |

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Module | `MyApp.Mode` with `head_script/0`, `current/1`, `mode_toggle/1` |
| Layout | `data-mode={@mode}` on `<html>`; `{MyApp.Mode.head_script()}` in `<head>` (before theme when both exist) |
| site.js | `Toggle` hook; `phx:set-mode` listener writes `localStorage` + `data-mode` |
| CSS | `@import "../corex/corex.css"` and `toggle` in `components:` when you use Design |

Full Elixir / `site.js` paste lives in [Tableau: optional mode wiring](tableau.html#optional-mode-wiring).

## Mode toggle

`id="mode-switcher"` matches the scaffolded component. Use `data-toggle-dual-label` to swap moon and sun icons.

```heex
<MyApp.Mode.mode_toggle mode={@mode} />
```

`Mode.mode_toggle/1` (from install wiring) renders:

```heex
<.toggle
  id="mode-switcher"
  class="toggle ui-size-sm shrink-0"
  data-toggle-dual-label
  pressed={@mode == "dark"}
  on_pressed_change_client="phx:set-mode"
>
  <span>
    <.heroicon name="hero-moon" />
    <span class="sr-only">Dark mode</span>
  </span>
  <span data-pressed>
    <.heroicon name="hero-sun" />
    <span class="sr-only">Light mode</span>
  </span>
</.toggle>
```

`on_pressed_change_client="phx:set-mode"` fires a browser event the `site.js` listener handles (`pressed: true` → dark, `false` → light).

## Layout placement

Ensure `RootLayout` assigns `:mode` (install wiring) and renders the toggle where it belongs in the shell (header, menu, footer):

```heex
<MyApp.Mode.mode_toggle mode={@mode} />
```

With [Tableau Theming](tableau_theming.html), keep `data-theme={@theme}` and add `data-mode={@mode}`. Root `<html>` should carry both so the first paint matches storage.

## CSS

```css
@import "../corex/corex.css";
```

`corex.css` loads utilities, themes, and components. Include `toggle` in `components:` when you use a mode switcher. For layered imports, see [Design](design.html).

Corex Design themes define `[data-mode=dark]` overrides. Custom CSS can target `[data-mode="dark"]` the same way.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Toggle does nothing | `site.js` listens for `phx:set-mode`; `Toggle` hook is registered |
| Wrong pressed state | `pressed={@mode == "dark"}` and the layout receives `:mode` |
| Flash of wrong mode | `Mode.head_script()` is in `<head>`; root `data-mode` matches the assign |

## Related

- [Tableau](tableau.html#optional-mode-wiring): `head_script` and `site.js` listeners
- [Configuration](configuration.html): build vs picker vs generators
- [Tableau Theming](tableau_theming.html): multi-theme picker
- [Dark mode](dark_mode.html): Phoenix plug and cookie flow
