# Manual installation

This guide is the Phoenix **wiring home** for Corex in an existing app: dependency, ESM Esbuild, hooks, root layout module script, `use Corex`, plus optional **Design**, **Theme**, **Mode**, and **Locale** plumbing (plugs, config, bridge scripts, `lang`/`dir`, and related hooks).

Picker UI (theme select, mode toggle, language switcher) lives in the dedicated guides after you finish the wiring here:

- [Theming](theming.html)
- [Dark mode](dark_mode.html)
- [Localize](localize.html)

If you are creating a new project instead, see the [Installation guide](installation.html).

## Requirements

- **Elixir**
- **Phoenix** and **LiveView**
- A standard **Esbuild** asset pipeline

## 1. Add the dependency

Add `corex` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.2.0"}
  ]
end
```

Then fetch the dependencies:

```bash
mix deps.get
```

## 2. Esbuild

Corex's JavaScript ships as ECMAScript modules with dynamic `import()`. Each component hook loads its own chunk on demand, so a component that never appears on a page is never fetched.

This requires two Esbuild flags on your main app target: **`--format=esm`**, **`--splitting`** and **`--outdir=../priv/static/assets/js`**. In `config/config.exs`:

```elixir
config :esbuild,
  version: "0.25.4",
  my_app: [
    args:
      ~w(js/app.js --bundle --format=esm --splitting --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]
```

## 3. Phoenix Hooks

<!-- tabs-open -->

### All Corex hooks

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import corex from "corex"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...corex },
})

liveSocket.connect()
```

Merge with `colocatedHooks` when your app uses them:

```javascript
hooks: { ...colocatedHooks, ...corex },
```

### Lazy hooks only

Import only the hooks you render. Keys must match `phx-hook` names (`Dialog`, `Accordion`, …):

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { hooks } from "corex/hooks"

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content")

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: {
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Dialog: () => import("corex/dialog"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})

liveSocket.connect()
```

Each value is a zero-argument function returning a dynamic `import()`. Esbuild emits chunks only for listed hooks.

<!-- tabs-close -->

## 4. Root layout: load app.js as a module

The Corex JS bundle is ESM, so the browser must load it as a module. In `lib/my_app_web/components/layouts/root.html.heex`, set `type="module"` on the `<script>` tag that loads `assets/js/app.js`:

```heex
<script defer phx-track-static type="module" src={~p"/assets/js/app.js"}></script>
```

If your root layout already uses `type="text/javascript"` (the `phx.new` default), replace `text/javascript` with `module`. If it has no `type` at all, add `type="module"` next to `phx-track-static`.

## 5. Import Corex

In your web module (typically `lib/my_app_web.ex`), add `use Corex` inside the `quote` block of `defp html_helpers`, alongside the other imports that apply to HEEx templates:

```elixir
defp html_helpers do
  quote do
    use Gettext, backend: MyAppWeb.Gettext
    import Phoenix.HTML
    import MyAppWeb.CoreComponents
    use Corex
    alias Phoenix.LiveView.JS
    alias MyAppWeb.Layouts
    unquote(verified_routes())
  end
end
```

By default this imports every Corex function component (`accordion/1`, `combobox/1`, `dialog/1`, …). If you want a smaller surface area or to avoid name collisions with other components, narrow it with `only:` / `except:` and an optional `prefix:`:

```elixir
use Corex, only: [:accordion], prefix: "ui"
```

```heex
<.ui_accordion
  id="my-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "first", label: "First", content: "First panel."],
    [value: "second", label: "Second", content: "Second panel."],
    [value: "third", label: "Third", content: "Third panel."]
  ])}
/>
```

Compile and rebuild assets:

```bash
mix compile
mix assets.build
```

## 6. Optional: Corex Design

Add the `corex_design` dependency to `mix.exs`:

```elixir
{:corex_design, "~> 0.2", runtime: false, only: :dev},
```

Optionally rebuild Design CSS on every compile (most apps call the build from `assets.build` / `assets.deploy` instead):

```elixir
def project do
  [
    compilers: Mix.compilers() ++ [:corex_design]
  ]
end
```

Add to `config/config.exs` (build-time CSS only; see [Configuration](configuration.html)):

```elixir
config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  themes: nil,
  scales: [],
  components: ~w(button dialog accordion typo layout-heading)a,
  semantics: nil
```

`default_theme` / `default_mode` / `themes` control which theme CSS the design build emits. They are not the runtime picker allowlist (`config :my_app, :themes`). `components:` lists the component recipes to emit. Omit the key or set `nil` for the full catalog. `semantics:` trims unused palette roles and `ui-{role}` utilities when you need a smaller bundle. List allowed keys with `mix corex.design.options`.

Add `"corex.design.build"` to your `assets.build` and `assets.deploy` aliases in `mix.exs`.

Ignore the generated output in git (rebuild with `mix corex.design.build`):

```gitignore
/assets/corex/
```

If that tree was already committed, stop tracking it without deleting files on disk:

```bash
git rm -r --cached assets/corex
git commit -m "Stop tracking generated Corex Design CSS"
```

Generate CSS:

```bash
mix deps.get
mix corex.design.build
```

Then import from `assets/css/app.css`. Prefer the single umbrella entry:

```css
@import "../corex/corex.css";
@source "../corex";
```

Layered imports (`main.css` + `theme/neo.css` + `components.css`) still work if you filter themes yourself. `components.css` is generated from the `components:` list in `config :corex_design`.

If your `app.css` still imports the stock **daisyUI** plugin from `phx.new`, remove or isolate it. Mixing daisyUI tokens with Corex Design tokens leads to duplicated reset rules and conflicting CSS variables.

Finally, set **`data-theme`** and **`data-mode`** on **`<html>`** so token files such as `theme/neo.css` and light/dark palettes apply. Use values that match your imports and toggles (for example `data-theme="neo"` when you import `../corex/theme/neo.css`, and `data-mode="light"` or `data-mode="dark"`). Sections [8](#8-optional-theme-wiring) and [9](#9-optional-mode-wiring) wire these from plugs and bridge scripts; the picker UI is in [Theming](theming.html) and [Dark mode](dark_mode.html).

Give **`<body>`** the **`typo`** and **`layout`** classes so base typography and the layout shell apply:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

See the [Design guide](design.html) for commands, modifiers, bundle filtering, and themes.

## 7. Optional: Phoenix flash with Toast

To render Phoenix flash (and LiveView flash) as Corex toasts instead of the default `<.flash_group>`, render a `<.toast_group>` in your app layout and pass it `flash={@flash}`. In `lib/my_app_web/components/layouts.ex`, replace the flash group inside `def app/1` with:

```heex
<.toast_group id="layout-toast" class="toast" flash={@flash}>
  <:loading>
    <.heroicon name="hero-arrow-path" class="icon" />
  </:loading>
  <:close>
    <.heroicon name="hero-x-mark" class="icon" />
  </:close>
</.toast_group>
```

Optionally, add the connection-state toasts so users see feedback when the socket drops or the server errors out:

```heex
<.toast_client_error
  toast_group_id="layout-toast"
  title={gettext("We can't find the internet")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
<.toast_server_error
  toast_group_id="layout-toast"
  title={gettext("Something went wrong!")}
  description={gettext("Attempting to reconnect")}
  type={:error}
  duration={:infinity}
/>
```

Make sure every LiveView and controller view that uses this layout passes `flash={@flash}` into it (e.g. `<Layouts.app flash={@flash} ...>`).

See `Corex.Toast` for `create/5`, `create/6`, `update/3`, `update/4`, `remove/2`, `remove/3`, and `dismiss/2` / `dismiss/3`. Pass `action: %{label: "…", js: %Phoenix.LiveView.JS{}}` with `JS.push`, `JS.patch`, or `JS.navigate` composed in `js`.

## Optional: Theme wiring {: #optional-theme-wiring}

Runtime theme picker allowlist in `config/config.exs` (first entry is the default):

```elixir
config :my_app, :themes, ~w(neo uno duo leo)
```

This list is for the picker and plug validation only. Trim emitted CSS with `config :corex_design, themes:` (build-time). Keep the picker list a subset of the themes you build.

Create `lib/my_app_web/plugs/theme.ex`:

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

Browser pipeline (after `:fetch_live_flash`; with locale wiring, put Mode/Theme plugs after localize plugs):

```elixir
plug MyAppWeb.Plugs.Mode
plug MyAppWeb.Plugs.Theme
```

On `<html>` in `root.html.heex`:

```heex
<html lang="en" data-theme={assigns[:theme] || "neo"} data-mode={assigns[:mode] || "light"}>
```

Theme bridge in `<head>` (merge into the same IIFE as [Dark mode](dark_mode.html) / [section 9](#9-optional-mode-wiring) when you use both):

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

Keep `validThemes` and fallbacks in sync with `config :my_app, :themes` (and with the themes you emit from `:corex_design`).

Ensure the **`Select`** hook is registered in `assets/js/app.js` (via `...corex` or a lazy `Select: () => import("corex/select")` entry). Include `select` in `config :corex_design, components:` when you use a theme picker.

CSS: import the Design umbrella entry from section 6:

```css
@import "../corex/corex.css";
```

Then add the UI: [Theming](theming.html).

## Optional: Mode wiring {: #optional-mode-wiring}

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

In `router.ex`, mount **after** `:fetch_live_flash` (and after localize plugs when you use section 10):

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

On `<html>` in `root.html.heex`:

```heex
<html lang="en" data-mode={assigns[:mode] || "light"}>
```

Mode bridge in `<head>` (merge into the same IIFE as [Theming](theming.html) / [section 8](#8-optional-theme-wiring) when you use both):

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

Ensure the **`Toggle`** hook is registered in `assets/js/app.js` (via `...corex` or a lazy `Toggle: () => import("corex/toggle")` entry). Include `toggle` in `config :corex_design, components:` when you use a mode switcher.

Then add the UI: [Dark mode](dark_mode.html).

## Optional: Locale wiring {: #optional-locale-wiring}

This section covers routing and layout wiring only. The language switcher UI is in [Localize](localize.html).

### Deps

```elixir
def deps do
  [
    {:corex, "~> 0.2.0"},
    {:localize_web, "~> 0.5"},
    {:gettext_sigils, "~> 0.5"}
  ]
end
```

```bash
mix deps.get
```

### Gettext and supported locales

```elixir
defmodule MyAppWeb.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    locales: ~w(en fr ar)
end
```

```elixir
config :localize,
  supported_locales: [:en, :fr, :ar]

config :phoenix,
  gettext_backend: MyAppWeb.Gettext
```

Keep Gettext `locales:` and `:supported_locales` aligned. Optionally patch `html_helpers` to `use GettextSigils` for `~t"..."` templates.

Download CLDR locale data at least once after adding deps or changing locales:

```bash
mix localize.download_locales
```

### Verified routes `path_prefixes`

In `lib/my_app_web.ex`:

```elixir
use Phoenix.VerifiedRoutes,
  endpoint: MyAppWeb.Endpoint,
  router: MyAppWeb.Router,
  statics: MyAppWeb.static_paths(),
  path_prefixes: [{MyAppWeb.Locale, :current, []}]
```

### Router

After `use MyAppWeb, :router`:

```elixir
use Localize.Routes, gettext: MyAppWeb.Gettext, helpers: false
```

Locale plugs **immediately after** `:fetch_live_flash`. Place Mode/Theme plugs **after** `Localize.Plug.PutSession` when you use those features:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash

  plug Localize.Plug.PutLocale,
    from: [:path, :session, :accept_language],
    gettext: MyAppWeb.Gettext

  plug Localize.Plug.PutSession, as: :string

  plug MyAppWeb.Plugs.Mode
  plug MyAppWeb.Plugs.Theme

  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

Wrap localized routes in `localize do` and mirror them under `scope "/:locale"` as needed:

```elixir
scope "/", MyAppWeb do
  pipe_through :browser

  localize do
    get "/", PageController, :home
  end
end
```

### MyAppWeb.Locale

Create `lib/my_app_web/locale.ex`:

```elixir
defmodule MyAppWeb.Locale do
  def locales do
    Localize.supported_locales() |> Enum.map(&Atom.to_string/1)
  end

  def current do
    case Localize.get_locale() do
      %{cldr_locale_id: id} when is_atom(id) -> Atom.to_string(id)
      %{cldr_locale_id: id} when is_binary(id) -> id
      _ -> "en"
    end
  end

  def label(loc) when is_binary(loc) do
    loc = to_string(loc)

    case Localize.Locale.display_name(loc, locale: loc) do
      {:ok, name} -> format_language_select_label(name)
      _ -> String.upcase(loc)
    end
  end

  def label(loc) when is_atom(loc), do: label(Atom.to_string(loc))

  defp format_language_select_label(name) when is_binary(name) do
    trimmed = String.trim(name)

    if trimmed == "" do
      trimmed
    else
      if String.match?(trimmed, ~r/^\p{Latin}/u) do
        trimmed
        |> String.split(~r/\s+/u, trim: true)
        |> Enum.map_join(" ", &titlecase_word/1)
      else
        trimmed
      end
    end
  end

  defp titlecase_word(word) do
    case String.next_grapheme(String.downcase(word)) do
      {first, rest} -> String.upcase(first) <> rest
      nil -> word
    end
  end

  def lang do
    Localize.get_locale()
  end

  def dir do
    case Localize.Locale.get(Localize.get_locale(), [:layout, :character_order], fallback: true) do
      {:ok, :rtl} -> "rtl"
      {:ok, :ltr} -> "ltr"
      _ -> "ltr"
    end
  end

  def swap_path(request_path, target_locale) when is_binary(request_path) do
    target = to_string(target_locale)
    supported = locales()

    rest =
      case String.split(request_path, "/", trim: true) do
        [first | rest] ->
          if first in supported, do: rest, else: [first | rest]

        [] ->
          []
      end

    "/" <> Enum.join([target | rest], "/")
  end
end
```

### Root layout lang and dir

```heex
<html lang={MyAppWeb.Locale.lang()} dir={MyAppWeb.Locale.dir()}>
```

Add `data-theme` / `data-mode` when you also use sections 8 and 9.

### LiveView on_mount

With LiveViews, add `on_mount MyAppWeb.Hooks.Layout` immediately after `use Phoenix.LiveView` so locale context, session `mode` / `theme`, and `current_path` stay in sync for the layout. See [Localize](localize.html) for the hook and language switcher UI.

Then add the UI: [Localize](localize.html).

## 11. Add your first component

After the install, every Corex function component is available in your templates. The `id` attribute is required for any component you want to drive from the API.

`Corex.Content.new/1` builds a list of items. Each item's `value` is auto-generated when missing; you can also flag an item as `disabled`.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### Driving components from the API

Every component documents its helpers under **`Corex.<Name>`** in Hexdocs (see **API** and **Events** on each module page). You need a stable **`id`** on the root.

**Client-side** (inline binding):

```heex
<button type="button" phx-click={Corex.Accordion.set_value("welcome-accordion", ["1"])}>
  Open the first panel
</button>
```

**Server-side** (`handle_event/3`):

```elixir
def handle_event("open_first", _params, socket) do
  {:noreply, Corex.Accordion.set_value(socket, "welcome-accordion", ["1"])}
end
```

For custom slots, controlled values, async loading, and the full API, see [Corex.Accordion](Corex.Accordion.html).

## What's next

Wiring done? Add the picker UI:

- [Theming](theming.html) theme `<.select>`
- [Dark mode](dark_mode.html) mode `<.toggle>`
- [Localize](localize.html) language switcher

Also:

- [Design](design.html) modifiers, bundle filtering, and themes
- [Forms](forms.html) `field`, validation, and `auto_invalid`
- [MCP](https://hexdocs.pm/corex_mcp/MCP.html) AI tooling in development
- [Production](production.html) prod build and run
- [Updating Corex](update.html) migrate an existing app
