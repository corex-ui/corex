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

By default the installer also adds the **`plug Corex.MCP`** hook for development and test (see [MCP](mcp.html)); use **`--no-mcp`** if you do not want it.

If you want the full feature set:

```bash
mix corex.new my_app --mode --theme --lang --designex
```

Run **`mix help corex.new`** or see **`Mix.Tasks.Corex.New`** in Hexdocs for every Corex-only flag.

## Existing Phoenix application

Add Corex to a Phoenix app you already have in the [manual installation guide](manual_installation.html).

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

See [API](api.html) and [Events](events.html) for how helpers, `on_*`, and browser events fit together.

- [API](api.html) control components from LiveView, HEEx, or JavaScript.
- [Events](events.html) `on_*`, client events, and hook responses.
- [MCP](mcp.html) Corex MCP for AI tooling in development.
- [Dark mode](dark_mode.html) light/dark wiring after `--mode`.
- [Theming](theming.html) theme picker after `--theme`.
- [Localize](localize.html) locales and routes after `--lang`.
- [Production](production.html) prod build and run.
- [Manual installation](manual_installation.html) add Corex to an existing Phoenix app.
