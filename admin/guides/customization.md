# Customization

Corex Admin is the Phoenix **staff admin**: host **Resource** modules you own,
generic LiveViews you rarely copy, and **Corex UI exclusively**.

- Host **contexts** stay the source of truth (`list` / `get` / `create` / `update` /
  `delete`)
- Host **auth** stays `on_mount` (never ship an open admin)
- Host **policy** stays deny-by-default `CorexAdmin.Policy` (including `:export`
  and `:history`)
- **Rendering** is Corex (`data_table`, `native_input`, `select`, `combobox`,
  `date_picker`, `data_list`, `dialog`, `menu`, `tabs`, `toast`, `pagination`,
  `file_upload`, `nested_fields`, `layout_heading`) plus Design `admin.css`
- **Customization** is Elixir modules you own — not YAML, not a fork of
  `CorexAdmin.Live.Index`, and not a second admin UI

Allowed Hex deps are **headless**: Carbonite or Threadline **query APIs**,
`nimble_csv`, `jason`, Gettext / host `localize_web` (locale data + routing).
They must not render.

Forbidden: mounting Threadline’s operator console, Backpex HTML, AshAdmin,
Kaffy, or any other admin surface; third-party table/form widgets; host Field
or Action modules that emit non-Corex HTML; a second admin stylesheet.

## Copy templates vs config-only

Copying package Index/Show/Form into the host (Torch) is the wrong default.
YAML-only config is also wrong. Elixir customization is **modules you own**
(Django `ModelAdmin`, Filament `Resource`, Ash `admin do`).

1. Host **Resource module** — DSL + optional `title/1`, `query/2`,
   `canned_filters/0`. Not a copy of our internals. No `{:safe, html}` / HEEx
   on the resource.
2. Generic LiveViews: `use CorexAdmin.Live, :index | :show | :form | :home`
   (overridable + function-component chrome). Package modules are one-liners.
3. Nuclear hatch: `mix corex.admin.gen.live PostResource` writes ~40 lines that
   `use CorexAdmin.Live, :index`. Same idea as `phx.gen.auth`. You do **not**
   copy `CorexAdmin.Live.Index`.
4. Custom pages: hub `home:` / `pages:` — still Corex components, same tokens.

## Resource `live:` and `mix corex.admin.gen.live`

```elixir
use CorexAdmin.Resource,
  live: [
    index: MyAppWeb.Admin.PostLive.Index,
    show: MyAppWeb.Admin.PostLive.Show,
    form: MyAppWeb.Admin.PostLive.Form
  ]
```

The router expands **explicit per-slug routes**. Unknown slugs 404 at the
router. Generated LiveViews:

```elixir
defmodule MyAppWeb.Admin.PostLive.Index do
  use CorexAdmin.Live, :index
end
```

Override `render/1` or `handle_event/3` and call `super` when needed.

## Resource callbacks

- `title/1` — show heading, breadcrumbs (default: `title_field`)
- `query/2` — index/export list (default: context `list`)
- `canned_filters/0` — optional `[{label, params_map}]` rendered as index
  shortcuts that patch the current list URL
- `singular:` — “New Ticket” / empty copy still uses the plural `label`

```elixir
def title(ticket), do: "##{ticket.id} #{ticket.title}"

def query(scope, list_opts) do
  MyApp.Support.list_open_tickets(scope, list_opts)
end
```

## Field modules

`field :title, :text` stays. Internally `CorexAdmin.Field.Text` renders Corex
inputs. Host modules must compose Corex components:

```elixir
field :color, MyApp.Admin.Fields.Color
```

```elixir
defmodule MyApp.Admin.Fields.Color do
  @behaviour CorexAdmin.Field
  use Phoenix.Component
  use Corex

  def input(assigns) do
    ~H"""
    <.native_input type="color" field={@form[@field.name]} class="native-input">
      <:label>{@field.label}</:label>
    </.native_input>
    """
  end

  def display(assigns) do
    ~H"""
    <span class="admin-cell">{Map.get(@record, @field.name)}</span>
    """
  end

  def export(field, record), do: Map.get(record, field.name)
end
```

`export/2` is data-only (CSV/JSON scalars). Never return HTML.

## Actions

Collection / bulk / record modules; Corex `menu` + `dialog`. Delete and
bulk-delete are the defaults. `handle/3` calls a host context function.

```elixir
collection_actions do
  action CorexAdmin.Action.Export
end

bulk_actions do
  action CorexAdmin.Action.BulkDelete
  action CorexAdmin.Action.Export
end

record_actions do
  action CorexAdmin.Action.Delete
end
```

Omit the blocks to keep those defaults. Pass `collection_actions: []` (option)
or an empty `collection_actions do` to disable.

## Export

Corex **dialog** picker on index; **Plug controller** streams chunks. CSV via
`nimble_csv`, JSON via `jason`. Policy `:export`. Selected ids if any, else
current filters/search/sort. Field picker = readable, non-redacted,
`authorize_field`-allowed fields.

`POST #{prefix}/:resource/export` sits in the same `live_corex_admin` scope
(outside `live_session`). Auth is a short-lived `Phoenix.Token` minted by the
LiveView (`"corex_admin.export"`). No XLSX, XML, or queued jobs in this
package.

## History

Corex Admin does **not** capture writes. Show an optional History **tab**
(Corex `tabs` + `data_list`) by setting a data adapter:

```elixir
use CorexAdmin.Resource,
  history: CorexAdmin.History.Carbonite,
  history_opts: [repo: MyApp.Repo]
```

Or a host module wrapping Threadline’s `history/3`:

```elixir
use CorexAdmin.Resource,
  history: CorexAdmin.History.Threadline
```

Policy `:history`. Sensitive fields with `redact: true` are masked in diffs.
If no adapter: the tab is hidden. Never auto-install PostgreSQL triggers.
Never mount Threadline’s operator console or deep-link `/audit` as the History
UX.

## Localization

Do **not** add `localize_web` as a `corex_admin` dependency. Locale routing,
language switcher, and `dir` stay in the **host layout** (already the Corex
pattern). Admin chrome uses `Corex.Gettext` on domain `"admin"` (`~t` in the
host). Resource **labels** stay developer strings.

RTL: inherit `dir` from the layout; admin CSS uses logical properties
(`margin-inline`, `inset-inline-end`).

## Form / show sections and field policy

```elixir
form do
  section "Details", [:title, :email, :status]
  section "Body", [:body]
end

show do
  section "Overview", [:title, :status]
  section "Timestamps", [:inserted_at]
end
```

More than one named section renders Corex `tabs`. Default: one implicit
section from `fields do`.

Implement optional `authorize_field/5` on the policy to hide fields on index,
show, form, and export. Field `readable` / `writable` / `redact` flags still
apply.

Index tables use LiveView **streams** (`Corex.DataTable` already supports them)
plus the `:entries` assign for selection.

## Hub `home:` and `pages:`

Default home is `CorexAdmin.Live.Home`. Override with a host LiveView:

```elixir
use CorexAdmin,
  title: "Staff",
  description: "Day-to-day operations",
  home: MyAppWeb.Admin.DashboardLive,
  pages: [
    {"/reports", MyAppWeb.Admin.ReportsLive}
  ]
```

Custom pages mount **before** resource routes in the same session. Build them
with Corex cards/tables.

## App layout

Pass `layout: {MyAppWeb.AdminLayout, :admin}`. This is a **LiveView layout**,
so the function must render `{@inner_content}`. Mirror the docs shell with
`CorexAdmin.Live.Components.nav_tree/1` in the aside. Hosts must not `@source`
the `admin/` package.

## Index chrome

Heading + New + Export, search + Filters trigger, chips, slim bulk bar on the
table, streamed table, footer (Showing + pagination + page-size).

- Enumerated filters use `<.select>` (12 or fewer) or `<.combobox>` (more).
  Toggle group is only for `:boolean`.
- Date ranges include Today / Last 7 days / Last 30 days / This month / YTD.
- **Reset** / **Reset all** restore defaults; chip **X** clears to Any.

## Config (`config :corex_admin`)

- `:debug` — log authorize results in development (never attrs)
- `:default_page_size` / `:max_page_size` / `:page_size_options`

Gettext uses Phoenix's `gettext_backend` when set. There is no required
`localize_web` dep on `corex_admin`.
