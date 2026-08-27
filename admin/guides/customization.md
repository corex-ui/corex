# Customization

Corex Admin is a **thin LiveView composition layer** over your Phoenix app:

- Host **contexts** stay the source of truth (`list` / `get` / `create` / `update` /
  `delete` already required)
- Host **auth** stays `on_mount` (never ship an open admin)
- Host **policy** stays deny-by-default `CorexAdmin.Policy`
- **Rendering** is the Corex components you already use (`data_table`,
  `native_input`, `select`, `combobox`, `date_picker`, `data_list`, `dialog`,
  `toast`, `menu`, `floating_panel`, `layout_heading`)
- **Customization** is Elixir modules and HEEx slots in the host app — not PHP
  view classes and not a fork of `CorexAdmin.Live.Index`

## Filament surface → Corex Admin

| Filament | Corex Admin |
| -------- | ----------- |
| Panel | `use CorexAdmin` hub (`layout`, `on_mount`, `policy`, `resources`, `title`, `description`, `home`, `pages`) |
| Tables | generic Index LiveView (search, filter popover, bulk on the table, page-size in the footer) |
| Forms | generic Form LiveView + resource `fields do` + changeset |
| Infolists | show `data_list` today; later `show do` / `infolist do` on the resource |
| Notifications | layout `toast` / `toast_group`; flash stays Phoenix |
| Action modals | delete / bulk `dialog` today; extra actions will be a resource DSL + Corex `dialog` / `menu` |
| Dashboard widgets | default home is grouped resources from config; a custom dashboard is a **host LiveView** via `home:` |

There is no paid widget store. Phoenix apps bring their own LiveView. Corex’s
advantage is tokens + components.

## Cheapest → heaviest

1. **Resource options** — labels, groups, field flags, `filters do`, page size,
   `default_sort`, `default_filters`, `filters_open`, `selectable`.
2. **Hub options** — `title`, `description`, `layout`, `policy`, optional `home`
   LiveView.
3. **Extra routes** in the same `live_session`:
   `pages: [{"/reports", MyAppWeb.Admin.ReportsLive}]`.
4. **Declarative extra actions** on the resource (generic LiveView renders
   `dialog` / `menu`) — follow-up slice, not a fork of Index.
5. **Custom page LiveViews** that reuse `CorexAdmin.Live.Components`
   (breadcrumbs, heading) and Corex widgets.
6. **Design tokens / theme / mode** — not a fork of `admin.css` structure.
7. **Multiple hubs** (staff vs superadmin) — second `use CorexAdmin` + second
   `live_corex_admin`.

Do **not** add render callbacks on resources that return raw HTML. Do **not**
fork `CorexAdmin.Live.Index|Show|Form` to restyle chrome. Classes live in Design
(`admin-*` in `admin.css`). Hosts must not `@source` the `admin/` package.

The resource/policy/context layer has **no LiveView dependency**. v0.1 renders
with generic LiveViews. A controller renderer is planned for v0.2 and will
consume the same modules.

Do not put HTML in field labels. HEEx escapes values; there is no `{:safe,
html}` escape hatch.

## Hub `home:` and `pages:`

Default home is `CorexAdmin.Live.Home`: grouped resource cards from
`config.resources`. Override it with a host LiveView when you want a dashboard:

```elixir
use CorexAdmin,
  # ...
  title: "Staff",
  description: "Day-to-day operations",
  home: MyAppWeb.Admin.DashboardLive,
  pages: [
    {"/reports", MyAppWeb.Admin.ReportsLive}
  ]
```

`home:` accepts a LiveView module or `{Module, :live_action}`. Custom pages
mount **before** `/:resource` in the same session, layout, and tree. Build those
LiveViews with Corex cards/tables — that is the free custom dashboard.

## App layout

Pass `layout: {MyAppWeb.AdminLayout, :admin}`. This is a **LiveView layout**
(same contract as `live_session layout:`), so the function must render
`{@inner_content}` rather than `render_slot(@inner_block)`.

Mirror the docs shell: site header + `Shell.wrapper` / `Shell.side` / `Shell.main`,
with `CorexAdmin.Live.Components.nav_tree/1` in the aside. The installer writes
`AdminLayout` for you. Do not point the hub at a slot-based `Layouts.app`.

## Index chrome

The index is a stable stack: heading + New, search + Filters trigger, chips,
slim bulk bar immediately above the table, table, footer (Showing + pagination +
page-size).

- Enumerated filters use `<.select>` (12 or fewer options) or `<.combobox>`
  (more than 12). Toggle group is only for `:boolean`.
- Date ranges include Today / Last 7 days / Last 30 days / This month / YTD
  presets plus a Custom range picker.
- **Reset** / **Reset all** use `button ui-size-sm ui-ghost ui-alert`.
- **Reset** on a filter restores that field’s `default_filters` value (or Any
  when there is no default).
- **Reset all** restores every filter default and clears search. Sort and page
  size stay as they are.
- Chip **X** clears that value to Any even when a default exists (the URL then
  carries an empty `filters[name]=` so the default is not reapplied).

If you later need extra bulk or row actions, prefer a declarative resource DSL
that the generic LiveView renders with Corex `dialog` / `menu` — not a render
callback on the resource and not an Index fork.

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
