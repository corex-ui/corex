# Tableau Mode

## Introduction

You add light/dark switching to a Tableau site that already follows [Tableau](tableau.html). Visitors get `data-mode` on `<html>`, a before-paint script, a Corex `<.toggle>`, and `mode.js` for `localStorage` and `corex:set-mode`.

For Phoenix apps with `Plugs.Mode` and cookies, see [Dark mode](dark_mode.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| [Tableau](tableau.html) | Design assets, ESM Esbuild, `use Corex`, `LiveSocket` |
| `toggle.css` | Imported in `site.css` |

## How it works

1. **`head_script/0`** sets `data-mode` from `localStorage` or `prefers-color-scheme` before paint.
2. **`mode.js`** syncs the toggle after hydration and listens for `corex:set-mode`.
3. **`<.toggle id="mode-switcher">`** dispatches `corex:set-mode` when pressed changes.

| Setup | `<html>` | `<head>` script order |
| ----- | -------- | --------------------- |
| Mode only | Fixed `data-theme="neo"` + `data-mode={@mode}` | `Mode.head_script()` only |
| With [Tableau Theming](tableau_theming.html) | `data-theme` from theming | `Theme.head_script()` then `Mode.head_script()` |

<!-- tabs-open -->

### Mode only

`lib/my_app/mode.ex`:

```elixir
defmodule MyApp.Mode do
  def head_script do
    Phoenix.HTML.raw("""
    <script>
      try {
        const m = localStorage.getItem("data-mode");
        const prefersDark = matchMedia("(prefers-color-scheme: dark)").matches;
        const mode = m === "dark" || m === "light" ? m : (prefersDark ? "dark" : "light");
        document.documentElement.setAttribute("data-mode", mode);
      } catch (_) {}
    </script>
    """)
  end

  def current(assigns) do
    case Map.get(assigns, :mode) do
      "dark" -> "dark"
      _ -> "light"
    end
  end
end
```

In `RootLayout.template/1`:

```elixir
assigns = Map.put(assigns, :mode, MyApp.Mode.current(assigns))
```

```heex
<html lang="en" dir="ltr" data-theme="neo" data-mode={@mode}>
  <head>
    {MyApp.Mode.head_script()}
```

Import in `assets/css/site.css`:

```css
@import "../corex/components/toggle.css";
```

### With Tableau Theming

Keep `data-theme`, `data-themes`, and `data-default-theme` from [Tableau Theming](tableau_theming.html). Add `data-mode={@mode}` on `<html>`.

In `<head>`:

```heex
{MyApp.Theme.head_script()}
{MyApp.Mode.head_script()}
```

### mode.js

Create `assets/js/mode.js`:

```javascript
;(() => {
  const html = () => document.documentElement

  const whenControlReady = (id, run) => {
    const iv = window.setInterval(() => {
      const root = document.getElementById(id)
      if (root && !root.hasAttribute("data-loading")) {
        window.clearInterval(iv)
        run()
      }
    }, 10)
    window.setTimeout(() => window.clearInterval(iv), 10_000)
  }

  const readStoredMode = () => localStorage.getItem("data-mode")

  const getSystemMode = () =>
    window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"

  const syncModeToggle = (mode) => {
    const root = document.getElementById("mode-switcher")
    if (!root) return
    root.dispatchEvent(
      new CustomEvent("corex:toggle:set-pressed", {
        bubbles: false,
        detail: { pressed: mode === "dark" },
      }),
    )
  }

  const applyMode = (mode) => {
    const resolved =
      mode === "dark" || mode === "light" ? mode : getSystemMode()
    localStorage.setItem("data-mode", resolved)
    html().setAttribute("data-mode", resolved)
    return resolved
  }

  const syncModeFromDocument = () => {
    const m = html().getAttribute("data-mode") || getSystemMode()
    syncModeToggle(m === "dark" || m === "light" ? m : getSystemMode())
  }

  applyMode(
    readStoredMode() || html().getAttribute("data-mode") || getSystemMode(),
  )

  whenControlReady("mode-switcher", syncModeFromDocument)

  window.addEventListener("storage", (e) => {
    if (e.key === "data-mode" && e.newValue) {
      applyMode(e.newValue)
      whenControlReady("mode-switcher", syncModeFromDocument)
    }
  })

  window.addEventListener("corex:set-mode", (e) => {
    const detail = e.detail
    if (typeof detail?.pressed === "boolean") {
      applyMode(detail.pressed ? "dark" : "light")
      whenControlReady("mode-switcher", syncModeFromDocument)
      return
    }
    const raw = detail?.value
    const isDark = Array.isArray(raw) && raw.includes("dark")
    applyMode(isDark ? "dark" : "light")
    whenControlReady("mode-switcher", syncModeFromDocument)
  })
})()
```

### site.js

With theme and mode:

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import "./theme.js"
import "./mode.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Select: () => import("corex/select"),
      Toggle: () => import("corex/toggle"),
      Accordion: () => import("corex/accordion"),
    }),
  },
})

liveSocket.connect()
```

Mode only: omit `theme.js` and `Select` if you do not use [Tableau Theming](tableau_theming.html).

### Toggle

`id="mode-switcher"` must match `mode.js`. Use `data-toggle-dual-label` to swap moon and sun icons.

```heex
<.toggle
  id="mode-switcher"
  class="toggle toggle--sm"
  data-toggle-dual-label
  pressed={@mode == "dark"}
  on_pressed_change_client="corex:set-mode"
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

<!-- tabs-close -->

## Related

- [Tableau](tableau.html) — baseline setup
- [Tableau Theming](tableau_theming.html) — multi-theme picker
- [Dark mode](dark_mode.html) — Phoenix plug and cookie flow
