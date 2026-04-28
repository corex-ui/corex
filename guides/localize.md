# Localize

## Introduction

This guide walks through wiring **locale-aware URLs and content** into a Phoenix + Corex app using the [`localize_web`](https://hex.pm/packages/localize_web) library. The result is:

- URLs that include a locale prefix (e.g. `/en/home`, `/fr/home`)
- A `<html lang="..." dir="...">` that reflects the active locale, with **RTL automatic** for languages like Arabic
- A `<.select>` language switcher that swaps locales while preserving the current page
- Gettext-driven translations for component labels and your own strings

If you ran `mix corex.new my_app --lang` (or `mix igniter.install corex --yes --lang`), the installer wrote everything below for you. Use this guide to understand what that produced, or to wire it by hand.

For the underlying Corex install, see [Manual installation](manual_installation.html).

### The problem

You want to:

- Serve the app in multiple locales with the locale in the URL
- Persist the user's choice and respect browser language headers as a fallback
- When switching locale, keep the same logical path (`/en/accordion` → `/fr/accordion`)
- Get correct `lang` and `dir` on `<html>` so screen readers, font shaping, and bidi text all work

### The solution

`localize_web` provides the URL-routing layer (`Localize.Routes`, `Localize.VerifiedRoutes`) and the per-request locale resolution plugs (`Localize.Plug.PutLocale`, `Localize.Plug.PutSession`). Corex layers on top:

- A small **`MyAppWeb.Path`** helper that strips the locale prefix from `conn.request_path` so the language switcher can rebuild URLs in any locale.
- A **`MyAppWeb.Plugs.Path`** that assigns `:path` (the locale-stripped request path) for layouts.
- A **`MyAppWeb.LocalizeLayout`** module exposing `html_lang/1` and `html_dir/1` for the root layout, with `dir` derived from CLDR (so RTL is automatic).
- A **`<.language_switch>`** component on `Layouts` that renders a Corex `<.select>` populated from `Gettext.known_locales/1`.

## Prerequisites

A standard Phoenix app with **Gettext** and a backend module — `phx.new` ships this out of the box at `lib/my_app_web/gettext.ex`. If you don't have it yet, configure it like any Phoenix app, then continue here.

## 1. Add the dependency

Add `localize_web` to your `mix.exs` deps:

```elixir
def deps do
  [
    {:corex, "~> 0.1.0-beta.1"},
    {:localize_web, "~> 0.5"}
  ]
end
```

```bash
mix deps.get
```

## 2. Configure Gettext + supported locales

Configure your Gettext backend with a default locale and the list of locales you support. In `lib/my_app_web/gettext.ex`:

```elixir
defmodule MyAppWeb.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    locales: ~w(en fr ar)
end
```

Then, in `config/runtime.exs`, hand the same list to `localize_web` at boot. Reading from `Gettext.known_locales/1` keeps the two lists in lockstep — add a locale once and both libraries see it:

```elixir
import Config

config :localize,
  supported_locales: Gettext.known_locales(MyAppWeb.Gettext) |> Enum.map(&String.to_atom/1)
```

`localize_web` expects atoms; `Gettext.known_locales/1` returns strings, hence the `Enum.map`.

While you're in config, also point Corex at the same Gettext backend so its components use your translations. In `config/config.exs`:

```elixir
config :corex,
  gettext_backend: MyAppWeb.Gettext,
  json_library: Jason
```

## 3. Use Phoenix verified routes via `Localize.VerifiedRoutes`

`Localize.VerifiedRoutes` is a drop-in replacement for `Phoenix.VerifiedRoutes` that injects the active locale into `~p` paths. In `lib/my_app_web.ex`, swap the `verified_routes/0` helper:

```elixir
def verified_routes do
  quote do
    use Localize.VerifiedRoutes,
      endpoint: MyAppWeb.Endpoint,
      router: MyAppWeb.Router,
      gettext: MyAppWeb.Gettext,
      statics: MyAppWeb.static_paths()
  end
end
```

Phoenix's stock helper generation flag (`use Phoenix.Router, helpers: false`) is incompatible with `Localize.VerifiedRoutes`. In the same file, flip it on:

```elixir
def router do
  quote do
    use Phoenix.Router, helpers: true
  end
end
```

After this swap, `~p"/home"` inside a request scoped to French automatically renders as `/fr/home`.

## 4. Router: `use Localize.Routes`, plugs, and `localize do … end`

In `lib/my_app_web/router.ex`, three things change.

**a)** Add `use Localize.Routes` after `use MyAppWeb, :router` so the `localize` macro is available:

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use Localize.Routes, gettext: MyAppWeb.Gettext

  # ...
end
```

**b)** Add the locale-resolution plugs to the `:browser` pipeline, **after** `:fetch_live_flash` and (if you have them) the Mode/Theme plugs:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash

  plug MyAppWeb.Plugs.Mode
  plug MyAppWeb.Plugs.Theme

  plug Localize.Plug.PutLocale,
    from: [:route, :session, :accept_language, :query, :path],
    gettext: MyAppWeb.Gettext

  plug Localize.Plug.PutSession, as: :string

  plug MyAppWeb.Plugs.Path

  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

The `from:` list is the resolution priority: the route segment wins first, then the session (so the choice survives across requests), then the `Accept-Language` header, then the query string, and finally the path. This matches the Corex installer default and works for both bookmarked URLs and first-time visitors.

`Localize.Plug.PutSession, as: :string` writes the active locale into the session as a string so LiveViews can read it.

`MyAppWeb.Plugs.Path` is created in step 6 — it assigns `:path` (the request path with the locale segment stripped). The language switcher uses this.

**c)** Wrap the routes that should gain a locale prefix in `localize do … end`. The simplest setup is to wrap the home route:

```elixir
scope "/", MyAppWeb do
  pipe_through :browser

  localize do
    get "/", PageController, :home
  end
end
```

Visiting `/` now redirects to `/en` (or whichever locale the resolver picked). To localize more routes, put them inside the same `localize do … end` block, or open additional ones inside their scopes.

## 5. Create `MyAppWeb.Path`

`Localize.Plug.PutLocale` exposes the active locale, but the language switcher needs to rebuild the **same** path under a different locale. Create `lib/my_app_web/path.ex` with helpers for stripping and rejoining the locale segment:

```elixir
defmodule MyAppWeb.Path do
  @moduledoc false

  def strip_after_locale(request_path) when is_binary(request_path) do
    loc = locale_leading_from_path(request_path) || Gettext.get_locale(MyAppWeb.Gettext)
    after_locale(request_path, loc)
  end

  defp locale_leading_from_path(path) do
    first =
      path
      |> String.trim_leading("/")
      |> String.split("/")
      |> List.first()
      |> case do
        s when s in ["", nil] -> nil
        s -> s
      end

    if is_binary(first) and first in Gettext.known_locales(MyAppWeb.Gettext),
      do: first,
      else: nil
  end

  defp after_locale(path, loc) when is_binary(path) and is_binary(loc) do
    base = "/" <> loc

    cond do
      path in ["/", base] -> ""
      String.starts_with?(path, base <> "/") -> String.replace_prefix(path, base, "")
      true -> path
    end
  end

  def join_locale_path(locale, after_path)
      when is_binary(locale) and (is_binary(after_path) or after_path == "") do
    base = "/" <> locale

    cond do
      after_path == "" or after_path == nil -> base
      String.starts_with?(after_path, "/") -> base <> after_path
      true -> base <> "/" <> after_path
    end
  end

  def with_current_locale(after_path) when is_binary(after_path) or after_path == "" do
    join_locale_path(Gettext.get_locale(MyAppWeb.Gettext), after_path)
  end
end
```

The three public functions are:

- `strip_after_locale/1` — `"/en/products"` → `"/products"` (used by `Plugs.Path` below).
- `join_locale_path/2` — `("fr", "/products")` → `"/fr/products"` (used by the switcher to build options).
- `with_current_locale/1` — `"/products"` → `"/en/products"` for the active request locale (used to mark the current option).

## 6. Create `MyAppWeb.Plugs.Path`

Create `lib/my_app_web/plugs/path.ex`. It runs after `Localize.Plug.PutSession` and assigns `:path` for the layout:

```elixir
defmodule MyAppWeb.Plugs.Path do
  @moduledoc "Assigns locale-stripped :path from the request (after Localize.Plug)."

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    path = MyAppWeb.Path.strip_after_locale(conn.request_path)
    assign(conn, :path, path)
  end
end
```

It's already mounted by step 4. From here on, `assigns[:path]` in any layout is the locale-stripped path (`"/products"`, never `"/en/products"`), exactly what the language switcher needs to build target URLs.

## 7. Create `MyAppWeb.LocalizeLayout`

The root layout's `lang` and `dir` come from `localize_web`'s CLDR data, not from a hand-maintained list. Create `lib/my_app_web/localize_layout.ex`:

```elixir
defmodule MyAppWeb.LocalizeLayout do
  @moduledoc false

  def html_lang(conn) do
    case Localize.Plug.PutLocale.get_locale(conn) do
      %Localize.LanguageTag{} = tag ->
        Localize.LanguageTag.to_string(tag)

      _ ->
        Gettext.get_locale(MyAppWeb.Gettext)
    end
  end

  def html_dir(conn) do
    locale_id =
      case Localize.Plug.PutLocale.get_locale(conn) do
        %Localize.LanguageTag{} = tag ->
          Localize.Locale.to_locale_id(tag)

        _ ->
          Gettext.get_locale(MyAppWeb.Gettext)
          |> Localize.Locale.locale_id_from_posix()
          |> Localize.LanguageTag.parse!()
          |> Localize.Locale.to_locale_id()
      end

    case Localize.Locale.get(locale_id, [:layout, :character_order], fallback: true) do
      {:ok, :rtl} -> "rtl"
      {:ok, :ltr} -> "ltr"
      {:ok, "right-to-left"} -> "rtl"
      _ -> "ltr"
    end
  end
end
```

`html_dir/1` queries the CLDR `:layout / :character_order` for the active locale, so adding `ar` to your Gettext locales is all it takes for `<html dir="rtl">` to start rendering — there is **no separate RTL guide** to follow.

## 8. Root layout: `lang` + `dir`

Update `lib/my_app_web/components/layouts/root.html.heex` to source `lang` and `dir` from `LocalizeLayout`:

```heex
<!DOCTYPE html>
<html
  lang={MyAppWeb.LocalizeLayout.html_lang(@conn)}
  dir={MyAppWeb.LocalizeLayout.html_dir(@conn)}
  data-theme={assigns[:theme] || "neo"}
  data-mode={assigns[:mode] || "light"}
>
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

Drop `data-theme` / `data-mode` if you have not enabled [Theming](theming.html) or [Dark mode](dark_mode.html) — they're shown here for completeness because most apps wire all three together.

## 9. `Layouts.app`: pass `path` and add the language switch

The language switcher needs the locale-stripped path so it can build `/fr/products`, `/en/products`, etc. Add a `:path` attr on `app/1` and a `language_switch/1` component to `lib/my_app_web/components/layouts.ex`:

```elixir
attr :flash, :map, required: true, doc: "the map of flash messages"
attr :path, :string, default: nil, doc: "locale-stripped path (from Plugs.Path)"
attr :mode, :string, default: "light", doc: "current mode (light or dark)"
attr :theme, :string, default: "neo", doc: "current theme"
attr :current_scope, :map, default: nil

slot :inner_block, required: true

def app(assigns) do
  ~H"""
  <header class="layout__header flex items-center gap-2">
    <.language_switch path={@path} />
    <.theme_toggle theme={@theme} />
    <.mode_toggle mode={@mode} />
  </header>
  <main class="layout__main">
    <div class="layout__content">
      {render_slot(@inner_block)}
    </div>
  </main>
  """
end

attr :path, :string, default: nil, doc: "locale-stripped path (from Plugs.Path)"

def language_switch(assigns) do
  backend = MyAppWeb.Gettext
  p = assigns.path || ""

  items =
    for loc <- Gettext.known_locales(backend), into: [] do
      %{
        id: MyAppWeb.Path.join_locale_path(loc, p),
        label: Localize.Locale.display_name!(loc, locale: loc)
      }
    end

  value = [MyAppWeb.Path.with_current_locale(p)]

  assigns =
    assigns
    |> assign(:items, items)
    |> assign(:value, value)

  ~H"""
  <.select
    id="corex-language-switch"
    class="select select--sm w-4xs"
    items={@items}
    value={@value}
    redirect
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

A few things worth calling out:

- **`Localize.Locale.display_name!(loc, locale: loc)`** renders each locale in **its own language** ("English", "Français", "العربية") rather than translating them all into the active locale.
- **Each option's `id` is a full path** like `"/fr/products"`. Combined with `redirect` on `<.select>`, picking a locale issues a real navigation to that URL, which re-runs the `:browser` pipeline and re-resolves the locale.
- **`value` is the current localized path**, so the matching option is always pre-selected.

## 10. Pass `path` from your pages

Every template that renders `Layouts.app` has to pass `path={assigns[:path]}` so the switcher knows where to send the user when they pick a different locale:

```heex
<Layouts.app
  flash={@flash}
  path={assigns[:path]}
  theme={assigns[:theme] || "neo"}
  mode={assigns[:mode] || "light"}
>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

For LiveViews, attach a small `on_mount` hook that pulls `:path` (and `:locale`, if you want it on the socket) from `connect_info` or `params`:

```elixir
defmodule MyAppWeb.PathLive do
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> assign_new(:path, fn -> "/" end)
      |> attach_hook(:path, :handle_params, fn _params, uri, socket ->
        path =
          uri
          |> URI.parse()
          |> Map.get(:path)
          |> Kernel.||("/")
          |> MyAppWeb.Path.strip_after_locale()

        {:cont, assign(socket, :path, path)}
      end)

    {:cont, socket}
  end
end
```

```elixir
def live_view do
  quote do
    use Phoenix.LiveView

    on_mount MyAppWeb.ModeLive
    on_mount MyAppWeb.ThemeLive
    on_mount MyAppWeb.PathLive
    unquote(html_helpers())
  end
end
```

`attach_hook(:handle_params, ...)` keeps `:path` in sync across `live_patch` and `live_navigate` without a full page reload.

## 11. Translate strings

With Gettext configured (step 2), wrap user-facing strings in `gettext("...")` and run the extract / merge cycle whenever you add new ones:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

`mix gettext.extract` rewrites `priv/gettext/default.pot` from your source. `mix gettext.merge priv/gettext` creates or updates the per-locale `.po` files (one for every locale in the `locales:` list of your backend).

Open `priv/gettext/fr/LC_MESSAGES/default.po` and fill in the `msgstr`:

```
#: lib/my_app_web/controllers/page_html/home.html.heex:3
#, elixir-autogen, elixir-format
msgid "Home"
msgstr "Accueil"
```

Corex components that expose translatable labels (Select, Editable, Dialog, …) read them from your Gettext backend automatically because of `config :corex, :gettext_backend, MyAppWeb.Gettext` in step 2. To override a single label without touching the whole catalog, pass a `Translation` struct on the component:

```heex
<.editable translation={%Corex.Editable.Translation{input: "Champ éditable"}} />
```

## Summary

1. **`localize_web` dep + Gettext** — Gettext is the source of truth for the locale list; `config :localize, :supported_locales` derives from it at runtime.
2. **`Localize.VerifiedRoutes`** — `~p"/foo"` automatically prefixes the active locale, so links never need manual locale handling.
3. **Router** — `use Localize.Routes`, `Localize.Plug.PutLocale` + `Localize.Plug.PutSession` after `:fetch_live_flash`, and `localize do … end` around the routes that gain a locale prefix.
4. **`MyAppWeb.Path`** — three small helpers (`strip_after_locale/1`, `join_locale_path/2`, `with_current_locale/1`) the switcher uses to rebuild URLs.
5. **`MyAppWeb.Plugs.Path`** — assigns `:path` (locale-stripped) for layouts.
6. **`MyAppWeb.LocalizeLayout`** — `html_lang/1` and CLDR-driven `html_dir/1`, so `<html dir="rtl">` is automatic for Arabic, Hebrew, Persian, …
7. **`Layouts.app`** — accepts `path={@path}` and renders `<.language_switch>`, a `<.select redirect>` populated from `Gettext.known_locales/1`.
8. **Translations** — `mix gettext.extract && mix gettext.merge priv/gettext`, then fill in the `.po` files.

This gives you URL-driven locales with a persistent user choice, RTL handling for free, and Corex components that speak the user's language out of the box.

## Related

- [Installation](installation.html) — the `--lang` flag wires all of the above automatically.
- [Dark mode](dark_mode.html) and [Theming](theming.html) — orthogonal preferences; the same browser pipeline carries them.
- [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) — what `~p` does under the hood.
- [`localize_web`](https://hex.pm/packages/localize_web) — full docs for the routing and CLDR layer.
