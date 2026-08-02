# Accessibility preferences

Package: [corex_design](https://hexdocs.pm/corex_design). Full guide on **corex** Hexdocs.

## Introduction

Corex Design can emit optional preference CSS driven by orthogonal `data-*` attributes on `<html>` (text zoom, contrast, motion, cursor, focus, links). Visitors change those axes from a small panel in your app; the choice persists in `localStorage` and a cookie, the same way theme and mode do.

The panel UI is app-owned. Design only builds the CSS and exposes `Corex.Design.Accessibility` helpers for allowlists, defaults, and sanitize/parse. Off by default: set `config :corex_design, accessibility:` and rebuild.

New apps: `mix corex.new my_app --a11y` or `mix corex.tableau.new my_site --a11y` (default off).

## Enable in Design

In `config/config.exs`:

```elixir
config :corex_design,
  accessibility: true
```

`true` enables the preferred axes (`:text`, `:focus`, `:links`). Motion follows `prefers-reduced-motion` in recipes; contrast starts from `prefers-contrast`. Or enable a subset / extra axes:

```elixir
config :corex_design,
  accessibility: [:text, :focus, :links, :contrast]
```

Allowed axes: `:text`, `:contrast`, `:motion`, `:cursor`, `:focus`, `:links`. `false` (default) emits no preference CSS.

Rebuild:

```bash
mix corex.design.build
mix assets.build
```

`corex.css` pulls in `preferences.css` when any axis is enabled. See [Design](design.html) and [Configuration](configuration.html).

## What each axis does

| Axis | Attribute | Values | Effect |
| ---- | --------- | ------ | ------ |
| Text | `data-text` | `md` (default), `lg` | Larger text (`font-size: 125%`) |
| Contrast | `data-contrast` | `normal`, `more` | Higher-contrast palette overrides |
| Motion | `data-motion` | `system`, `reduce` | Near-zero theme durations |
| Cursor | `data-cursor` | `normal`, `large` | Larger custom cursor |
| Focus | `data-focus` | `normal`, `strong` | Thicker focus ring tokens |
| Links | `data-links` | `normal`, `underline` | Underline links (skip link excluded) |

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Config | `config :corex_design, accessibility: true` (or an axis list) |
| Plug | `MyAppWeb.Plugs.Accessibility` in the browser pipeline; assigns `:a11y` |
| Live | `on_mount` copies session `:a11y` onto the socket |
| Bridge | Inline `<script>` in `<head>` listens for `phx:set-a11y-*` / reset and writes `localStorage` / cookie / `data-*` |
| Hooks | `Dialog` and `ToggleGroup` registered in `assets/js/app.js` |
| CSS | `@import "../corex/corex.css"` after a design rebuild with accessibility on |
| Root | `<html>` carries `data-text`, `data-contrast`, … from the `:a11y` assign |

## Plug

```elixir
defmodule MyAppWeb.Plugs.Accessibility do
  import Plug.Conn

  alias Corex.Design.Accessibility

  def init(opts), do: opts

  def call(conn, _opts) do
    a11y =
      conn.cookies
      |> Map.get("phx_a11y", "")
      |> Accessibility.parse()

    conn
    |> assign(:a11y, a11y)
    |> put_session(:a11y, a11y)
  end
end
```

In `router.ex`, mount after `:fetch_live_flash` (and after theme/mode plugs when you use those):

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug MyAppWeb.Plugs.Accessibility
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

## LiveView assign

```elixir
defmodule MyAppWeb.AccessibilityLive do
  def on_mount(:default, _params, session, socket) do
    a11y = session["a11y"] || Corex.Design.Accessibility.defaults()
    {:cont, Phoenix.Component.assign(socket, :a11y, a11y)}
  end
end
```

Register on the live session:

```elixir
live_session :default, on_mount: [MyAppWeb.AccessibilityLive] do
  # ...
end
```

## Root layout

Apply sanitized attrs on `<html>` and keep the FOUC bridge in `<head>`:

```elixir
defp a11y_data_attrs(nil), do: a11y_data_attrs(%{})

defp a11y_data_attrs(a11y) when is_map(a11y) do
  a11y
  |> Corex.Design.Accessibility.sanitize()
  |> Map.new(fn {key, value} -> {"data-#{key}", value} end)
end
```

```heex
<html
  lang="en"
  data-theme={assigns[:theme] || "neo"}
  data-mode={assigns[:mode] || "light"}
  {a11y_data_attrs(assigns[:a11y])}
>
```

Bridge (merge into the same IIFE as [Theming](theming.html) / [Dark mode](dark_mode.html) when you use those):

```heex
<script>
  (() => {
    const a11yAxes = <%= raw(Jason.encode!(Enum.map(Corex.Design.Accessibility.axes(), &Atom.to_string/1))) %>;
    const a11yDefaults = <%= raw(Jason.encode!(Corex.Design.Accessibility.defaults())) %>;
    const a11yValues = <%= raw(Jason.encode!(Map.new(Corex.Design.Accessibility.axes(), fn axis ->
      {Atom.to_string(axis), Corex.Design.Accessibility.values(axis)}
    end))) %>;

    const readA11y = () => {
      const raw = localStorage.getItem("phx:a11y") || "";
      const parsed = Object.fromEntries(new URLSearchParams(raw).entries());
      const next = { ...a11yDefaults };
      for (const axis of a11yAxes) {
        const value = parsed[axis];
        if (value && (a11yValues[axis] || []).includes(value)) next[axis] = value;
      }
      return next;
    };

    const writeA11y = (state) => {
      const params = new URLSearchParams();
      for (const axis of a11yAxes) params.set(axis, state[axis]);
      const encoded = params.toString();
      localStorage.setItem("phx:a11y", encoded);
      document.cookie = "phx_a11y=" + encodeURIComponent(encoded) + "; path=/; max-age=31536000";
      for (const axis of a11yAxes) {
        document.documentElement.setAttribute("data-" + axis, state[axis]);
      }
    };

    const syncA11yControls = (state) => {
      for (const axis of a11yAxes) {
        const el = document.getElementById("a11y-" + axis);
        if (!el) continue;
        el.dispatchEvent(
          new CustomEvent("corex:toggle-group:set-value", {
            bubbles: false,
            detail: { value: [state[axis]] },
          })
        );
      }
    };

    if (a11yAxes.length) {
      const initial = readA11y();
      writeA11y(initial);

      const controlReady = (axis) => {
        const el = document.getElementById("a11y-" + axis);
        return el && !el.hasAttribute("data-loading");
      };
      const syncWhenReady = () => {
        if (a11yAxes.every(controlReady)) {
          syncA11yControls(initial);
          return true;
        }
        return false;
      };
      if (!syncWhenReady()) {
        const observer = new MutationObserver(() => {
          if (syncWhenReady()) observer.disconnect();
        });
        observer.observe(document.documentElement, {
          childList: true,
          subtree: true,
          attributes: true,
          attributeFilter: ["data-loading"],
        });
      }

      window.addEventListener("storage", (e) => {
        if (e.key === "phx:a11y" && e.newValue != null) {
          const state = readA11y();
          writeA11y(state);
          syncA11yControls(state);
        }
      });

      for (const axis of a11yAxes) {
        window.addEventListener("phx:set-a11y-" + axis, (e) => {
          const value = e.detail?.value;
          const next = Array.isArray(value) && value[0] ? value[0] : a11yDefaults[axis];
          if (!(a11yValues[axis] || []).includes(next)) return;
          writeA11y({ ...readA11y(), [axis]: next });
        });
      }

      window.addEventListener("phx:set-a11y-reset", () => {
        const state = { ...a11yDefaults };
        writeA11y(state);
        syncA11yControls(state);
      });
    }
  })();
</script>
```

When `accessibility:` is off, `axes()` is `[]` and the bridge is a no-op.

## Panel UI

Example dialog with one `toggle_group` per enabled axis. Keep control ids as `a11y-<axis>` so the bridge can sync them.

```elixir
alias Corex.Design.Accessibility

def accessibility_panel(assigns) do
  assigns = assign(assigns, :axes, Accessibility.axes())

  ~H"""
  <.dialog
    :if={@axes != []}
    id="a11y-dialog"
    class="dialog"
    modal
    prevent_scroll
    animation="instant"
    final_focus="dialog:a11y-dialog:trigger"
  >
    <:trigger
      class="button ui-ghost ui-size-sm ui-trigger--circle fixed bottom-space end-space z-40"
      aria_label="Accessibility"
    >
      <.heroicon name="hero-adjustments-horizontal" />
    </:trigger>
    <:title>Accessibility</:title>
    <:close_trigger>
      <.heroicon name="hero-x-mark" />
    </:close_trigger>
    <:content>
      <div class="flex w-full flex-col gap-space">
        <div class="grid w-full grid-cols-2 gap-space">
          <div :for={axis <- @axes} class="flex min-w-0 flex-col gap-space-sm">
            <.toggle_group
              id={"a11y-#{axis}"}
              class="toggle-group ui-size-sm ui-width-full"
              multiple={false}
              deselectable={false}
              value={[]}
              on_value_change_client={"phx:set-a11y-#{axis}"}
            >
              <:label>{axis |> Atom.to_string() |> String.capitalize()}</:label>
              <:item :for={value <- Accessibility.values(axis)} value={value}>
                {value}
              </:item>
            </.toggle_group>
          </div>
        </div>

        <.action
          type="button"
          class="button ui-alert ui-size-sm ui-width-fit"
          onclick="window.dispatchEvent(new CustomEvent('phx:set-a11y-reset'))"
        >
          Reset
        </.action>
      </div>
    </:content>
  </.dialog>
  """
end
```

Render it once in the root layout (for example next to skip-to-content):

```heex
<.accessibility_panel />
```

Register hooks with static imports so the panel is interactive without waiting on a second chunk (see [Eager chrome + lazy extras](manual_installation.html#eager-chrome-lazy-extras) when mixing with other lazy hooks):

```javascript
import { Dialog } from "corex/dialog"
import { ToggleGroup } from "corex/toggle-group"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    Dialog,
    ToggleGroup,
  },
})
```

Include `dialog` and `toggle_group` in `config :corex_design, components:` when you trim the component list.

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Panel missing | `Accessibility.axes()` is non-empty; `:if={@axes != []}` on the dialog |
| Controls do nothing | Bridge listens for `phx:set-a11y-<axis>`; `ToggleGroup` hook is registered |
| CSS has no effect | `accessibility:` is on; rebuilt with `mix corex.design.build`; `data-*` on `<html>` |
| Flash of wrong prefs | Bridge `<script>` is in `<head>`; root attrs match the plug assign |
| Reset does nothing | Listener for `phx:set-a11y-reset` is present and syncs toggle groups |

## Related

- [Design](design.html): `config :corex_design` and preference CSS emit
- [Configuration](configuration.html): build vs runtime knobs
- [Theming](theming.html): `data-theme`; combine bridges in one `<script>` IIFE
- [Dark mode](dark_mode.html): `data-mode`; same bridge pattern
- [Manual installation](manual_installation.html): hooks, Design, theme/mode plugs
