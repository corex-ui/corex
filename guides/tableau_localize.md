# Tableau static + Corex: localize

This guide is for a **[Tableau](https://hex.pm/packages/tableau)** site that already follows **[Tableau](tableau.html)** through design assets, ESM Esbuild, root layout, and `LiveSocket` hooks.

The Phoenix setup in **[Localize](localize.html)** resolves locale in the router and wraps routes in **`localize do … end`**. Static Tableau builds **locale into permalinks** at compile time:** **`/`** for the default locale, **`/<locale>/...`** elsewhere. **`locale.js`** persists the chosen locale for cross-tab UX and hydrates the language select; **`Gettext`** still drives **`gettext/1`** in templates.

Dependencies for **`locale.js`** **`data-rtl-locales`**: derive RTL locale codes from the same source as **`MyApp.Locale.dir/1`** (template below filters locales where CLDR layout is **`:rtl`**).

---

### 1. Dependencies

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

**`mix localize.download_locales`** fills the on-disk CLDR cache for **`Localize.Locale.get/3`** and **`Localize.Locale.display_name/2`**. Run it when the supported list changes; consider **`mix setup`**.

> **`localize_web` is not required** in a Tableau site — its plugs and **`Localize.Routes`** are Phoenix-router only. Add it only if you want its HTML helpers.

---

### 2. Gettext backend and config

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

In **`config/config.exs`** (use literals; config runs before your modules compile):

```elixir
config :phoenix,
  gettext_backend: MyApp.Gettext,
  json_library: Jason

config :localize,
  supported_locales: ~w(en ar)a
```

**`config :phoenix, :gettext_backend`** lets Corex components read default labels from your catalog.

---

### 3. `MyApp.Config` (locale slice)

Merge with **[Tableau static + Corex: theming](tableau_theming.html)** **`themes`** / **`site_name`** if you use that guide too.

```elixir
defmodule MyApp.Config do
  @app :my_app

  def site_name, do: Application.get_env(@app, :site_name, "MyApp")

  def default_locale, do: MyApp.Gettext.default_locale()

  def locales, do: MyApp.Gettext.locales()
end
```

---

### 4. `MyApp.Locale`

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

---

### 5. Root layout additions

In **`template/1`**, add **`use Gettext, backend: MyApp.Gettext`** next to **`use Corex`**. Resolve **`locale`** from **`assigns.page`**, apply **`Gettext.put_locale/2`** before **`~H`**, and enrich assigns (**`rtl_locales`** must agree with **`MyApp.Locale.dir/1`** for each listed code):

```elixir
def template(assigns) do
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

Minimal **`<html>`** deltas (combine with **`data-theme`** / **`data-mode`** when you follow those guides):

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

If you publish under a subpath (**GitHub Pages** project sites), also set **`data-public-path-prefix`** to the pathname prefix (**without** trailing slash); **`locale.js`** strips it before reading the first segment. Omit both when serving from the domain root.

Theming and mode **`<head>`** scripts stay **outside** this guide; see **[Tableau static + Corex: theming](tableau_theming.html)** and **[Tableau static + Corex: mode](tableau_mode.html)**.

---

### 6. `assets/js/locale.js`

Self-contained (**`parseList`**, **`whenControlReady`**, **`firstDetailValue`** inlined):

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

---

### 7. `assets/js/site.js` additions

```javascript
import "./locale.js"
```

Register **Select** if not already present:

```javascript
      Select: () => import("corex/select"),
```

---

### 8. Per-locale page modules

One template module; **`Module.create/3`** emits one **`Tableau.Page`** per locale:

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

Repeat the **`for`** block for each page that should exist under every locale.

---

### 9. Language switcher HEEx

**`redirect`** navigates to **`item.to`**; **`on_value_change_client="corex:set-locale"`** updates **`locale.js`** / **`localStorage`**. The authoritative locale remains the URL.

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

---

### 10. Translate strings

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Fill **`priv/gettext/<locale>/LC_MESSAGES/default.po`**.

## Related

- [Tableau](tableau.html) — baseline Tableau + Corex setup.
- [Localize](localize.html) — Phoenix **`localize_web`** and **`localize do`**.
- [Tableau static + Corex: theming](tableau_theming.html) / [Tableau static + Corex: mode](tableau_mode.html) — combine when you want theme or mode alongside locales.
