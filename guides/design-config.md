# Design config

Configure how Corex Design generates CSS: theme colors, spacing, radii, which recipes to emit, and token aliases.

Register the `:corex_design` compiler in `mix.exs`, set `config :corex, Corex.Design`, then run `mix compile`.

Requires **OTP 27+** (stdlib `:json`, used by the `color` dependency). Elixir **1.18+** is recommended.

Phoenix apps (from `mix corex.new`):

```elixir
compilers: [:phoenix_live_view] ++ Mix.compilers() ++ [:corex_design]
```

Other apps:

```elixir
compilers: Mix.compilers() ++ [:corex_design]
```

Validate without a full CSS rebuild:

```shell
mix corex.design.validate
mix corex.design.lint
```

Export resolved config for tooling:

```shell
mix corex.design.config
mix corex.design.config --output /tmp/corex-design.json
```

Set `output: "assets/css/corex.tailwind.css"` and import `@import "./corex.tailwind.css";` in `app.css`.

`:corex` components turn style attrs into BEM classes mechanically (no defaults: omitted attrs emit no modifiers). `:corex_design` merges recipe `default_variants` into base CSS so bare block classes still look styled. Theme plugs read `Corex.Design.Theme` at runtime.

Registry id vs recipe filename: `action` → `button.css`, `navigate` → `link.css`. Recipe splits (`dialog_modal`, `dialog_side`, `tree_navigation`) emit as separate files under `recipes/`.

## Config map

| Key | Required | Default | Purpose |
| --- | --- | --- | --- |
| `:output` | yes | — | Generated CSS path for the compiler |
| `:default_theme` | no | `:neo` | HTML `data-theme` default |
| `:default_mode` | no | `:light` | HTML `data-mode` default |
| `:themes` | no | all presets | Preset id list or full theme catalog map |
| `:scales` | no | built-in defaults | Per-axis replacement: step lists or `[step: value]` keyword lists |
| `:recipes` | no | all / `[]` sources | `include:` allowlist, `sources:` host modules |
| `:aliases` | no | `%{}` | Semantic role aliases for token resolution |

Component roles for `semantic=` in theme specs use `roles` keys with `component: true`.

`:corex` does not validate style attrs at render time. BEM modifiers emit when `config :corex, Corex.Design` is set, or when you opt in with `emit_style_classes: true` on headless apps.

## Minimal styled app

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css"
```

Omit optional keys to use built-in neo, uno, duo, and leo presets with light/dark modes. See [Theming](theming.html).

## Full reference (styled Phoenix app)

```elixir
import Config

config :corex,
  debug: false,
  mcp_verbose_errors: false,
  generators: [
    gettext: :sigils,
    layout: [theme: true, mode: true, locale: true]
  ]

config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css",
  default_theme: :neo,
  default_mode: :light,
  themes: ~w(neo uno duo leo)a,

  scales: %{
    size: [sm: 0.5, md: 1.0, lg: 1.5, xl: 2.0],
    text: [xs: 0.75, sm: 0.875, base: 1.0, lg: 1.125, xl: 1.25, "2xl": 1.5],
    radius: [none: 0, sm: 0.25, md: 0.375, lg: 0.5, full: 9999],
    weight: [normal: 400, medium: 500, bold: 700],
    visual: [:solid, :ghost, :outline, :subtle],
    shape: [:auto, :square, :circle],
    space: [sm: 2, md: 3, lg: 4, xl: 5],
    semantic: [:base, :accent, :brand, :alert, :info, :success]
  },

  recipes: [
    include: nil,
    sources: []
  ],

  aliases: %{}
```

## Themes

| Form | Example | Behavior |
| --- | --- | --- |
| Omitted | — | All built-in presets (neo, uno, duo, leo) |
| List | `themes: ~w(neo leo)a` | Subset of built-in presets (smaller CSS + picker) |
| Map | `themes: %{custom: spec, neo: Presets.neo()}` | Full catalog with custom specs |

Built-in presets: `Corex.Design.Theme.Presets.neo/0`, `uno/0`, `duo/0`, `leo/0`.

## Theme schema

Each theme spec:

```elixir
%{
  palette: %{base: "#F0F0F0", accent: "#4B4B4B", ...},
  colors: %{
    light: %{
      surface: %{page: %{...}, raised: %{...}, control: %{...}},
      roles: %{accent: %{palette: :accent, lightness: 40, component: true}, ...},
      on: %{page: %{palette: :base, against: :page, ratio: 8}, ...},
      border: %{palette: :base, against: :control, ratio: 1.12},
      focus: %{palette: :base, against: :control, ratio: 2.2},
      shadow: %{palette: :base, against: :page, ratio: 1.05}
    },
    dark: %{...}
  },
  dimensions: %{space_scale: 1.0, size_scale: 1.0, ...}
}
```

CSS variables use Tailwind v4 namespaces: `--spacing-md`, `--color-surface-page`, `--color-on-page`, `--color-accent`, `--color-border`, `--color-focus`.

## Custom theme

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css",
  default_theme: :custom,
  default_mode: :light,
  themes: %{
    neo: Corex.Design.Theme.Presets.neo(),
    uno: Corex.Design.Theme.Presets.uno(),
    duo: Corex.Design.Theme.Presets.duo(),
    leo: Corex.Design.Theme.Presets.leo(),
    custom:
      Corex.Design.Theme.merge_specs(Corex.Design.Theme.Presets.neo(), %{
        palette: %{brand: "#E11D48"},
        colors: %{
          light: %{
            roles: %{
              brand: %{
                palette: :brand,
                lightness: 40,
                states: %{muted: 43, default: 40, hover: 36, active: 33},
                component: true
              }
            }
          },
          dark: %{}
        },
        dimensions: %{radius_scale: 1.2}
      })
  }
```

Tier 1 customization: edit `palette` and `dimensions` only; inherit surface, roles, on, and structural tokens from the merged preset.

## Scales

`scales:` under `config :corex, Corex.Design` replaces each axis you list:

- **Dimension axes** (`size`, `radius`, `text`, `weight`, `space`, …): keyword list `[step: value]` or a step name list (values fall back to built-in numerics for listed steps).
- **`semantic`**: atom list of theme role names (`[:accent, :brand, …]`).

Omitted axes keep built-in defaults. Full replacement per axis when provided; adapt theme presets if custom steps break preset dimension maps.

After changing `scales:` or `themes:`, run `mix corex.design.validate` to check design config.

## Recipe overrides

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css",
  recipes: [
    sources: [MyApp.DesignRecipes]
  ]
```

Host modules implement `Corex.Design.RecipeSource` and return recipe structs. Built-in recipes with the same `:id` are replaced in place.

## Smaller CSS bundles

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css",
  recipes: [
    include: ~w(button accordion select)a
  ]
```

Only listed recipe ids are written to `assets/css/recipes/`.
