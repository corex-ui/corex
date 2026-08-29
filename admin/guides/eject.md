# Eject

Copying framework views into a host app always works and always ages badly:
the copy stops receiving upstream fixes, and nothing tells you which copies
have fallen behind.

Prefer [Customization](customization.md) first: compose `CorexAdmin.UI` with
`mix corex.admin.gen.live --render`. Reach for ejection only when you must
change the **markup** of a block itself.

## What gets copied

```bash
mix corex.admin.gen.admin
mix corex.admin.gen.admin --only index,filters
```

Writes:

- `lib/my_app_web/admin/components/*.ex` — blocks renamed into
  `MyAppWeb.Admin.Components`
- `priv/corex_admin/ejected.exs` — which blocks were copied, from which
  package version, with a sha256 of the package source

Ejectable blocks: Index, Form, Show, Home, Nav, Filters, Dialogs, Fields.

**Not** ejected: `CorexAdmin.UI` (imports only) and `CorexAdmin.UI.Labels`
(shared translated vocabulary).

Configuration is not copied. Ejected blocks still receive the same assigns,
still read `@spec`, and still delegate events to the package controllers.
Fields, filters, policy, and the context contract stay in your resource
modules.

Point a LiveView at the copy:

```elixir
def render(assigns) do
  ~H"""
  <MyAppWeb.Admin.Components.Index.page {assigns} />
  """
end
```

## Tracking drift

```bash
mix corex.admin.doctor
```

For each ejected block:

| Status | Meaning |
| ------ | ------- |
| **current** | Package source unchanged since you copied it |
| **behind** | Package source changed; diff and decide |
| **unknown** | Package source could not be read |

`doctor` exits **1** when any block is behind, so CI can fail on unreviewed
drift:

```bash
# in CI after mix deps.get
mix corex.admin.doctor
```

It does not merge. Copied markup cannot be merged automatically. Diff each
block against the package source, then either re-run `gen.admin` (overwrites
your copy — diff first) or patch by hand and update the manifest by
re-ejecting when you intentionally catch up.

```bash
diff lib/my_app_web/admin/components/index.ex \
  deps/corex_admin/lib/corex_admin/ui/index.ex
```

## Upgrade workflow

1. Bump `corex_admin` and run your test suite.
2. Run `mix corex.admin.doctor`.
3. For each **behind** block, diff, decide, re-eject or patch.
4. Commit the updated `priv/corex_admin/ejected.exs` with the chrome changes.

If nothing is ejected, `doctor` reports that there is nothing to fall behind —
that is the healthy default.
