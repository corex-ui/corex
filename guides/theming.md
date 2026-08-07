# Theming

Package: [corex_design](https://hexdocs.pm/corex_design). Full guide on **corex** Hexdocs.

## Introduction

Visitors pick a Corex Design theme (neo, uno, duo, leo) from a `<.select>`. The choice updates `data-theme` on `<html>` without a server round-trip, and persists across reloads.

Each preset is a full personality pack: muted brand color, shared status colors (alert / info / success), plus density, radius, shadow, blur, focus ring geometry, border width, and motion durations. Switching themes should change how the UI feels, not only the brand hue.

Theme is independent from light/dark mode. Corex Design combines them as `[data-theme="neo"][data-mode="dark"]`. Mode is covered in [Dark mode](dark_mode.html). Static Tableau sites use the same picker pattern without plugs; see [Tableau Theming](tableau_theming.html).

## Install first

Wire the picker allowlist, plug, bridge script, and `select` hook before you drop this UI into a layout:

- New app: `mix corex.new my_app --theme`
- Existing app: [Manual installation: optional theme wiring](manual_installation.html#optional-theme-wiring)

Which theme CSS the design build emits is separate (`config :corex_design`). See [Design](design.html) and [Configuration](configuration.html). Keep the picker list a subset of the themes you build. Run `mix corex.design.options` for allowed build values.

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Config | `config :my_app, :themes, ~w(neo uno duo leo)` (first entry is the default) |
| Plug | `MyAppWeb.Plugs.Theme` in the browser pipeline; assigns `:theme` / `:themes` |
| Bridge | Inline `<script>` listens for `phx:set-theme` and writes `localStorage` / cookie / `data-theme` |
| Hook | `Select` registered in `assets/js/app.js` |
| CSS | `@import "../corex/corex.css"` and `select` in `components:` when you use Design |

## Theme picker

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
      <.heroicon name="hero-swatch" />
    </:trigger>
    <:item_indicator>
      <.heroicon name="hero-check" />
    </:item_indicator>
  </.select>
  """
end
```

`on_value_change_client="phx:set-theme"` fires a browser event the theme bridge handles. Keep the `items` values in sync with `config :my_app, :themes` and with `validThemes` in the bridge.

## Layout placement

Pass `:theme` (and `:mode` when you use both) into the app layout from every LiveView and controller template:

```heex
<Layouts.app flash={@flash} theme={assigns[:theme] || "neo"} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

Render the picker where it belongs in the shell (header, menu, footer):

```heex
<.theme_toggle theme={@theme} />
```

With LiveViews, ensure `:theme` is on the socket (session via `Plugs.Theme`, or `on_mount` / `Hooks.Layout` when you also use `--lang`). Root `<html>` should carry `data-theme={assigns[:theme] || "neo"}` so the first paint matches the plug.

## CSS

```css
@import "../corex/corex.css";
```

`corex.css` loads utilities, configured themes, and `components.css`. Include `select` in `components:` when you use a theme picker. For layered imports, see [Design](design.html).

## Bridge {: #bridge}

Before-paint script in `<head>` (merge into the same IIFE as [Dark mode](dark_mode.html#bridge) when you use both):

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

Keep `validThemes` in sync with `config :my_app, :themes` and the picker `items`.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Picker does nothing | Bridge listens for `phx:set-theme`; `Select` hook is registered |
| Wrong theme selected | `value={[@theme]}` matches an item `value`; plug assign reaches the layout |
| Theme flashes then resets | Bridge `validThemes` matches config and picker items |
| Styles missing for a theme | That theme is in `config :corex_design` and you rebuilt with `mix corex.design.build` |

## Related

- [Manual installation](manual_installation.html#optional-theme-wiring): plug, bridge, and config
- [Configuration](configuration.html): build vs picker vs generators
- [Design](design.html): `config :corex_design` theme CSS
- [Dark mode](dark_mode.html): mode toggle; combine bridges in one `<script>` block
- [Accessibility](accessibility.html): optional preference axes; same bridge pattern
- [Tableau Theming](tableau_theming.html): static site equivalent
- [Localize](localize.html): language switcher when using `--lang`
