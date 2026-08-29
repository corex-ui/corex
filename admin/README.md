# Corex Admin

Context-first, deny-by-default LiveView admin for Phoenix + Ecto, built on
[Corex](https://hex.pm/packages/corex). You own Resource modules and contexts;
the package owns authorization checks and Corex chrome. It never calls `Repo`.

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
mix deps.get
mix corex.admin.install
```

Full day-one path: [Getting started](guides/installation.md).

## Start here

Read the guides in this order:

1. [Getting started](guides/installation.md) — install, auth hook, first resource, `/admin`
2. [Security](guides/security.md) — deny-by-default policy, scoping, export tokens
3. [Resources](guides/resources.md) — fields, filters, relations, actions, callbacks
4. [Customization](guides/customization.md) — compose `CorexAdmin.UI`, custom Field/Filter/Action modules
5. [Eject](guides/eject.md) — copy chrome into your app and track drift with `doctor`

Most apps stop at Resources. Reach for Customization when a page needs its own
layout; eject only when you must change the markup itself.
