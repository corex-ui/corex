# Dark mode

## Introduction

This guide walks through wiring **light/dark mode** into a Phoenix + Corex app. The result is a `data-mode="light"` or `data-mode="dark"` attribute on `<html>` that drives CSS (including the Corex Design `dark` variant) and a server-rendered initial value that matches what the user picked previously.

If you ran `mix corex.new my_app --mode`, the installer wrote everything below for you. Use this guide either to understand what that produced, or to wire it by hand in an existing app.

See [Installation](installation.html) for Corex-only flags (including **`--mcp`**). For the underlying Corex install, see [Manual installation](manual_installation.html).

### The problem

The classic "toggle a class on `<html>` from JS" approach is fine for purely CSS-driven components, but Corex components need to know the active mode **at render time** to:

- Avoid Flash of Unstyled Content (FOUC) on the first paint
- Initialize their state machines and ARIA attributes correctly on mount

If the server renders one mode and the client immediately switches to another, you get a flicker, and any component that ran its `mounted()` hook with the wrong attribute is now stale.

### The solution

Use **three** layers in concert:

1. **Cookie + Plug**  -  the server reads a `phx_mode` cookie and assigns `:mode` so the initial HTML carries the right `data-mode`.
2. **Inline `<script>` in `<head>`**  -  runs before `<body>` paints; reconciles `localStorage` ↔ `data-mode` ↔ `prefers-color-scheme`, then writes the cookie back so the next request matches.
3. **`phx:set-mode` window event**  -  the Corex toggle dispatches it on change; the bridge script listens and updates everything.

## 1. Create the Mode plug

Create `lib/my_app_web/plugs/mode.ex`. It reads the `phx_mode` cookie, normalises it, and assigns `:mode` for the layout. It also writes the value to the session so LiveView mounts can read it back.

```elixir
defmodule MyAppWeb.Plugs.Mode do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    mode =
      conn.cookies["phx_mode"]
      |> parse_mode()

    conn
    |> assign(:mode, mode)
    |> put_session(:mode, mode)
  end

  defp parse_mode("dark"), do: "dark"
  defp parse_mode(_), do: "light"
end
```

`parse_mode/1` falls back to `"light"` for any unknown or missing cookie value, which guarantees `assigns[:mode]` is always a non-nil string.

## 2. Add the plug to the browser pipeline

Mount the plug in `lib/my_app_web/router.ex` **after** `:fetch_live_flash`. The order matters: flash needs to run first so `Plugs.Mode` doesn't interfere with the LiveView flash machinery.

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug MyAppWeb.Plugs.Mode
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

## 3. Update the root layout

In `lib/my_app_web/components/layouts/root.html.heex`, expose `data-mode` on `<html>` from the assign, with `"light"` as the fallback:

**Hand-wired layout**

```heex
<!DOCTYPE html>
<html lang="en" data-mode={assigns[:mode] || "light"}>
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

**`mix corex.new` with `--design`**

When Corex Design is on, the generated root layout may set static **`data-theme`** / **`data-mode="light"`** placeholders on **`<html>`** while **`Plugs.Mode`** still assigns **`conn`** for controllers. The **bridge script** (step 4) runs in **`<head>`** before paint and reconciles **`localStorage`**, the attribute on **`<html>`**, and **`prefers-color-scheme`**, so the effective mode still matches the user before the body renders. If you need the first byte of HTML to echo the cookie exactly, switch the template to **`data-mode={assigns[:mode] || "light"}`** as above.

## 4. Add the bridge script

Inside `<head>`, **before** the closing `</head>`, add the bridge script. It runs synchronously on first paint, reconciles `localStorage` ↔ `data-mode` ↔ system preference, persists the result back to the `phx_mode` cookie, and listens for the `phx:set-mode` event the Corex toggle dispatches.

```heex
<script>
  (() => {
    const getSystemMode = () =>
      window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

    const setMode = (mode) => {
      const resolved = mode === "dark" || mode === "light" ? mode : getSystemMode();
      localStorage.setItem("phx:mode", resolved);
      document.cookie = "phx_mode=" + resolved + "; path=/; max-age=31536000";
      document.documentElement.setAttribute("data-mode", resolved);
    };

    setMode(
      localStorage.getItem("phx:mode") ||
        document.documentElement.getAttribute("data-mode") ||
        getSystemMode()
    );

    window.addEventListener(
      "storage",
      (e) => e.key === "phx:mode" && e.newValue && setMode(e.newValue)
    );

    window.addEventListener("phx:set-mode", (e) => {
      const value = e.detail?.value;
      const mode = Array.isArray(value) && value[0] ? value[0] : "light";
      setMode(mode);
    });
  })();
</script>
```

The resolution order is deliberate:

1. `localStorage["phx:mode"]`  -  what the user explicitly chose last time
2. `document.documentElement.getAttribute("data-mode")`  -  what the server rendered (from the cookie via `Plugs.Mode`)
3. `prefers-color-scheme`  -  fallback when neither exists

Because the script runs in `<head>` synchronously, the page never paints with the wrong mode.

## 5. Add a mode toggle to the app layout

Use `Corex.ToggleGroup`. The `on_value_change_client="phx:set-mode"` attribute makes it dispatch the same window event the bridge script listens for, no `handle_event/3` round-trip.

In `lib/my_app_web/components/layouts.ex`, add a `:mode` attr to your `app/1` and render the toggle inside the header:

```elixir
attr :flash, :map, required: true, doc: "the map of flash messages"
attr :mode, :string, default: "light", doc: "current mode (light or dark) from the session"
attr :current_scope, :map, default: nil

slot :inner_block, required: true

def app(assigns) do
  ~H"""
  <header class="layout__header">
    <.mode_toggle mode={@mode} />
  </header>
  <main class="layout__main">
    <div class="layout__content">
      {render_slot(@inner_block)}
    </div>
  </main>
  """
end

attr :mode, :string,
  default: "light",
  values: ["light", "dark"],
  doc: "current mode (light or dark)"

def mode_toggle(assigns) do
  ~H"""
  <.toggle_group
    id="mode-switcher"
    class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
    value={if @mode == "dark", do: ["dark"], else: []}
    on_value_change_client="phx:set-mode"
  >
    <:item value="dark">
      <.heroicon name="hero-sun" class="icon state-on" />
      <.heroicon name="hero-moon" class="icon state-off" />
    </:item>
  </.toggle_group>
  """
end
```

The **`toggle-group--duo`** class matches **`mix corex.new --mode`**. You can use **`toggle-group--inverted`** or other modifiers instead if you prefer a different Corex Design variant.

Then make sure every page that renders the layout passes `mode={@mode}` (or `mode={assigns[:mode] || "light"}`) into it:

```heex
<Layouts.app flash={@flash} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

For LiveViews, attach a small **`on_mount`** hook that pulls **`:mode`** from the session into the socket. If you used **`mix corex.new … --lang`**, the installer adds **`on_mount MyAppWeb.Hooks.Layout`** after **`use Phoenix.LiveView`**, which assigns **`mode`** (and **`theme`**, **`current_path`**) from the session  -  you do not need a separate **`ModeLive`** in that setup unless you remove that hook.

```elixir
defmodule MyAppWeb.ModeLive do
  def on_mount(:default, _params, session, socket) do
    mode = session["mode"] || "light"
    {:cont, Phoenix.Component.assign(socket, :mode, mode)}
  end
end
```

```elixir
def live_view do
  quote do
    use Phoenix.LiveView

    on_mount MyAppWeb.ModeLive
    unquote(html_helpers())
  end
end
```

## 6. Styling

If you are using **Corex Design**, make sure `assets/css/app.css` includes the `toggle-group` component CSS  -  that's what styles the toggle you just added  -  alongside any theme/dark CSS you depend on:

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/toggle-group.css";
```

The Corex Design themes already define `[data-mode=dark]` overrides, so once `<html>` flips to `data-mode="dark"`, your tokens cascade automatically. If you write your own CSS, target the same selector:

```css
[data-mode="dark"] .my-card {
  background: #111;
  color: #f5f5f5;
}
```

## Troubleshooting

**Wrong mode on first paint.** Confirm the bridge `<script>` is in `<head>` (not `<body>`), `MyAppWeb.Plugs.Mode` runs in the browser pipeline, and the `phx_mode` cookie value matches what the script computes. FOUC almost always traces back to one of those three.

**Mode changes don't persist across tabs.** The bridge script listens for `storage` events. Make sure you have not stripped that listener  -  without it, two open tabs can drift.

**Mode resets on every navigation.** The cookie's `path` is `/`. If you scoped it differently or your reverse proxy rewrites cookies, the server-side `Plugs.Mode` reads `nil` and falls back to `"light"`.

## Summary

1. **Cookie**  -  `Plugs.Mode` reads `phx_mode` and assigns `:mode` for the initial render and the session.
2. **Server-rendered `data-mode`**  -  `<html data-mode={assigns[:mode] || "light"}>` carries the value into the first paint.
3. **Inline `<script>` in `<head>`**  -  reconciles `localStorage` ↔ `data-mode` ↔ system preference, persists the cookie, and listens for `phx:set-mode`.
4. **`Corex.ToggleGroup`**  -  `on_value_change_client="phx:set-mode"` dispatches the event the bridge listens for, so the toggle works without a server round-trip.
5. **LiveView `on_mount`**  -  pulls `:mode` from the session so LiveViews see the same value as the initial render.

Together these layers give you no-flicker dark mode that survives reloads, navigation, and multiple tabs.

## Related

- [Theming](theming.html)  -  orthogonal `data-theme` switcher; the bridge script extends to handle both.
- [Installation](installation.html)  -  the **`--mode`** flag wires the installer output; see also **`--mcp`** / **`--no-mcp`** there.
- [Localize](localize.html)  -  **`Hooks.Layout`** combines locale routing with session **mode**/**theme** when **`--lang`** is enabled.
