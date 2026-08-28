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
    filter :role, :select, options: ~w(admin editor viewer), pin: true
    filter :email, :text
    filter :bio, :presence, pin: false
    filter :id, :id, pin: false
    filter :created, :relative_date, field: :inserted_at, pin: false
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
| `filters_open` | `false` | Open the first pinned filter pill on first paint |
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
by value shape: lists use `in`, `%{contains: term}` uses `ilike`, `:empty` /
`:set` test presence, `%{from, to}` / `%{min, max}` use range bounds, everything
else uses equality.

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

`filters do` is the source of truth for the index filter bar and the ListOpts
allowlist. `filterable: true` on a field does not render a control.

Pinned filters (`pin: true`, the default) are always on the bar as pills.
Unpinned filters appear under **Add filter** until the operator adds them.
Named views come from `canned_filters/0` and render as a toggle group above
the bar.

## Filter types

The index bar is Shopify/Linear-style: **saved views** (`canned_filters/0`) as a
toggle group, **pinned pills** always on the bar, and **Add filter** for the
rest (`pin: false`). Each pill is a Corex collapsible popover.

| Type | Widget | Query |
| ---- | ------ | ----- |
| `:select` | `<.select>` (≤12 options) or `<.combobox>` (>12). Optional `operators: [:in, :not_in]` | `==` / `not in` |
| `:multi_select` | same widgets, `multiple` | `in` / `not in` |
| `:date_range` | named presets (Today, Yesterday, Last 7/30/90, This week/month/quarter, YTD) plus `<.date_picker selection_mode="range">` | `>= from 00:00` and `< to+1 day` |
| `:datetime_range` | two `<.native_input type="datetime-local">` | `>= from` and `<= to` |
| `:relative_date` | `<.toggle_group>` of rolling windows (`options:` to subset them) | same bounds as `:date_range`, recomputed on each request |
| `:number_range` | two `<.number_input>`; also `<.slider>` when `min:` and `max:` are set | `>= min` and `<= max` |
| `:number` | operator + `<.number_input>` (`:eq`, `:gte`, `:lte`) | `==` / `>=` / `<=` |
| `:boolean` | `<.toggle_group>` Yes / No (deselect for Any) | `==` |
| `:text` | operator (`:contains`, `:equals`, `:starts_with`, `:ends_with`, `:not_contains`) + `<.native_input>` | `ilike` / `==` |
| `:id` | `<.native_input>` exact match | `==` |
| `:presence` | `<.toggle_group>` Has value / Is empty | `is_nil` / not nil |
| `:tags` | `<.tags_input>` | `in` |

Optional `field:` on a filter if the URL name should differ from the schema column
(for example `filter :created, :relative_date, field: :inserted_at`).
Optional `pin: false` to hide a filter behind **Add filter**.
Optional `operators:` / `default_operator:` to restrict or reorder comparison ops.
Do not put HTML in resource modules.

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

