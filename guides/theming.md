# Theming

## Introduction

This guide explains how to set up **theme selection** using the `data-theme` attribute and the `Corex.Select` component in Phoenix LiveView.

Theme (neo, uno, duo, leo) is independent from mode (light/dark). The CSS token system uses both: `[data-theme="neo"][data-mode="dark"]`. See [Dark Mode](dark_mode.html) for mode setup.

This approach uses [Plugs](https://hexdocs.pm/plug/Plug.html) to load the correct theme on initial render, avoiding FOUC (Flash of Unstyled Content).

---

## Implementation

### 1. Create the Theme Plug

Create a plug that reads the theme from the `phx_theme` cookie and puts it in assigns and session:

```elixir
defmodule MyAppWeb.Plugs.Theme do
  @moduledoc """
  Reads the theme from the phx_theme cookie and puts it in assigns and session.
  Allows the server to render the correct theme in the initial HTML (no flash).
  """
  import Plug.Conn

  @valid_themes ~w(neo uno duo leo)

  def init(opts), do: opts

  def call(conn, _opts) do
    theme =
      conn.cookies["phx_theme"]
      |> parse_theme()

    conn
    |> assign(:theme, theme)
    |> put_session(:theme, theme)
  end

  defp parse_theme(nil), do: "neo"
  defp parse_theme(theme) when theme in @valid_themes, do: theme
  defp parse_theme(_), do: "neo"
end
```

### 2. Add the Plug to Your Router

Add the Theme plug to your browser pipeline:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug MyAppWeb.Plugs.Theme
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

### 3. Create the Theme Live Hook

Create a LiveView hook that assigns the theme from the session:

```elixir
defmodule MyAppWeb.ThemeLive do
  @moduledoc """
  Assigns the theme from the session to the LiveView socket.
  """
  def on_mount(:default, _params, session, socket) do
    theme = session["theme"] || "neo"

    {:cont, Phoenix.Component.assign(socket, :theme, theme)}
  end
end
```

Add it to your live sessions:

```elixir
live_session :default, on_mount: [MyAppWeb.ThemeLive, MyAppWeb.SharedEvents] do
  live "/", PageLive, :index
end
```

### 4. Configure Your Root Layout

Update your `root.html.heex` to use a dynamic `data-theme` attribute and add the theme script:

```heex
<html lang="en" data-theme={assigns[:theme] || "neo"}>
  <head>
    <script>
      (() => {
        const validThemes = ["neo", "uno", "duo", "leo"];
        const setTheme = (theme) => {
          const resolved = validThemes.includes(theme) ? theme : "neo";
          localStorage.setItem("phx:theme", resolved);
          document.cookie = "phx_theme=" + resolved + "; path=/; max-age=31536000";
          document.documentElement.setAttribute("data-theme", resolved);
        };

        setTheme(localStorage.getItem("phx:theme") || document.documentElement.getAttribute("data-theme") || "neo");

        window.addEventListener("storage", (e) => e.key === "phx:theme" && e.newValue && setTheme(e.newValue));

        window.addEventListener("phx:set-theme", (e) => {
          const value = e.detail?.value;
          const theme = Array.isArray(value) && value[0] ? value[0] : "neo";
          setTheme(theme);
        });
      })();
    </script>
  </head>
  <body>
    {@inner_content}
  </body>
</html>
```

### 5. Theme Select Component

Add a theme switcher using the Select component:

```elixir
attr :theme, :string,
  default: "neo",
  values: ["neo", "uno", "duo", "leo"],
  doc: "the theme from cookie/session"

def theme_toggle(assigns) do
  ~H"""
  <.select
    id="theme-select"
    class="select select--sm select--micro"
    collection={[
      %{id: "neo", label: "Neo"},
      %{id: "uno", label: "Uno"},
      %{id: "duo", label: "Duo"},
      %{id: "leo", label: "Leo"}
    ]}
    value={[@theme]}
    on_value_change_client="phx:set-theme"
  >
    <:label class="sr-only">
      Theme
    </:label>
    <:item :let={item}>
      {item.label}
    </:item>
    <:trigger>
      <.icon name="hero-swatch" />
    </:trigger>
    <:item_indicator>
      <.icon name="hero-check" />
    </:item_indicator>
  </.select>
  """
end
```

### 6. Styling

Import all theme CSS files so switching works. Each theme has light and dark variants, combined with `data-mode`:

```css
@import "../corex/tokens/themes/neo/light.css";
@import "../corex/tokens/themes/neo/dark.css";
@import "../corex/tokens/themes/uno/light.css";
@import "../corex/tokens/themes/uno/dark.css";
@import "../corex/tokens/themes/duo/light.css";
@import "../corex/tokens/themes/duo/dark.css";
@import "../corex/tokens/themes/leo/light.css";
@import "../corex/tokens/themes/leo/dark.css";
```

---

## Available Themes

- **neo**
- **uno**
- **duo**
- **leo**

Theme and mode are independent. The active selector is `[data-theme="neo"][data-mode="dark"]` for Neo in dark mode.

---

## Summary

1. The theme is read from the `phx_theme` cookie on initial load (via Theme plug)
2. The theme is stored in assigns and session
3. A client-side script in `root.html.heex` initializes and persists the theme
4. LiveView receives the theme via the ThemeLive `on_mount` hook
5. The Select component dispatches `phx:set-theme` on change
6. Both cookie and localStorage stay in sync for server and client

Theme logic is separate from mode logic: use distinct plugs, hooks, cookies, and scripts for each.
