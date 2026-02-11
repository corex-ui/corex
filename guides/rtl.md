# RTL

## Introduction

This guide adds **RTL (Right-to-Left)** support to an app that already has [locale](locale.md) set up. It covers setting the document direction (`dir="rtl"`) from the current locale and ensuring Corex components (menus, dialogs, select, etc.) mirror correctly for languages like Arabic.

**Prerequisites:** You have followed the [Locale guide](locale.md) and have a Locale plug, `/:locale` routes, and `@locale` / `@current_path` in assigns.

### The Problem

For RTL locales (e.g. `ar`), you need to:

- Set `dir="rtl"` on the root `<html>` so layout and text flow correctly.
- Have the Locale plug and LiveView hooks assign `:dir` so the root layout and any component that needs it can use it.
- Rely on Corex components to derive direction from the document when `dir` is not passed explicitly.

### The Solution

1. Configure which locales are RTL via `config :corex, rtl_locales: ["ar"]`.
2. In the Locale plug’s `set_locale`, assign `:dir` from the current locale and that config.
3. In the root layout, set `dir={assigns[:dir] || "ltr"}` on `<html>` (with an optional fallback from `locale` + `rtl_locales`).
4. In the shared LiveView hook, assign `:dir` from `params["locale"]` and the same config.
5. Corex components that support direction read it from the document when `dir` is not passed; you can override per component with `dir={@dir}` if needed.

---

## Implementation

### 1. Configuration

In `config/config.exs` (or env-specific config), add which locales are RTL:

```elixir
config :corex,
  gettext_backend: MyAppWeb.Gettext,
  rtl_locales: ["ar"]
```

Add every RTL locale code you support (e.g. `["ar", "fa", "he"]`).

### 2. Locale Plug: Assign `dir`

In your Locale plug’s `set_locale` function, compute `dir` from the current locale and assign it:

```elixir
defp set_locale(conn, locale) do
  Gettext.put_locale(@backend, locale)
  current_path = path_without_locale(conn.request_path, locale)
  dir = if locale in Application.get_env(:corex, :rtl_locales, []), do: "rtl", else: "ltr"

  conn
  |> assign(:locale, locale)
  |> assign(:dir, dir)
  |> assign(:current_path, current_path)
end
```

### 3. Root Layout: `dir` on `<html>`

Set `dir` on the root `<html>` from assigns so the initial render and LiveView both have the correct direction:

```heex
<!DOCTYPE html>
<html lang={assigns[:locale] || "en"} dir={assigns[:dir] || "ltr"} data-theme="neo" data-mode={assigns[:mode]}>
  ...
</html>
```

If the root layout can run before the plug has set `assigns[:dir]` (e.g. first paint), you can derive `dir` from `locale` and config:

```heex
<html
  lang={assigns[:locale] || "en"}
  dir={assigns[:dir] || (if assigns[:locale] in Application.get_env(:corex, :rtl_locales, []), do: "rtl", else: "ltr")}
  data-theme="neo"
  data-mode={assigns[:mode]}
>
```

This avoids FOUC and lets Corex components that read direction from the document get the right value.

### 4. Shared LiveView Hook: Assign `dir`

In the shared hook used by LiveViews under `/:locale`, assign `:dir` from the locale param and the same config:

```elixir
def on_mount(:default, params, _session, socket) do
  locale = params["locale"] || "en"
  dir = if locale in Application.get_env(:corex, :rtl_locales, []), do: "rtl", else: "ltr"

  socket =
    socket
    |> assign(:locale, locale)
    |> assign(:dir, dir)
    |> assign_current_path(params)
    |> attach_hook(:locale_change, :handle_event, &handle_locale_change/3)
    |> attach_hook(:current_path, :handle_params, &assign_current_path_from_uri/3)

  {:cont, socket}
end
```

Pass `@dir` into the app layout if you use it in the layout (e.g. for a wrapper with `dir={@dir}`). The root `<html>` is rendered by the server on full page loads; LiveView updates the body, so `dir` on `<html>` is correct as long as the plug or initial LiveView mount sets it (e.g. via the root layout assigns).

### 5. Corex Components and Direction

- **Document**: Setting `dir="rtl"` on `<html>` is enough for the page and for Corex components that derive direction from the document when `dir` is not passed.
- **Explicit `dir`**: Many Corex components (menu, dialog, select, combobox, tabs, etc.) accept an optional `dir` attribute. If you pass `dir={@dir}`, that overrides the document-derived value. Usually you only need the document `dir` and the shared assigns.
- **Per-component override**: For a single component that should differ from the page (e.g. a LTR menu on an RTL page), pass `dir="ltr"` (or the opposite of `@dir`) explicitly.

---

## Summary

1. **Config**: Add `rtl_locales: ["ar"]` (and any other RTL locale codes) under `config :corex, ...`.
2. **Locale plug**: In `set_locale`, set `dir` from locale + `rtl_locales` and `assign(conn, :dir, dir)`.
3. **Root layout**: Set `dir={assigns[:dir] || "ltr"}` (or derive from `assigns[:locale]` + `rtl_locales`) on `<html>`.
4. **SharedEvents**: On mount, assign `:dir` from `params["locale"]` and `rtl_locales`.
5. **Corex components**: Use document `dir` by default; pass `dir={@dir}` only when you need to override or pass it explicitly.

This gives correct RTL layout and Corex component behavior when using RTL locales. For locale setup (URL, cookie, switcher), see the [Locale guide](locale.md).
