# Localize

## Introduction

Visitors switch locale with a Corex `<.language_switch>` (a `<.select redirect>`). Choosing a language keeps the same logical page (`/en/accordion` → `/fr/accordion`) by rewriting the locale segment of the current path.

Localized apps also set `lang` and `dir` on `<html>` from `MyAppWeb.Locale` so screen readers, font shaping, and bidi text work. Static Tableau sites use permalink-based locales instead; see [Tableau Localize](tableau_localize.html).

## Install first

Wire `localize_web`, Gettext locales, router plugs / `localize do`, `MyAppWeb.Locale`, and (for LiveViews) `Hooks.Layout` before you drop this UI into a layout:

- New app: `mix corex.new my_app --lang`
- Existing app: [Manual installation: optional locale wiring](manual_installation.html#optional-locale-wiring)

## Already wired?

| Piece | Expect |
| ----- | ------ |
| Deps | `localize_web` (and Gettext / CLDR data for supported locales) |
| Router | `Localize.Plug.PutLocale` / `PutSession`, routes inside `localize do` / `/:locale` |
| Locale module | `MyAppWeb.Locale` with `locales/0`, `current/0`, `label/1`, `swap_path/2`, `lang/0`, `dir/0` |
| LiveView | `on_mount MyAppWeb.Hooks.Layout` (or equivalent) so `:current_path` tracks navigation |
| Hook | `Select` registered in `assets/js/app.js` |

## Language switcher

The switcher needs the **full request path** (including the locale segment) so `Locale.swap_path/2` can rewrite the first segment. `mix corex.new --lang` adds a `:current_path` assign on `Layouts.app` and typically renders `<.language_switch>` in the footer.

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

`redirect` navigates to each item’s `to` path. Items use `Corex.List.Item` so value, label, and destination stay aligned.

## Layout placement

**Controllers / HEEx**: pass the connection path:

```heex
<Layouts.app flash={@flash} current_path={@conn.request_path}>
  <h1>{gettext("Home")}</h1>
</Layouts.app>
```

Add `mode`, `theme`, and other assigns when you use those features.

**LiveViews**: `Hooks.Layout` (from `--lang`) should assign `:current_path` on mount and keep it updated on `live_patch` / `live_navigate`. Then render the switcher in the shell:

```heex
<.language_switch current_path={@current_path} />
```

Root layout should set `lang` and `dir` from `MyAppWeb.Locale` (install wiring). With Corex Design and mode/theme, also set `data-theme` / `data-mode` on `<html>`; see [Dark mode](dark_mode.html) and [Theming](theming.html).

## Troubleshooting

| Symptom | Check |
| ------- | ----- |
| Switcher missing or empty | `Locale.locales/0` matches supported locales; `Select` hook registered |
| Wrong page after switch | `current_path` is the full request path (including locale segment) |
| Stale path after LiveView navigate | `Hooks.Layout` (or your `handle_params`) updates `:current_path` |
| Labels look like `EN` / `FR` | CLDR data downloaded for those locales (`mix localize.download_locales`) |
| `dir` wrong for RTL | `Locale.dir/0` and root `dir={MyAppWeb.Locale.dir()}` |

## Related

- [Manual installation](manual_installation.html#optional-locale-wiring): deps, router, `Locale`, and LiveView hooks
- [Installation](installation.html): `mix corex.new --lang`
- [Tableau Localize](tableau_localize.html): static site equivalent
- [Dark mode](dark_mode.html) and [Theming](theming.html): picker UI when combined with locale
- [Phoenix verified routes](https://hexdocs.pm/phoenix/Phoenix.VerifiedRoutes.html): what `~p` does under the hood
- [`localize_web`](https://hex.pm/packages/localize_web): routing and CLDR layer
