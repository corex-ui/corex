# Installation

Add the Hex dependency (path dep in this monorepo):

```elixir
def deps do
  [
    {:corex, "~> 0.2"},
    {:corex_admin, "~> 0.1"}
  ]
end
```

Run the installer:

```bash
mix deps.get
mix corex.admin.install
```

The installer writes:

- `lib/my_app_web/admin.ex` — hub with **required** `on_mount` and `policy`
- `lib/my_app_web/admin_policy.ex` — **deny-all** policy
- `lib/my_app_web/components/admin_layout.ex` — LiveView layout (`{@inner_content}`
  + `CorexAdmin.UI.Nav.tree/1` / `Nav.mobile/1`). Do not point `layout:` at a
  slot-based `Layouts.app`.

Optional hub options:

```elixir
use CorexAdmin,
  # ...
  title: "Admin",
  description: nil,
  pages: []
```

`home:` is a LiveView module (or `{Module, :live_action}`). `pages:` are extra
`{path, LiveView}` routes in the same session; see [Customization](customization.html).

Mount inside the browser pipeline (CSRF already on):

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

Generate a resource that points at an **existing** context:

```bash
mix corex.admin.gen.resource Accounts User
```

Add the resource module to `use CorexAdmin, resources: [...]`.

Implement `list/2` to accept `%CorexAdmin.ListOpts{}` and return
`{:ok, %CorexAdmin.Page{}}`. Use `CorexAdmin.Query.apply/2` inside the
context after you scope the query. See [Resources](resources.html).

When a page needs its own `render/1`:

```bash
mix corex.admin.gen.live UserResource
mix corex.admin.gen.live UserResource --render
```

When the block markup itself must change:

```bash
mix corex.admin.gen.admin
mix corex.admin.doctor
```

See [Customization](customization.html) for the three tiers.

Expand `:filter_parameters` in the endpoint config beyond `"password"`.
