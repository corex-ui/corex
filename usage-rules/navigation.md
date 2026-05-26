# Corex navigation

Navigation is three patterns — not one component.

## Links — `<.navigate>`

Explicit anchors. Import `link.css` when using Corex Design.

```heex
<.navigate to="/about" class="link">About</.navigate>
<.navigate to={~p"/dashboard"} type="navigate" class="link link--accent">Dashboard</.navigate>
<.navigate to={~p"/items?page=2"} type="patch" class="link">Page 2</.navigate>
<.navigate to="https://example.com" external class="link">External</.navigate>
```

| `type` | Behavior |
|--------|----------|
| `"href"` (default) | Full page load |
| `"navigate"` | LiveView navigation |
| `"patch"` | LiveView patch (same live session) |

Icon-only links need `aria_label`. `external` only valid with `type="href"`.

## Buttons — `<.action>`

Actions and form submit. Can bind imperative API:

```heex
<.action class="button button--accent" phx-click={Corex.Dialog.open("my-dialog")}>
  Open
</.action>
```

## Redirect on select — list components

Set `redirect` on the component. Build items with `Corex.List.new/1` or `Corex.List.Item.new/1`.

**Component attr:** `redirect` (boolean) — navigate when user selects an item.

**Per-item fields:**

| Field | Purpose |
|-------|---------|
| `:value` / `:to` | Destination path or URL |
| `:redirect` | `:href` (default), `:patch`, `:navigate`, or `false` |
| `:new_tab` | Open external link in new tab |

Components supporting `redirect`: `select`, `menu`, `combobox`, `listbox`, `pagination`.

### Language switcher example

```elixir
items =
  for locale <- MyAppWeb.Locale.locales(), into: [] do
    dest = MyAppWeb.Locale.swap_path(current_path, locale)

    Corex.List.Item.new(%{
      value: dest,
      label: MyAppWeb.Locale.label(locale),
      to: dest
    })
  end
```

```heex
<.select
  id="language-switch"
  class="select select--sm"
  items={items}
  value={[current_dest]}
  redirect
  positioning={%Corex.Positioning{same_width: true}}
>
  <:label class="sr-only">Language</:label>
  <:item :let={item}>{item.label}</:item>
  <:trigger><.heroicon name="hero-language" /></:trigger>
</.select>
```

### Redirect type per item

```elixir
Corex.List.Item.new(%{
  value: "/menu/anatomy",
  label: "Full page",
  redirect: :href
})

Corex.List.Item.new(%{
  value: "/menu/events",
  label: "LiveView navigate",
  redirect: :navigate
})
```

### Pagination with URL sync

```heex
<.pagination
  id="users-pagination"
  controlled
  redirect={:patch}
  to={~p"/users"}
  …
/>
```

## When to use which

| Need | Use |
|------|-----|
| Static link in markup | `<.navigate>` |
| Button action / submit | `<.action>` |
| Pick destination from list (locale, menu, theme) | `redirect` on select/menu/combobox |
| Server logic before navigate | `on_value_change` + `redirect/2` in `handle_event` instead of `redirect` attr |

## References

- https://hexdocs.pm/corex/localize.html
- `Corex.Navigate`, `Corex.Menu`, `Corex.Select` moduledocs
