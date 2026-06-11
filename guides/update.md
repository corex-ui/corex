# Updating Corex

How to pull a newer Corex release into your app and refresh generated design CSS.

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

When the release notes mention CSS, tokens, or design files, update both packages and recompile:

```bash
mix deps.update corex corex_design
mix deps.get
mix compile
mix assets.build
```

Run `mix compile` to refresh `assets/css/` (`corex.tailwind.css`, `layers/`, `recipes/`, `aggregates/`). If you customized `config :corex, Corex.Design`, review [Design config](design-config.html) for new keys after upgrading. First-time setup is in [Styled](styled.html).

## After upgrading

1. Read [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) for breaking or additive changes.
2. Run your usual checks (`mix test`, `mix assets.build`, and any e2e suite you use).
3. Spot-check pages that use components you rely on (forms, overlays, tables).

For a full manual install path (first-time setup), see [Manual installation](manual_installation.html).

