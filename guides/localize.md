# Localize

## Introduction

You add locale-aware URLs and translated content to a Phoenix + Corex app with [`localize_web`](https://hex.pm/packages/localize_web). Visitors get paths like `/en/home` and `/fr/home`, correct `lang` and `dir` on `<html>`, and a language switcher that keeps the same page when changing locale.

Static Tableau sites use permalink-based locales instead—see [Tableau Localize](tableau_localize.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Phoenix + Gettext | `phx.new` includes Gettext |
| `localize_web` | Add to `mix.exs` deps |
| Corex | [Manual installation](manual_installation.html) |

## How it works

1. **`localize_web`** resolves locale from path, session, and `Accept-Language`.
2. **`localize do`** scopes wrap localized routes.
3. **`MyAppWeb.Locale`** builds switcher paths and CLDR-backed `dir` for RTL.
4. **Gettext** translates template and component strings.

### The problem

You want to:

- Serve the app in multiple locales with the locale in the URL
- Persist the user's choice and respect browser language headers as a fallback
- When switching locale, keep the same logical path (`/en/accordion` → `/fr/accordion`)
- Get correct `lang` and `dir` on `<html>` so screen readers, font shaping, and bidi text all work

### The solution

`localize_web` provides the URL-routing layer (`Localize.Routes`) and the per-request locale resolution plugs (`Localize.Plug.PutLocale`, `Localize.Plug.PutSession`). Corex layers on top:

- A **`MyAppWeb.Locale`** module with **`lang/0`**, **`dir/0`**, **`locales/0`**, **`label/1`**, **`current/0`**, and **`swap_path/2`** for the root layout and language switcher (CLDR-backed `dir`, display names with fallback).
- A **`MyAppWeb.Hooks.Layout`** LiveView **`on_mount`** hook (generated with **`--lang`**) that keeps **`current_path`**, session **`mode`**, and session **`theme`** in sync for **`Layouts.app`** when you use LiveViews together with mode/theme.
- A **`<.language_switch>`** component on **`Layouts`** that renders a Corex **`<.select redirect>`** whose items use **`Corex.List.Item`**, **`Locale.swap_path/2`**, and the full request path.

The installer does **not** generate **`MyAppWeb.Path`** or **`MyAppWeb.Plugs.Path`**; locale stripping for the switcher is handled via **`Locale.swap_path/2`** and the path your templates pass in.

## Prerequisites

A standard Phoenix app with **Gettext** and a backend module  -  `phx.new` ships this out of the box at `lib/my_app_web/gettext.ex`. If you don't have it yet, configure it like any Phoenix app, then continue here.

## 1. Add the dependency

Add `localize_web` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0"},
    {:localize_web, "~> 0.5"}
  ]
end
```

```bash
mix deps.get
```

## 2. Configure Gettext + supported locales

**What `mix corex.new --lang` generates**

The installer injects **`locales: ~w(en fr ar)`** into **`use Gettext.Backend`** in **`lib/my_app_web/gettext.ex`**, adds **`config :localize, supported_locales: [:en, :fr, :ar]`** to **`config/config.exs`**, adds **`{:gettext_sigils, "~> 0.5"}`**, patches **`html_helpers`** to **`use GettextSigils`**, wraps scaffold copy in **`~t"..."`**, and copies starter **`priv/gettext`** PO files for English, French, and Arabic. Keep Gettext and Localize locale lists aligned when you add or remove locales.

**Manual / existing apps**

Configure your Gettext backend with a default locale and the list of locales you support:

```elixir
defmodule MyAppWeb.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    locales: ~w(en fr ar)
end
```

Point **`localize`** at the same set of locales (atoms). One approach is **`config/config.exs`**:

```elixir
config :localize,
  supported_locales: [:en, :fr, :ar]
```

Another approach is **`config/runtime.exs`** so the list tracks Gettext:

```elixir
import Config

config :localize,
  supported_locales: Gettext.known_locales(MyAppWeb.Gettext) |> Enum.map(&String.to_atom/1)
```

While you're in config, set the Phoenix Gettext backend so Corex components use your translations. In **`config/config.exs`**:

```elixir
config :phoenix,
  gettext_backend: MyAppWeb.Gettext
```

Corex reads **`config :phoenix, :gettext_backend`** (the same key Phoenix uses for `gettext/1` in templates).

### Download CLDR locale files (mix localize.download_locales)

The [`localize`](https://hex.pm/packages/localize) dependency (pulled in by `localize_web`) serves formatting, validation, and locale display names from Unicode CLDR data stored in an **on-disk cache**. Until a locale’s data is present there, APIs such as `Localize.Locale.display_name/2`, `Localize.Locale.get/3` (used for RTL **`dir`** in **`MyAppWeb.Locale.dir/0`**), and **`Locale.label/1`** in the language switcher may not resolve that locale cleanly and may fall back.

Download the locales that match **`:supported_locales`** at least once after adding dependencies or changing supported locales:

```bash
mix localize.download_locales
```

Or request specific locale ids:

```bash
mix localize.download_locales en fr ar
```

Files are written under the app’s build output (for example `_build/dev/lib/localize/priv/localize/locales/`). In Docker or CI, run **`mix localize.download_locales`** during the image build so production ships with the cache; alternatively set **`config :localize, allow_runtime_locale_download: true`** so missing locales are fetched from the Localize CDN on first use (often avoided in production in favor of pre-downloading).

You can hook the task into setup-style pipelines - for example **`mix setup`** - alongside asset tooling so new clones get CLDR data without an extra manual step.

## 3. Phoenix verified routes and `path_prefixes`

[`mix corex.new --lang`](installation.html) configures [`path_prefixes`](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes) on **`Phoenix.VerifiedRoutes`** in **`lib/my_app_web.ex`**

```elixir
use Phoenix.VerifiedRoutes,
  endpoint: MyAppWeb.Endpoint,
  router: MyAppWeb.Router,
  statics: MyAppWeb.static_paths(),
  path_prefixes: [{MyAppWeb.Locale, :current, []}]
```

**`MyAppWeb.Locale.current/0`** returns the active locale segment (from **`Localize.get_locale()`** with a Gettext fallback). At runtime, **`~p"/users"`** expands to **`/en/users`** (or the current locale) while your router defines resources under **`scope "/:locale", …`** only.

**`mix corex.gen.live`** and **`mix corex.gen.html`** emit plain **`~p"/…"`** paths when **`path_prefixes`** is present. The generator shell instructions tell you to add routes inside the **`/:locale`** scope.

### Without `path_prefixes` (advanced)

If you omit **`path_prefixes`**, **`~p`** expects paths **without** a leading locale segment (for example **`~p"/users/#{user}"`**). Routes must then exist under **`scope "/", …`** as well as under **`scope "/:locale", …`**, or you must add manual **`/#{@locale}`** segments in templates. Confirm behavior with [**Phoenix.VerifiedRoutes**](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) for your Phoenix version.

## 4. Router: Localize.Routes, plugs, and localize block

In **`lib/my_app_web/router.ex`**, three things change.

**a)** Add **`use Localize.Routes`** after **`use MyAppWeb, :router`**. **`mix corex.new --lang`** generates:

```elixir
use Localize.Routes, gettext: MyAppWeb.Gettext, helpers: false
```

The **`helpers: false`** option matches what Corex installs; other **`localize_web`** setups may differ  -  see the package docs.

**b)** Add the locale-resolution plugs to the **`:browser`** pipeline **immediately after** **`:fetch_live_flash`**. If you use **`--mode`** / **`--theme`**, the installer inserts **`MyAppWeb.Plugs.Mode`** and **`MyAppWeb.Plugs.Theme`** **after** **`Localize.Plug.PutSession`** (order relative to each other may vary; both run after localize plugs).

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

Omit **`Plugs.Mode`** / **`Plugs.Theme`** when you did not enable those Corex flags.

The **`from:`** list matches **`mix corex.new --lang`**: leading URL segment, then session, then **`Accept-Language`**. You can add **`:route`**, **`:query`**, or reorder if your app needs different priority  -  see [`localize_web`](https://hex.pm/packages/localize_web).

**`Localize.Plug.PutSession, as: :string`** writes the active locale into the session so LiveViews can read it.

The installer does **not** add **`MyAppWeb.Plugs.Path`**.

**c)** Wrap the routes that should gain a locale prefix in **`localize do … end`**. The simplest setup is to wrap the home route:

```elixir
scope "/", MyAppWeb do
  pipe_through :browser

  localize do
    get "/", PageController, :home
  end
end
```

**`mix corex.new --lang`** also duplicates the **`scope "/"`** block into **`scope "/:locale"`** so helpers and scopes match localized URLs  -  inspect your generated **`router.ex`** for the exact pattern.

After **`mix corex.gen.live`**, **`mix corex.gen.html`**, or any manual **`router.ex`** edit, add **`live`**, **`resources`**, and other browser routes inside the **`scope "/:locale"`** block (not only under **`scope "/"`**). **`path_prefixes`** keeps **`~p`** helpers aligned with those localized routes.

Visiting **`/`** redirects to **`/en`** (or whichever locale the resolver picked). To localize more routes, put them inside the same **`localize do … end`** block, or open additional ones inside their scopes.

## 5. Create MyAppWeb.Locale

Create **`lib/my_app_web/locale.ex`** (this matches the Corex installer template):

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

Adding **`ar`** (and downloading CLDR data) is enough for **`dir="rtl"`** where the locale metadata says RTL  -  there is **no separate RTL guide**.

## 6. Root layout: lang and dir

Localized apps set **`lang`** and **`dir`** from **`MyAppWeb.Locale`** in **`root.html.heex`**. With Corex Design and mode/theme, the installer template conditionally adds **`data-theme`** / **`data-mode`** on **`<html>`**; align with [Dark mode](dark_mode.html) and [Theming](theming.html) if you hand-wire.

```heex
<!DOCTYPE html>
<html lang={MyAppWeb.Locale.lang()} dir={MyAppWeb.Locale.dir()}>
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

Drop **`data-theme`** / **`data-mode`** / **`class="typo layout"`** if you have not enabled [Theming](theming.html), [Dark mode](dark_mode.html), or Corex Design  -  the generator turns those pieces on only when the matching flags are set.

## 7. Layouts.app: current_path and language_switch

The switcher needs the **full request path** (including the locale segment) so **`Locale.swap_path/2`** can rewrite the first segment. **`mix corex.new --lang`** adds a **`:current_path`** assign on **`Layouts.app`** and renders **`<.language_switch>`** in the **footer**.

Example **`language_switch`** aligned with the installer:

```elixir
attr :current_path, :string, default: "/", doc: "request path for locale switching"

def language_switch(assigns) do
  current_path = assigns.current_path || "/"
  current = MyAppWeb.Locale.current()

  items =
    for locale <- MyAppWeb.Locale.locales(), into: [] do
      dest = MyAppWeb.Locale.swap_path(current_path, locale)

      Corex.List.Item.new(%{
        value: dest,
        label: MyAppWeb.Locale.label(locale),
        to: dest
      })
    end

  selected = [MyAppWeb.Locale.swap_path(current_path, current)]

  assigns =
    assigns
    |> assign(:items, items)
    |> assign(:value, selected)

  ~H"""
  <.select
    id="corex-language-switch"
    class="select ui-size-sm max-w-6xs"
    items={@items}
    value={@value}
    redirect
    positioning={%Corex.Positioning{same_width: true}}
  >
    <:label class="sr-only">Language</:label>
    <:item :let={item}>{item.label}</:item>
    <:trigger>
      <.heroicon name="hero-language" class="icon" />
    </:trigger>
    <:item_indicator>
      <.heroicon name="hero-check" class="icon" />
    </:item_indicator>
  </.select>
  """
end
```

**Controllers / HEEx**  -  pass the connection path:

```heex
<Layouts.app flash={@flash} current_path={@conn.request_path}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

Add **`mode`**, **`theme`**, and other assigns when you use those features.

## 8. LiveViews: Hooks.Layout

**`mix corex.new --lang`** generates **`lib/my_app_web/hooks/layout.ex`** and patches **`lib/my_app_web.ex`** so **`live_view`** contains **`on_mount MyAppWeb.Hooks.Layout`** immediately after **`use Phoenix.LiveView`**:

```elixir
use Phoenix.LiveView

on_mount MyAppWeb.Hooks.Layout
```

That hook restores locale context from the session, assigns **`mode`** / **`theme`** from the session, and attaches **`handle_params`** so **`current_path`** tracks **`live_patch`** / **`live_navigate`**.

If you maintain an app without rerunning the installer, add the same **`on_mount`** line after **`use Phoenix.LiveView`** (or replicate the hook’s behavior).

## 9. Translate strings

With Gettext configured, wrap user-facing strings in **`~t"..."`** (from **`gettext_sigils`**, enabled in **`html_helpers`** when you use **`mix corex.new --lang`**) or **`gettext("...")`**, then run the extract / merge cycle whenever you add new ones:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

`mix gettext.extract` rewrites **`priv/gettext/default.pot`** from your source. **`mix gettext.merge priv/gettext`** creates or updates the per-locale **`.po`** files (one for every locale in the **`locales:`** list of your backend).

**`mix corex.new --lang`** ships starter **`priv/gettext/en`**, **`fr`**, and **`ar`** catalogs for the home page and layout scaffold. Open **`priv/gettext/fr/LC_MESSAGES/default.po`** to adjust translations or add new **`msgstr`** entries:

```
#: lib/my_app_web/controllers/page_html/home.html.heex
#, elixir-autogen, elixir-format
msgid "Corex for Phoenix"
msgstr "Corex pour Phoenix"
```

Corex components that expose translatable labels (Select, Editable, Dialog, …) read them from your Gettext backend automatically when **`config :phoenix, :gettext_backend`** is set. To override a single label without touching the whole catalog, pass a **`Translation`** struct on the component:

```heex
<.editable translation={%Corex.Editable.Translation{input: "Champ éditable"}} />
```

## Summary

1. **`localize_web` + `gettext_sigils` + Gettext**  -  align **`locales:`** on the backend with **`config :localize, :supported_locales`**. Run **`mix localize.download_locales en fr ar`** so CLDR data exists for **`Locale.dir/0`**, **`Locale.label/1`**, and related APIs.
2. **`Phoenix.VerifiedRoutes`**  -  **`mix corex.new --lang`** adds **`path_prefixes`** on **`Phoenix.VerifiedRoutes`** for locale-prefixed **`~p`** paths (see section 3).
3. **Router**  -  **`use Localize.Routes, gettext: ..., helpers: false`** (Corex default), **`Localize.Plug.PutLocale`** with **`from: [:path, :session, :accept_language]`**, **`Localize.Plug.PutSession`**, optional Mode/Theme plugs **after** localize plugs, and **`localize do … end`** around localized routes (plus **`/:locale`** scope as generated).
4. **`MyAppWeb.Locale`**  -  **`locales`**, **`current`**, **`swap_path`**, **`lang`**, **`dir`**, **`label`** for root layout and switcher.
5. **`Layouts.app`**  -  **`current_path`** and **`<.language_switch>`** with **`Corex.List.Item`** + **`<.select redirect>`**.
6. **LiveViews**  -  **`on_mount MyAppWeb.Hooks.Layout`** after **`use Phoenix.LiveView`** (installer adds this when **`--lang`**).
7. **Translations**  -  **`~t`** in templates, starter **`priv/gettext`** from the installer, then **`mix gettext.extract`** / **`mix gettext.merge priv/gettext`** as you add copy.

This gives you URL-driven locales with a persistent user choice, RTL handling where CLDR says so, and Corex components that follow your Gettext backend.

## Related

- [Installation](installation.html) — `mix corex.new --lang`
- [Tableau Localize](tableau_localize.html) — static site equivalent
- [Dark mode](dark_mode.html) and [Theming](theming.html) — Mode/Theme plugs after localize plugs when combined
- [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html)  -  what **`~p`** does under the hood.
- [`localize_web`](https://hex.pm/packages/localize_web)  -  full docs for the routing and CLDR layer.
