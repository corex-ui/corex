# Tableau

## Introduction

[Corex](installation.html) on a [Tableau](https://hex.pm/packages/tableau) static site: HEEx templates, Esbuild, Tailwind, and lazy Corex hooks over `LiveSocket`.

Install the archives once, then scaffold a site:

```bash
mix archive.install hex tableau_new
mix archive.install hex corex_new
mix corex.tableau.new my_site
# optional: --mode --theme --lang --mcp
```

`--lang` scaffolds Gettext, Localize, permalink Locale helpers, `locale.js`, per-locale pages (`en` / `fr` / `ar`), and a language `<.select>` (implies `--design`). Example sites: [corex-ui/soonex](https://github.com/corex-ui/soonex) (baseline), [corex-ui/soonex_i18n](https://github.com/corex-ui/soonex_i18n) (`--lang` shape). For Phoenix apps with plugs and router scopes, see [Localize](localize.html).

The default scaffold (without `--lang`) mirrors `mix corex.new` patterns (design assets, ESM Esbuild, `use Corex`, lazy hooks) plus a Blog link and one sample post.

**Manual** (this guide) owns install wiring: baseline Corex, plus optional theme / mode / locale (`head_script/0`, `phx:set-*` listeners in `site.js`, locale.js, Gettext). [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), and [Tableau Localize](tableau_localize.html) are picker UI only (after wiring or `mix corex.tableau.new --theme --mode --lang`). For Phoenix apps with cookies and plugs, see [Dark mode](dark_mode.html), [Theming](theming.html), and [Localize](localize.html). Config layers are summarized in [Configuration](configuration.html).

Run **`mix help corex.tableau.new`** or see **`Mix.Tasks.Corex.Tableau.New`** for every Corex-only flag.

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Elixir ~> 1.15 | Match your Tableau version |
| Node.js | For Esbuild and npm deps |
| `tableau_new` + `corex_new` archives | Or an existing Tableau HEEx site for the Manual path |

## How it works

1. **`mix corex.design.build`** generates token and component CSS into `assets/corex/` via the `corex_design` dependency.
2. **Esbuild** bundles `assets/js/site.js` as ESM with splitting into `_site/js/`.
3. **`RootLayout`** loads CSRF meta, `site.css`, and `type="module"` for `site.js`.
4. **`LiveSocket`** registers only the Corex hooks you import (lazy factories keep chunks small).

## Manual

For an existing Tableau site (HEEx + Esbuild + Tailwind), add Corex by hand.

Add Corex and Corex Design to `mix.exs`:

```elixir
{:corex, "~> 0.2"},
{:corex_design, "~> 0.2", runtime: false, only: :dev},
```

```bash
mix deps.get
mix corex.design.build
```

Configure Esbuild in `config/config.exs` (ESM + splitting for dynamic hook imports):

```elixir
config :esbuild,
  version: "0.25.5",
  default: [
    args:
      ~w(js/site.js --bundle --format=esm --splitting --target=es2022 --outdir=../_site/js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
```

Import Corex CSS in `assets/css/site.css`:

```css
@import "tailwindcss";
@plugin "../vendor/heroicons";
@import "../corex/corex.css";
```

Add `typo` (and layout utilities as needed) on `<body>` in your root layout.

<!-- tabs-open -->

### Hooks lazy

Import only the hooks you use. In `assets/js/site.js`:

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
    }),
  },
})

liveSocket.connect()
```

### Hooks all

Load every Corex hook in one bundle:

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

<!-- tabs-close -->

## Root layout

Corex expects ESM and a CSRF token. In `lib/layouts/root_layout.ex`:

```elixir
defmodule MyApp.RootLayout do
  import Phoenix.Controller, only: [get_csrf_token: 0]

  use Tableau.Layout
  use Phoenix.Component
  use Corex

  def template(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" dir="ltr">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>{assigns[:page_title] || "MyApp"}</title>
        <link rel="stylesheet" href="/css/site.css" />
        <script type="module" src="/js/site.js" />
      </head>
      <body class="layout typo">
        <main class="layout__main">
          <div class="layout__content">
            {render(@inner_content)}
          </div>
        </main>
      </body>
    </html>
    """
    |> Phoenix.HTML.Safe.to_iodata()
  end
end
```

## Optional: Theme wiring {: #optional-theme-wiring}

Runtime theme picker allowlist, before-paint `head_script/0`, and `phx:set-theme` listeners. No Phoenix plugs. `mix corex.tableau.new --theme` scaffolds this shape.

Requires `{:jason, "~> 1.0"}` for `Jason.encode!/1` in `head_script/0`.

Which theme CSS the design build emits is separate: `config :corex_design` (`themes`, `default_theme`). See [Design](design.html) and [Configuration](configuration.html). Keep the picker list a subset of the themes you build.

### Config

In `config/config.exs`:

```elixir
config :my_app,
  site_name: "MyApp",
  themes: ~w(neo uno duo leo)
```

Do not set an OTP picker `default_theme`. The first entry in `themes` is the fallback when nothing is stored (`List.first(themes)`). Build defaults live under `config :corex_design` only.

### Elixir

`lib/my_app/config.ex` (merge with locale fields if you use [locale wiring](#optional-locale-wiring)):

```elixir
defmodule MyApp.Config do
  @app :my_app

  def site_name, do: Application.get_env(@app, :site_name, "MyApp")

  def themes, do: Application.get_env(@app, :themes, ~w(neo uno duo leo))

  def default_theme, do: themes() |> List.first()
end
```

`lib/my_app/theme.ex`:

```elixir
defmodule MyApp.Theme do
  use Phoenix.Component
  use Corex

  def themes, do: MyApp.Config.themes()
  def default_theme, do: MyApp.Config.default_theme()

  def head_script do
    themes_json = Jason.encode!(themes())
    default_theme_json = Jason.encode!(default_theme())

    Phoenix.HTML.raw("""
    <script>
      try {
        const themes = #{themes_json};
        const dt = #{default_theme_json};
        const t = localStorage.getItem("data-theme");
        const theme = themes.includes(t) ? t : dt;
        document.documentElement.setAttribute("data-theme", theme);
      } catch (_) {}
    </script>
    """)
  end

  def current(assigns) do
    list = themes()
    d = default_theme()

    case Map.get(assigns, :theme) do
      t when is_binary(t) -> if(t in list, do: t, else: d)
      _ -> d
    end
  end

  def select_items do
    themes()
    |> Enum.map(fn t -> %{value: t, label: String.capitalize(t)} end)
    |> Corex.List.new()
  end

  attr :theme, :string, required: true

  def theme_toggle(assigns) do
    ~H"""
    <.select
      id="theme-select"
      class="select ui-size-sm w-auto"
      items={select_items()}
      value={[@theme]}
      positioning={%Corex.Positioning{same_width: false}}
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
end
```

### Layout

In `RootLayout.template/1`, before `~H`:

```elixir
assigns = Map.put(assigns, :theme, MyApp.Theme.current(assigns))
```

On `<html>`:

```heex
<html lang="en" dir="ltr" data-theme={@theme}>
```

In `<head>`, run mode then theme when both exist (same order as `mix corex.tableau.new`):

```heex
{MyApp.Mode.head_script()}
{MyApp.Theme.head_script()}
```

Theme only: call `{MyApp.Theme.head_script()}` alone.

When you add [locale wiring](#optional-locale-wiring), set `lang` and `dir` from your locale module instead of fixed `en` / `ltr`.

### site.js

Register `Select` and listen for `phx:set-theme` after `liveSocket.connect()`:

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
      Select: () => import("corex/select"),
    }),
  },
})

liveSocket.connect()

window.addEventListener("phx:set-theme", (e) => {
  const value = e.detail?.value
  const themes = ["neo", "uno", "duo", "leo"]
  const defaultTheme = "neo"
  const theme =
    Array.isArray(value) && value[0] && themes.includes(value[0])
      ? value[0]
      : defaultTheme
  localStorage.setItem("data-theme", theme)
  document.documentElement.setAttribute("data-theme", theme)
})
```

Keep the `themes` / `defaultTheme` arrays in sync with `config :my_app, :themes`. Include `select` in `components:` in `config :corex_design` when you use the theme switcher.

Then add the UI: [Tableau Theming](tableau_theming.html).

## Optional: Mode wiring {: #optional-mode-wiring}

Before-paint `head_script/0` and `phx:set-mode` listeners. Mode is client-side only. There is no OTP picker allowlist for mode. Resolution uses `localStorage`, then `prefers-color-scheme`. `config :corex_design, default_mode:` is a **build-time** default for generated CSS, not the runtime toggle. See [Configuration](configuration.html).

`mix corex.tableau.new --mode` scaffolds this shape.

| Setup | `<html>` | `<head>` script order |
| ----- | -------- | --------------------- |
| Mode only | Fixed `data-theme` (or design default) + `data-mode={@mode}` | `Mode.head_script()` only |
| With [theme wiring](#optional-theme-wiring) | `data-theme` from theming | `Mode.head_script()` then `Theme.head_script()` |

### Elixir

`lib/my_app/mode.ex`:

```elixir
defmodule MyApp.Mode do
  use Phoenix.Component
  use Corex

  def head_script do
    Phoenix.HTML.raw("""
    <script>
      try {
        const m = localStorage.getItem("data-mode");
        const prefersDark = matchMedia("(prefers-color-scheme: dark)").matches;
        const mode = m === "dark" || m === "light" ? m : (prefersDark ? "dark" : "light");
        document.documentElement.setAttribute("data-mode", mode);
      } catch (_) {}
    </script>
    """)
  end

  def current(assigns) do
    case Map.get(assigns, :mode) do
      "dark" -> "dark"
      _ -> "light"
    end
  end

  attr :mode, :string, required: true

  def mode_toggle(assigns) do
    ~H"""
    <.toggle
      id="mode-switcher"
      class="toggle ui-size-sm shrink-0"
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
end
```

### Layout

In `RootLayout.template/1`:

```elixir
assigns = Map.put(assigns, :mode, MyApp.Mode.current(assigns))
```

Mode only:

```heex
<html lang="en" dir="ltr" data-theme="neo" data-mode={@mode}>
  <head>
    {MyApp.Mode.head_script()}
```

With theme wiring, keep `data-theme={@theme}` and add `data-mode={@mode}`. In `<head>` (mode first, then theme):

```heex
{MyApp.Mode.head_script()}
{MyApp.Theme.head_script()}
```

Include `toggle` in `components:` when you use a mode switcher.

### site.js

With theme and mode:

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
      Select: () => import("corex/select"),
      Toggle: () => import("corex/toggle"),
    }),
  },
})

liveSocket.connect()

window.addEventListener("phx:set-mode", (e) => {
  const detail = e.detail
  let mode
  if (typeof detail?.pressed === "boolean") {
    mode = detail.pressed ? "dark" : "light"
  } else {
    const value = detail?.value
    mode = Array.isArray(value) && value[0] ? value[0] : "light"
  }
  localStorage.setItem("data-mode", mode)
  document.documentElement.setAttribute("data-mode", mode)
})

window.addEventListener("phx:set-theme", (e) => {
  const value = e.detail?.value
  const themes = ["neo", "uno", "duo", "leo"]
  const defaultTheme = "neo"
  const theme =
    Array.isArray(value) && value[0] && themes.includes(value[0])
      ? value[0]
      : defaultTheme
  localStorage.setItem("data-theme", theme)
  document.documentElement.setAttribute("data-theme", theme)
})
```

Mode only: omit the `Select` hook and the `phx:set-theme` listener if you do not use [theme wiring](#optional-theme-wiring).

Then add the UI: [Tableau Mode](tableau_mode.html).

## Optional: Locale wiring {: #optional-locale-wiring}

Or scaffold with `mix corex.tableau.new my_site --lang`.

Every locale is permalink-prefixed (`/<locale>/...`, including the default). A separate root page at `/` renders the default locale (same template as `/en/`). Gettext owns the locale list; `locale.js` and layout `data-locale*` attributes keep the language select in sync. Prefer `localize_web` (or `localize`) for CLDR display names and RTL; you do not need Phoenix router plugs on a static Tableau site.

### Dependencies

```elixir
def application do
  [
    mod: {MyApp.Application, []},
    extra_applications: [:logger, :localize]
  ]
end

defp deps do
  [
    {:gettext, "~> 1.0"},
    {:gettext_sigils, "~> 0.5"},
    {:localize_web, "~> 0.5"}
  ]
end

defp aliases do
  [
    setup: ["deps.get", "localize.download_locales", "corex.design.build"]
  ]
end
```

```bash
mix deps.get
mix localize.download_locales en fr ar
```

Run `mix localize.download_locales` again when you add locales.

### Gettext

`lib/my_app/gettext.ex`:

```elixir
defmodule MyApp.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    locales: ~w(en fr ar)

  def default_locale, do: "en"

  def locales do
    case Gettext.known_locales(__MODULE__) do
      [] -> ~w(en fr ar)
      locales -> locales
    end
  end
end
```

Thin sigil helper (`lib/my_app/gettext_sigil.ex`) so pages can use `~t"..."`:

```elixir
defmodule MyApp.GettextSigil do
  defmacro __using__(_opts) do
    quote do
      use Gettext, backend: MyApp.Gettext
      use GettextSigils, backend: MyApp.Gettext
    end
  end
end
```

`config/config.exs` (string locales; CI-safe):

```elixir
config :phoenix, gettext_backend: MyApp.Gettext

config :localize,
  default_locale: "en",
  supported_locales: ~w(en fr ar)
```

### Locale module

`lib/my_app/locale.ex` should expose:

`locales/0`, `default_locale_string/0`, `current/0`, `current/1`, `lang/1`, `dir/1`, `label/1`, `swap_path/2`, `current_path/1`, `selected_path/2`, `language_select_items/1`, `language_select_value/2`

`swap_path/2` always builds `/<locale>/...`. For the default locale on the home path only, it returns `/` so the root alias and the language select stay aligned. Copy the full module from a `--lang` scaffold or from [soonex_i18n](https://github.com/corex-ui/soonex_i18n) (`Locale` without an Endpoint `path/1` prefix unless you deploy under a subpath).

### Layout

In `RootLayout`, add `use MyApp.GettextSigil` (or `use Gettext` / `GettextSigils`) next to `use Corex`.

In `template/1`, before `~H`:

```elixir
locale = MyApp.Locale.current(assigns.page)
Gettext.put_locale(MyApp.Gettext, MyApp.Locale.lang(locale))

rtl_locales =
  MyApp.Locale.locales()
  |> Enum.filter(&(MyApp.Locale.dir(&1) == "rtl"))
  |> Enum.join(",")

assigns =
  assigns
  |> Map.put(:locale, locale)
  |> Map.put(:rtl_locales, rtl_locales)
```

On `<html>` (combine with `data-theme` / `data-mode` when you use those sections):

```heex
<html
  lang={MyApp.Locale.lang(@locale)}
  dir={MyApp.Locale.dir(@locale)}
  data-locale={@locale}
  data-locales={Enum.join(MyApp.Locale.locales(), ",")}
  data-rtl-locales={@rtl_locales}
  data-locale-selected-path={MyApp.Locale.selected_path(@page, @locale)}
  data-public-path-prefix=""
>
```

For GitHub Pages project sites, set `data-public-path-prefix` to the pathname prefix without a trailing slash; `locale.js` strips it before reading the first path segment.

[Theme wiring](#optional-theme-wiring) and [mode wiring](#optional-mode-wiring) head scripts stay in `<head>` as documented above.

### locale.js

Create `assets/js/locale.js` that:

- Reads `data-locales`, `data-rtl-locales`, `data-locale`, `data-locale-selected-path`, and optional `data-public-path-prefix`
- Persists the choice under `localStorage` key `data-locale`
- Syncs `#corex-language-switch` via `corex:select:set-value`
- Listens for `corex:set-locale` (from the select `on_value_change_client`)

Copy the file from a `--lang` scaffold (or soonex_i18n `assets/js/locale.js`, inlining any shared helpers).

### site.js

```javascript
import "./locale.js"
```

Register `Select` in `hooks` if not already present. Include `select` in `config :corex_design, components:` when you use the language switcher.

### Pages

One shared template; emit one `Tableau.Page` per locale at `/<locale>/...`, plus a root index at `/` for the default locale:

```elixir
defmodule MyApp.HomePage do
  use Phoenix.Component
  use Corex
  use MyApp.GettextSigil

  def template(assigns) do
    ~H"""
    <.layout_heading class="layout-heading">
      <:title>{~t"Welcome"}</:title>
    </.layout_heading>
    """
  end
end

for locale <- MyApp.Locale.locales() do
  mod = Module.concat(MyApp.HomePage, String.upcase(locale))
  permalink = "/#{locale}/"

  Module.create(
    mod,
    quote do
      use Tableau.Page,
        layout: MyApp.RootLayout,
        permalink: unquote(permalink),
        title: "MyApp",
        page_kind: :home

      def template(assigns), do: MyApp.HomePage.template(assigns)
    end,
    __ENV__
  )
end

defmodule MyApp.RootIndexPage do
  use Tableau.Page,
    layout: MyApp.RootLayout,
    permalink: "/",
    title: "MyApp",
    page_kind: :home

  def template(assigns), do: MyApp.HomePage.template(assigns)
end
```

Repeat the `for` block for each page that should exist under every locale (for example `/#{locale}/blog/`).

Extract and merge catalogs:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Fill `priv/gettext/<locale>/LC_MESSAGES/default.po`.

Then add the UI: [Tableau Localize](tableau_localize.html).

## Try a component

In a page template:

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "first", label: "First", content: "Panel one."],
    [value: "second", label: "Second", content: "Panel two."],
    [value: "third", label: "Third", content: "Panel three."]
  ])}
/>
```

## Optional: MCP on Bandit

Tableau has no Phoenix endpoint. Run [MCP](https://hexdocs.pm/corex_mcp/MCP.html) (`corex_mcp`) on a separate Bandit port (default `4004`). With `mix corex.tableau.new`, MCP is on by default (`--no-mcp` to skip).

`lib/my_app/mcp_plug.ex`:

```elixir
defmodule MyApp.McpPlug do
  use Plug.Builder

  plug Corex.MCP
  plug :not_found

  defp not_found(conn, _) do
    if conn.halted? do
      conn
    else
      conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(404, "Not found")
    end
  end
end
```

`lib/my_app/application.ex`:

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:my_app, :mcp_enabled, false) do
        [
          {Bandit,
           plug: MyApp.McpPlug,
           scheme: :http,
           port: Application.get_env(:my_app, :mcp_port, 4004)}
        ]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

`config/dev.exs`:

```elixir
config :my_app, :mcp_enabled, true
config :my_app, :mcp_port, 4004
```

Point your MCP client at `http://localhost:4004`.

## Related

- [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), [Tableau Localize](tableau_localize.html): picker UI after wiring
- [Manual installation](manual_installation.html): Esbuild, `corex_design`, `use Corex` (Phoenix)
- [MCP](https://hexdocs.pm/corex_mcp/MCP.html): plug behavior and Phoenix endpoint setup
- [Installation](installation.html): `mix corex.new` for full Phoenix apps
