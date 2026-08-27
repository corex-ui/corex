# Resources

A resource is configuration, not a LiveView. It names context functions and
declares fields. Filters are **per resource** — the generic index only renders
that resource's `filters do` block.

```elixir
defmodule MyAppWeb.Admin.UserResource do
  use CorexAdmin.Resource,
    context: MyApp.Accounts,
    schema: MyApp.Accounts.User,
    slug: "users",
    group: "Accounts",
    label: "Users",
    page_size: 25,
    page_size_options: [10, 25, 50, 100],
    default_sort: {:inserted_at, :desc},
    title_field: :email,
    selectable: true

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
    field :password, :password
    field :inserted_at, :datetime, sortable: true
  end

  filters do
    filter :role, :select, options: ~w(admin editor viewer)
    filter :inserted_at, :date_range
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
| `filters_open` | `false` | Initial open state of the index filter popover |
| `title_field` | primary key | Breadcrumbs, flash, show heading (overridable via `title/1`) |
| `singular` | schema name | “New Ticket”; empty copy still uses plural `label` |
| `selectable` | `true` | Index checkboxes, bulk bar, and bulk delete |
| `live` | generic LiveViews | `index` / `show` / `form` host modules (`use CorexAdmin.Live`) |
| `history` | none | Optional `CorexAdmin.History` adapter (Show History tab) |

## Context contract

When `scope/1` is set, the scope/actor is the first argument.

- `list(scope, %CorexAdmin.ListOpts{}) :: {:ok, %CorexAdmin.Page{}} | {:error, term}`
- `get!(scope, id)` — must filter by scope
- `create(scope, attrs) :: {:ok, record} | {:error, changeset}`
- `update(scope, record, attrs) :: {:ok, record} | {:error, changeset}`
- `delete(scope, record) :: {:ok, record} | {:error, term}`
- `change_create(scope, %Schema{}, attrs)` / `change_update(scope, record, attrs)` return
  changesets. Phoenix apps often share one `change_*` for both (the admin passes an empty
  struct on create).

Use `CorexAdmin.Query.apply/2` and `paginate/2` **inside** the context after you
scope the query. The admin does not run Repo. `Query.apply/2` dispatches filters
by value shape: lists use `in`, `%{from, to}` / `%{min, max}` use range bounds,
everything else uses equality.

```elixir
def list_users(scope, %CorexAdmin.ListOpts{} = opts) do
  query =
    User
    |> where([u], u.org_id == ^scope.user.org_id)
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

## Field flags

| Flag | Default |
| ---- | ------- |
| `searchable` / `sortable` / `filterable` | `false` |
| `index` | readable, not redacted, not `:textarea` / `:password` |
| `show` | readable, not redacted |
| `:id` and timestamps | not writable |
| `:password` | write-only, redacted |
| schema `redact: true` | redacted |

`filters do` is the source of truth for the index toolbar and the ListOpts
allowlist. `filterable: true` on a field does not render a control.

v0.1 field types: `:id`, `:text`, `:textarea`, `:email`, `:password`,
`:number`, `:boolean`, `:select`, `:date`, `:datetime`, `:url`,
`:embeds_many`.

## Nested embeds

Use `:embeds_many` for repeating rows on the form (for example social links).
Declare child fields in a `do` block. Default `index: false`. The host changeset
must `cast_embed/3` with `sort_param: :{name}_sort` and `drop_param: :{name}_drop`.

```elixir
field :social_links, :embeds_many, schema: MyApp.SocialLink, index: false do
  field :label, :text
  field :url, :url
  field :preferred, :boolean
end
```

`CorexAdmin.Attrs.take_writable/2` copies the embed payload plus the sort/drop
params and keeps only allowlisted child keys — unknown nested keys are dropped
and never atomized.

## Filter types

| Type | Widget | Query |
| ---- | ------ | ----- |
| `:select` | `<.select>` when there are 12 or fewer options, or `<.combobox>` when there are more than 12 | `==` |
| `:multi_select` | same widgets as `:select`, with `multiple` | `in` |
| `:date_range` | presets (Today, Last 7 days, Last 30 days, This month, YTD) plus `<.date_picker selection_mode="range">` | `>= from 00:00` and `< to+1 day` |
| `:datetime_range` | two `<.native_input type="datetime-local">` | `>= from` and `<= to` |
| `:number_range` | two `<.number_input>` | `>= min` and `<= max` |
| `:boolean` | `<.toggle_group>` Yes / No (deselect for Any) | `==` |

Optional `field:` on a filter if the URL name should differ from the schema column.
Do not put HTML in resource modules.
