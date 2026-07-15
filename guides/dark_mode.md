# Dark mode

Package: [corex_design](https://hexdocs.pm/corex_design). Full guide on **corex** Hexdocs.

## Introduction

Visitors switch light and dark appearance with a Corex `<.toggle>`. The choice updates `data-mode` on `<html>` without a server round-trip, drives Corex Design tokens, and matches what they chose on the last visit.

There is no OTP allowlist for mode (only `light` / `dark`). `config :corex_design, default_mode:` is a build-time default for generated CSS, not the runtime control. See [Configuration](configuration.html) and [Design](design.html). Static Tableau sites use the same `data-mode` idea without plugs; see [Tableau Mode](tableau_mode.html).

## Install first

Wire the mode plug, bridge script, and `toggle` hook before you drop this UI into a layout:

- New app: `mix corex.new my_app --mode`
- Existing app: [Manual installation: optional mode wiring](manual_installation.html#optional-mode-wiring)

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Plug | `MyAppWeb.Plugs.Mode` in the browser pipeline; assigns `:mode` |
| Bridge | Inline `<script>` in `<head>` listens for `phx:set-mode` and writes `localStorage` / cookie / `data-mode` |
| Hook | `Toggle` registered in `assets/js/app.js` |
| CSS | `@import "../corex/corex.css"` and `toggle` in `components:` when you use Design |

## Mode toggle

In `layouts.ex` (or a dedicated component module):

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
    class="toggle ui-size-sm"
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

`on_pressed_change_client="phx:set-mode"` fires a browser event the mode bridge handles (`pressed: true` → dark, `false` → light).

## Layout placement

Pass `mode` into the layout from every LiveView and controller template:

```heex
<Layouts.app flash={@flash} mode={assigns[:mode] || "light"}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

With LiveViews, ensure `:mode` is on the socket (session via `Plugs.Mode`, or `on_mount` / `Hooks.Layout` when you also use `--lang`). Root `<html>` should carry `data-mode={assigns[:mode] || "light"}` so the first paint matches the plug.

## CSS

```css
@import "../corex/corex.css";
```

`corex.css` loads utilities, themes, and components. Include `toggle` in `components:` when you use a mode switcher. For layered imports, see [Design](design.html).

Corex Design themes define `[data-mode=dark]` overrides. Custom CSS can target `[data-mode="dark"]` the same way.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Toggle does nothing | Bridge listens for `phx:set-mode`; `Toggle` hook is registered |
| Wrong pressed state | `pressed={@mode == "dark"}` and the layout receives `:mode` |
| Flash of wrong mode | Bridge `<script>` is in `<head>`; root `data-mode` matches the plug assign |
| Tabs drift | Bridge `storage` listener is present (install wiring) |

## Related

- [Manual installation](manual_installation.html#optional-mode-wiring): plug, bridge, and pipeline
- [Configuration](configuration.html): build vs picker vs generators
- [Theming](theming.html): `data-theme`; combine both bridges in one `<script>` IIFE
- [Tableau Mode](tableau_mode.html): static site equivalent
- [Installation](installation.html): `mix corex.new --mode`
