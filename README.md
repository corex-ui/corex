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

With `{:corex, "~> 0.1.0"}`, patch and minor releases stay backward compatible until 0.2.0. See [Updating Corex](https://hexdocs.pm/corex/update.html).

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

By default Corex Design will be installed. You can use `--no-design` to opt out.

By default the installer adds **`plug Corex.MCP`** in `:dev` and `:test` only (see [MCP](https://hexdocs.pm/corex/mcp.html)); never enable it in `:prod`. Use **`--no-mcp`** if you do not want it.

If you want the full feature set:

```bash
mix corex.new my_app --mode --theme --lang --designex
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
    [value: "lorem", trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."],
    [value: "duis", trigger: "Duis dictum gravida odio ac pharetra?", content: "Nullam eget vestibulum ligula, at interdum tellus."],
    [value: "donec", trigger: "Donec condimentum ex mi", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."]
  ])}
/>
```

If you are using Corex Design import the accordion css

```css
@import "../corex/components/accordion.css";
```

### API

Every Corex component exposes JS commands for client-side control and matching `socket` helpers for server-side control. You need an `id` on the component.

```heex
<.action class="button" phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])}>
  Open the first panel
</.action>
```

## Become a sponsor

Corex is open source. If you rely on it in production or want to help sustain development, consider [becoming a sponsor on GitHub](https://github.com/sponsors/corex-ui).

## Next steps

- [MCP](https://hexdocs.pm/corex/mcp.html) Corex MCP for AI tooling in development.
- [Design](https://hexdocs.pm/corex/design.html) styling overview: [Unstyled](https://hexdocs.pm/corex/unstyled.html), [Styled](https://hexdocs.pm/corex/styled.html), [Design config](https://hexdocs.pm/corex/design-config.html).
- [Dark mode](https://hexdocs.pm/corex/dark_mode.html) light/dark wiring after `--mode`.
- [Theming](https://hexdocs.pm/corex/theming.html) theme picker after `--theme`.
- [Localize](https://hexdocs.pm/corex/localize.html) locales and routes after `--lang`.
- [Production](https://hexdocs.pm/corex/production.html) prod build and run.
- [Manual installation](https://hexdocs.pm/corex/manual_installation.html) add Corex to an existing Phoenix app.
- [Tableau](https://hexdocs.pm/corex/tableau.html) Corex on static Tableau sites ([Tableau Theming](https://hexdocs.pm/corex/tableau_theming.html), [Tableau Mode](https://hexdocs.pm/corex/tableau_mode.html), [Tableau Localize](https://hexdocs.pm/corex/tableau_localize.html)).
