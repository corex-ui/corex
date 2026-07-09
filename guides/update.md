# Updating Corex

How to pull a newer Corex release into your app and refresh design assets.

## Elixir dependency

In `mix.exs`:

```elixir
{:corex, "~> 0.2.0"}
```

`~> 0.2.0` keeps you on **0.2.x** (patch and minor releases on that line). To move from **0.1.x**, change the requirement after reading [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

```bash
mix deps.update corex corex_design
mix deps.get
mix compile
```

## Design assets

When the release notes mention CSS, tokens, or design files:

```bash
mix corex.design.build
```

Or run a full asset build:

```bash
mix assets.build
```

### Migrating from `mix corex.design`

If your app still uses copied design files without the `corex_design` dependency:

1. Add `{:corex_design, "~> 0.2", runtime: false, only: :dev}` to `mix.exs`
2. Add `config :corex_design` to `config/config.exs` (see [Manual installation](manual_installation.html))
3. Add `"corex.design.build"` to `assets.build` and `assets.deploy`
4. Run `mix deps.get && mix corex.design.build`

## After upgrading

1. Read [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) for breaking or additive changes.
2. Run your usual checks (`mix test`, `mix assets.build`, and any e2e suite you use).
3. Spot-check pages that use components you rely on (forms, overlays, tables).

For a full manual install path (first-time setup), see [Manual installation](manual_installation.html).
