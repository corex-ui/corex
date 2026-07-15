# Corex Design

Optional config-driven tokens, themes, and component CSS for [Corex](https://hex.pm/packages/corex).

Full app wiring (html attributes, pickers, fonts, icons) lives in Corex Hexdocs: [Design](https://hexdocs.pm/corex/design.html), [Theming](https://hexdocs.pm/corex/theming.html), [Dark mode](https://hexdocs.pm/corex/dark_mode.html), [Modifiers](https://hexdocs.pm/corex/modifiers.html).

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
  themes: nil,
  scales: [],
  components: nil,
  semantics: nil
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
| `mix corex.design.build` | Write `assets/corex/` (`corex.css`, themes, components) |
| `mix corex.design.options` | List allowed config values and your resolved config |
| `mix corex.design.validate` | Validate `config :corex_design` |

```css
@import "../corex/corex.css";
@source "../corex";
```

### Bundle filtering

| Key | Default | Effect |
|-----|---------|--------|
| `components` | `nil` (all) | Emit only listed component CSS |
| `semantics` | `nil` (all) | Emit only listed palette roles (`base` always included) |
| `themes` | `nil` (all) | Emit only listed theme CSS |
| `default_theme` | `:neo` | Build default theme |
| `default_mode` | `:light` | Build default mode |

```elixir
components: ~w(button dialog accordion typo layout-heading)a,
semantics: ~w(accent brand alert)a,
themes: ~w(neo uno)a
```

Prefer top-level `semantics:` over legacy `scales: [semantic: ...]`.

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

Public keys: `space`, `size`, `text`, `radius`, `weight`.

## Modifiers

Shared host classes: `ui-accent`, `ui-solid`, `ui-size-lg`, `ui-rounded-xl`, …. Full reference: [modifiers](guides/modifiers.md).

## See also

- [Corex Design guide](https://hexdocs.pm/corex/design.html)
- [Theming](https://hexdocs.pm/corex/theming.html) / [Dark mode](https://hexdocs.pm/corex/dark_mode.html)
- [Manual installation](https://hexdocs.pm/corex/manual_installation.html)
