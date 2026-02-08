# Dark Mode

## Introduction

This guide will walk you through setting up a **dark mode** toggle using the `Corex.ToggleGroup` component in Phoenix LiveView.

This approach uses [Plugs](https://hexdocs.pm/plug/Plug.html) to load the correct mode on initial render, affecting both styling and component initialization.

### The Problem

The classic approach using only local storage works well for CSS-only components, as data attributes are available as soon as the page starts to load (via the initial script in `root.html.heex`).

However, **Corex components** need to know their initial props on render to:
- Avoid FOUC (Flash of Unstyled Content)
- Initialize component accessibility correctly on page render

### The Solution

Use **both local storage and cookies** in conjunction with a Plug to get the current mode on render.

For LiveView, we add a **Live Hook** to assign the mode to the socket.

---

## Implementation

### 1. Create the Mode Plug

Create a plug that reads the mode from the `phx_mode` cookie and puts it in assigns and session. This allows the server to render the correct mode in the initial HTML without any flash.

```elixir
defmodule MyAppWeb.Plugs.Mode do
  @moduledoc """
  Reads the mode from the phx_mode cookie and puts it in assigns and session.
  Allows the server to render the correct mode in the initial HTML (no flash).
  """
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

### 2. Add the Plug to Your Router

Add the `MyAppWeb.Plugs.Mode` plug to your browser pipeline in `router.ex`:

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

### 3. Create the LiveView Mode Hook

Create a LiveView hook that assigns the mode from the session to the socket:

```elixir
defmodule MyAppWeb.ModeLive do
  @moduledoc """
  Assigns the mode from the session to the LiveView socket.
  """
  def on_mount(:default, _params, session, socket) do
    mode = session["mode"] || "light"

    {:cont, Phoenix.Component.assign(socket, :mode, mode)}
  end
end
```

### 4. Configure Your Web Module

Add the hook to your `live_view` function in your web module (typically `my_app_web.ex`):

```elixir
def live_view do
  quote do
    use Phoenix.LiveView

    on_mount MyAppWeb.ModeLive
    unquote(html_helpers())
  end
end
```

### 5. Configure Your Root Layout

Update your `root.html.heex` to include the `data-mode` attribute and the client-side script that handles mode switching:

```heex
<!DOCTYPE html>
<html lang="en" data-theme="neo" data-mode={assigns[:mode] || "light"}>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={get_csrf_token()} />
    <.live_title default="MyApp" suffix=" · Phoenix Framework">
      {assigns[:page_title]}
    </.live_title>
    <link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/js/app.js"}>
    </script>
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

        // Initialize mode from localStorage, server-rendered attribute, or system preference
        setMode(
          localStorage.getItem("phx:mode") || 
          document.documentElement.getAttribute("data-mode") || 
          getSystemMode()
        );

        // Sync mode across tabs
        window.addEventListener("storage", (e) => {
          if (e.key === "phx:mode" && e.newValue) {
            setMode(e.newValue);
          }
        });

        // Handle mode toggle from LiveView
        window.addEventListener("phx:set-mode", (e) => {
          const value = e.detail?.value;
          const mode = Array.isArray(value) && value[0] ? value[0] : "light";
          setMode(mode);
        });
      })();
    </script>
  </head>
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

**Key points about this script:**

- Runs immediately on page load (before body renders) to prevent FOUC
- Checks localStorage first for user preference
- Falls back to server-rendered `data-mode` attribute from the Plug
- Falls back to system preference if neither is available
- Syncs mode changes across browser tabs via `storage` event
- Listens for `phx:set-mode` events from the toggle component
- Updates both localStorage and cookie to keep client and server in sync

### 6. Update Your Layout Module

Create your layout with the mode toggle component:

We will add `attr :mode, :string, default: "light"` to our app and include the `Corex.ToggleGroup` 

```elixir
defmodule MyAppWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use MyAppWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash} mode={@mode}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :mode, :string, default: "light", doc: "the mode (dark or light) from cookie/session"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header>
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
    doc: "the mode (dark or light) from cookie/session"

  @doc """
  Provides dark vs light theme toggle using toggle_group.
  """
  def mode_toggle(assigns) do
    ~H"""
    <.toggle_group
      id="mode-switcher"
      class="toggle-group toggle-group--sm toggle-group--circle toggle-group--inverted"
      value={if @mode == "dark", do: ["dark"], else: []}
      on_value_change_client="phx:set-mode"
    >
      <:item value="dark">
        <.icon name="hero-sun" class="icon state-on" />
        <.icon name="hero-moon" class="icon state-off" />
      </:item>
    </.toggle_group>
    """
  end
end
```

### 7. Styling

If you followed the initial installation guide or using Corex Design you can import the toggle-group and dark mode css

```css
@import "../corex/tokens/themes/neo/light.css";
@import "../corex/tokens/themes/neo/dark.css";
@import "../corex/components/toggle-group.css";
```

---

## Summary

This implementation ensures that:

1. The mode is read from cookies on initial page load (via Plug)
2. The mode is available in both assigns and session
3. A client-side script in `root.html.heex` initializes the mode immediately to prevent FOUC
4. The script prioritizes: localStorage → server-rendered attribute → system preference
5. LiveView receives the mode through the `on_mount` hook
6. Components render with the correct mode from the start
7. Mode changes sync across browser tabs via localStorage events
8. Both cookie and localStorage are updated to keep client and server state in sync

The key is using a **triple-layer approach**:
- **Cookies** for server-side persistence (Plug)
- **localStorage** for client-side persistence across sessions
- **Immediate script execution** in the HTML head to prevent visual flash

This ensures seamless dark mode switching with no flicker, proper SSR support, and consistent state across tabs and page reloads.