# Design config

Configure how Corex Design generates CSS: theme colors, spacing, radii, which recipes to emit, and token aliases.

Register the `:corex_design` compiler in `mix.exs`, set `config :corex_design`, then run `mix compile`.

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
```

After changing `scales:` or `themes:`, lint templates in CI:

```shell
mix corex.design.lint
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
| `:scales` | no | full `Corex.Scales` | Subset of built-in steps per axis (smaller CSS) |
| `:recipes` | no | all / `[]` sources | `include:` allowlist, `sources:` host modules |
| `:aliases` | no | `%{}` | Semantic role aliases for token resolution |

Component roles for `semantic=` in theme specs use `roles` keys with `component: true`.

## Minimal styled app

```elixir
config :corex_design,
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

config :corex_design,
  output: "assets/css/corex.tailwind.css",
  default_theme: :neo,
  default_mode: :light,
  themes: ~w(neo uno duo leo)a,

  scales: [
    size: ~w(sm md lg xl)a,
    text: ~w(xs sm base lg xl 2xl 3xl 4xl)a,
    radius: ~w(none xs sm md lg xl 2xl 3xl 4xl full)a,
    weight: ~w(thin extralight light normal medium semibold bold extrabold black)a,
    visual: ~w(solid ghost outline subtle)a,
    shape: ~w(auto square circle)a,
    space: ~w(none sm md lg xl)a
  ],

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
  palette: %{neutral: "#F0F0F0", accent: "#4B4B4B", ...},
  colors: %{
    light: %{
      surface: %{page: %{...}, raised: %{...}, control: %{...}},
      roles: %{accent: %{palette: :accent, lightness: 40, component: true}, ...},
      on: %{page: %{palette: :neutral, against: :page, ratio: 8}, ...},
      border: %{palette: :neutral, against: :control, ratio: 1.12},
      focus: %{palette: :neutral, against: :control, ratio: 2.2},
      shadow: %{palette: :neutral, against: :page, ratio: 1.05}
    },
    dark: %{...}
  },
  dimensions: %{space_scale: 1.0, size_scale: 1.0, ...}
}
```

CSS variables use Tailwind v4 namespaces: `--spacing-md`, `--color-surface-page`, `--color-on-page`, `--color-accent`, `--color-border`, `--color-focus`.

## Custom theme

```elixir
config :corex_design,
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

## Scales (fixed vocabulary, optional subset)

Step **names** (`sm`, `md`, `lg`, `accent`, …) are fixed in `Corex.Scales`. Components expose those values on style attrs. You cannot add or rename steps in config.

Optional `scales:` narrows which steps get token CSS and recipe variant rules (smaller bundles). Every configured step must exist in `Corex.Scales` for that axis; invalid config fails at `mix compile`.

Visual tuning (how big is `md`?) belongs in theme `dimensions`, not new step names.

After subsetting, run `mix corex.design.lint` to catch templates still using dropped steps (for example `size="xl"` when `xl` was removed from config).

## Recipe overrides

```elixir
config :corex_design,
  output: "assets/css/corex.tailwind.css",
  recipes: [
    sources: [MyApp.DesignRecipes]
  ]
```

Host modules implement `Corex.Design.RecipeSource` and return recipe structs. Built-in recipes with the same `:id` are replaced in place.

## Smaller CSS bundles

```elixir
config :corex_design,
  output: "assets/css/corex.tailwind.css",
  recipes: [
    include: ~w(button accordion select)a
  ]
```

Only listed recipe ids are written to `assets/css/recipes/`.
