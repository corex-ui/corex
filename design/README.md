# Corex Design

Optional config-driven tokens, themes, and component CSS for [Corex](https://hex.pm/packages/corex). Declare themes and semantics in `config :corex_design`, then generate CSS with `mix corex.design.build`.

Full app wiring (html attributes, pickers, fonts, icons) lives in Corex Hexdocs: [Design](https://hexdocs.pm/corex/design.html), [Theming](https://hexdocs.pm/corex/theming.html), [Dark mode](https://hexdocs.pm/corex/dark_mode.html), [Modifiers](https://hexdocs.pm/corex/modifiers.html). Upgrading from 0.1.x: [Updating Corex](https://hexdocs.pm/corex/update.html).

## Requirements

- **Elixir** `~> 1.17`
- **JSON:** OTP 27+ uses native `:json`. On OTP 24–26, add `{:json_polyfill, "~> 0.2 or ~> 1.0"}` to the host app (the installer adds it for `--lang` / `--design`).

## Packages

| Package | Kind | Purpose | `mix corex.new` |
|---------|------|---------|-----------------|
| [`corex`](https://hex.pm/packages/corex) | Hex dep | Unstyled Phoenix components, hooks, LiveView API | Always |
| [`corex_design`](https://hex.pm/packages/corex_design) | Hex dep (`runtime: false`) | Config-driven tokens, themes, and component CSS ([Design](https://hexdocs.pm/corex/design.html)) | On by default; `--no-design` to skip |
| [`corex_mcp`](https://hex.pm/packages/corex_mcp) | Hex dep (`only: [:dev, :test]`) | Dev MCP server for AI component and design discovery ([MCP](https://hexdocs.pm/corex/MCP.html)); never enable in `:prod` | On by default; `--no-mcp` to skip |
| [`corex_new`](https://hex.pm/packages/corex_new) | Mix archive | Greenfield generator (`mix corex.new`) | Install once with `mix archive.install hex corex_new` |

## Install

```elixir
# mix.exs
{:corex_design, "~> 0.2", runtime: false}
```

```elixir
# config/config.exs
config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  themes: [:neo],
  modes: [:light, :dark],
  scales: [],
  components: [:button, :dialog, :typo, :layout-heading],
  semantics: [:accent, :brand, :alert],
  accessibility: false
```

Add `/assets/corex/` to `.gitignore`. Do not commit the generated tree.

Optionally rebuild on every compile:

```elixir
def project do
  [
    compilers: Mix.compilers() ++ [:corex_design]
  ]
end
```

Most apps call the build from `assets.build` / `assets.deploy` instead (see Corex [Manual installation](https://hexdocs.pm/corex/manual_installation.html)).

## Build

| Command | Purpose |
|---------|---------|
| `mix corex.design.build` | Write `assets/corex/` (`corex.css`, `recipes.css`, themes, components) |
| `mix corex.design.options` | List allowed config values and your resolved config |
| `mix corex.design.validate` | Validate `config :corex_design` |

```css
@import "../corex/corex.css";
@source "../corex";
```

One consumption mode: import `corex.css`. Do not cherry-pick individual component CSS files.

### Bundle filtering

| Key | Default | Effect |
|-----|---------|--------|
| `components` | `nil` (all) | Emit only listed component CSS (deps auto-included) |
| `semantics` | `nil` (all) | Emit only listed roles (`accent`, `brand`, `alert`, `info`, `success`) |
| `themes` | `nil` (all) | Emit only listed theme CSS; map form for custom themes |
| `modes` | `[:light, :dark]` | Emit only listed color modes |
| `default_theme` | `:uno` (package fallback) | Theme used when CSS loads with no `data-theme`. `mix corex.new` scaffolds `neo` without `--theme`. |
| `default_mode` | `:light` | Build default mode |
| `accessibility` | `false` | `true` (text/focus/links), or axis list (`:text`, `:contrast`, `:motion`, `:cursor`, `:focus`, `:links`) |

```elixir
components: ~w(button dialog accordion typo layout-heading)a,
semantics: ~w(accent brand alert)a,
themes: ~w(neo uno)a,
modes: [:light],
accessibility: [:text, :focus, :links]
```

Motion and contrast prefer OS media queries (`prefers-reduced-motion`, `prefers-contrast`). User prefs cover text zoom, focus rings, and link underlines by default.

### Tokens

Public color names (authoring = CSS):

- Structure: `root`, `surface`, `ui`, `ink`, `ink-muted`, `link`, `border`, `focus`, `shadow`
- Roles: `accent`, `brand`, `alert`, `info`, `success` (+ `-hover`/`-active`/`-muted`/`-contrast`/`-text`)

Themes use perceptual color seeds and contrast-aware roles. Custom themes author `seeds` plus per-mode token defs. See the built-in theme presets and the [Theming](https://hexdocs.pm/corex/theming.html) guide.

### Scales

```elixir
scales: [
  space: [md: 4],
  size: [md: 11],
  text: [md: 1.05],
  radius: [md: 0.5],
  weight: [normal: 450]
]
```

### Host class opt-in

Design styles apply only when the host carries the component class:

```heex
<.accordion class="accordion ui-accent">...</.accordion>
<.accordion class="my-accordion">...</.accordion>
```

Omit the component class for a fully custom instance.

## Next steps

- [Design](https://hexdocs.pm/corex/design.html) / [Modifiers](https://hexdocs.pm/corex/modifiers.html) / [Theming](https://hexdocs.pm/corex/theming.html)
- [Updating Corex](https://hexdocs.pm/corex/update.html) migrate from 0.1.x
- [corex](https://hexdocs.pm/corex) / [corex_mcp](https://hexdocs.pm/corex_mcp) / [corex_new](https://hex.pm/packages/corex_new)
