# Theming

## Introduction

You wire a theme picker (neo, uno, duo, leo) into a Phoenix + Corex app. The result is `data-theme` on `<html>` that persists across reloads. Theme is independent from light/dark mode; Corex Design combines them as `[data-theme="neo"][data-mode="dark"]`.

Static Tableau sites use the same `data-theme` pattern without plugs—see [Tableau Theming](tableau_theming.html). Mode is covered in [Dark mode](dark_mode.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Corex installed | [Manual installation](manual_installation.html) or `mix corex.new --theme` |
| Theme CSS imported | One `@import` per theme you expose in the picker |
| `select` hook | Registered in `assets/js/app.js` |

## How it works

1. **`config :my_app, :themes`** is the single source of truth; the first entry is the default.
2. **`Plugs.Theme`** reads `phx_theme`, validates against config, assigns `:theme`.
3. **Bridge script** reconciles `localStorage`, `data-theme`, and the default.
4. **`<.select on_value_change_client="phx:set-theme">`** updates theme without a server round-trip.

<!-- tabs-open -->

### Config and plug

`config/config.exs`:

```elixir
config :my_app, :themes, ~w(neo uno duo leo)
```

`lib/my_app_web/plugs/theme.ex`:

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

Browser pipeline (after `:fetch_live_flash`; with `--lang`, put Mode/Theme plugs after localize plugs):

```elixir
plug MyAppWeb.Plugs.Mode
plug MyAppWeb.Plugs.Theme
```

### Layout and theme bridge

`root.html.heex`:

```heex
<html lang="en" data-theme={assigns[:theme] || "neo"} data-mode={assigns[:mode] || "light"}>
```

Theme bridge in `<head>` (merge into the same IIFE as [Dark mode](dark_mode.html) when you use both):

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

Keep `validThemes` and fallbacks in sync with `config :my_app, :themes`.

### Theme picker

```elixir
def theme_toggle(assigns) do
  ~H"""
  <.select
    id="theme-select"
    class="select ui-size-sm"
    items={[
      %{value: "neo", label: "Neo"},
      %{value: "uno", label: "Uno"},
      %{value: "duo", label: "Duo"},
      %{value: "leo", label: "Leo"}
    ]}
    value={[@theme]}
    on_value_change_client="phx:set-theme"
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
  """
end
```

```heex
<Layouts.app flash={@flash} theme={assigns[:theme] || "neo"} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

### LiveView on_mount

```elixir
defmodule MyAppWeb.ThemeLive do
  def on_mount(:default, _params, session, socket) do
    theme = session["theme"] || "neo"
    {:cont, Phoenix.Component.assign(socket, :theme, theme)}
  end
end
```

<!-- tabs-close -->

## CSS

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/theme/uno.css";
@import "../corex/theme/duo.css";
@import "../corex/theme/leo.css";
@import "../corex/components.css";
```

Include `select` in `components:` when you use a theme picker.

## Related

- [Dark mode](dark_mode.html) — combine bridges in one `<script>` block
- [Tableau Theming](tableau_theming.html) — static site equivalent
- [Localize](localize.html) — session layout hook may also assign theme and mode
