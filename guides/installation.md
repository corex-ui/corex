# Installation

Corex gives you accessible, keyboard-friendly UI primitives on Phoenix and LiveView: declarative HEEx components, matching JavaScript hooks, and server-side APIs that stay in sync with the client. Use your own styles or opt into the Corex Design assets.

This guide covers adding Corex with the official generators. For the same setup without Igniter, see [Manual installation](manual_installation.html).

> **Beta** — Corex is under active development. The public API is stabilizing; report rough edges on [GitHub](https://github.com/corex-ui/corex).

## Prerequisites

- **Elixir** `~> 1.17` (see the [corex package](https://hex.pm/packages/corex) on Hex for the exact requirement).
- **Phoenix** and **LiveView** versions compatible with Corex (constraints are listed on Hex).

## New Phoenix application

Install the archives once

```bash
mix archive.install hex phx_new
mix archive.install hex igniter
mix archive.install hex corex_new
```

Generate an application:

```bash
mix corex.new my_app
```

Update the generator before creating a project:

```bash
mix local.corex
mix corex.new my_app
```

```bash
mix help corex.new
```

### Corex options (`corex.new` and `mix igniter.install corex`)

Corex flags are unique and **do not conflict** with `phx.new` or Igniter switches, so you can pass them bare to either generator (no `--corex.` prefix needed).

| Flag | Effect |
|------|--------|
| `--mode` | Light/dark mode: plugs, assigns, root layout script, optional layout UI (see [Dark mode](dark_mode.html)). **Implies `--design`** (with a notice). |
| `--theme` | Theme picker (neo, uno, duo, leo): plugs, assigns, optional UI (see [Theming](theming.html)). **Implies `--design`** (with a notice). |
| `--lang` | Localization with `localize_web`, Path plug, router helpers (see [Localize](localize.html)). Does **not** imply `--design`. |
| `--replace` / `--no-replace` | Stock welcome page uses Corex app layout and toast pattern; no separate `/home` demo route. Pass **`--no-replace`** to keep the default Phoenix home and add `GET /home` with `Layouts.corex` instead. **Default: on** for `corex.new`, **off** for `mix igniter.install corex`. |
| `--design` / `--no-design` | Add the Corex Design System and component styles (`mix corex.design`). Pass **`--no-design`** to skip. **Default: on**. Cannot be combined with `--mode`, `--theme`, or `--designex`. |
| `--designex` | Pass `--designex` to `mix corex.design` when design runs. **Implies `--design`**. |
| `--mcp` / `--no-mcp` | Add the Corex MCP plug on the web endpoint in development. Pass **`--no-mcp`** to skip. **Default: on**. |

Examples:

```bash
mix corex.new my_app --mode --theme --lang
mix corex.new my_app --no-design
mix igniter.install corex --mode --theme --lang --yes
mix igniter.install corex --replace --yes
```

Installing Corex from a **local checkout or path dependency** is **not** covered here — use **`mix help corex.new`** and the task moduledoc for `Mix.Tasks.Corex.New`.

## Existing Phoenix application

From your app directory:

```bash
mix igniter.install corex
```

Re-running `mix igniter.install corex` with the same flags makes no diffs to the project — the installer is idempotent. You can also re-run with new UI flags (e.g. add `--lang` later) and only the new bits will be added; previously enabled features are preserved.

## Try a component

Use any Corex function component after `use Corex`. For example, see **`Corex.Accordion`** in the sidebar module list for attributes, slots, and examples.

## Next steps

- [MCP](mcp.html) — Corex MCP in development.
- [Dark mode](dark_mode.html) — light/dark after `--mode`.
- [Theming](theming.html) — theme picker after `--theme`.
- [Localize](localize.html) — locales and routes after `--lang`.
- [Production](production.html) — prod build and run.
- [Manual installation](manual_installation.html) — install Corex without Igniter.

---

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=corex-install)](https://coveralls.io/github/corex-ui/corex?branch=corex-install)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)
