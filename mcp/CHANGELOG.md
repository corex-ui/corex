# Changelog

## Unreleased

Host-app install snippets recommend `{:corex_design, "~> 0.2", runtime: false}`
without `only: :dev`, matching the asset-pipeline Mix task.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.1 - 2026-08-08

Patch release aligned with Corex 0.2.1. No MCP API changes.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

## 0.2.0 - 2026-08-07

Initial Hex release of `corex_mcp` as a package separate from `corex`.

Optional MCP package (`only: [:dev, :test]`, **Apache-2.0**) for AI component
and design discovery. Never enable in production.

See the monorepo
[CHANGELOG](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) and
[MCP guide](https://hexdocs.pm/corex_mcp/mcp.html).
