# Tableau static + Corex: mode

This guide is for a **[Tableau](https://hex.pm/packages/tableau)** site that already follows **[Tableau](tableau.html)** through design assets, ESM Esbuild, root layout, and `LiveSocket` hooks. It adds **light/dark** switching: `data-mode`, a before-paint inline script, **`<.toggle_group>`**, and **`mode.js`** for `localStorage` and `corex:set-mode`.

Phoenix’s pipeline in **[Dark mode](dark_mode.html)** sets **`data-mode`** per request from a cookie. Here, static HTML uses **build defaults + client reconciliation** and `prefers-color-scheme` inside the head script when nothing is stored.

If you use **[Tableau static + Corex: theming](tableau_theming.html)** as well, install **mode** after **theme** so `<head>` runs **`MyApp.Theme.head_script()`** then **`MyApp.Mode.head_script()`**. If you **only** want mode, keep a **single** theme CSS import and a **fixed** **`data-theme`** on `<html>` (for example **`neo`**) so palette tokens resolve.

---

### 1. `MyApp.Mode`

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

  def toggle_value("dark"), do: ["dark"]
  def toggle_value(_), do: []
end
```

---

### 2. CSS imports

Add **`toggle-group.css`** (see **[Tableau](tableau.html) §4** for the baseline stack):

```css
@import "../corex/components/toggle-group.css";
```

---

### 3. Root layout additions

In **`template/1`**:

```elixir
assigns = Map.put(assigns, :mode, MyApp.Mode.current(assigns))
```

On **`<html>`** (mode-only example with a fixed theme):

```heex
<html lang="en" dir="ltr" data-theme="neo" data-mode={@mode}>
```

If **[Tableau static + Corex: theming](tableau_theming.html)** already sets **`data-theme`**, **`data-themes`**, and **`data-default-theme`**, add only **`data-mode={@mode}`**.

Inside **`<head>`** (after **`MyApp.Theme.head_script`** when both guides apply):

```heex
{MyApp.Mode.head_script()}
```

---

### 4. `assets/js/mode.js`

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
    const value = mode === "dark" ? ["dark"] : []
    root.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", { detail: { value } }),
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
    const raw = e.detail?.value
    const isDark = Array.isArray(raw) && raw.includes("dark")
    applyMode(isDark ? "dark" : "light")
    whenControlReady("mode-switcher", syncModeFromDocument)
  })
})()
```

---

### 5. `assets/js/site.js` additions

```javascript
import "./mode.js"
```

Register **ToggleGroup**:

```javascript
    ...hooks({
      ToggleGroup: () => import("corex/toggle-group"),
      Accordion: () => import("corex/accordion"),
    }),
```

Merge with **`Select`** and **`theme.js`** from the theming guide if you use both.

---

### 6. Mode toggle HEEx

**`id="mode-switcher"`** matches **`mode.js`**. **`state-on`** / **`state-off`** swap icons with the toggle value.

```heex
<.toggle_group
  id="mode-switcher"
  class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
  multiple={false}
  deselectable={true}
  value={MyApp.Mode.toggle_value(@mode)}
  dir="ltr"
  on_value_change_client="corex:set-mode"
>
  <:item value="dark" aria_label="Toggle color mode">
    <.heroicon name="hero-sun" class="icon state-on" />
    <.heroicon name="hero-moon" class="icon state-off" />
  </:item>
</.toggle_group>
```

## Related

- [Tableau](tableau.html) — baseline Tableau + Corex setup.
- [Tableau static + Corex: theming](tableau_theming.html) — multi-theme **`data-theme`** and picker.
- [Dark mode](dark_mode.html) — Phoenix **`Plugs.Mode`** and cookie flow.
