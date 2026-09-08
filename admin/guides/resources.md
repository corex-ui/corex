# Resources

A resource is **data**, not a LiveView. It names context functions, declares
fields and filters, and optionally implements callbacks. Generic pages read the
compiled `%CorexAdmin.Resource.Spec{}` and render `CorexAdmin.UI` blocks. Your
context owns every query — the admin never calls `Repo`.

Start with a minimal resource, then add filters, relations, and actions as you
need them. Custom Field / Filter / Action **modules** are documented in
[Customization](customization.md).

## Minimal resource

```elixir
defmodule MyAppWeb.Admin.UserResource do
  use CorexAdmin.Resource,
    context: MyApp.Accounts,
    schema: MyApp.Accounts.User,
    slug: "users",
    group: "Accounts",
    label: "Users",
    title_field: :email

  scope :current_scope

  actions do
    list :list_users
    get :get_user!
    create :create_user
    update :update_user
    delete :delete_user
    change_create :change_user
    change_update :change_user
  end

  fields do
    field :id, :id
    field :email, :email, searchable: true, sortable: true
    field :role, :select, options: ~w(admin editor viewer)
    field :inserted_at, :datetime, sortable: true
  end

  filters do
    filter :role, :select, options: ~w(admin editor viewer)
  end
end
```

Register it on the hub: `resources: [MyAppWeb.Admin.UserResource]`.

## Fuller example

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
| `default_sort` | none | `{field, :asc \| :desc}` when the URL has no sort |
| `default_filters` | `%{}` | Applied when the matching query key is missing. Empty query values mean “any”. |
| `title_field` | primary key | Breadcrumbs, flash, show heading (overridable via `title/1`) |
| `singular` | schema name | “New Ticket”; empty copy still uses plural `label` |
| `selectable` | `true` | Index checkboxes, bulk bar, and bulk delete |
| `live` | generic LiveViews | `index` / `show` / `form` host modules — see [Customization](customization.md) |
| `history` | none | Optional `CorexAdmin.History` adapter (Show History tab) |

## Context contract

When `scope/1` is set, the scope/actor is the first argument.

- `list(scope, %CorexAdmin.ListOpts{}) :: {:ok, %CorexAdmin.Page{}} | {:error, term}`
- `get!(scope, id)` — must filter by scope. Preload `has_many` associations
  the show page should list.
- `create(scope, attrs) :: {:ok, record} | {:error, changeset}`
- `update(scope, record, attrs) :: {:ok, record} | {:error, changeset}`
- `delete(scope, record) :: {:ok, record} | {:error, term}`
- `change_create` / `change_update` return changesets (often one shared `change_*`)

Use `CorexAdmin.Query.apply/2` and `paginate/2` **inside** the context after you
scope the query. This is a helper, not a gate: build your own query from
`ListOpts` when you need something the helper cannot express.

`Query.apply/2` dispatches filters by value shape (lists, `%{contains: _}`,
`%{op, value}`, ranges, `:empty` / `:set`, scalars). Anything unrecognized
**raises** — silently listing every row is worse than failing.

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
joined. Deeper paths belong in the context before `apply/2`.

```elixir
filter :author_email, :text, path: [:author, :email]
field :author_name, :text, searchable: true, path: [:author, :name]
```

## Fields

| Flag | Default |
| ---- | ------- |
| `searchable` / `sortable` | `false` |
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

`filters do` is the source of truth for the filter bar and the ListOpts
allowlist. A `filterable:` flag on a field does **not** render a control.

**Types:** `:id`, `:text`, `:textarea`, `:email`, `:password`, `:number`,
`:boolean`, `:select`, `:radio`, `:date`, `:datetime`, `:url`, `:tags`,
`:file`, `:embeds_many`, `:embeds_one`, `:belongs_to`, `:has_many`.

Host field modules (`field :color, MyApp.Admin.Fields.Color`) implement
`CorexAdmin.Field` — see [Customization](customization.md).

### Computed columns

`column/3` is a read-only cell that is not a schema column:

```elixir
column :post_count, MyAppWeb.Admin.Cells.PostCount, label: "Posts"
```

Never writable; never on the form.

## Filters

The index command bar is two rows: saved views + search + Export / Delete on
the first; pinned filters, **Add filter**, and **More filters** on the second.
Range widgets (`:date_range`, `:datetime_range`, `:number_range`) are compact
triggers that open their own dialog — not calendars glued to the toolbar.
Index chrome composition: [Customization](customization.md).

| Type | Row | Dialog | Query |
| ---- | --- | ------ | ----- |
| `:select` / `:multi_select` | select (≤12) or combobox (>12) | same, plus optional operators | `==` / `in` / `not in` |
| `:boolean` / `:presence` / `:relative_date` | select | same | equality / `is_nil` / rolling bounds |
| `:text` | input (label as placeholder) | same, plus operators | `ilike` / `==` |
| `:id` | input, exact | same | `==` |
| `:number` | number input | same, plus `:eq` / `:gte` / `:lte` | comparison |
| `:tags` | tags input | same | `in` |
| `:date_range` | summary trigger | presets + range picker | day bounds |
| `:datetime_range` | summary trigger | two `datetime-local` inputs | inclusive instants |
| `:number_range` | summary trigger | slider when bounds known | `min` / `max` |

Optional `field:`, `path:`, `pin: false`, `operators:`, `default_operator:`,
`min:` / `max:` (static bounds; overridden by `filter_bounds/2`).
Do not put HTML in resource modules.

Host filter modules: [Customization](customization.md).

### Dynamic options and bounds

```elixir
def filter_options(scope, :status), do: MyApp.Support.ticket_statuses(scope)
def filter_options(_scope, _name), do: nil

def filter_bounds(scope, :priority), do: MyApp.Support.ticket_priority_bounds(scope)
def filter_bounds(_scope, _name), do: nil
```

Returning `nil` falls back to static `options:` / `min:` / `max:`.

## Relations

The admin never queries associations. A relation names a **context function**.

### `belongs_to`

Combobox (or select) on the form. Options from `context.list(scope, opts)` with
`[query: term, limit: n]` when `search: true`. Writable attrs use `owner_key`
(the foreign key), not the association name.

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

Related-list panel on show, filled from the **preloaded** record. Empty
relations still show a panel. `has_many` is omitted from the detail definition
list so it does not appear twice.

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

## Nested embeds

```elixir
field :social_links, :embeds_many, schema: MyApp.SocialLink, index: false do
  field :label, :text
  field :url, :url
  field :preferred, :boolean, exclusive: true
end
```

Host changeset must `cast_embed/3` with `sort_param` / `drop_param`.
`CorexAdmin.Attrs.take_writable/2` allowlists child keys only.

`exclusive: true` means at most one row may be true; the last true row wins and
`Attrs` clears the rest. Enforce the same rule in the changeset.

## Metrics

```elixir
def metrics(scope, _list_opts) do
  [%{label: "Open", value: 12, hint: "waiting on us"}]
end
```

Cards above the index command bar. Not a dashboard framework — use `home:` for
that ([Customization](customization.md)).

## Form save actions

| Page | Primary | Secondary |
| ---- | ------- | --------- |
| New | **Create** → show | **Create and add another** → blank form |
| Edit | **Save** → stay | **Save and close** → show |

## Form / show sections

```elixir
form do
  section "Request", [:title, :status, :assignee]
  section "Details", [:body, :social_links]
end

show do
  section "Overview", [:title, :status]
  section "Timestamps", [:inserted_at]
end
```

More than one named section renders tabs. Default: one section from `fields do`.

## Actions

Delete, bulk delete, and export are ordinary registrations and the defaults
when you omit the blocks:

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
disable. Implementing `handle/3`, form dialogs, and icons:
[Customization](customization.md).

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
