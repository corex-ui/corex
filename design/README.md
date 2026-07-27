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
| `default_theme` | `:uno` (package fallback) | Build default theme id. `mix corex.new` scaffolds `neo` without `--theme`. |
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

Color math uses the Color package directly (Oklch lightness + `Color.Palette.contrast`). Custom themes author `seeds` plus per-mode token defs (`{:l, …}` / `{:contrast, …}`). See `Corex.Design.Theme.Presets`.

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
