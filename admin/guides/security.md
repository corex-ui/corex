# Security

Corex Admin is a **staff backoffice**. End-user CRUD belongs in
`mix corex.gen.live`. This package owns **authorization**, not identity.

## Authentication is the host app's job

The hub **requires** a non-empty `on_mount` list. Missing it is a compile
error. Typical wiring:

```elixir
on_mount: [
  {MyAppWeb.UserAuth, :ensure_authenticated},
  {MyAppWeb.UserAuth, :ensure_admin}
]
```

Do not mount `/admin` without that hook. Use a dedicated `live_session`
(what `live_corex_admin/2` already creates). Keep `check_origin` enabled.
On sign-out, disconnect LiveView sockets the same way `phx.gen.auth` does.

## Authorization is deny-by-default

The installer generates:

```elixir
def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
```

Allow `:index`, `:show`, `:new`, `:edit`, `:create`, `:update`, `:delete`,
and (when you enable them) `:export` and `:history`. Hiding a button is not
access control.

Optional `authorize_field/5` can further lock fields. Field flags
(`readable`, `writable`, `redact`) always apply.

This callback is Bodyguard-shaped so you can wrap `Bodyguard.permit/4` or
Permit without depending on those libraries.

## Data plane

The admin **never** calls `Repo.insert/update/delete/get`. Contexts do.
`get!` must be scoped (IDOR). `list/2` must apply the same scope.

## Mass assignment and params

- Only **writable** fields are copied into context attrs.
- Nested `:embeds_many` payloads keep allowlisted child keys plus `{name}_sort`
  / `{name}_drop`. Unknown nested keys are dropped and never atomized.
- Sort/filter/search keys are **allowlisted**. Unknown query params are dropped.
- User input is never turned into unbounded atoms.
- `:password` fields are write-only and never rendered on index/show.
- Schema `redact: true` fields are redacted unless overridden.

## Other

- No `Phoenix.HTML.raw` for user content.
- Pagination `page_size` must be in the resource (or app) `page_size_options` and
  is capped (`config :corex_admin, :max_page_size`). Unknown sizes fall back to
  the resource default.
- Search uses parameterized `ilike`, not interpolated SQL.
- Telemetry events include resource slug and action — never payloads.
- Document CSP and `force_ssl` the same way you would for LiveDashboard.

Rate-limit the **login** path in the host app (PlugAttack, Hammer). This
package has no login endpoint.
