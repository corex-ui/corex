# Tableau Localize

## Introduction

You add locales to a Tableau site that already follows [Tableau](tableau.html). Each locale gets its own permalink at build time (`/` for the default, `/<locale>/...` for others). Gettext drives copy; `locale.js` persists the visitor's choice and syncs the language `<.select>`.

For Phoenix apps with `localize_web` and router scopes, see [Localize](localize.html).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| [Tableau](tableau.html) | Design assets, ESM Esbuild, `use Corex`, `LiveSocket` |
| `{:gettext, "~> 1.0"}` and `{:localize, "~> 0.26}` | CLDR display names and RTL |
| `select.css` | For the language switcher |

`localize_web` is not required for Tableau static sites.

## How it works

1. **Gettext** catalogs hold translated strings; `gettext/1` in templates reads the active locale.
2. **Permalinks** encode locale in the URL path at compile time.
3. **`locale.js`** reads `data-locale*` on `<html>`, updates `lang`/`dir`, and syncs the select.
4. **`<.select redirect>`** navigates to the target path; `corex:set-locale` updates storage for cross-tab UX.

<!-- tabs-open -->

### Dependencies

```elixir
def deps do
  [
    {:gettext, "~> 1.0"},
    {:localize, "~> 0.26"}
  ]
end
```

```bash
mix deps.get
mix localize.download_locales en ar
```

Run `mix localize.download_locales` again when you add locales.

### Gettext

`lib/my_app/gettext.ex`:

```elixir
defmodule MyApp.Gettext do
  use Gettext.Backend,
    otp_app: :my_app,
    default_locale: "en",
    allowed_locales: ~w(en ar)

  def default_locale, do: __gettext__(:default_locale)
  def locales, do: Gettext.known_locales(__MODULE__)
end
```

`config/config.exs`:

```elixir
config :phoenix,
  gettext_backend: MyApp.Gettext,
  json_library: Jason

config :localize,
  supported_locales: ~w(en ar)a
```

### Locale module

Merge `site_name` with [Tableau Theming](tableau_theming.html) if you use themes.

`lib/my_app/config.ex`:

```elixir
defmodule MyApp.Config do
  @app :my_app

  def site_name, do: Application.get_env(@app, :site_name, "MyApp")
  def default_locale, do: MyApp.Gettext.default_locale()
  def locales, do: MyApp.Gettext.locales()
end
```

`lib/my_app/locale.ex`:

```elixir
defmodule MyApp.Locale do
  def locales, do: MyApp.Config.locales()
  def default_locale_string, do: MyApp.Config.default_locale()

  def current(page) when is_map(page) do
    perm = Map.get(page, :permalink) || Map.get(page, "permalink") || "/"

    case String.split(perm, "/", trim: true) do
      [first | _] -> if first in locales(), do: first, else: default_locale_string()
      [] -> default_locale_string()
    end
  end

  def lang(locale) when is_binary(locale), do: locale
  def lang(_), do: default_locale_string()

  def dir(locale) do
    loc = lang(locale)

    case Localize.Locale.get(loc, [:layout, :character_order], fallback: true) do
      {:ok, :rtl} -> "rtl"
      {:ok, :ltr} -> "ltr"
      _ -> if loc == "ar", do: "rtl", else: "ltr"
    end
  end

  def label(loc) when is_atom(loc), do: label(Atom.to_string(loc))

  def label(loc) when is_binary(loc) do
    case Localize.Locale.display_name(loc, locale: loc) do
      {:ok, name} -> name
      _ -> String.upcase(loc)
    end
  end

  def swap_path(request_path, target_locale) do
    target = to_string(target_locale)
    supported = locales()
    default = default_locale_string()

    rest =
      case String.split(request_path, "/", trim: true) do
        [first | tail] -> if first in supported, do: tail, else: [first | tail]
        [] -> []
      end

    cond do
      target == default and rest == [] -> "/"
      target == default -> "/" <> Enum.join(rest, "/")
      rest == [] -> "/" <> target <> "/"
      true -> "/" <> Enum.join([target | rest], "/")
    end
  end

  def current_path(%{permalink: perm}) when is_binary(perm) do
    if String.starts_with?(perm, "/"), do: perm, else: "/" <> perm
  end

  def current_path(_), do: "/"

  def selected_path(page, locale), do: page |> current_path() |> swap_path(locale)

  def language_select_items(current_path) do
    locales()
    |> Enum.map(fn loc ->
      dest = swap_path(current_path, loc)

      Corex.List.Item.new(%{
        value: dest,
        to: dest,
        label: label(loc)
      })
    end)
    |> Corex.List.new()
  end

  def language_select_value(current_path, locale), do: [swap_path(current_path, locale)]
end
```

### Layout

In `RootLayout`, add `use Gettext, backend: MyApp.Gettext` next to `use Corex`.

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

On `<html>` (combine with `data-theme` / `data-mode` when you use those guides):

```heex
<html
  lang={MyApp.Locale.lang(@locale)}
  dir={MyApp.Locale.dir(@locale)}
  data-locale={@locale}
  data-locales={Enum.join(MyApp.Config.locales(), ",")}
  data-rtl-locales={@rtl_locales}
  data-locale-selected-path={MyApp.Locale.selected_path(assigns.page, @locale)}
>
```

For GitHub Pages project sites, set `data-public-path-prefix` to the pathname prefix without a trailing slash; `locale.js` strips it before reading the first path segment.

[Tableau Theming](tableau_theming.html) and [Tableau Mode](tableau_mode.html) head scripts stay in `<head>` as documented there.

### locale.js

Create `assets/js/locale.js`:

```javascript
;(() => {
  const html = () => document.documentElement

  const parseList = (attr) =>
    (html().getAttribute(attr) || "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean)

  const whenControlReady = (id, run) => {
    const iv = window.setInterval(() => {
      const root = document.getElementById(id)
      if (root && !root.hasAttribute("data-loading")) {
        window.clearInterval(iv)
        run()
      }
    }, 10)
    window.setTimeout(() => window.clearInterval(iv), 10_000)
  }

  const firstDetailValue = (e) => {
    const value = e.detail?.value
    return Array.isArray(value) && value[0] ? value[0] : null
  }

  const validLocales = () => parseList("data-locales")

  const rtlLocales = () => new Set(parseList("data-rtl-locales"))

  const directionForLocale = (loc) =>
    loc && rtlLocales().has(loc) ? "rtl" : "ltr"

  const resolvedLocale = () => {
    const pathLoc = localeFromPathname()
    if (pathLoc) return pathLoc
    const docLoc = html().getAttribute("data-locale")
    if (docLoc && validLocales().includes(docLoc)) return docLoc
    const stored = localStorage.getItem("data-locale")
    if (stored && validLocales().includes(stored)) return stored
    return ""
  }

  const syncDocumentLocale = () => {
    const loc = resolvedLocale()
    if (!loc || !validLocales().includes(loc)) return
    html().setAttribute("lang", loc)
    html().setAttribute("data-locale", loc)
    html().setAttribute("dir", directionForLocale(loc))
  }

  const setLocale = (loc) => {
    const allowed = validLocales()
    if (!loc || !allowed.includes(loc)) return
    localStorage.setItem("data-locale", loc)
  }

  const syncLangSelect = (path) => {
    const root = document.getElementById("corex-language-switch")
    if (!root || !path) return
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [path] } }),
    )
  }

  const publicPathPrefix = () => {
    const raw = html().getAttribute("data-public-path-prefix") || ""
    return raw.replace(/\/+$/, "")
  }

  const localeFromPathname = () => {
    let pathname = window.location.pathname
    const pre = publicPathPrefix()
    if (pre && pathname.startsWith(pre)) {
      pathname = pathname.slice(pre.length) || "/"
    }
    const segs = pathname.split("/").filter(Boolean)
    const first = segs[0] || ""
    return validLocales().includes(first) ? first : ""
  }

  const syncLangFromDocument = () => {
    const path = html().getAttribute("data-locale-selected-path")
    syncLangSelect(path)
  }

  const pathLocale = localeFromPathname()
  if (pathLocale) setLocale(pathLocale)

  syncDocumentLocale()

  whenControlReady("corex-language-switch", () => {
    syncDocumentLocale()
    syncLangFromDocument()
  })

  window.addEventListener("storage", (e) => {
    if (e.key === "data-locale" && e.newValue) {
      setLocale(e.newValue)
      syncDocumentLocale()
    }
  })

  window.addEventListener("corex:set-locale", (e) => {
    const raw = firstDetailValue(e)
    const s = raw != null ? String(raw) : ""
    const seg = s.replace(/^\/+|\/+$/g, "").split("/")[0] || ""
    const allowed = validLocales()
    if (allowed.includes(seg)) {
      setLocale(seg)
      html().setAttribute("lang", seg)
      html().setAttribute("data-locale", seg)
      html().setAttribute("dir", directionForLocale(seg))
    }
  })

  window.addEventListener("pageshow", () => {
    syncDocumentLocale()
    syncLangFromDocument()
  })
})()
```

### site.js

```javascript
import "./locale.js"
```

Register `Select` in `hooks` if not already present.

### Pages

One shared template; emit one `Tableau.Page` per locale:

```elixir
defmodule MyApp.HomePage do
  use Phoenix.Component
  use Corex
  use Gettext, backend: MyApp.Gettext

  def template(assigns) do
    ~H"""
    <article class="layout__article" aria-labelledby="home-headline">
      <h1 id="home-headline">{gettext("Welcome")}</h1>
      <p>{gettext("Hello from %{name}.", name: MyApp.Config.site_name())}</p>
    </article>
    """
  end
end

for locale <- MyApp.Config.locales() do
  mod = Module.concat(MyApp.HomePage, String.upcase(locale))

  permalink =
    if locale == MyApp.Config.default_locale(), do: "/", else: "/#{locale}/"

  Module.create(
    mod,
    quote do
      use Tableau.Page,
        layout: MyApp.RootLayout,
        permalink: unquote(permalink),
        title: unquote(MyApp.Config.site_name()),
        page_kind: :home

      def template(assigns), do: MyApp.HomePage.template(assigns)
    end,
    __ENV__
  )
end
```

Repeat the `for` block for each page that should exist under every locale.

### Language select

`redirect` navigates to `item.to`. The URL is authoritative; `corex:set-locale` updates `localStorage` for other tabs.

```heex
<.select
  id="corex-language-switch"
  class="select select--sm max-w-6xs"
  dir={MyApp.Locale.dir(@locale)}
  items={MyApp.Locale.language_select_items(MyApp.Locale.current_path(@page))}
  value={MyApp.Locale.language_select_value(MyApp.Locale.current_path(@page), @locale)}
  redirect
  on_value_change_client="corex:set-locale"
  translation={%Corex.Select.Translation{placeholder: gettext("Language")}}
  positioning={%Corex.Positioning{same_width: true}}
>
  <:label class="sr-only">{gettext("Language")}</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger>
    <.heroicon name="hero-language" class="icon" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" class="icon" />
  </:item_indicator>
</.select>
```

Extract and merge catalogs:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Fill `priv/gettext/<locale>/LC_MESSAGES/default.po`.

<!-- tabs-close -->

## Related

- [Tableau](tableau.html) — baseline setup
- [Localize](localize.html) — Phoenix `localize_web` and router scopes
- [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html) — combine when needed
