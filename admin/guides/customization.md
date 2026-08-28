# Customization

Corex Admin is the Phoenix **staff admin**: host **Resource** modules you own,
generic LiveViews you rarely copy, and **Corex UI exclusively**.

Four rules:

1. A **resource is data** — DSL + callbacks, never HEEx, never `{:safe, html}`.
2. **Config points at modules** — Field, Filter, Action, History, Live.
3. **UI is public slotted blocks** — `CorexAdmin.UI.*`. Compose them; copy them
   only as a last resort.
4. **The host owns every query** — the admin never calls Repo.

- Host **contexts** stay the source of truth (`list` / `get` / `create` /
  `update` / `delete`)
- Host **auth** stays `on_mount` (never ship an open admin)
- Host **policy** stays deny-by-default `CorexAdmin.Policy` (including `:export`
  and `:history`)
- **Rendering** is Corex plus Design `admin.css`
- **Customization** is Elixir modules you own — not YAML, not a fork of the
  package index LiveView, and not a second admin UI

Allowed Hex deps are **headless**: Carbonite or Threadline **query APIs**,
`nimble_csv`, `jason`, Gettext / host `localize_web` (locale data + routing).
They must not render.

Forbidden: mounting Threadline’s operator console, Backpex HTML, AshAdmin,
Kaffy, or any other admin surface; third-party table/form widgets; host Field
or Action modules that emit non-Corex HTML; a second admin stylesheet.

## Three tiers

Copying package Index/Show/Form into the host (Torch) is the wrong default.
YAML-only config is also wrong. Elixir customization is **modules you own**
(Django `ModelAdmin`, Filament `Resource`, Ash `admin do`).

### 1. Resource DSL + callbacks

Host **Resource module** — fields, filters, relations, actions, plus optional
`title/1`, `query/2`, `canned_filters/0`, `filter_options/2`,
`filter_bounds/2`, `metrics/2`. Not a copy of our internals.

This is enough for almost every staff tool. See [Resources](resources.html).

### 2. Compose public blocks

Generic LiveViews: `use CorexAdmin.Live, :index | :show | :form | :home`.
Package modules are one-liners. Override `render/1` or `handle_event/3` and
call `super` when needed.

`mix corex.admin.gen.live PostResource` writes ~40 lines that `use`
`CorexAdmin.Live`. Add `--render` to also write a `render/1` that **composes
`CorexAdmin.UI` blocks**. Reorder them, drop one, wrap one, or fill a slot.
The block markup stays in the package, so upstream fixes still reach the page.

```elixir
use CorexAdmin.Resource,
  live: [
    index: MyAppWeb.Admin.PostLive.Index,
    show: MyAppWeb.Admin.PostLive.Show,
    form: MyAppWeb.Admin.PostLive.Form
  ]
```

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

Behaviour (auth, URL state, events) stays in
`CorexAdmin.Live.Index.Controller`. You do **not** copy that module.

`--render` expands `page/1` into the named blocks (`heading`, `metrics`,
`command`, `table`, `footer`, dialogs) so you can delete or wrap one without
forking the composition helper.

### 3. Eject the chrome

`mix corex.admin.gen.admin` copies `CorexAdmin.UI` blocks into
`MyAppWeb.Admin.Components`. That is the only tier that costs you
maintenance. Prefer `--render` first.

```bash
mix corex.admin.gen.admin
mix corex.admin.gen.admin --only index,filters
```

It writes:

- `lib/my_app_web/admin/components/*.ex` — copied blocks, rewritten into your
  namespace
- `priv/corex_admin/ejected.exs` — which blocks were copied, from which
  version, with a sha256 of the package source

Configuration is **not** copied. Ejected blocks still receive the same
assigns, still read `@spec`, and still delegate events to the package
controllers. Fields, filters, policy, and the context contract stay in your
resource modules.

`CorexAdmin.UI` itself and `CorexAdmin.UI.Labels` are not ejectable: the
first is only imports, the second is translated vocabulary.

Run `mix corex.admin.doctor` after upgrading. It reports **current**,
**behind**, or **unknown** per block, and exits 1 if anything is behind so CI
can fail on unreviewed drift. It does not merge — copied markup cannot be
merged automatically. Diff, decide, then re-copy or patch by hand.

## `CorexAdmin.UI`

Every admin page is a composition of these blocks. They never query and they
never decide authorization — they receive assigns the controller already
resolved.

| Module | Role |
| ------ | ---- |
| `UI.Index` | heading, metrics, command bar, table, footer |
| `UI.Form` | form grid, sections, save actions |
| `UI.Show` | details, embeds, related lists, history |
| `UI.Home` | hub landing |
| `UI.Nav` | sidebar `tree/1`, `mobile/1`, breadcrumbs |
| `UI.Filters` | views, bar, range dialogs |
| `UI.Dialogs` | delete, bulk delete, export, action forms |
| `UI.Fields` | one field on any surface (`value/1`, `input/1`) |
| `UI.Labels` | translated operator / preset vocabulary |

Index slots: `:heading_actions`, `:command_bar_actions`, `:before_table`,
`:after_table`. Show slots: `:heading_actions`, `:before_details`,
`:after_details`.

## Field modules

`field :title, :text` stays. Internally a built-in type renders Corex inputs.
Host modules must compose Corex components. Index, show, form, and export all
go through `CorexAdmin.UI.Fields` so a custom module cannot change one
surface and silently miss another.

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

### Overriding one surface

When only the cell needs to change, name a function instead of writing a
whole module:

```elixir
field :status, :select, options: ~w(open done),
  render: {MyAppWeb.Admin.Cells, :status_badge}
```

`render:` replaces `display/1`; `render_form:` replaces `input/1`. Both
receive the same assigns (`@field`, `@record` or `@form`, `@value`) and must
return a rendered template. They are `{module, function}` pairs rather than
captures so a resource stays serializable data.

## Filter modules

Built-in type atoms (`:select`, `:date_range`, …) resolve to
`CorexAdmin.Filter.*`. A host module owns `parse/2` (untrusted params →
canonical value, or `nil` for “no constraint”) and optionally `apply/3` for
SQL the built-in shapes cannot express.

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

`apply/3` runs inside the host context, never against a repo owned by the
admin. `CorexAdmin.Query` raises on unrecognized shapes rather than returning
an unfiltered query; implement `apply/3` if you introduce a new shape.

## Actions

An action is a module the resource registers. `handle/3` calls a **host
context function**. Optional callbacks describe presentation so the index
chrome can render it without knowing what it does:

| Callback | Default | Effect |
| -------- | ------- | ------ |
| `icon/0` | `hero-bolt` | Trigger icon |
| `form_fields/1` | `[]` | Inputs in the action dialog |
| `confirm/1` | `nil` | Dialog description; presence implies confirmation |
| `destructive?/0` | `false` | Alert styling and `alertdialog` role |
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

`handle/3` receives string-keyed params: `"id"` (record), `"ids"` (bulk),
`"payload"` (form fields). Built-ins (`Delete`, `BulkDelete`, `Export`)
implement the same behaviour.

## Export

Corex **dialog** picker on index; **Plug controller** streams chunks. CSV via
`nimble_csv`, JSON via `jason`. Policy `:export`. Selected ids if any; the
export trigger is disabled when nothing is selected. Field picker = readable,
non-redacted, `authorize_field`-allowed fields.

`POST #{prefix}/:resource/export` sits in the same `live_corex_admin` scope
(outside `live_session`). Auth is a short-lived `Phoenix.Token` minted by the
LiveView (salt `"corex_admin.export"`, max age 300 seconds). No XLSX, XML, or
queued jobs in this package.

## History

Corex Admin does **not** capture writes. Show an optional History **tab**
(Corex `tabs` + definition list) by setting a data adapter:

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
pattern). Admin chrome uses Gettext on domain `"admin"` (`~t` in the host).
Resource **labels** stay developer strings.

RTL: inherit `dir` from the layout; admin CSS uses logical properties
(`margin-inline`, `inset-inline-end`).

## Hub `home:` and `pages:`

Default home is `use CorexAdmin.Live, :home`. Override with a host LiveView:

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
so the function must render `{@inner_content}`. Mount `CorexAdmin.UI.Nav.tree/1`
in the aside and `Nav.mobile/1` for small viewports. Hosts must not `@source`
the `admin/` package.

The installer writes this layout. `Nav.tree/1` only lists resources the actor
may index.

## Index chrome

Heading + New, then optional metric cards, then a two-row command bar: views
+ search + icon-only Export / Delete; filter row with compact Corex controls,
**Add filter**, and **More filters**. Streamed table, footer (Showing +
pagination + page-size). Range filters open their own dialogs.

- Enumerated filters use `<.select>` (12 or fewer) or `<.combobox>` (more).
- Text and datetime-local inputs sit in a form so LiveView serializes
  `phx-change`.
- **Clear all** restores defaults; unpinned **X** removes that filter from the
  bar.

## Config (`config :corex_admin`)

- `:debug` — log authorize results in development (never attrs)
- `:default_page_size` / `:max_page_size` / `:page_size_options`

Gettext uses Phoenix's `gettext_backend` when set. There is no required
`localize_web` dep on `corex_admin`.
