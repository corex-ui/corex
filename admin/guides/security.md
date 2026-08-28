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
and (when you enable them) `:export` and `:history`. Custom actions declare
their own `policy_action/0` (often `:update`). Hiding a button is not access
control. `CorexAdmin.UI.Nav.tree/1` only lists resources the actor may index.

Optional `authorize_field/5` can further lock fields. Field flags
(`readable`, `writable`, `redact`) always apply.

This callback is Bodyguard-shaped so you can wrap `Bodyguard.permit/4` or
Permit without depending on those libraries.

## Data plane

The admin **never** calls `Repo.insert/update/delete/get`. Contexts do.
`get!` must be scoped (IDOR). `list/2` must apply the same scope.
Relation pickers call a **host** `list/2` with the same scope; the admin
does not query associations, and `has_many` panels read only what `get!`
already preloaded.

## Mass assignment and params

- Only **writable** fields are copied into context attrs.
- `belongs_to` writes the foreign key (`owner_key`), not the association name.
- Nested `:embeds_many` payloads keep allowlisted child keys plus `{name}_sort`
  / `{name}_drop`. Unknown nested keys are dropped and never atomized.
- `exclusive: true` nested booleans: at most one row stays true; `Attrs`
  clears the rest so the UI cannot be trusted for uniqueness.
- Sort/filter/search keys are **allowlisted**. Unknown query params are dropped.
- User input is never turned into unbounded atoms.
- `:password` fields are write-only and never rendered on index/show.
- Schema `redact: true` fields are redacted unless overridden.
- Filter `parse/2` drops values outside `options:`; it does not forward them.

## Export

`POST #{prefix}/:resource/export` is a Plug controller in the same router
scope, outside `live_session`. Auth is a short-lived `Phoenix.Token` minted
by the LiveView (salt `"corex_admin.export"`, max age 300 seconds). Policy
`:export` is checked when the token is minted and when the controller runs.
The export trigger is disabled until rows are selected.

## Other

- No `Phoenix.HTML.raw` for user content.
- Pagination `page_size` must be in the resource (or app) `page_size_options` and
  is capped (`config :corex_admin, :max_page_size`). Unknown sizes fall back to
  the resource default.
- Search uses parameterized `ilike`, not interpolated SQL.
- `CorexAdmin.Query` raises on unrecognized filter shapes rather than returning
  an unfiltered query.
- Telemetry events include resource slug and action — never payloads.
- Document CSP and `force_ssl` the same way you would for LiveDashboard.

Rate-limit the **login** path in the host app (PlugAttack, Hammer). This
package has no login endpoint.
