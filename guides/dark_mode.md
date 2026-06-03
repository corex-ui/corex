# Dark mode

## Introduction

You wire light/dark mode into a Phoenix + Corex app. The result is `data-mode="light"` or `data-mode="dark"` on `<html>` that drives Corex Design tokens and matches what the user chose on the last visit.

Static Tableau sites use the same `data-mode` idea without plugs—see [Tableau Mode](tableau_mode.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Corex installed | [Manual installation](manual_installation.html) or `mix corex.new --mode` |
| Corex Design (optional) | `toggle.css` and theme files with `[data-mode=dark]` variants |
| `toggle` hook | Registered in `assets/js/app.js` |

## How it works

1. **`Plugs.Mode`** reads the `phx_mode` cookie and assigns `:mode` for the first HTML byte.
2. **`<html data-mode={...}>`** carries that value into the document.
3. **Inline `<script>` in `<head>`** reconciles `localStorage`, `data-mode`, and `prefers-color-scheme`, then writes the cookie back.
4. **`<.toggle on_pressed_change_client="phx:set-mode">`** updates mode without a server round-trip.
5. **`on_mount`** copies `:mode` from the session into LiveViews.

<!-- tabs-open -->

### Plug and layout

Create `lib/my_app_web/plugs/mode.ex`:

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

In `router.ex`, mount **after** `:fetch_live_flash`:

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

In `root.html.heex`:

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

### Bridge script

Inside `<head>`, before `</head>`:

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
      const detail = e.detail;
      if (typeof detail?.pressed === "boolean") {
        setMode(detail.pressed ? "dark" : "light");
        return;
      }
      const value = detail?.value;
      const mode = Array.isArray(value) && value[0] ? value[0] : "light";
      setMode(mode);
    });
  })();
</script>
```

Resolution order: `localStorage["phx:mode"]`, then `data-mode` from the server, then `prefers-color-scheme`.

### Toggle

In `layouts.ex`:

```elixir
attr :flash, :map, required: true
attr :mode, :string, default: "light"
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

attr :mode, :string, default: "light", values: ["light", "dark"]

def mode_toggle(assigns) do
  ~H"""
  <.toggle
    id="mode-switcher"
    class="toggle toggle--sm"
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
  """
end
```

Pass `mode` into the layout from every LiveView and controller template:

```heex
<Layouts.app flash={@flash} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

### LiveView on_mount

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

If you use `mix corex.new --lang`, `on_mount MyAppWeb.Hooks.Layout` may already assign `:mode` from the session.

<!-- tabs-close -->

## CSS

```css
@import "./corex.tailwind.css";
```

Corex Design themes define `[data-mode=dark]` overrides. Custom CSS can target `[data-mode="dark"]` the same way.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Wrong mode on first paint | Bridge `<script>` is in `<head>`; `Plugs.Mode` runs in the browser pipeline |
| Tabs drift | `storage` listener is present in the bridge script |
| Resets every navigation | Cookie uses `path=/` |

## Related

- [Theming](theming.html) — `data-theme`; combine both bridges in one `<script>` IIFE
- [Tableau Mode](tableau_mode.html) — static site equivalent
- [Installation](installation.html) — `mix corex.new --mode`
