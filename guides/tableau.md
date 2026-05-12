# Tableau

This guide adds [Corex](installation.html) to a **[Tableau](https://hex.pm/packages/tableau)** static site generated with HEEx, Esbuild, and Tailwind. It also covers the static-site equivalents of the Phoenix flow for **light/dark mode**, **theme**, **localization**, and the **MCP** plug  -  none of which can rely on a request-time plug pipeline in a Tableau site.

If you only need the minimum Corex install, stop after **6. Corex hooks**. **7** through **9** are optional: add mode/theme, localization, and/or MCP as needed.

For the underlying ideas behind the Phoenix flow (cookies + plugs + verified routes) see [Dark mode](dark_mode.html), [Theming](theming.html), and [Localize](localize.html)  -  this guide owns the Tableau equivalents.

## Create the site

```bash
mix tableau.new my_site --template heex --js esbuild --css tailwind
cd my_site
```


What `tableau.new` already gives you

- **`mix.exs`**: `tableau`, `tailwind`, `phoenix_live_view`, and `esbuild`
- **`config/config.exs`**: Esbuild profile **`default`** bundles **`assets/js/site.js`** into **`_site/js`**, with **`NODE_PATH`** pointing at **`deps/`** so npm-style imports from Hex dependencies resolve. Tailwind compiles **`assets/css/site.css`** to **`_site/css/site.css`**.
- **`lib/layouts/root_layout.ex`**: stylesheet at **`/css/site.css`**, script at **`/js/site.js`** (plain script tag, no CSRF meta).
- **`assets/js/site.js`**: empty in a fresh project.
- **`assets/css/site.css`**: typically only `@import "tailwindcss"`.

## 1. Elixir and the `corex` dependency

```elixir
{:corex, "~> 0.1.0-beta.5"}
```

Then:

```bash
mix deps.get
```

## 2. Esbuild: ESM, splitting, and `_site/js`

Corex’s client uses **dynamic `import()`** for hook chunks. Follow **[Manual installation  -  Esbuild](manual_installation.html#2-esbuild)** (`--format=esm`, `--splitting`, a modern `--target` such as **`es2022`**). Keep Tableau’s output directory so URLs stay **`/js/site.js`** and chunks stay next to that file under **`_site/js`**.

Replace the stock **`config :esbuild, ... default:`** args with something like:

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

## 3. Corex design assets

Copy packaged design CSS into your app:

```bash
mix corex.design
```

That creates **`assets/corex/`** from the **`corex`** package (see **`Mix.Tasks.Corex.Design`**). Use **`--force`** to overwrite, **`--designex`** to also copy token sources if you use [Designex](https://hex.pm/packages/designex) later.

## 4. Tailwind entry: import Corex CSS

After **`@import "tailwindcss"`** (or your Tailwind v4 entry), import design layers. At minimum: **`main.css`**, a **theme** (here **`neo`**), **typography** and **layout**, plus **one stylesheet per component family** you render. The example below already imports **`select.css`** and **`toggle-group.css`** for the theme picker and mode toggle in **7. Mode and theme**  -  drop them if you skip that part.

```css
@import "tailwindcss";

@import "../corex/main.css";
@import "../corex/theme/neo.css";

@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/select.css";
@import "../corex/components/toggle-group.css";
@import "../corex/components/accordion.css";
```

To support all four soonex-style themes at once, also import **`theme/uno.css`**, **`theme/duo.css`**, and **`theme/leo.css`**. Each `theme/*.css` file scopes its tokens under `[data-theme="<name>"]`, so they coexist in one bundle  -  the active one is whichever the `<html>` attribute names.

Add **`typo`** and **`layout`** classes on **`<body>`**

## 5. Root layout

Corex’s JS is **ESM** and Phoenix **`LiveSocket`** expects a **CSRF** token in the page. The layout below includes `data-*` attributes for mode and theme (**7**), `lang` / `dir` for localization (**8**), and the inline script from **7.5**  -  remove what you do not use.

In your **`Tableau.Layout`** module (typically **`lib/layouts/root_layout.ex`**):

```elixir
defmodule MyApp.RootLayout do
  import Phoenix.Controller, only: [get_csrf_token: 0]

  use Tableau.Layout
  use Phoenix.Component
  use Corex
  use Gettext, backend: MyApp.Gettext

  def template(assigns) do
    locale = MyApp.Locale.current(assigns.page)
    Gettext.put_locale(MyApp.Gettext, MyApp.Locale.lang(locale))

    assigns =
      assigns
      |> Map.put(:locale, locale)
      |> Map.put(:theme, MyApp.Theme.current(assigns))
      |> Map.put(:mode, MyApp.Mode.current(assigns))
      |> Map.put(:site_name, MyApp.Config.site_name())

    ~H"""
    <!DOCTYPE html>
    <html
      lang={MyApp.Locale.lang(@locale)}
      dir={MyApp.Locale.dir(@locale)}
      data-theme={@theme}
      data-mode={@mode}
      data-locale={@locale}
      data-themes={Enum.join(MyApp.Config.themes(), ",")}
      data-locales={Enum.join(MyApp.Config.locales(), ",")}
      data-default-theme={MyApp.Config.default_theme()}
      data-locale-selected-path={MyApp.Locale.selected_path(@page, @locale)}
    >
      <head>
        {MyApp.Appearance.head_script()}
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <title>{assigns[:page_title] || @site_name}</title>
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

Three pieces stay invariant:

1. **`<meta name="csrf-token" content={get_csrf_token()} />`**  -  required by `Phoenix.LiveSocket`.
2. **`<script type="module" src="/js/site.js" />`**  -  Corex’s JS bundle is ESM.
3. **`use Corex`**  -  exposes Corex function components inside the layout template.

If you skip **7**, drop **`data-theme`** / **`data-mode`** / **`data-themes`** / **`data-default-theme`** and **`MyApp.Appearance.head_script()`**. If you skip **8**, drop **`use Gettext`**, **`Gettext.put_locale/2`**, and **`lang`** / **`dir`** / **`data-locale*`**. **`MyApp.Theme`**, **`MyApp.Mode`**, **`MyApp.Locale`**, **`MyApp.Config`**, and **`MyApp.Appearance`** appear in the sections below.

## 6. Corex hooks

Import the **lazy `hooks`** helper from **`corex/hooks`** and pass one zero-argument factory per hook you actually use. Object keys must match the **`phx-hook`** names. With **`--format=esm --splitting`** from **2. Esbuild**, Esbuild emits chunks **only** for the modules you list, so a component that never appears on a page is never fetched.

In **`assets/js/site.js`**:

```javascript
import "./appearance.js"
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
      ToggleGroup: () => import("corex/toggle-group"),
      Tooltip: () => import("corex/tooltip"),
      Accordion: () => import("corex/accordion"),
    }),
  },
})

liveSocket.connect()
```

Drop **`Select`** / **`ToggleGroup`** / **`Tooltip`** when you skip **7**, and drop **`import "./appearance.js"`** when you skip mode/theme/lang entirely  -  that file is the bridge from **7.5**.

If you'd rather pull in **every** Corex hook at once and let your bundler keep the full lazy registry in your graph, replace the `hooks({...})` block with:

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: { ...corex },
})
```

Each lazy factory in the **`hooks({...})`** form is a **zero-argument function** returning the same dynamic `import()` your bundler would emit. If you already eager-import hook implementations from **`corex/<component>`**, you can still merge them with **`hooks`** by passing hook objects (not functions) as values  -  useful with `colocatedHooks`.

## 7. Mode and theme

The Phoenix flow in [Dark mode](dark_mode.html) and [Theming](theming.html) uses cookies + a **`Plugs.Mode`** / **`Plugs.Theme`** pipeline + a server-rendered **`data-mode`** / **`data-theme`** on `<html>`. Tableau builds static HTML, so there is no per-request plug pipeline. Instead:

1. **App config** lists the available themes and the default theme.
2. **`MyApp.Config`** / **`MyApp.Theme`** / **`MyApp.Mode`** read those values and resolve the active mode/theme from the layout assigns (defaulting when nothing is set).
3. **`MyApp.Appearance.head_script/0`** emits an inline `<script>` that runs **before paint** and reconciles `localStorage` ↔ `data-theme` / `data-mode` on `<html>`, with `prefers-color-scheme` as the mode fallback and `data-default-theme` as the theme fallback.
4. **`assets/js/appearance.js`** is the bridge: it listens for **`corex:set-theme`**, **`corex:set-mode`** (and **`corex:set-locale`**  -  see **8**) window events from the Corex controls, persists the choice to `localStorage`, syncs `<html>` data attributes, and pushes the value back into the Select / ToggleGroup once each control mounts.
5. The **`<.select>`** theme picker and **`<.toggle_group>`** mode toggle dispatch those events via **`on_value_change_client="corex:set-theme"`** / **`"corex:set-mode"`**  -  no server round-trip.

### 7.1. App config

In **`config/config.exs`**:

```elixir
config :my_app,
  site_name: "MyApp",
  themes: ~w(neo uno duo leo),
  default_theme: "neo"
```

Match the list to the theme files you `@import` in `app.css`  -  exposing `leo` is pointless if you never `@import "../corex/theme/leo.css"`. The first theme in the list is also the safe fallback when no choice is stored.

### 7.2. `MyApp.Config`

A small wrapper so layout, helpers, and the bridge JS read from the same source of truth.

```elixir
defmodule MyApp.Config do
  @app :my_app

  def site_name, do: Application.get_env(@app, :site_name, "MyApp")

  def themes, do: Application.get_env(@app, :themes, ["neo"])

  def default_theme do
    Application.get_env(@app, :default_theme) || List.first(themes()) || "neo"
  end
end
```

You'll extend this module with **`default_locale`** / **`locales`** in **8. Localization**.

### 7.3. `MyApp.Theme` and `MyApp.Mode`

Resolve the active theme/mode from layout assigns with safe fallbacks. **`MyApp.Theme.select_items/0`** is the source of truth for the picker.

```elixir
defmodule MyApp.Theme do
  def themes, do: MyApp.Config.themes()
  def default_theme, do: MyApp.Config.default_theme()

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
end
```

```elixir
defmodule MyApp.Mode do
  def current(assigns) do
    case Map.get(assigns, :mode) do
      "dark" -> "dark"
      _ -> "light"
    end
  end

  def toggle_value("dark"), do: ["dark"]
  def toggle_value(_), do: []
end
```

`current/1` always returns `"light"` or `"dark"`  -  `prefers-color-scheme` only applies **client-side** via the inline script in **7.4**. The first paint follows the layout assigns (usually the default); the script corrects before the body paints.

### 7.4. Inline reconciliation script

**`MyApp.Appearance.head_script/0`** runs **inside `<head>`, before `<body>` paints**. It reads `localStorage["data-theme"]` / `localStorage["data-mode"]` and writes the resolved values back to `<html>` so the first paint matches what the user picked previously.

```elixir
defmodule MyApp.Appearance do
  def head_script do
    themes_json = Jason.encode!(MyApp.Config.themes())
    default_theme_json = Jason.encode!(MyApp.Config.default_theme())

    Phoenix.HTML.raw("""
    <script>
      try {
        const themes = #{themes_json};
        const dt = #{default_theme_json};
        const t = localStorage.getItem("data-theme");
        const theme = themes.includes(t) ? t : dt;
        document.documentElement.setAttribute("data-theme", theme);

        const m = localStorage.getItem("data-mode");
        const prefersDark = matchMedia("(prefers-color-scheme: dark)").matches;
        const mode = m === "dark" || m === "light" ? m : (prefersDark ? "dark" : "light");
        document.documentElement.setAttribute("data-mode", mode);
      } catch (_) {}
    </script>
    """)
  end
end
```

The root layout (**5. Root layout**) already calls `{MyApp.Appearance.head_script()}` inside `<head>`. Because the script runs synchronously before the body paints, the page avoids a wrong theme/mode flash.

### 7.5. The bridge: `assets/js/appearance.js`

Imported as the **first** statement of `assets/js/site.js` (**6. Corex hooks**). It reads **`data-themes`** / **`data-default-theme`** / **`data-locales`** from `<html>` so the JS doesn't duplicate the config:

```javascript
(() => {
  const html = () => document.documentElement;

  const parseList = (attr) =>
    (html().getAttribute(attr) || "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);

  const validThemes = () => parseList("data-themes");
  const defaultTheme = () =>
    html().getAttribute("data-default-theme") || validThemes()[0] || "neo";
  const validLocales = () => parseList("data-locales");

  const getSystemMode = () =>
    window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

  const applyTheme = (theme) => {
    const themes = validThemes();
    const resolved = themes.includes(theme) ? theme : defaultTheme();
    localStorage.setItem("data-theme", resolved);
    html().setAttribute("data-theme", resolved);
    return resolved;
  };

  const applyMode = (mode) => {
    const resolved = mode === "dark" || mode === "light" ? mode : getSystemMode();
    localStorage.setItem("data-mode", resolved);
    html().setAttribute("data-mode", resolved);
    return resolved;
  };

  const setLocale = (loc) => {
    const allowed = validLocales();
    if (loc && allowed.includes(loc)) localStorage.setItem("data-locale", loc);
  };

  const firstDetailValue = (e) => {
    const v = e.detail?.value;
    return Array.isArray(v) && v[0] ? v[0] : null;
  };

  const whenControlReady = (id, run) => {
    const iv = window.setInterval(() => {
      const root = document.getElementById(id);
      if (root && !root.hasAttribute("data-loading")) {
        window.clearInterval(iv);
        run();
      }
    }, 10);
    window.setTimeout(() => window.clearInterval(iv), 10_000);
  };

  const syncSelect = (id, value) => {
    const root = document.getElementById(id);
    if (!root || !value) return;
    root.dispatchEvent(
      new CustomEvent("corex:select:set-value", { detail: { value: [value] } }),
    );
  };

  const syncToggleGroup = (id, mode) => {
    const root = document.getElementById(id);
    if (!root) return;
    root.dispatchEvent(
      new CustomEvent("corex:toggle-group:set-value", {
        detail: { value: mode === "dark" ? ["dark"] : [] },
      }),
    );
  };

  applyTheme(localStorage.getItem("data-theme") || html().getAttribute("data-theme") || defaultTheme());
  applyMode(localStorage.getItem("data-mode") || html().getAttribute("data-mode") || getSystemMode());

  whenControlReady("theme-switcher", () => syncSelect("theme-switcher", html().getAttribute("data-theme")));
  whenControlReady("mode-switcher", () => syncToggleGroup("mode-switcher", html().getAttribute("data-mode")));
  whenControlReady("corex-language-switch", () =>
    syncSelect("corex-language-switch", html().getAttribute("data-locale-selected-path")),
  );

  window.addEventListener("storage", (e) => {
    if (e.key === "data-theme" && e.newValue) applyTheme(e.newValue);
    if (e.key === "data-mode" && e.newValue) applyMode(e.newValue);
    if (e.key === "data-locale" && e.newValue) setLocale(e.newValue);
  });

  window.addEventListener("corex:set-theme", (e) => {
    applyTheme(firstDetailValue(e) || defaultTheme());
  });

  window.addEventListener("corex:set-mode", (e) => {
    const raw = e.detail?.value;
    const isDark = Array.isArray(raw) && raw.includes("dark");
    applyMode(isDark ? "dark" : "light");
  });

  window.addEventListener("corex:set-locale", (e) => {
    const raw = firstDetailValue(e);
    const seg = (raw || "").replace(/^\/+|\/+$/g, "").split("/")[0] || "";
    setLocale(seg);
  });
})();
```

The **`whenControlReady`** helper waits for each Corex control to finish hydrating (its hook clears the **`data-loading`** attribute once `mount` runs), then pushes the current value via **`corex:select:set-value`** / **`corex:toggle-group:set-value`**. This is what keeps the picker UI in sync with `localStorage` after the inline reconciliation script ran.

The **`storage`** listener gives you cross-tab sync for free: change theme in one tab and every other open tab follows.

### 7.6. Theme picker and mode toggle

Render both inside the root layout (**5**), typically in a header or a floating `<.tooltip>`. The DOM ids **`theme-switcher`** and **`mode-switcher`** must match the values the bridge looks for.

```heex
<.select
  id="theme-switcher"
  class="select select--sm"
  dir={MyApp.Locale.dir(@locale)}
  items={MyApp.Theme.select_items()}
  value={[@theme]}
  close_on_select={false}
  update_trigger={false}
  on_value_change_client="corex:set-theme"
  translation={%Corex.Select.Translation{placeholder: gettext("Theme")}}
>
  <:label class="sr-only">{gettext("Theme")}</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger>
    <.heroicon name="hero-swatch" class="icon" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" class="icon" />
  </:item_indicator>
</.select>

<.toggle_group
  id="mode-switcher"
  class="toggle-group toggle-group--sm toggle-group--duo toggle-group--circle"
  multiple={false}
  deselectable={true}
  value={MyApp.Mode.toggle_value(@mode)}
  dir={MyApp.Locale.dir(@locale)}
  on_value_change_client="corex:set-mode"
>
  <:item value="dark" aria_label={gettext("Toggle color mode")}>
    <.heroicon name="hero-sun" class="icon state-on" />
    <.heroicon name="hero-moon" class="icon state-off" />
  </:item>
</.toggle_group>
```

Drop **`dir={…}`** when you skip **8** and replace **`gettext(...)`** with plain strings if you don't want Gettext. The Corex Design **`state-on`** / **`state-off`** classes flip which icon is visible based on the toggle's selected value.

## 8. Localization

The Phoenix flow in [Localize](localize.html) plugs locale resolution into the router and wraps localized routes in **`localize do … end`**. Tableau has no router, so locales are **baked in at build time**:

1. **App config**  -  supported locales + default locale.
2. **`MyApp.Gettext`** + **`MyApp.Locale`**  -  the Gettext backend and a small helper that drives `<html lang dir>`, **`swap_path/2`**, and the language switcher items.
3. **Per-locale page modules** generated with **`Module.create/3`**, with permalink **`"/"`** for the default locale and **`"/<locale>/..."`** for the rest.
4. **`<.select redirect>`** language switcher in the layout that navigates to the swapped path; the bridge persists the choice to `localStorage` so the next visit lands on the right locale.

### 8.1. Add the dependencies

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

**`mix localize.download_locales`** populates the on-disk CLDR cache that **`Localize.Locale.get/3`** (used by **`MyApp.Locale.dir/1`**) and **`Localize.Locale.display_name/2`** (used by **`MyApp.Locale.label/1`**) read from. Run it once after adding the dep, and again whenever the supported list changes; consider hooking it into **`mix setup`** so fresh clones don't have to remember.

> **`localize_web` is not required** in a Tableau site  -  its plugs and **`Localize.Routes`** are Phoenix-router only. Add it only if you want its HTML helpers in templates.

### 8.2. Configure Gettext + supported locales

Put default and allowed locales on the Gettext backend (and optional small helpers), not scattered across `config :my_app`:

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

In **`config/config.exs`**, wire Corex to the host catalog via **Phoenix**. Corex resolves the host Gettext backend from `Application.get_env(:phoenix, :gettext_backend)` at render time. Set JSON for Phoenix, and declare **Localize** supported locales (must use literals or fixed atoms here: config is evaluated before your app modules are compiled, so you cannot call `Gettext.known_locales/1` from this file):

```elixir
config :phoenix,
  gettext_backend: MyApp.Gettext,
  json_library: Jason

config :localize,
  supported_locales: ~w(en ar)a
```

**`config :phoenix, :gettext_backend`** is what makes Corex components (Select, Editable, Dialog, …) pull their default labels from your catalog. Override a single label with a **`Translation`** struct on the component.

Point **`MyApp.Config`** (**7.2**) at Gettext for the same list the rest of the app uses:

```elixir
def default_locale, do: MyApp.Gettext.default_locale()
def locales, do: MyApp.Gettext.locales()
```

### 8.3. `MyApp.Locale`

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

**`current/1`** reads the page's permalink  -  the first path segment is the locale when supported, otherwise the default. **`swap_path/2`** is the workhorse for the language switcher: it strips the existing locale segment, prepends the target, and serves the default locale at **`/`** (instead of **`/en/`**) so canonical URLs stay clean. **`dir/1`** falls back through CLDR character order, then a hard-coded `ar → rtl` for safety.

### 8.4. Per-locale page modules

A single template module keeps the markup; **`Module.create/3`** builds one **`Tableau.Page`** per locale with the right permalink:

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

Repeat the **`for`** block for every other page (about, posts index, …) you want under every locale. Markdown posts can keep a single layout (e.g. **`MyApp.PostLayout`**) and use **`permalink: /:title/`** in the front matter  -  the locale prefix only applies to the page modules you generate yourself.

### 8.5. Language switcher

The root layout in **5. Root layout** already sets **`<html lang dir>`** and the **`data-locale*`** attributes, and it calls **`Gettext.put_locale/2`**. Render the language switcher anywhere in the body  -  typically in a footer:

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

**`redirect`** makes the **`<.select>`** navigate to **`item.to`** on selection (the **`swap_path/2`** result), and **`on_value_change_client="corex:set-locale"`** lets the bridge persist the choice in **`localStorage["data-locale"]`** so other open tabs (and the language picker after hydration) stay in sync. The active locale on each page is still driven by the URL  -  `/` for the default locale, `/<locale>/...` for the others  -  so canonical links survive sharing.

### 8.6. Translate strings

Wrap user-facing strings in **`gettext("…")`** and run the extract / merge cycle:

```bash
mix gettext.extract
mix gettext.merge priv/gettext
```

Edit **`priv/gettext/<locale>/LC_MESSAGES/default.po`** and fill in the **`msgstr`**s. Corex components pick up the translations automatically through **`config :corex, :gettext_backend`**.

## 9. MCP via Bandit (optional)

**`mix corex.new`** for Phoenix wires the **MCP plug** directly into the endpoint (`plug` line in the snippet below). Tableau builds static HTML and has no endpoint, so MCP runs as a **separate Bandit child** in the application supervisor on a dedicated port (default **`4004`**).

For what that plug exposes and how it is used by AI tools, see [MCP](mcp.html).

### 9.1. The plug

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

The **MCP plug** halts the conn for the routes it handles; the **`:not_found`** fallback returns a 404 for everything else so the Bandit child doesn't sit silent on unrelated paths.

### 9.2. The supervisor child

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

Add **`{:bandit, "~> 1.0"}`** to your deps if it isn't there yet, and point **`mod:`** in **`mix.exs`** at **`{MyApp.Application, []}`** so the supervisor starts.

### 9.3. Per-environment config

Enable it in **`config/dev.exs`** (and **`config/test.exs`** if you also need it for tests):

```elixir
config :my_app, :mcp_enabled, true
config :my_app, :mcp_port, 4004
```

Production keeps **`:mcp_enabled`** falsey by default. With Tableau's dev server on **`:4999`** and MCP on **`:4004`**, point your MCP client at **`http://localhost:4004`**.

## Try a component

After **`mix compile`** and your usual Tableau asset build (for example **`mix tableau.build`** or watch tasks from **`config :tableau, :assets`**), use a component in a page template.

```heex
<.accordion
  id="welcome-accordion"
  class="accordion"
  items={Corex.Content.new([
    [label: "First", content: "Panel one."],
    [label: "Second", content: "Panel two."]
  ])}
/>
```

## Related

- [Installation](installation.html)  -  **`mix corex.new`**, first components, next steps.
- [Manual installation](manual_installation.html)  -  Esbuild details, **`mix corex.design`**, **`type="module"`**, **`use Corex`**, toasts, MCP, and Phoenix-only layout notes.
- [Dark mode](dark_mode.html) and [Theming](theming.html)  -  Phoenix-style cookies and plugs for what **7** does in this guide.
- [Localize](localize.html)  -  Phoenix-style **`localize_web`** and **`localize do … end`** for what **8** does here.
- [MCP](mcp.html)  -  what the **MCP plug** does and the standard Phoenix-pipeline integration.
