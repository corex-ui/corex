# Theming

## Introduction

This guide walks through wiring a **theme picker** (skins like `neo`, `uno`, `duo`, `leo`) into a Phoenix + Corex app. The result is a `data-theme="neo"` attribute on `<html>` driven by the user's selection, persisted across reloads.

Theme is **independent** from light/dark mode. The Corex Design tokens combine the two: a CSS rule like `[data-theme="neo"][data-mode="dark"]` is what you'd target if you wanted Neo's dark variant. Mode is covered in [Dark mode](dark_mode.html); this guide is theme-only, but they share the same bridge script and slot together cleanly.

If you ran `mix corex.new my_app --theme`, the installer wrote everything below for you. Use this guide to understand what that produced, or to wire it by hand in an existing app.

See [Installation](installation.html) for Corex-only flags (including **`--mcp`**). For the underlying Corex install, see [Manual installation](manual_installation.html).

### The problem

Like dark mode, theme has to be known **at render time**. The server has to set the right `data-theme` on `<html>` so the first paint already uses the correct CSS tokens — switching client-side after paint causes a visible flash.

### The solution

The same three-layer pattern as dark mode:

1. **Cookie + Plug** — `Plugs.Theme` reads `phx_theme` and assigns `:theme`.
2. **Inline `<script>` in `<head>`** — reconciles `localStorage["phx:theme"]`, `data-theme`, and the configured default; persists the cookie back.
3. **`phx:set-theme` window event** — the Corex select dispatches it on change.

## 1. Configure the theme list

The Corex installer writes the available themes into your application config so the plug, the bridge script, and any UI can read the same list. In `config/config.exs`:

```elixir
config :my_app, :themes, ~w(neo uno duo leo)
```

The **first entry** is the default theme used when no cookie is set. Use the subset that matches the Corex Design themes you import in `app.css` — there is no point exposing `leo` in the picker if you never `@import "../corex/theme/leo.css"`.

## 2. Create the Theme plug

Create `lib/my_app_web/plugs/theme.ex`. It reads `phx_theme` from the cookies, validates it against your configured `:themes` list, and falls back to the first one when the cookie is missing or invalid. It also exposes the full list as `:themes` so the picker can render it without re-reading config. Use your real **`otp_app`** atom in **`Application.get_env/3`** (shown as **`:my_app`** below); **`mix corex.new`** emits the correct name automatically.

```elixir
defmodule MyAppWeb.Plugs.Theme do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    themes = Application.get_env(:my_app, :themes, ["neo"])
    default_theme = List.first(themes) || "neo"

    theme =
      conn.cookies["phx_theme"]
      |> parse_theme(themes, default_theme)

    conn
    |> assign(:theme, theme)
    |> assign(:themes, themes)
    |> put_session(:theme, theme)
  end

  defp parse_theme(nil, _themes, default), do: default

  defp parse_theme(theme, themes, default) do
    if theme in themes, do: theme, else: default
  end
end
```

## 3. Add the plug to the browser pipeline

Mount it in `lib/my_app_web/router.ex` **after** `:fetch_live_flash`. With **`mix corex.new --lang`**, **`Localize.Plug.PutLocale`** / **`PutSession`** run first; Mode and Theme plugs are inserted **after** those. If you only use mode/theme, the two plugs sit side by side (either order is fine).

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug MyAppWeb.Plugs.Mode
  plug MyAppWeb.Plugs.Theme
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

## 4. Update the root layout

In `lib/my_app_web/components/layouts/root.html.heex`, expose `data-theme` on `<html>` from the assign, defaulting to `"neo"` (or whichever theme you put first in `:themes`):

```heex
<!DOCTYPE html>
<html lang="en" data-theme={assigns[:theme] || "neo"} data-mode={assigns[:mode] || "light"}>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={get_csrf_token()} />
    <.live_title default="MyApp" suffix=" · Phoenix Framework">
      {assigns[:page_title]}
    </.live_title>
    <link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
    <script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
  </head>
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

`type="module"` on the `<script>` tag is required by the Corex JS bundle — see [Manual installation](manual_installation.html#4-root-layout-load-app-js-as-a-module) if you have not set it yet.

## 5. Add the bridge script

Inside `<head>`, **before** the closing `</head>`, add the bridge script. It runs synchronously on first paint, reconciles `localStorage` ↔ `data-theme` ↔ default, persists the cookie back, and listens for `phx:set-theme` from the picker.

If you already have the dark-mode bridge from [Dark mode](dark_mode.html#4-add-the-bridge-script), add this block right after it inside the same `<script>` IIFE — they share the same lifecycle.

```heex
<script>
  (() => {
    const validThemes = ["neo", "uno", "duo", "leo"];

    const setTheme = (theme) => {
      const resolved = validThemes.includes(theme) ? theme : "neo";
      localStorage.setItem("phx:theme", resolved);
      document.cookie = "phx_theme=" + resolved + "; path=/; max-age=31536000";
      document.documentElement.setAttribute("data-theme", resolved);
    };

    setTheme(
      localStorage.getItem("phx:theme") ||
        document.documentElement.getAttribute("data-theme") ||
        "neo"
    );

    window.addEventListener(
      "storage",
      (e) => e.key === "phx:theme" && e.newValue && setTheme(e.newValue)
    );

    window.addEventListener("phx:set-theme", (e) => {
      const value = e.detail?.value;
      const theme = Array.isArray(value) && value[0] ? value[0] : "neo";
      setTheme(theme);
    });
  })();
</script>
```

Keep `validThemes` and the fallback string in sync with your `config :my_app, :themes` list. If you only ship `neo` and `uno`, set `validThemes = ["neo", "uno"]`.

## 6. Add a theme picker to the app layout

Use `Corex.Select`. The `on_value_change_client="phx:set-theme"` attribute makes it dispatch the same window event the bridge script listens for — no `handle_event/3` needed.

In `lib/my_app_web/components/layouts.ex`, add a `:theme` attr to your `app/1` and render the picker in the header:

```elixir
attr :flash, :map, required: true, doc: "the map of flash messages"
attr :mode, :string, default: "light", doc: "current mode (light or dark)"
attr :theme, :string, default: "neo", doc: "current theme"
attr :current_scope, :map, default: nil

slot :inner_block, required: true

def app(assigns) do
  ~H"""
  <header class="layout__header">
    <div class="layout__header__content">
      <div class="layout__row">
        <.theme_toggle theme={@theme} />
        <.mode_toggle mode={@mode} />
      </div>
    </div>
  </header>
  <main class="layout__main">
    <div class="layout__content">
      {render_slot(@inner_block)}
    </div>
  </main>
  """
end

attr :theme, :string,
  default: "neo",
  values: ["neo", "uno", "duo", "leo"],
  doc: "current theme"

def theme_toggle(assigns) do
  ~H"""
  <.select
    id="theme-select"
    class="select select--sm"
    items={[
      %{value: "neo", label: "Neo"},
      %{value: "uno", label: "Uno"},
      %{value: "duo", label: "Duo"},
      %{value: "leo", label: "Leo"}
    ]}
    value={[@theme]}
    on_value_change_client="phx:set-theme"
  >
    <:label class="sr-only">
      Theme
    </:label>
    <:item :let={item}>{item.label}</:item>
    <:trigger>
      <.heroicon name="hero-swatch" class="icon" />
    </:trigger>
    <:item_indicator>
      <.heroicon name="hero-check" class="icon" />
    </:item_indicator>
  </.select>
  """
end
```

Then make sure every page passes `theme={@theme}` (or `theme={assigns[:theme] || "neo"}`) into the layout:

```heex
<Layouts.app flash={@flash} theme={assigns[:theme] || "neo"} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

For LiveViews, attach a small **`on_mount`** hook that pulls **`:theme`** from the session into the socket. If you used **`mix corex.new … --lang`**, the installer adds **`on_mount MyAppWeb.Hooks.Layout`** after **`use Phoenix.LiveView`**, which assigns **`theme`** (and **`mode`**, **`current_path`**) from the session — you only need a dedicated **`ThemeLive`** below if you do not use that hook.

```elixir
defmodule MyAppWeb.ThemeLive do
  def on_mount(:default, _params, session, socket) do
    theme = session["theme"] || "neo"
    {:cont, Phoenix.Component.assign(socket, :theme, theme)}
  end
end
```

```elixir
def live_view do
  quote do
    use Phoenix.LiveView

    on_mount MyAppWeb.ModeLive
    on_mount MyAppWeb.ThemeLive
    unquote(html_helpers())
  end
end
```

## 7. Styling

Import each theme you want available, plus the `select` component CSS that styles the picker. In `assets/css/app.css`:

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/theme/uno.css";
@import "../corex/theme/duo.css";
@import "../corex/theme/leo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/select.css";
```

Each `theme/*.css` file scopes its tokens under `[data-theme="<name>"]`, so all four can coexist in the same bundle — the active one is whichever the `<html>` attribute names.

If you also use Corex Design with [Dark mode](dark_mode.html), each theme file already defines a `[data-theme="<name>"][data-mode="dark"]` variant. Theme and mode compose without extra setup.

## 8. Changing the default theme

The default is the **first entry** of `config :my_app, :themes`. Reorder it to change the fallback for new visitors (and anyone who hasn't picked a theme yet):

```elixir
config :my_app, :themes, ~w(uno neo duo leo)
```

If you change the default, also update:

- The fallback in the bridge script (`"neo"` → your new default in **two** places).
- The `:theme` default in `Layouts.app/1` and any `theme_toggle/1` `attr :theme, default: ...`.
- The fallback in your `<html data-theme={... || "neo"}>` attribute.

`Plugs.Theme` already picks up `List.first(themes)` automatically.

## Summary

1. **Config** — `config :my_app, :themes, ~w(neo uno duo leo)` is the single source of truth; first entry is the default.
2. **Cookie** — `Plugs.Theme` reads `phx_theme`, validates against the config, assigns `:theme` and `:themes`.
3. **Server-rendered `data-theme`** — `<html data-theme={assigns[:theme] || "neo"}>` carries the value into the first paint.
4. **Inline `<script>` in `<head>`** — reconciles `localStorage` ↔ `data-theme` ↔ default, persists the cookie, and listens for `phx:set-theme`.
5. **`Corex.Select`** — `on_value_change_client="phx:set-theme"` dispatches the event the bridge listens for; no server round-trip.
6. **CSS** — every theme you list also has to be `@import`ed; `select.css` styles the picker.

## Related

- [Dark mode](dark_mode.html) — same pattern for `data-mode`; combine the two bridges in one `<script>` block.
- [Localize](localize.html) — **`Hooks.Layout`** carries session **theme**/**mode** when **`--lang`** is enabled.
- [Installation](installation.html) — the **`--theme`** flag wires the installer output; see also **`--mcp`** / **`--no-mcp`** there.
