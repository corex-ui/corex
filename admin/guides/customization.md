# Customization

Layers, from cheapest to heaviest:

1. **Resource options** — labels, groups, field flags, filters, page size.
2. **Field/filter types** — stick to the built-in types in v0.1; custom
   `CorexAdmin.Field` behaviours are a later extension point.
3. **App layout** — pass `layout: {MyAppWeb.Layouts, :admin}`. This is a
   **LiveView layout** (same contract as `live_session layout:`), so the
   function must render `{@inner_content}` rather than `render_slot(@inner_block)`.
   Style with Corex Design tokens. The admin ships structure, not a locked theme.
4. **Policy** — per-action and optional per-field authorization.

The resource/policy/context layer has **no LiveView dependency**. v0.1 renders
with generic LiveViews (`CorexAdmin.Live.Home|Index|Show|Form`). A controller
renderer is planned for v0.2 and will consume the same modules.

Do not put HTML in field labels. HEEx escapes values; there is no `{:safe,
html}` escape hatch.

## Config (`config :corex_admin`)

- `:debug` — log authorize results in development (never attrs)
- `:default_page_size` / `:max_page_size` / `:page_size_options`
- Gettext uses Phoenix's `gettext_backend` when set

Hub config never lists filters. Each resource declares its own `filters do`.

```elixir
config :corex_admin,
  default_page_size: 25,
  page_size_options: [10, 25, 50, 100],
  max_page_size: 100
```
