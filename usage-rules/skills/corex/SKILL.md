---
name: corex
description: Use when building or changing Corex UI in Phoenix (components, hooks, HEEx, assets).
---

## When to use

Apply this skill for LiveView or controller templates that use Corex components, for hook wiring in `assets/js`, and for styling tokens or design assets shipped with Corex demos.

## Essentials

- Import and use function components from `Corex` in HEEx; keep accessibility props from component docs.
- List-shaped UIs: build data with `Corex.Content.new/1` (or `Corex.List` / `Corex.Tree` helpers) and pass into the matching component attribute.
- Client state: add the hook in `assets/js/app.js`, point `phx-hook` at the registered name, and keep hook keys aligned with the TypeScript hook under `assets/hooks/`.
- Reference: [https://hexdocs.pm/corex](https://hexdocs.pm/corex)

## Sync

Projects with `usage_rules` configured should run `mix usage_rules.sync` after dependency changes so this skill stays aligned with the installed Corex version.
