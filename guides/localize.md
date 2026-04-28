# Localize

Locale-aware URLs, assigns, and HTML **`lang`** / **`dir`** are optional. Enable them with **`--lang`** when generating or installing Corex.

## Enable with the installer

**New app:**

```bash
mix corex.new my_app --lang
```

**Existing app:**

```bash
mix igniter.install corex --yes --lang
```

Prerequisites: a standard Phoenix app with **Gettext** and a Gettext backend module (for example **`MyAppWeb.Gettext`**) so **`localize_web`** can discover locales. If you are adding Gettext only for this flow, generate or configure it like any Phoenix app, then continue here — [Gettext](https://hexdocs.pm/gettext/Gettext.html) and Phoenix guides cover the baseline.


## Router and plugs

The installer typically:

1. Adds **`use Localize.Routes, gettext: YourAppWeb.Gettext`** (your real backend module) to the **router**.
2. Wraps the initial browser routes in **`localize do … end`** so paths gain locale segments where configured.
3. Inserts **`Localize.Plug.PutLocale`** and **`Localize.Plug.PutSession`** after **`fetch_live_flash`**, with **`from:`** `[:route, :session, :accept_language, :query, :path]` so the locale is resolved from the URL and related inputs.
4. Inserts **`YourAppWeb.Plugs.Path`** immediately after **`PutSession`**. That plug assigns **`path`** — the request path **with locale segments stripped** — so links and UI can build locale-aware routes without double prefixes.

Mode and theme plugs, if enabled, are ordered with the same pipeline conventions as in **`Mix.Tasks.Corex.Install`**.

## Layout assigns

Root layouts generated with localization use helpers (often under something like **`LocalizeLayout`**) for **`html_lang/1`** and **`html_dir/1`** from **`conn`**, and pass **`locale`**, **`dir`**, **`theme`**, and **`mode`** when those features are combined.

Use **`@conn`** in layouts plugged through the browser pipeline to read assigns **`locale`**, **`path`**, and related values **`localize_web`** sets. For LiveViews, ensure **`current_scope`** / **`conn`** patterns match your Phoenix version so assigns reach **`Layouts.app`**.

Verified routes and helpers from **`Localize.Routes`** follow **`localize_web`** documentation — treat this guide as the Corex-specific wiring layer and read **`localize_web`** on Hex for API details.

## Gettext backend

Point **`Localize.Plug.PutLocale`** at your app Gettext module (the installer uses **`Module.concat(web_module, Gettext)`**). Ensure **`config :gettext, …`** (or your chosen backend config) matches that module so **`known_locales`** and runtime lookups agree.

## RTL

When a locale is RTL, **`html_dir`** should be **`rtl`** on **`<html>`** so layout and components mirror correctly. The installer’s localized root layout wires **`dir`** from the helper; if you merge layouts by hand, keep **`dir`** and **`lang`** in sync with **`conn`**.

## Design notes

Localized builds may import extra Corex Design pieces for language or direction-aware controls (for example select styling). Run **`mix corex.design`** and extend **`app.css`** imports as in [Manual installation](manual_installation.html).

## Related

- [Installation](installation.html) — **`--lang`** alongside **`--mode`** / **`--theme`**.
- [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html) — link helpers with your localized prefix patterns.
