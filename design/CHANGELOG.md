# Changelog

## 0.2.2 - 2026-08-29

### Upgrade notes

- Run `mix corex.design.build` from `assets.build` / `assets.deploy` (not `mix compile`).
- For `--a11y` + `mix release`, add `corex_design: :load`.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.1 - 2026-08-08

Patch release aligned with Corex 0.2.1. No Design API changes.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.0 - 2026-08-07

Initial Hex release of `corex_design` as a package separate from `corex`.

Config-driven Elixir CSS pipeline: themes, semantics, modes, shared `ui-*`
modifiers, and `mix corex.design.build`. `accessibility: true` enables all six
preference axes; see `Corex.Design.Accessibility` on Hexdocs.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) and
[update guide](https://hexdocs.pm/corex/update.html).
