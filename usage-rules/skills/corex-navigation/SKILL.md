---
name: corex-navigation
description: >-
  Load when using .navigate with type navigate or patch, .action for buttons,
  redirect on select menu combobox listbox pagination, Corex.List.Item.new with
  to redirect :href :navigate :patch, language_switch locale paths, or
  guides/localize language switcher pattern.
---

# Corex navigation

Three patterns: links, buttons, redirect-on-select.

## Links

```heex
<.navigate to={~p"/dashboard"} type="navigate" class="link link--accent">Dashboard</.navigate>
<.navigate to={~p"/items?page=2"} type="patch" class="link">Page 2</.navigate>
```

## Redirect on select

```heex
<.select id="language-switch" class="select select--sm" items={items} value={[dest]} redirect>
  <:item :let={item}>{item.label}</:item>
</.select>
```

```elixir
Corex.List.Item.new(%{value: dest, label: "English", to: dest, redirect: :navigate})
```

Per-item `:redirect` — `:href`, `:patch`, `:navigate`, or `false`. Server logic before navigate → `on_value_change` + `redirect/2` instead.

Full checklist: sub-rule `corex:navigation`.
