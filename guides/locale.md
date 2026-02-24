# Locale

## Introduction

This guide walks through setting up **locale** (language) support in a Phoenix app using Corex. 

Locale is handled by a Plug that reads the locale from the URL segment, cookie, referer, or `Accept-Language` header.

For **RTL (Right-to-Left)** support (e.g. Arabic), see the [RTL guide](rtl.md) as a follow-up once locale is in place.

### The Problem

You want to:

- Serve the app in multiple locales (e.g. English and Arabic) with the locale in the URL (`/en/...`, `/fr/...`).
- Persist the user’s choice (e.g. cookie) and respect browser language.
- When switching locale, keep the same logical path (e.g. `/en/accordion` → `/fr/accordion`).

### The Solution

Use a **Locale plug** that:

1. Redirects requests without a valid locale (e.g. `/` or `/invalid/...`) to a localized path.
2. Sets `conn.assigns.locale` and `conn.assigns.current_path` (path without locale, for building switcher URLs).
3. Sets Gettext locale and a preferred-locale cookie.

Use **shared LiveView hooks** to assign `locale` and `current_path` from the URL on mount, and to handle the **locale_change** event so the locale switcher can redirect to the same path in another locale.

Set **`lang`** on the root `<html>` so the initial HTML and LiveView have the correct language.

---

## Implementation

### 1. Gettext Setup

Configure your Gettext backend with a default locale and the list of locales you support. In `lib/my_app_web/gettext.ex`:

```elixir
defmodule MyAppWeb.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    locales: ~w(en fr)
end
```

Extract translatable strings and create/update PO files for each locale:

```bash
mix gettext.extract
mix gettext.merge priv/gettext --locale fr
```

`mix gettext.extract` updates the default POT file from your source. `mix gettext.merge priv/gettext` creates or updates `.po` files for each locale in the `locales` list. Add more locale codes to `locales` as needed (e.g. `~w(en fr)`).

### 2. Create the Locale Plug

Create a plug that:

- Accepts requests where the first path segment is a valid locale (e.g. `/en/...`, `/fr/...`).
- Redirects all other requests to a localized URL using a determined locale (cookie, referer, `Accept-Language`, or default).
- Sets locale and path-without-locale in assigns and sets the Gettext locale.

Example (conceptually based on [SetLocale](https://github.com/smeevil/set_locale)); adapt module and backend to your app:

```elixir
defmodule MyAppWeb.Plugs.Locale do
  @moduledoc """
  Sets the locale for the current request from the path, cookie, referer, or Accept-Language.
  Assigns :locale and :current_path (path without locale segment).
  
  This integration is based on [SetLocale](https://github.com/smeevil/set_locale/tree/master), all credits go to original author [smeevil](https://github.com/smeevil).

  """
  import Plug.Conn

  @backend MyAppWeb.Gettext
  @locales Gettext.known_locales(@backend)
  @default_locale @backend.__gettext__(:default_locale)
  @cookie_key "preferred_locale"

  def init(opts), do: opts

  @doc """
  Returns the path without the locale prefix, for building locale-switch URLs.

  ## Examples

      path_without_locale("/en/accordion", "en")  # => "/accordion"
      path_without_locale("/fr", "fr")            # => "/"
  """
  def path_without_locale(path, locale) when is_binary(path) and is_binary(locale) do
    case String.replace_prefix(path, "/#{locale}", "") do
      "" -> "/"
      rest -> rest
    end
  end

  def call(%{params: %{"locale" => locale}} = conn, _opts) when locale in @locales do
    conn
    |> set_locale(locale)
    |> put_resp_cookie(@cookie_key, locale, max_age: 365 * 24 * 60 * 60)
  end

  def call(%{params: %{"locale" => invalid_locale}} = conn, _opts) do
    locale = determine_locale(conn)
    redirect_with_locale(conn, locale, strip_invalid_locale(conn.request_path, invalid_locale))
  end

  def call(conn, _opts) do
    locale = determine_locale(conn)
    redirect_with_locale(conn, locale, conn.request_path)
  end

  defp determine_locale(conn) do
    conn.cookies[@cookie_key] ||
      get_locale_from_referer(conn) ||
      get_locale_from_accept_language(conn) ||
      @default_locale
  end

  defp get_locale_from_referer(conn) do
    case get_req_header(conn, "referer") do
      [referer] when is_binary(referer) ->
        referer
        |> URI.parse()
        |> Map.get(:path)
        |> extract_locale_from_path()
        |> validate_locale()

      _ ->
        nil
    end
  end

  defp get_locale_from_accept_language(conn) do
    conn
    |> MyAppWeb.Plugs.Locale.Headers.extract_accept_language()
    |> Enum.find(&(&1 in @locales))
  end

  defp extract_locale_from_path(path) when is_binary(path) do
    case String.split(path, "/", parts: 3) do
      ["", maybe_locale | _] -> maybe_locale
      _ -> nil
    end
  end

  defp extract_locale_from_path(_), do: nil

  defp validate_locale(locale) when locale in @locales, do: locale
  defp validate_locale(_), do: nil

  defp strip_invalid_locale(path, invalid_locale) do
    String.replace_prefix(path, "/#{invalid_locale}", "")
  end

  defp redirect_with_locale(conn, locale, path) do
    path = localize_path(path, locale)
    path = preserve_query_string(conn, path)

    conn
    |> put_resp_cookie(@cookie_key, locale, max_age: 365 * 24 * 60 * 60)
    |> Phoenix.Controller.redirect(to: path)
    |> halt()
  end

  defp localize_path("/", locale), do: "/#{locale}"
  defp localize_path(path, locale), do: "/#{locale}#{path}"

  defp preserve_query_string(%{query_string: ""}, path), do: path
  defp preserve_query_string(%{query_string: qs}, path), do: "#{path}?#{qs}"

  defp set_locale(conn, locale) do
    Gettext.put_locale(@backend, locale)
    current_path = path_without_locale(conn.request_path, locale)

    conn
    |> assign(:locale, locale)
    |> assign(:current_path, current_path)
  end

  defmodule Headers do
    def extract_accept_language(conn) do
      case Plug.Conn.get_req_header(conn, "accept-language") do
        [value | _] ->
          value
          |> String.split(",")
          |> Enum.map(&parse_language_option/1)
          |> Enum.sort(&(&1.quality > &2.quality))
          |> Enum.map(& &1.tag)
          |> Enum.reject(&is_nil/1)
          |> ensure_language_fallbacks()

        _ ->
          []
      end
    end

    defp parse_language_option(string) do
      captures = Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

      quality =
        case Float.parse(captures["quality"] || "1.0") do
          {val, _} -> val
          _ -> 1.0
        end

      %{tag: captures["tag"], quality: quality}
    end

    defp ensure_language_fallbacks(tags) do
      Enum.flat_map(tags, fn tag ->
        [language | _] = String.split(tag, "-")
        if Enum.member?(tags, language), do: [tag], else: [tag, language]
      end)
    end
  end
end
```

### 3. Shared LiveView Hooks (locale + current_path + locale_change)

LiveViews under `/:locale` need `locale` and `current_path` on the socket, and must handle the **locale_change** event so the locale switcher can change language without losing the current path.

Create a shared hook module that:

- On mount: assigns `locale` from `params["locale"]`, and `current_path` from the request URI (using `path_without_locale`).
- On `handle_params`: updates `current_path` when the LiveView URL changes (e.g. patch).
- On `handle_event("locale_change", ...)`: redirects to the new locale URL (e.g. value `["/fr/accordion"]` or build `/fr` + `current_path`).

Example:

```elixir
defmodule MyAppWeb.SharedEvents do
  @moduledoc "Event handlers and assigns shared on LiveView modules (locale, current_path, locale_change)."
  use Phoenix.LiveView

  def on_mount(:default, params, _session, socket) do
    locale = params["locale"] || "en"
    Gettext.put_locale(FlytisWeb.Gettext, locale)

    socket =
      socket
      |> assign(:locale, locale)
      |> assign_current_path(params)
      |> attach_hook(:locale_change, :handle_event, &handle_locale_change/3)
      |> attach_hook(:current_path, :handle_params, &assign_current_path_from_uri/3)

    {:cont, socket}
  end

  defp assign_current_path(socket, params) do
    locale = params["locale"] || "en"
    path = get_connect_info(socket, :uri) |> path_from_uri()
    current_path = MyAppWeb.Plugs.Locale.path_without_locale(path || "/#{locale}", locale)
    assign(socket, :current_path, current_path)
  end

  defp assign_current_path_from_uri(_params, uri, socket) do
    path = path_from_uri(uri)
    locale = socket.assigns.locale
    current_path = MyAppWeb.Plugs.Locale.path_without_locale(path || "/#{locale}", locale)
    {:cont, assign(socket, :current_path, current_path)}
  end

  defp path_from_uri(nil), do: nil
  defp path_from_uri(uri) when is_binary(uri), do: URI.parse(uri).path
  defp path_from_uri(%URI{path: path}), do: path

  defp handle_locale_change("locale_change", params, socket) do
    value = params["value"] || params[:value] || []
    path = params["path"] || params[:path] || socket.assigns[:current_path] || "/"
    first = List.first(value)
    to =
      if first && String.starts_with?(first, "/") do
        first
      else
        "/#{first || "en"}#{path}"
      end

    {:halt, redirect(socket, to: to)}
  end

  defp handle_locale_change(_event, _params, socket) do
    {:cont, socket}
  end
end
```

Attach this in your `live_session` via `on_mount: [MyAppWeb.SharedEvents]` so every LiveView under that session gets locale, current_path, and the locale_change handler.


### 4. Create a Live View

Create a home Live View

```elixir
defmodule MyAppWeb.HomeLive do
  use MyAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <Layouts.app flash={@flash} locale={@locale} current_path={@current_path}>
    <h1>{gettext("Home")}</h1>
</Layouts.app>
    """
  end
end
```

### 5. Router: Locale in the Path

Use two scopes:

- **`scope "/"`** – e.g. a single `get "/", PageController, :home`. The Locale plug runs and redirects to `/{locale}` (or `/{locale}/...` if you later change the root to redirect to a default path).
- **`scope "/:locale"`** – all other routes (LiveView and controller). The first path segment is `params["locale"]`, so the plug sets assigns and does not redirect.

Add the plug to the browser pipeline:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug MyAppWeb.Plugs.Locale
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end

scope "/", MyAppWeb do
  pipe_through :browser
  get "/", PageController, :home
end

scope "/:locale", MyAppWeb do
  pipe_through :browser

  live_session :default, on_mount: [MyAppWeb.SharedEvents] do
    live "/home", HomeLive
  end

  get "/", PageController, :home
end
```

Visiting `/` triggers a redirect to `/{locale}` (e.g. `/en` or `/fr`). Visiting `/en/home` keeps the request in the `/:locale` scope and the plug sets `locale` and `current_path`.

### 5. Root Layout: `lang`

Set `lang` on the root `<html>` from assigns so the initial render and LiveView have the correct language:

```heex
<!DOCTYPE html>
<html lang={assigns[:locale] || "en"}>
  ...
</html>
```

### 6. Layout: App and Locale Switcher

Your app layout should receive `locale` and `current_path` and pass them to a locale switcher. Controllers get these from `conn.assigns`; LiveViews get them from the shared hook.

**App layout** – add `locale` and `current_path`:

```elixir
attr :locale, :string, default: nil, doc: "Current locale (from plug or LiveView assigns)."
attr :current_path, :string, default: "/", doc: "Path without locale segment, e.g. \"/accordion\", for the locale switcher."
```

In the layout template, pass them to the switcher and use them for links:

In you home.heex.html replace the content with 
```heex
<Layouts.app flash={@flash} locale={@locale} current_path={@current_path}>
  <div>
    <h1>{gettext("Home")}</h1>
  </div>
</Layouts.app>
```

**Locale switcher** – use Corex `<.select>` with:

- `collection`: options like `[%{id: "/en" <> current_path, label: "English"}, %{id: "/fr" <> current_path, label: "Français"}]`.
- `value`: `["/#{@locale}#{@current_path}"]`.
- `redirect`: true so normal changes do a full navigation.
- `on_value_change="locale_change"` so the shared hook can run and redirect (e.g. to preserve path or handle server-driven redirect).


Example inside you layout app:

```elixir
  <.select
    id="locale-select"
    class="select select--sm select--micro"
    collection={[
      %{id: "/en#{@current_path}", label: "English"},
      %{id: "/fr#{@current_path}", label: "Français"}
    ]}
    value={["/#{@locale}#{@current_path}"]}
    redirect
    on_value_change="locale_change"
  >
    <:label class="sr-only">Language</:label>
    <:item :let={item}>{item.label}</:item>
    <:trigger>
      <.icon name="hero-language" />
    </:trigger>
    <:item_indicator>
      <.icon name="hero-check" />
    </:item_indicator>
  </.select>
end
```

When the user picks another locale, the select sends the new URL (e.g. `/fr/accordion`) as value; the shared **locale_change** handler redirects to it, the Locale plug runs, and the next page renders with the same logical path in the new locale.

### 7. Controllers and LiveViews: Passing locale and current_path

- **Controllers** (under `scope "/:locale"`): After the plug runs, `conn.assigns` has `:locale` and `:current_path`. Pass them into the layout when rendering:

  ```elixir
  render(conn, :home, locale: conn.assigns.locale, current_path: conn.assigns.current_path)
  ```

  Your layout or page templates should use the same assign names (e.g. `@locale`, `@current_path`) so the root layout and locale switcher work.

- **LiveViews**: With `SharedEvents` in `on_mount`, each LiveView already has `@locale` and `@current_path`. Use them in the layout call:

  ```heex
  <Layouts.app flash={@flash} locale={@locale} current_path={@current_path}>
  ```

Internal links should include the locale so they stay in the same language:

```heex
<.link navigate={~p"/#{@locale}/accordion"} class="link">Accordion</.link>
```

Use `path_without_locale/2` only when building switcher URLs (e.g. `/en` + current_path); for normal links, use `@locale` in the path.


### 8. Gettext translate

Now lets translate our new Home word.
First let's run

```bash
 mix gettex extract
 mix gettex merge priv/gettext
```

You can then locate `my_app/priv/gettext/fr/LC_MESSAGES/default.po` and modify the last translation

```
#: lib/my_app_web/controllers/page_html/home.html.heex:3
#: lib/my_app_web/live/home_live.ex:13
#, elixir-autogen, elixir-format
msgid "Home"
msgstr "Accueil"
```
---

## Summary

1. **Gettext**: Configure backend with `default_locale` and `locales`; run `mix gettext.extract` and `mix gettext.merge priv/gettext` to create/update PO files.
2. **Locale plug**: Valid locale in path → set locale, current_path, Gettext, cookie; otherwise redirect to a localized URL using cookie/referer/Accept-Language/default.
3. **Router**: Root `get "/"` in `scope "/"` (plug redirects); all other routes under `scope "/:locale"` with the same browser pipeline.
4. **Root layout**: `<html lang={assigns[:locale] || "en"}>` from assigns.
5. **SharedEvents**: On mount assign `locale` and `current_path`; on params update `current_path`; handle **locale_change** by redirecting to the chosen locale URL.
6. **Layout**: Pass `locale` and `current_path` into the app layout; locale switcher uses `<.select>` with `redirect` and `on_value_change="locale_change"` and options built from `current_path`.
7. **Controllers**: Pass `conn.assigns.locale` and `conn.assigns.current_path` into the layout.
8. **LiveViews**: Rely on SharedEvents for `@locale` and `@current_path`, and use them in the layout and in links (`~p"/#{@locale}/..."`).

This gives URL-based locales, persistent preference, and path-preserving locale switch. For RTL support, see the [RTL guide](rtl.md).
