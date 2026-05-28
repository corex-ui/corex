# Updating Corex

How to pull a newer **0.1.x** release into your app and refresh vendored assets.

## Elixir dependency

In `mix.exs`:

```elixir
{:corex, "~> 0.1.0"}
```

`~> 0.1.0` keeps you on **0.1.0-rc.x** and **0.1.x** (patch and minor releases on that line). To move to a future **0.2.0**, change the requirement after reading [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

```bash
mix deps.update corex
mix deps.get
mix compile
```

## Design assets

When the release notes mention CSS, tokens, or design files:

```bash
mix corex.design --force
```

If you use Designex:

```bash
mix corex.design --designex --force
```

Compare `assets/corex/VERSION` in your app with the version in `mix deps` after updating.

## After upgrading

1. Read [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) for breaking or additive changes.
2. Run your usual checks (`mix test`, `mix assets.build`, and any e2e suite you use).
3. Spot-check pages that use components you rely on (forms, overlays, tables).

For a full manual install path (first-time setup), see [Manual installation](manual_installation.html).

## Controlled components (0.1.0)

These components support `controlled` with matching `on_*_change` handlers: accordion, angle slider, checkbox, collapsible, date picker, dialog, listbox, pagination, radio group, select, switch, tabs, tags input, toggle, and toggle group.

Other stateful components use assign-driven defaults (`value`, `open`, `paths`, etc.) without `controlled` for now.
