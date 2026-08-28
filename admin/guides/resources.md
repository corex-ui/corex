# Resources

A resource is **data**, not a LiveView. It names context functions, declares
fields and filters, and optionally implements callbacks. The generic pages
read the compiled `%CorexAdmin.Resource.Spec{}` and render
`CorexAdmin.UI` blocks. Hosts own every query.

```elixir
defmodule MyAppWeb.Admin.TicketResource do
  use CorexAdmin.Resource,
    context: MyApp.Support,
    schema: MyApp.Support.Ticket,
    slug: "tickets",
    group: "Support",
    label: "Tickets",
    singular: "Ticket",
    page_size: 25,
    page_size_options: [10, 25, 50, 100],
    default_sort: {:inserted_at, :desc},
    title_field: :title,
    selectable: true

  scope :current_scope

  actions do
    list :list_tickets
    get :get_ticket!
    create :create_ticket
    update :update_ticket
    delete :delete_ticket
    change_create :change_ticket
    change_update :change_ticket
  end

  fields do
    field :id, :id
    field :title, :text, searchable: true, sortable: true
    field :email, :email, searchable: true
    field :status, :select, options: ~w(open pending done)
    field :priority, :number, sortable: true
    field :due_on, :date, sortable: true

    field :assignee, :belongs_to,
      relation: [
        context: MyApp.Accounts,
        list: :list_users,
        label: :name,
        owner_key: :assignee_id,
        search: true
      ]

    field :body, :textarea
    field :inserted_at, :datetime, sortable: true

    field :social_links, :embeds_many, schema: MyApp.SocialLink, index: false do
      field :label, :text
      field :url, :url
      field :preferred, :boolean, exclusive: true
    end
  end

  filters do
    filter :status, :multi_select, options: ~w(open pending done), pin: true
    filter :priority, :number_range, pin: true
    filter :due_on, :date_range, label: "Due", pin: true
    filter :assignee_name, :text, label: "Assignee", path: [:assignee, :name], pin: false
    filter :email, :text, pin: false
    filter :created, :relative_date, field: :inserted_at, pin: false
  end

  def canned_filters do
    [{"Open queue", %{"filters" => %{"status" => ["open"]}}}]
  end

  def title(ticket), do: "##{ticket.id} #{ticket.title}"

  def filter_options(scope, :status), do: MyApp.Support.ticket_statuses(scope)
  def filter_options(_scope, _name), do: nil

  def filter_bounds(scope, :priority), do: MyApp.Support.ticket_priority_bounds(scope)
  def filter_bounds(_scope, _name), do: nil

  def metrics(scope, _list_opts) do
    counts = MyApp.Support.ticket_counts(scope)

    [
      %{label: "Open", value: Map.get(counts, "open", 0), hint: "waiting on us"},
      %{label: "Done", value: Map.get(counts, "done", 0)}
    ]
  end
end
```

## Resource options

| Option | Default | Purpose |
| ------ | ------- | ------- |
| `page_size` | app `default_page_size` | Default per-page size |
| `page_size_options` | app `[10, 25, 50, 100]` | Allowed `?page_size=` values (also capped by `max_page_size`) |
| `default_sort` | none | `{field, :asc | :desc}` when the URL has no sort |
| `default_filters` | `%{}` | Filter values applied when the matching query key is missing. An empty query value (`filters[status]=`) means “any” and will not re-apply the default. |
| `title_field` | primary key | Breadcrumbs, flash, show heading (overridable via `title/1`) |
| `singular` | schema name | “New Ticket”; empty copy still uses plural `label` |
| `selectable` | `true` | Index checkboxes, bulk bar, and bulk delete |
| `live` | generic LiveViews | `index` / `show` / `form` host modules (`use CorexAdmin.Live`) |
| `history` | none | Optional `CorexAdmin.History` adapter (Show History tab) |

## Context contract

When `scope/1` is set, the scope/actor is the first argument. The admin
**never** calls Repo.

- `list(scope, %CorexAdmin.ListOpts{}) :: {:ok, %CorexAdmin.Page{}} | {:error, term}`
- `get!(scope, id)` — must filter by scope. Preload `has_many` associations
  the show page should list; the admin reads what you already loaded.
- `create(scope, attrs) :: {:ok, record} | {:error, changeset}`
- `update(scope, record, attrs) :: {:ok, record} | {:error, changeset}`
- `delete(scope, record) :: {:ok, record} | {:error, term}`
- `change_create(scope, %Schema{}, attrs)` / `change_update(scope, record, attrs)` return
  changesets. Phoenix apps often share one `change_*` for both (the admin passes an empty
  struct on create).

Use `CorexAdmin.Query.apply/2` and `paginate/2` **inside** the context after you
scope the query. This is a helper, not a gate: a context that needs something
the helper cannot express should build its own query from `ListOpts`.

`Query.apply/2` dispatches filters by value shape. Lists use `in`,
`%{contains: term}` uses `ilike`, `:empty` / `:set` test presence,
`%{op, value}` uses the named operator, `%{relative: window}` resolves to a
rolling date range, `%{from, to}` / `%{min, max}` use range bounds. Anything
unrecognized **raises** — silently listing every row is worse than failing.

```elixir
def list_tickets(scope, %CorexAdmin.ListOpts{} = opts) do
  query =
    Ticket
    |> where([t], t.org_id == ^scope.user.org_id)
    |> CorexAdmin.Query.apply(opts)

  {:ok,
   %CorexAdmin.Page{
     entries: Repo.all(CorexAdmin.Query.paginate(query, opts)),
     total: Repo.aggregate(query, :count),
     page: opts.page,
     page_size: opts.page_size
   }}
end
```

### Association paths

A filter, searchable field, or sortable field with `path: [:author, :email]`
is joined automatically as a named binding. Only single-level paths are
joined. Deeper paths, or joins that need conditions, belong in the context
before `apply/2`.

```elixir
filter :author_email, :text, path: [:author, :email]
field :author_name, :text, searchable: true, path: [:author, :name]
```

## Field flags

| Flag | Default |
| ---- | ------- |
| `searchable` / `sortable` | `false` |
| `filterable` | unused — `filters do` is the source of truth |
| `index` | readable, not redacted, not `:textarea` / `:password` |
| `show` | readable, not redacted |
| `:id` and timestamps | not writable |
| `:password` | write-only, redacted |
| schema `redact: true` | redacted |
| `virtual: true` | never written; used by `column/3` |
| `exclusive: true` | nested boolean: at most one row may be true |
| `path:` | association path for search/sort |
| `render:` / `render_form:` | `{module, function}` override for one surface |
| `relation:` | `belongs_to` / `has_many` options from a host context |

`filters do` is the source of truth for the index filter bar and the ListOpts
allowlist. `filterable: true` on a field does not render a control.

v0.1 field types: `:id`, `:text`, `:textarea`, `:email`, `:password`,
`:number`, `:boolean`, `:select`, `:radio`, `:date`, `:datetime`, `:url`,
`:tags`, `:file`, `:embeds_many`, `:embeds_one`, `:belongs_to`, `:has_many`.

A host field module (`field :color, MyApp.Admin.Fields.Color`) implements
`CorexAdmin.Field` and is used on index, show, form, and export. See
[Customization](customization.html).

### Computed columns

`column/3` is a read-only cell that is not a schema column — a joined label,
a derived total, a status rollup. It is never writable and never appears on
the form.

```elixir
column :post_count, MyAppWeb.Admin.Cells.PostCount, label: "Posts"
```

## Filters

The index bar is two rows: **saved views**, **search**, and icon-only
**Export** / **Delete** on the first; **pinned filters**, **Add filter**, and
**More filters** on the second.

Pinned filters (`pin: true`, the default) render as compact Corex controls on
the filter row. Unpinned filters appear under **Add filter**. Named views come
from `canned_filters/0` (All plus each named view).

Range widgets never live on the bar. A `:date_range`, `:datetime_range`, or
`:number_range` is a compact summary trigger that opens its own dialog,
because a calendar pinned to a toolbar makes the row jump. **More filters**
lists non-range filters (with operators); ranges stay on their own dialogs so
the overflow does not duplicate calendars.

| Type | Row | Dialog | Query |
| ---- | --- | ------ | ----- |
| `:select` / `:multi_select` | `<.select>` (≤12) or `<.combobox>` (>12) | same, plus optional `operators: [:in, :not_in]` | `==` / `in` / `not in` |
| `:boolean` / `:presence` / `:relative_date` | `<.select>` | same | equality / `is_nil` / rolling bounds |
| `:text` | input with the filter label as placeholder | same, plus operators | `ilike` / `==` |
| `:id` | input, exact match | same | `==` |
| `:number` | `<.number_input>` | same, plus `:eq` / `:gte` / `:lte` | `==` / `>=` / `<=` |
| `:tags` | `<.tags_input>` | same | `in` |
| `:date_range` | summary trigger | presets + `<.date_picker selection_mode="range">` | `>= from 00:00` and `< to+1 day` |
| `:datetime_range` | summary trigger | two `datetime-local` inputs | `>= from` and `<= to` |
| `:number_range` | summary trigger | slider when bounds are known, else two number inputs | `>= min` and `<= max` |

Optional `field:` if the URL name should differ from the schema column
(`filter :created, :relative_date, field: :inserted_at`).
Optional `path:` to target an association column.
Optional `pin: false` to hide a filter behind **Add filter**.
Optional `operators:` / `default_operator:` to restrict or reorder comparison ops.
Optional `min:` / `max:` as static slider bounds (overridden by `filter_bounds/2`).
Do not put HTML in resource modules.

A host filter module (`filter :nearby, MyApp.Admin.Filters.Nearby`) implements
`CorexAdmin.Filter`. Most filters need only `parse/2`; implement `apply/3`
when the built-in shapes cannot express the SQL. See
[Customization](customization.html).

### Dynamic options and bounds

`filter_options/2` lets a resource read choices from the scoped context so
enumerations stay in the database:

```elixir
def filter_options(scope, :status), do: MyApp.Support.ticket_statuses(scope)
def filter_options(_scope, _name), do: nil
```

`filter_bounds/2` computes slider bounds from the data:

```elixir
def filter_bounds(scope, :priority), do: MyApp.Support.ticket_priority_bounds(scope)
def filter_bounds(_scope, _name), do: nil
```

Returning `nil` falls back to the filter's static `options:` / `min:` / `max:`.

## Relations

Corex Admin never queries associations itself. A relation names a **context
function** that returns candidate records, so scoping, preloads, and limits
stay in the host.

### `belongs_to`

Renders as a combobox (or select) on the form. Options come from
`context.list(scope, opts)` where `opts` is `[query: term, limit: n]` when
`search: true`. `CorexAdmin.Attrs.take_writable/2` writes the **foreign key**
(`owner_key`), not the association name.

```elixir
field :author, :belongs_to,
  relation: [
    context: MyApp.Blog,
    list: :list_authors,
    label: :name,
    owner_key: :author_id,
    search: true,
    limit: 50
  ]
```

### `has_many`

Renders as a related-list panel on show, filled from the **preloaded**
record. An empty relation still shows its panel. `has_many` is omitted from
the detail definition list so it does not appear twice.

```elixir
field :posts, :has_many,
  label: "Recent posts",
  index: false,
  relation: [
    context: MyApp.Blog,
    schema: MyApp.Blog.Post,
    label: :title,
    columns: [:title, :status, :published_at]
  ]
```

`get!` must preload what the panel should list. The admin does not load it.

## Nested embeds

Use `:embeds_many` / `:embeds_one` for repeating rows on the form. Declare
child fields in a `do` block. Default `index: false`. The host changeset must
`cast_embed/3` with `sort_param: :{name}_sort` and `drop_param: :{name}_drop`.

```elixir
field :social_links, :embeds_many, schema: MyApp.SocialLink, index: false do
  field :label, :text
  field :url, :url
  field :preferred, :boolean, exclusive: true
end
```

`CorexAdmin.Attrs.take_writable/2` copies the embed payload plus the
sort/drop params and keeps only allowlisted child keys — unknown nested keys
are dropped and never atomized.

### Exclusive nested booleans

`exclusive: true` on a child boolean means at most one row may be true
(“preferred” social link, default address). The last true row wins;
`Attrs` clears the others so two concurrent tabs cannot smuggle two flags
through. Enforce the same rule in the changeset.

## Metrics

Optional `metrics/2` returns cards above the index command bar:

```elixir
def metrics(scope, _list_opts) do
  [%{label: "Open", value: 12, hint: "waiting on us"}]
end
```

Each item is `%{label:, value:}` with optional `:hint`. Compute them from the
scoped context. They are not a dashboard framework.

## Form save actions

| Page | Primary | Secondary |
| ---- | ------- | --------- |
| New | **Create** → show the record | **Create and add another** → blank form |
| Edit | **Save** → stay on the form | **Save and close** → show |

## Form / show sections

```elixir
form do
  section "Request", [:title, :email, :status, :assignee]
  section "Details", [:body, :social_links]
end

show do
  section "Overview", [:title, :status]
  section "Timestamps", [:inserted_at]
end
```

More than one named section renders Corex `tabs`. Default: one implicit
section from `fields do`. Implement optional `authorize_field/5` on the
policy to hide fields on index, show, form, and export.

## Actions

Collection / bulk / record modules; Corex `menu` + `dialog`. Delete, bulk
delete, and export are ordinary registrations and the defaults when you omit
the blocks.

```elixir
collection_actions do
  action CorexAdmin.Action.Export
end

bulk_actions do
  action CorexAdmin.Action.BulkDelete
  action CorexAdmin.Action.Export
  action MyApp.Admin.Actions.SetTicketStatus
end

record_actions do
  action CorexAdmin.Action.Delete
end
```

Pass `collection_actions: []` (option) or an empty `collection_actions do` to
disable. A custom action implements `CorexAdmin.Action` (`handle/3` calls a
host context function) and may declare `form_fields/1`, `confirm/1`,
`destructive?/0`, and `icon/0`. See [Customization](customization.html).

## Resource callbacks

| Callback | Default | Purpose |
| -------- | ------- | ------- |
| `title/1` | `title_field` | Show heading, breadcrumbs, flash |
| `query/2` | context `list` | Index and export listing |
| `canned_filters/0` | `[]` | Named views in the command bar |
| `filter_options/2` | static `options:` | Scoped enumeration for a filter |
| `filter_bounds/2` | static `min:` / `max:` | Scoped slider bounds |
| `metrics/2` | `[]` | Index metric cards |

```elixir
def query(scope, list_opts) do
  MyApp.Support.list_open_tickets(scope, list_opts)
end
```
