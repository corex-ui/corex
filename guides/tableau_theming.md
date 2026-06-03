# Tableau Theming

## Introduction

You add a multi-theme picker to a Tableau site that already follows [Tableau](tableau.html). Visitors get `data-theme` on `<html>`, a before-paint script, a Corex `<.select>`, and `theme.js` for `localStorage` and `corex:set-theme`.

For Phoenix apps with `Plugs.Theme` and cookies, see [Theming](theming.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| [Tableau](tableau.html) | Design assets, ESM Esbuild, `use Corex`, `LiveSocket` |
| `{:jason, "~> 1.0"}` | For `Jason.encode!/1` in `head_script/0` |

## How it works

1. **Config** lists allowed theme names; CSS must `@import` each theme file you expose.
2. **`head_script/0`** runs in `<head>` and sets `data-theme` from `localStorage` before paint.
3. **`theme.js`** syncs the picker after hydration and listens for `corex:set-theme`.
4. **`<.select id="theme-switcher">`** dispatches `corex:set-theme` on change.

<!-- tabs-open -->

### Config

In `config/config.exs`:

```elixir
config :my_app,
  site_name: "MyApp",
  themes: ~w(neo uno duo leo),
  default_theme: "neo"
```

Only list themes you import in CSS. The first entry in `themes` is the fallback when nothing is stored.

### Elixir

`lib/my_app/config.ex` (merge with locale fields if you use [Tableau Localize](tableau_localize.html)):

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

`lib/my_app/theme.ex`:

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

### CSS

Ensure [Tableau](tableau.html) baseline imports `./corex.tailwind.css` in `assets/css/site.css`. Built-in themes (neo, uno, duo, leo) ship in the generated `layers/theme.css`; switch with `data-theme` on `<html>`.

### Layout

In `RootLayout.template/1`, before `~H`:

```elixir
assigns = Map.put(assigns, :theme, MyApp.Theme.current(assigns))
```

On `<html>`:

```heex
<html
  lang="en"
  dir="ltr"
  data-theme={@theme}
  data-themes={Enum.join(MyApp.Config.themes(), ",")}
  data-default-theme={MyApp.Config.default_theme()}
>
```

In `<head>`, before stylesheets if you want the earliest paint (after charset/viewport is fine):

```heex
{MyApp.Theme.head_script()}
```

When you add [Tableau Localize](tableau_localize.html), set `lang` and `dir` from your locale module instead of fixed `en` / `ltr`.

### theme.js

Create `assets/js/theme.js`:

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

### site.js

At the top of `assets/js/site.js`:

```javascript
import "./theme.js"
```

Register `Select` in `hooks`:

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"
import "./theme.js"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Select: () => import("corex/select"),
      Accordion: () => import("corex/accordion"),
    }),
  },
})

liveSocket.connect()
```

### Picker

Place in your header or toolbar. `id="theme-switcher"` must match `theme.js`.

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

<!-- tabs-close -->

## Related

- [Tableau](tableau.html) — baseline setup
- [Tableau Mode](tableau_mode.html) — `data-mode`; call `Theme.head_script()` then `Mode.head_script()` in `<head>` when both are used
- [Theming](theming.html) — Phoenix plug and cookie flow
