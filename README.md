# Installation

![Hex.pm License](https://img.shields.io/hexpm/l/corex)
![Hex.pm Version](https://img.shields.io/hexpm/v/corex)
[![Coverage Status](https://coveralls.io/repos/github/corex-ui/corex/badge.svg?branch=main)](https://coveralls.io/github/corex-ui/corex?branch=main)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/corex-ui/corex/elixir.yml)
![GitHub branch check runs](https://img.shields.io/github/check-runs/corex-ui/corex/main)

## Introduction

**The Phoenix UI with a real API.** Accessible, unstyled Phoenix components with a full server-and-client API, powered by [Zag.js](https://zagjs.com) state machines.

- **Server & client API.** Drive every component from LiveView or JavaScript and listen back from either side.
- **LiveView-native.** Update props at runtime without resetting component state.
- **Truly unstyled.** Bring your own CSS or opt into Corex Design tokens, themes and modes.
- **Accessible by default.** Keyboard, focus and ARIA wired in by Zag.js state machines.

With `{:corex, "~> 0.2.0"}`, follow [Updating Corex](https://hexdocs.pm/corex/update.html) when upgrading from 0.1.x (shared `ui-*` modifiers replace per-component BEM palette and size classes).

## Packages

| Package | Kind | Purpose | `mix corex.new` |
|---------|------|---------|-----------------|
| [`corex`](https://hex.pm/packages/corex) | Hex dep | Unstyled Phoenix components, hooks, LiveView API | Always |
| [`corex_design`](https://hex.pm/packages/corex_design) | Hex dep (`runtime: false`) | Config-driven tokens, themes, and component CSS ([Design](https://hexdocs.pm/corex/design.html)) | On by default; `--no-design` to skip |
| [`corex_mcp`](https://hex.pm/packages/corex_mcp) | Hex dep (`only: :dev`) | Dev MCP server for AI component and design discovery ([MCP](https://hexdocs.pm/corex/MCP.html)); never enable in `:prod` | On by default; `--no-mcp` to skip |
| [`corex_new`](https://hex.pm/packages/corex_new) | Mix archive | Greenfield generator (`mix corex.new`) | Install once with `mix archive.install hex corex_new` |

## New Corex application

Install the archives once:

```bash
mix archive.install hex phx_new
mix archive.install hex corex_new
```

Generate an application:

```bash
mix corex.new my_app
```

Design and MCP are on by default. Pass `--no-design` or `--no-mcp` to skip either package.

If you want the full feature set:

```bash
mix corex.new my_app --mode --theme --lang
```

Run **`mix help corex.new`** or see **`Mix.Tasks.Corex.New`** in Hexdocs for every Corex-only flag.

## Existing Phoenix application

Follow the [manual installation guide](https://hexdocs.pm/corex/manual_installation.html)

## Try your first component

### Accordion

```heex
<.accordion
  id="my-accordion"
  class="accordion"
  items={Corex.Content.new([
    [value: "lorem", label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [value: "duis", label: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [value: "donec", label: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

### API

Every Corex component exposes JS commands for client-side control and matching `socket` helpers for server-side control. You need an `id` on the component.

```heex
<.action class="button" phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])}>
  Open the first panel
</.action>
```

Each component documents **API** and **Events** on its Hexdocs page.

## Become a sponsor

Corex is open source. If you rely on it in production or want to help sustain development, consider [becoming a sponsor on GitHub](https://github.com/sponsors/corex-ui).

## Next steps

- [Forms](https://hexdocs.pm/corex/forms.html) `field`, validation, and `auto_invalid`
- [MCP](https://hexdocs.pm/corex/MCP.html) / [corex_mcp](https://hexdocs.pm/corex_mcp) AI tooling in development
- [Design](https://hexdocs.pm/corex/design.html) tokens, themes, and modifiers
- [Theming](https://hexdocs.pm/corex/theming.html) / [Dark mode](https://hexdocs.pm/corex/dark_mode.html) / [Localize](https://hexdocs.pm/corex/localize.html) pickers after `--theme` / `--mode` / `--lang`
- [Updating Corex](https://hexdocs.pm/corex/update.html) migrate to 0.2.x
- [Production](https://hexdocs.pm/corex/production.html) prod build and run
- [Manual installation](https://hexdocs.pm/corex/manual_installation.html) add Corex to an existing Phoenix app
- [Tableau](https://hexdocs.pm/corex/tableau.html) Corex on static Tableau sites
