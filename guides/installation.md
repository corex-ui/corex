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
- **Unstyled by default.** Corex ships behavior and markup, not opinionated CSS. You choose how things look.
- **Accessible by default.** Keyboard, focus and ARIA wired in by Zag.js state machines.

## How styling works

Corex does not bundle visual styles. That does **not** mean components render as plain, unmarked HTML.

Each component exposes **style attributes** (`semantic`, `size`, `radius`, and others depending on the component). These attrs do not apply CSS themselves. They declare the look you want: accent color, large size, rounded corners, and so on.

At render time, Corex turns those declarations into **BEM modifier classes** on the host element:

```heex
<.accordion semantic="accent" size="lg" class="accordion" … />
```

becomes something like:

```html
<div class="accordion accordion--semantic-accent accordion--size-lg" data-scope="accordion" …>
```

You write CSS against those classes (or against `data-part` selectors inside the component) and control every visual detail. The attrs are a stable vocabulary; your stylesheet is where the pixels live.

You can skip the attrs and set the same modifiers directly on `class`:

```heex
<.accordion class="accordion accordion--semantic-accent accordion--size-lg" … />
```

Both forms produce the same class list. Use whichever reads better in your templates.

**Corex Design** is an optional layer on top: token-based themes and ready-made Tailwind CSS for every modifier, so you import component styles instead of authoring them from scratch. `mix corex.new` installs it by default; use `--no-design` to stay fully custom. See [Unstyled](unstyled.html) for the styling model and [Styled](styled.html) for setup.

Pass `unstyled` on a component to skip class generation entirely and keep only what you put in `class`.

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

By default the installer adds **`plug Corex.MCP`** in `:dev` and `:test` only (see [MCP](mcp.html)); never enable it in `:prod`. Use **`--no-mcp`** if you do not want it.

If you want the full feature set:

```bash
mix corex.new my_app --mode --theme --lang
```

Run **`mix help corex.new`** or see **`Mix.Tasks.Corex.New`** in Hexdocs for every Corex-only flag.

## Existing Phoenix application

Add Corex to a Phoenix app you already have in the [manual installation guide](manual_installation.html).

## Generator and app config

`mix corex.gen.live` and `mix corex.gen.html` read optional keys under `config :corex, :generators`:

| Key | Values | Purpose |
| --- | ------ | ------- |
| `:gettext` | `true`, `:sigils`, or omit | When `true`, generated copy uses `gettext/1`. When `:sigils`, uses `~t` (needs `gettext_sigils` in `html_helpers`). |
| `:gettext_sigils` | boolean | Alias for `gettext: :sigils` |
| `:layout` | keyword | `mode: true`, `theme: true`, `locale: true` wire `Layouts.app` assigns in generated LiveViews / HTML |

Set `:debug` to `true` for verbose MCP request logging in development (default `false`).

Axis vocabulary and theme roles are configured under flat `config :corex_design` keys (`default_theme`, `themes`, `scales`, `recipes`, `aliases`). See [Design config](design-config.html) and [Unstyled](unstyled.html).

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

If you are using Corex Design, import the generated bundle (see [Styled](styled.html)):

```css
@import "./corex.tailwind.css";
```

### API

Every Corex component exposes JS commands for client-side control and matching `socket` helpers for server-side control. You need an `id` on the component.

```heex
<.action class="button" phx-click={Corex.Accordion.set_value("my-accordion", ["lorem"])}>
  Open the first panel
</.action>
```

Each component documents **API** and **Events** on its Hexdocs page (helpers, `on_*`, and browser events).

## Become a sponsor

Corex is open source. If you rely on it in production or want to help sustain development, consider [becoming a sponsor on GitHub](https://github.com/sponsors/corex-ui).

- [MCP](mcp.html) Corex MCP for AI tooling in development.
- [Dark mode](dark_mode.html) light/dark wiring after `--mode`.
- [Theming](theming.html) theme picker after `--theme`.
- [Localize](localize.html) locales and routes after `--lang`.
- [Production](production.html) prod build and run.
- [Design](design.html) — styling overview (Unstyled, Styled, Config)
- [Manual installation](manual_installation.html) add Corex to an existing Phoenix app.
- [Tableau](tableau.html) Corex on static Tableau sites; optional [Tableau Theming](tableau_theming.html), [Tableau Mode](tableau_mode.html), [Tableau Localize](tableau_localize.html).
