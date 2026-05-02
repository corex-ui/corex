# Localize

## Introduction

This guide walks through wiring **locale-aware URLs and content** into a Phoenix + Corex app using the [`localize_web`](https://hex.pm/packages/localize_web) library. The result is:

- URLs that include a locale prefix (e.g. `/en/home`, `/fr/home`)
- A `<html lang="..." dir="...">` that reflects the active locale, with **RTL automatic** for languages like Arabic
- A `<.select>` language switcher that swaps locales while preserving the current page
- Gettext-driven translations for component labels and your own strings

If you ran `mix corex.new my_app --lang`, the installer wrote the modules and layout wiring described here. Use this guide to understand what that produced, or to wire it by hand in an existing app.

For the underlying Corex install, see [Manual installation](manual_installation.html).

### The problem

You want to:

- Serve the app in multiple locales with the locale in the URL
- Persist the user's choice and respect browser language headers as a fallback
- When switching locale, keep the same logical path (`/en/accordion` → `/fr/accordion`)
- Get correct `lang` and `dir` on `<html>` so screen readers, font shaping, and bidi text all work

### The solution

`localize_web` provides the URL-routing layer (`Localize.Routes`) and the per-request locale resolution plugs (`Localize.Plug.PutLocale`, `Localize.Plug.PutSession`). Corex layers on top:

- A **`MyAppWeb.Path`** helper that strips the locale prefix from request paths, exposes the active locale segment for verified routes (optional), and builds localized URLs for the switcher.
- A **`MyAppWeb.Plugs.Path`** plug that assigns `:path` (locale-stripped) and mirrors it into the session.
- A **`MyAppWeb.Locale`** module with **`lang/0`**, **`dir/0`**, **`locales/0`**, and **`label/1`** for the root layout and language switcher labels (CLDR-backed `dir`, non-bang display names with fallback).
- A **`<.language_switch>`** component on `Layouts` that renders a Corex `<.select redirect>` whose items use **`Corex.List.Item`** and **`MyAppWeb.Locale`** / **`MyAppWeb.Path`**.

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

### Download CLDR locale files (`mix localize.download_locales`)

The [`localize`](https://hex.pm/packages/localize) dependency (pulled in by `localize_web`) serves formatting, validation, and locale display names from Unicode CLDR data stored in an **on-disk cache**. Until a locale’s data is present there, APIs such as `Localize.Locale.display_name/2`, `Localize.Locale.get/3` (used for RTL `dir` in **`MyAppWeb.Locale.dir/0`**), and `Locale.label/1` in the language switcher may not resolve that locale cleanly and may fall back.

Download the locales that match `:supported_locales` at least once after adding dependencies or changing supported locales:

```bash
mix localize.download_locales
```

Or request specific locale ids:

```bash
mix localize.download_locales en fr ar
```

Files are written under the app’s build output (for example `_build/dev/lib/localize/priv/localize/locales/`). In Docker or CI, run `mix localize.download_locales` during the image build so production ships with the cache; alternatively set `config :localize, allow_runtime_locale_download: true` so missing locales are fetched from the Localize CDN on first use (often avoided in production in favor of pre-downloading).

You can hook the task into setup-style pipelines—for example `mix setup`—alongside asset tooling so new clones get CLDR data without an extra manual step.

## 3. Phoenix verified routes (default vs optional `path_prefixes`)

[`mix corex.new --lang`](installation.html) keeps the stock **`Phoenix.VerifiedRoutes`** setup: **`endpoint`**, **`router`**, and **`statics`** only — **no** [`path_prefixes`](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html#module-localized-routes-and-path-prefixes). Static assets and route helpers behave like a typical Phoenix app; localized page URLs still come from your router (`localize do … end`) and plugs.

### Optional: prefix `~p` with the active locale

If you want `~p"/foo"` to expand to paths that include the leading locale segment (for example when matching bookmarked `/fr/...` URLs), add a **`path_prefixes`** entry whose function returns the same segment **`MyAppWeb.Path.locale_segment/0`** uses (derived from `Localize.get_locale()` with a Gettext fallback):

```elixir
def verified_routes do
  quote do
    use Phoenix.VerifiedRoutes,
      endpoint: MyAppWeb.Endpoint,
      router: MyAppWeb.Router,
      statics: MyAppWeb.static_paths(),
      path_prefixes: [{MyAppWeb.Path, :locale_segment, []}]
  end
end
```

Confirm against [`Phoenix.VerifiedRoutes`](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) for your Phoenix version; the MFA shape must match what `path_prefixes` expects.

Phoenix's stock helper generation flag (`use Phoenix.Router, helpers: false`) is incompatible with `Localize.Routes` (which expects route helpers). In `lib/my_app_web.ex`, ensure:

```elixir
def router do
  quote do
    use Phoenix.Router, helpers: true
  end
end
```

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
    from: [:path, :session, :accept_language],
    gettext: MyAppWeb.Gettext

  plug Localize.Plug.PutSession, as: :string

  plug MyAppWeb.Plugs.Path

  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end
```

The `from:` list matches **`mix corex.new --lang`**: leading URL segment, then session, then `Accept-Language`. You can add **` :route`**, **`:query`**, or reorder if your app needs different priority — see [`localize_web`](https://hex.pm/packages/localize_web).

`Localize.Plug.PutSession, as: :string` writes the active locale into the session so LiveViews can read it.

`MyAppWeb.Plugs.Path` is created in step 6 — it assigns `:path` (locale-stripped) and stores it in the session. The language switcher and **`Layouts.app`** use this.

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

Create `lib/my_app_web/path.ex`:

```elixir
defmodule MyAppWeb.Path do
  @moduledoc false

  @gettext_backend MyAppWeb.Gettext

  def locale_segment do
    case Localize.get_locale() do
      %{cldr_locale_id: id} when is_atom(id) ->
        Atom.to_string(id)

      %{cldr_locale_id: id} when is_binary(id) ->
        id

      _ ->
        Gettext.get_locale(@gettext_backend)
    end
  end

  def request_path_from_uri(uri) when is_binary(uri) do
    case URI.parse(uri) do
      %URI{path: nil} -> "/"
      %URI{path: ""} -> "/"
      %URI{path: path} -> path
    end
  end

  def request_path_from_uri(%URI{} = uri), do: uri.path || "/"

  def strip_after_locale(request_path) when is_binary(request_path) do
    loc = locale_leading_from_path(request_path) || Gettext.get_locale(@gettext_backend)
    after_locale(request_path, loc)
  end

  def join_locale_path(locale, after_path) when is_atom(locale) do
    join_locale_path(Atom.to_string(locale), after_path)
  end

  def join_locale_path(locale, after_path)
      when is_binary(locale) and (is_binary(after_path) or after_path in ["", nil]) do
    base = "/" <> locale

    cond do
      after_path == "" or after_path == nil ->
        base

      String.starts_with?(after_path, "/") ->
        base <> after_path

      true ->
        base <> "/" <> after_path
    end
  end

  def with_current_locale(after_path) when is_binary(after_path) or after_path in ["", nil] do
    join_locale_path(locale_segment(), after_path)
  end

  def locale_string(%Localize.LanguageTag{} = tag) do
    case tag.cldr_locale_id do
      id when is_atom(id) -> Atom.to_string(id)
      id when is_binary(id) -> id
      _ -> Gettext.get_locale(@gettext_backend)
    end
  end

  def locale_string(loc) when is_atom(loc), do: Atom.to_string(loc)
  def locale_string(loc) when is_binary(loc), do: loc

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

    if is_binary(first) and first in Gettext.known_locales(@gettext_backend),
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
end
```

## 6. Create `MyAppWeb.Plugs.Path`

Create `lib/my_app_web/plugs/path.ex`:

```elixir
defmodule MyAppWeb.Plugs.Path do
  @moduledoc "Assigns locale-stripped :path from the request (after Localize.Plug)."

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    path = MyAppWeb.Path.strip_after_locale(conn.request_path)

    conn
    |> assign(:path, path)
    |> put_session(:path, path)
  end
end
```

From here on, **`assigns[:path]`** on controller-backed pages is the locale-stripped path (`"/products"`, not `"/en/products"`). LiveViews do not get plug assigns automatically unless you add an **`on_mount`** hook (step 10).

## 7. Create `MyAppWeb.Locale`

The root layout’s effective language and direction come from **`Localize.get_locale()`** and CLDR **`Localize.Locale.get/3`**, matching the installer. Create `lib/my_app_web/locale.ex`:

```elixir
defmodule MyAppWeb.Locale do
  @moduledoc false

  @gettext_backend MyAppWeb.Gettext

  def locales do
    case Application.get_env(:localize, :supported_locales) do
      list when is_list(list) and list != [] -> Enum.map(list, &to_string/1)
      _ -> Gettext.known_locales(@gettext_backend)
    end
  end

  def label(loc) when is_binary(loc) do
    case Localize.Locale.display_name(loc, locale: loc) do
      {:ok, name} -> name
      _ -> String.upcase(loc)
    end
  end

  def label(loc) when is_atom(loc), do: label(Atom.to_string(loc))

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
end
```

Adding `ar` (and downloading CLDR data) is enough for **`dir="rtl"`** where the locale metadata says RTL — there is **no separate RTL guide**.

## 8. Root layout: `lang` + `dir`

Update `lib/my_app_web/components/layouts/root.html.heex` so localized apps set **`lang`** and **`dir`** from **`MyAppWeb.Locale`** (values must work as HTML attributes; adjust if `lang/0` returns a structured locale in your stack):

```heex
<!DOCTYPE html>
<html lang={MyAppWeb.Locale.lang()} dir={MyAppWeb.Locale.dir()} data-theme={assigns[:theme] || "neo"} data-mode={assigns[:mode] || "light"}>
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

Drop **`data-theme`** / **`data-mode`** / **`class="typo layout"`** if you have not enabled [Theming](theming.html), [Dark mode](dark_mode.html), or Corex Design — the generator turns those pieces on only when the matching flags are set.

## 9. `Layouts.app`: pass `path` and add the language switch

The language switcher needs the locale-stripped path so it can build targets like **`MyAppWeb.Path.join_locale_path("fr", suffix)`**. Add a **`:path`** attr on **`app/1`** (default **`""`** in the installer) and a **`language_switch/1`** component.

**Placement:** `mix corex.new --lang` renders **`<.language_switch>`** in the **layout footer** next to other actions; you can move it (for example into a header row) as long as you pass **`path={@path}`**.

Example **`language_switch`** aligned with the installer (Corex list items with **`to:`** for navigation):

```elixir
attr :path, :string, default: "", doc: "locale-stripped request path (from Plugs.Path)"

def language_switch(assigns) do
  suffix = assigns.path || ""

  items =
    for locale <- MyAppWeb.Locale.locales(), into: Corex.List.new([]) do
      loc_str = to_string(locale)

      Corex.List.Item.new(%{
        id: loc_str,
        label: MyAppWeb.Locale.label(locale),
        to: MyAppWeb.Path.join_locale_path(loc_str, suffix)
      })
    end

  value = [MyAppWeb.Path.locale_segment()]

  assigns =
    assigns
    |> assign(:items, items)
    |> assign(:value, value)

  ~H"""
  <.select
    id="corex-language-switch"
    class="select select--sm max-w-5xs"
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

Call **`<.language_switch path={@path} />`** from **`app/1`** wherever you want the control.

## 10. Pass `path` from your pages

**Controllers / HEEx** — pass the plug assign through:

```heex
<Layouts.app flash={@flash} path={@path}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

**LiveViews** — the installer does **not** add a global **`PathLive`** hook. Add your own **`on_mount`** if LiveViews render **`Layouts.app`** with a switcher, so **`assigns.path`** tracks **`live_patch`** / **`live_navigate`**:

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
          |> MyAppWeb.Path.request_path_from_uri()
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

1. **`localize_web` dep + Gettext** — Gettext lists locales; `config :localize, :supported_locales` derives from it at runtime when present. Run **`mix localize.download_locales`** so CLDR data exists for **`Locale.dir/0`**, **`Locale.label/1`**, and related APIs.
2. **`Phoenix.VerifiedRoutes`** — **`mix corex.new --lang`** does not add **`path_prefixes`**; optionally add **`path_prefixes: [{MyAppWeb.Path, :locale_segment, []}]`** if you need locale-prefixed **`~p`** expansion (verify against Phoenix docs).
3. **Router** — **`use Localize.Routes`**, **`Localize.Plug.PutLocale`** with **`from: [:path, :session, :accept_language]`**, **`Localize.Plug.PutSession`**, **`Plugs.Path`**, and **`localize do … end`** around localized routes.
4. **`MyAppWeb.Path`** — locale segment, strip/join helpers, URI path helper for LiveViews.
5. **`MyAppWeb.Plugs.Path`** — **`assign(:path, …)`** and **`put_session(:path, …)`**.
6. **`MyAppWeb.Locale`** — **`lang/0`**, **`dir/0`**, **`locales/0`**, **`label/1`** for root layout and switcher labels.
7. **`Layouts.app`** — **`path={@path}`** and **`<.language_switch>`** using **`Corex.List.Item`** + **`<.select redirect>`**.
8. **Translations** — **`mix gettext.extract`** && **`mix gettext.merge priv/gettext`**, then edit **`.po`** files.

This gives you URL-driven locales with a persistent user choice, RTL handling where CLDR says so, and Corex components that follow your Gettext backend.

## Related

- [Installation](installation.html) — the **`--lang`** flag wires the generated files for you.
- [Dark mode](dark_mode.html) and [Theming](theming.html) — orthogonal preferences; the same browser pipeline can carry Mode/Theme plugs alongside localize plugs.
- [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) — what **`~p`** does under the hood.
- [`localize_web`](https://hex.pm/packages/localize_web) — full docs for the routing and CLDR layer.
