# Corex Admin

Context-first, deny-by-default LiveView admin for Phoenix+Ecto apps, built on
[Corex](https://hex.pm/packages/corex).

**v0.1 is LiveView-only.** Resource, policy, and context modules have no LiveView
dependency so a controller renderer can land later without rewriting resources.

## Requirements

- Elixir `~> 1.17`
- Phoenix 1.8 and Phoenix LiveView 1.1+
- An existing Phoenix context + Ecto schema
- Host-app authentication (`phx.gen.auth` or equivalent `on_mount`)

This package does **not** ship login, registration, or an admin user table.

## Install

```elixir
# mix.exs
{:corex_admin, "~> 0.1"}
```

```bash
mix corex.admin.install
mix corex.admin.gen.resource Accounts User
```

See [Installation](guides/installation.md), [Security](guides/security.md),
[Resources](guides/resources.md), and [Customization](guides/customization.md).

Customization is three tiers: a Resource module and callbacks, host LiveViews
that compose `CorexAdmin.UI` (`mix corex.admin.gen.live --render`), and a
tracked ejection of chrome (`mix corex.admin.gen.admin` +
`mix corex.admin.doctor`).
