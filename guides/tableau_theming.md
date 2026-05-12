# Tableau static + Corex: theming

This guide is for a **[Tableau](https://hex.pm/packages/tableau)** site that already follows **[Tableau](tableau.html)** through design assets, ESM Esbuild, root layout, and `LiveSocket` hooks. It adds **multi-theme** support: `data-theme`, a before-paint inline script, a **theme** `<.select>`, and **`theme.js`** for `localStorage` and `corex:set-theme`.

Static HTML cannot run Phoenix’s theme plug on each request; the ideas in **[Theming](theming.html)** (cookie, `data-theme` from the server) translate here to **build-time defaults plus client reconciliation**. You can still share the same token bundles as a Phoenix app.

Prerequisites: **`{:jason, "~> 1.0"}`** (or another JSON encoder) in **`mix.exs`** for `Jason.encode!/1` in **`head_script`**.

---

### 1. App config

In **`config/config.exs`**:

```elixir
config :my_app,
  site_name: "MyApp",
  themes: ~w(neo uno duo leo),
  default_theme: "neo"
```

Expose only themes you **`@import`** in CSS. The first entry in **`themes`** is a safe fallback when nothing is stored yet.

---

### 2. `MyApp.Config` (theme slice)

If you already have **`MyApp.Config`**, merge **`themes`**, **`default_theme`**, and **`site_name`** into it. Otherwise add:

```elixir
defmodule MyApp.Config do
  @app :my_app

  def site_name, do: Application.get_env(@app, :site_name, "MyApp")

  def themes, do: Application.get_env(@app, :themes, ["neo"])

  def default_theme do
    Application.get_env(@app, :default_theme) || List.first(themes()) || "neo"
  end
end
```

---

### 3. `MyApp.Theme`

```elixir
defmodule MyApp.Theme do
  def themes, do: MyApp.Config.themes()
  def default_theme, do: MyApp.Config.default_theme()

  def head_script do
    themes_json = Jason.encode!(themes())
    default_theme_json = Jason.encode!(default_theme())

    Phoenix.HTML.raw("""
    <script>
      try {
        const themes = #{themes_json};
        const dt = #{default_theme_json};
        const t = localStorage.getItem("data-theme");
        const theme = themes.includes(t) ? t : dt;
        document.documentElement.setAttribute("data-theme", theme);
      } catch (_) {}
    </script>
    """)
  end

  def current(assigns) do
    list = themes()
    d = default_theme()

    case Map.get(assigns, :theme) do
      t when is_binary(t) -> if(t in list, do: t, else: d)
      _ -> d
    end
  end

  def select_items do
    themes()
    |> Enum.map(fn t -> %{value: t, label: String.capitalize(t)} end)
    |> Corex.List.new()
  end
end
```

---

### 4. CSS imports

Add **`select.css`** plus every theme CSS file you listed in config (see **[Tableau](tableau.html) §4** for the base imports):

```css
@import "../corex/components/select.css";

@import "../corex/theme/uno.css";
@import "../corex/theme/duo.css";
@import "../corex/theme/leo.css";
```

Skip the extra **`@import`s** if you only ship **`neo`**.

---

### 5. Root layout additions

In **`template/1`**, put **`@theme`** on assigns (defaulting through **`MyApp.Theme.current/1`**):

```elixir
assigns = Map.put(assigns, :theme, MyApp.Theme.current(assigns))
```

Add attributes and the head script inside the existing **`<html>`** / **`<head>`** from **[Tableau](tableau.html)**:

```heex
<html
  lang="en"
  dir="ltr"
  data-theme={@theme}
  data-themes={Enum.join(MyApp.Config.themes(), ",")}
  data-default-theme={MyApp.Config.default_theme()}
>
```

```heex
<head>
  {MyApp.Theme.head_script()}
```

Use **`lang`**, **`dir`**, and Gettext-driven copy from **[Tableau static + Corex: localize](tableau_localize.html)** when you add locales.

---

### 6. `assets/js/theme.js`

Self-contained module (no separate shared file). It keeps the theme `<.select>` in sync after hydration.

```javascript
;(() => {
  const html = () => document.documentElement

  const parseList = (attr) =>
    (html().getAttribute(attr) || "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean)

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

  const firstDetailValue = (e) => {
    const value = e.detail?.value
    return Array.isArray(value) && value[0] ? value[0] : null
  }

  const validThemes = () => parseList("data-themes")
  const defaultTheme = () =>
    html().getAttribute("data-default-theme") || validThemes()[0] || "neo"
  const readStoredTheme = () => localStorage.getItem("data-theme")

  const syncThemeSelect = (value) => {
    const root = document.getElementById("theme-switcher")
    if (!root || !value) return
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [value] } }),
    )
  }

  const applyTheme = (theme) => {
    const themes = validThemes()
    const dt = defaultTheme()
    const resolved = themes.includes(theme) ? theme : dt
    localStorage.setItem("data-theme", resolved)
    html().setAttribute("data-theme", resolved)
    return resolved
  }

  const syncThemeFromDocument = () => {
    const t = html().getAttribute("data-theme") || defaultTheme()
    const themes = validThemes()
    const dt = defaultTheme()
    syncThemeSelect(themes.includes(t) ? t : dt)
  }

  applyTheme(
    readStoredTheme() || html().getAttribute("data-theme") || defaultTheme(),
  )

  whenControlReady("theme-switcher", syncThemeFromDocument)

  window.addEventListener("storage", (e) => {
    if (e.key === "data-theme" && e.newValue) {
      applyTheme(e.newValue)
      whenControlReady("theme-switcher", syncThemeFromDocument)
    }
  })

  window.addEventListener("corex:set-theme", (e) => {
    const v = firstDetailValue(e)
    applyTheme(v || defaultTheme())
    whenControlReady("theme-switcher", syncThemeFromDocument)
  })
})()
```

---

### 7. `assets/js/site.js` additions

At the **top** of **`site.js`** (before `LiveSocket`):

```javascript
import "./theme.js"
```

Register the **Select** hook:

```javascript
    ...hooks({
      Select: () => import("corex/select"),
      Accordion: () => import("corex/accordion"),
    }),
```

---

### 8. Theme picker HEEx

Place where you want the control; **`id="theme-switcher"`** must match **`theme.js`**.

```heex
<.select
  id="theme-switcher"
  class="select select--sm"
  dir="ltr"
  items={MyApp.Theme.select_items()}
  value={[@theme]}
  close_on_select={false}
  update_trigger={false}
  on_value_change_client="corex:set-theme"
  translation={%Corex.Select.Translation{placeholder: "Theme"}}
>
  <:label class="sr-only">Theme</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger>
    <.heroicon name="hero-swatch" class="icon" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" class="icon" />
  </:item_indicator>
</.select>
```

With Gettext, replace placeholder and labels with **`gettext/1`** as in **[Tableau static + Corex: localize](tableau_localize.html)**.

## Related

- [Tableau](tableau.html) — baseline Tableau + Corex setup.
- [Tableau static + Corex: mode](tableau_mode.html) — **`data-mode`** and toggle (order **`Theme.head_script`** then **`Mode.head_script`** in `<head>` when both are used).
- [Theming](theming.html) — Phoenix plugs and cookies.
