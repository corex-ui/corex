# Resources

A resource is configuration, not a LiveView. It names context functions and
declares fields.

```elixir
defmodule MyAppWeb.Admin.UserResource do
  use CorexAdmin.Resource,
    context: MyApp.Accounts,
    schema: MyApp.Accounts.User,
    slug: "users",
    group: "Accounts",
    label: "Users"

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
    field :inserted_at, :datetime
  end

  filters do
    filter :role, :select
  end
end
```

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
scope the query. The admin does not run Repo.

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
| `:id` and timestamps | not writable |
| `:password` | write-only, redacted |
| schema `redact: true` | redacted |

v0.1 field types: `:id`, `:text`, `:textarea`, `:email`, `:password`,
`:number`, `:boolean`, `:select`, `:date`, `:datetime`, `:url`.
