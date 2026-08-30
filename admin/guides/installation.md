# Getting started

This guide takes you from a Phoenix app with an existing context to a working
staff admin at `/admin`. When you are done, read [Security](security.md) before
production, then [Resources](resources.md) to shape the DSL.

## 1. Add the dependency

```elixir
def deps do
  [
    {:corex, "~> 0.2"},
    {:corex_admin, "~> 0.1"}
  ]
end
```

```bash
mix deps.get
mix corex.admin.install
```

The installer writes:

- `lib/my_app_web/admin.ex` — hub (`use CorexAdmin`) with required `on_mount` and `policy`
- `lib/my_app_web/admin_policy.ex` — **deny-all** policy
- `lib/my_app_web/components/admin_layout.ex` — LiveView layout (`{@inner_content}`
  plus `CorexAdmin.UI.Nav.tree/1` / `Nav.mobile/1`)

Do not point `layout:` at a slot-based `Layouts.app`. Expand
`:filter_parameters` in your endpoint config beyond `"password"`.

## 2. Wire authentication

The hub **must** list at least one `on_mount` hook. Corex Admin never ships an
open admin. Point at your existing `phx.gen.auth` (or equivalent) hooks:

```elixir
use CorexAdmin,
  otp_app: :my_app,
  actor_assign: :current_scope,
  on_mount: [
    {MyAppWeb.UserAuth, :ensure_authenticated},
    {MyAppWeb.UserAuth, :ensure_admin}
  ],
  policy: MyAppWeb.AdminPolicy,
  layout: {MyAppWeb.AdminLayout, :admin},
  title: "Admin",
  resources: []
```

`actor_assign` is the socket assign that holds the actor or Phoenix scope
(for example `:current_scope`). See [Security](security.md) for the full
threat model.

## 3. Open the policy for staff

The installer denies everything. Until you allow actions, `/admin` mounts but
the nav stays empty. A minimal staff policy:

```elixir
defmodule MyAppWeb.AdminPolicy do
  @behaviour CorexAdmin.Policy

  @read ~w(index show)a
  @write ~w(new edit create update delete)a

  def authorize(%{user: %{role: :admin}}, action, _resource, _record)
      when action in @read or action in @write,
      do: :ok

  def authorize(%{user: %{role: :admin}}, action, _resource, _record)
      when action in [:export, :history],
      do: :ok

  def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
end
```

Hiding a button is not access control. Allow each action you need. Details and
`authorize_field/5` live in [Security](security.md).

## 4. Mount the router

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  import CorexAdmin.Router

  scope "/", MyAppWeb do
    pipe_through :browser
    live_corex_admin "/admin", MyAppWeb.Admin
  end
end
```

That creates a dedicated `live_session` with home, per-resource CRUD routes, and
`POST /admin/:resource/export`. Optional hub keys:

- `title:` / `description:` — home heading and sidebar label
- `home:` — replace the default home LiveView
- `pages:` — extra `{path, LiveView}` routes in the same session

See [Customization](customization.md) for `home:` and `pages:`.

## 5. Layout and assets

The installer layout already mounts the admin nav. Ensure Design `admin.css` is
part of your asset pipeline the same way other Corex components are (the
monorepo e2e app is a working reference). Hosts must not `@source` the
`admin/` package directory.

## 6. Generate a resource

You need an **existing** context and schema first.

```bash
mix corex.admin.gen.resource Accounts User
```

Register the module on the hub:

```elixir
resources: [MyAppWeb.Admin.UserResource]
```

The generator maps field types and wires `list_users`, `get_user!`,
`create_user`, and the other `phx.gen.context` names. Pass `--no-scope` only if
your context does not take a scope as the first argument.

## 7. Implement `list/2`

The admin never calls `Repo`. Your context accepts `%CorexAdmin.ListOpts{}` and
returns `{:ok, %CorexAdmin.Page{}}`:

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

Scope `get!` the same way (IDOR). Preload associations the show page should
list. Full field, filter, and relation DSL: [Resources](resources.md).

## 8. Open `/admin`

1. Sign in as a staff user your `on_mount` accepts.
2. Visit `/admin` — home lists resources you may `:index`.
3. Open `/admin/users` (or your slug) — index, new, show, and edit should work
   once policy allows those actions.

If the nav is empty, the policy is still denying `:index`. If the page 404s,
the resource is not in `resources:` or the slug does not match.

## Next steps

- Shape fields, filters, relations, and bulk actions — [Resources](resources.md)
- Override a page layout or write a Field/Action module — [Customization](customization.md)
- Copy chrome into your app only when markup must change — [Eject](eject.md)
- Before production — [Security](security.md)
