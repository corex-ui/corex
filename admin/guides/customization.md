# Customization

Most staff screens need only a [Resource](resources.md) module. When that is
not enough, customize in this order:

1. **Compose pages** — override `render/1` with public `CorexAdmin.UI` blocks
2. **Extend behaviour** — Field, Filter, and Action modules you own
3. **Eject chrome** — copy markup into your app ([Eject](eject.md)) only when
   the block itself must change

Rules that never change: a resource is data (no HEEx), config points at
modules, UI is Corex + `admin.css`, and the host owns every query. Do not mount
a second admin product (Backpex, AshAdmin, Kaffy, Threadline’s operator
console) beside this one. Headless Hex deps (Carbonite / Threadline **query**
APIs, `nimble_csv`, `jason`, Gettext) are fine.

## Compose pages

### Generic LiveViews

```elixir
use CorexAdmin.Resource,
  live: [
    index: MyAppWeb.Admin.PostLive.Index,
    show: MyAppWeb.Admin.PostLive.Show,
    form: MyAppWeb.Admin.PostLive.Form
  ]
```

```bash
mix corex.admin.gen.live PostResource
mix corex.admin.gen.live PostResource --render
```

Without `--render`, each file is a thin `use CorexAdmin.Live, :index` (and
friends). Override a callback and call `super` when needed.

With `--render`, each file gets a `render/1` that **composes** public UI
blocks. Reorder them, drop one, wrap one, or fill a slot. Markup stays in the
package, so upstream fixes still reach the page.

```elixir
defmodule MyAppWeb.Admin.PostLive.Index do
  use CorexAdmin.Live, :index

  def render(assigns) do
    ~H"""
    <CorexAdmin.UI.Index.page {assigns}>
      <:command_bar_actions>
        <.link navigate={~p"/admin/tickets/triage"} class="button ui-size-sm">Triage</.link>
      </:command_bar_actions>
    </CorexAdmin.UI.Index.page>
    """
  end
end
```

Auth, URL state, and events stay in `CorexAdmin.Live.Index.Controller` (and
show/form counterparts). Do not copy those controllers.

### `CorexAdmin.UI` blocks

| Module | Role |
| ------ | ---- |
| `UI.Index` | heading, metrics, command bar, table, footer |
| `UI.Form` | form grid, sections, save actions |
| `UI.Show` | details, embeds, related lists, history |
| `UI.Home` | hub landing |
| `UI.Nav` | sidebar `tree/1`, `mobile/1`, breadcrumbs |
| `UI.Filters` | views, bar, range dialogs |
| `UI.Dialogs` | delete, bulk delete, export, action forms |
| `UI.Fields` | one field on any surface |
| `UI.Labels` | translated operator / preset vocabulary |

Index slots: `:heading_actions`, `:command_bar_actions`, `:before_table`,
`:after_table`. Show slots: `:heading_actions`, `:before_details`,
`:after_details`.

The index command bar is two rows (views + search + actions; then filters).
Text and datetime-local filter inputs sit in a form so LiveView serializes
`phx-change`. Filter types and pinning: [Resources](resources.md).

### Hub `home:` and `pages:`

```elixir
use CorexAdmin,
  title: "Staff",
  description: "Day-to-day operations",
  home: MyAppWeb.Admin.DashboardLive,
  pages: [
    {"/reports", MyAppWeb.Admin.ReportsLive}
  ]
```

`home:` replaces the default grouped resource list. `pages:` mount **before**
resource routes in the same session (`/admin/reports`). They are not added to
the resource sidebar automatically — link them from home, the layout, or an
index slot.

```elixir
defmodule MyAppWeb.Admin.DashboardLive do
  use CorexAdmin.Live, :home

  # Override render/1 to build a dashboard with Corex cards/tables.
end
```

### App layout

Pass `layout: {MyAppWeb.AdminLayout, :admin}`. Render `{@inner_content}`.
Mount `CorexAdmin.UI.Nav.tree/1` in the aside and `Nav.mobile/1` for small
viewports. The installer writes this layout. `Nav.tree/1` only lists resources
the actor may index.

## Extend behaviour

### Field modules

Index, show, form, and export all go through `CorexAdmin.UI.Fields`, so a
custom module cannot change one surface and miss another.

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

`export/2` is data-only. Never return HTML.

Override one surface without a module:

```elixir
field :status, :select, options: ~w(open done),
  render: {MyAppWeb.Admin.Cells, :status_badge}
```

`render:` replaces `display/1`; `render_form:` replaces `input/1`. Both are
`{module, function}` pairs so the resource stays serializable.

### Filter modules

Built-in atoms resolve to `CorexAdmin.Filter.*`. A host module owns `parse/2`
and optionally `apply/3` for SQL the built-in shapes cannot express:

```elixir
filters do
  filter :nearby, MyApp.Admin.Filters.Nearby, label: "Within 10km"
end
```

```elixir
defmodule MyApp.Admin.Filters.Nearby do
  @behaviour CorexAdmin.Filter
  import Ecto.Query

  def parse(_filter, value), do: CorexAdmin.Filter.Cast.number(value)

  def apply(query, %CorexAdmin.Query.Ref{field: field}, km) do
    where(query, [row], fragment("? <@> point(0, 0) < ?", field(row, ^field), ^km))
  end
end
```

`apply/3` runs inside the host context. Unrecognized shapes raise in
`CorexAdmin.Query` — implement `apply/3` if you introduce a new shape.

### Action modules

`handle/3` calls a **host context function**. Optional callbacks describe how
the index chrome presents the action:

| Callback | Default | Effect |
| -------- | ------- | ------ |
| `icon/0` | `hero-bolt` | Trigger icon |
| `form_fields/1` | `[]` | Inputs in the action dialog |
| `confirm/1` | `nil` | Confirmation copy when present |
| `destructive?/0` | `false` | Alert styling |
| `chrome/0` | `:generic` | `:dedicated` hides the generic button (Delete, Export) |

```elixir
defmodule MyApp.Admin.Actions.SetStatus do
  @behaviour CorexAdmin.Action

  def name, do: :set_status
  def kind, do: :bulk
  def label(_spec), do: "Set status"
  def policy_action, do: :update
  def icon, do: "hero-check"

  def form_fields(_spec) do
    [%{name: :status, type: :select, label: "Status", options: ~w(open pending done)}]
  end

  def handle(_spec, scope, %{"ids" => ids, "payload" => %{"status" => status}}) do
    case MyApp.Support.set_ticket_status(scope, ids, status) do
      {:ok, n} -> {:ok, "Updated #{n} tickets."}
      {:error, _} = error -> error
    end
  end
end
```

Params: `"id"` (record), `"ids"` (bulk), `"payload"` (form fields). Register
with `bulk_actions do` / `collection_actions do` / `record_actions do` on the
resource ([Resources](resources.md)).

### Export

Corex dialog on index; Plug controller streams CSV (`nimble_csv`) or JSON
(`jason`). Policy `:export`. Trigger disabled until rows are selected. Token
salt `"corex_admin.export"`, max age 300 seconds. Details:
[Security](security.md).

### History

Corex Admin does **not** capture writes. Optional History tab via a data
adapter:

```elixir
use CorexAdmin.Resource,
  history: CorexAdmin.History.Carbonite,
  history_opts: [repo: MyApp.Repo]
```

Or a host wrapper around Threadline’s `history/3`. Policy `:history`. Redacted
fields are masked. Never auto-install triggers or mount Threadline’s operator
console as the History UX.

### Localization

Locale routing and `dir` stay in the **host layout**. Admin chrome uses
Gettext on domain `"admin"`. Resource labels stay developer strings. CSS uses
logical properties for RTL.

### Config (`config :corex_admin`)

- `:debug` — log authorize results in development (never attrs)
- `:default_page_size` / `:max_page_size` / `:page_size_options`

## When markup must change

Prefer `gen.live --render` first. When you need to edit the block HTML itself,
see [Eject](eject.md) (`mix corex.admin.gen.admin` + `mix corex.admin.doctor`).
