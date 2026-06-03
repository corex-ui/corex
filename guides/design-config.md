# Design config

Configure how Corex Design generates CSS: theme colors, spacing, radii, which recipes to emit, and per-component overrides.

Register the `:corex_design` compiler in `mix.exs`, define themes under `config :corex_design`, then run `mix compile`.

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

Axis vocabulary (`config :corex, scales` / `:semantics`) is separate; see [Unstyled](unstyled.html). Using Corex Design in templates is covered in [Styled](styled.html).

Set `output: "assets/css/corex.tailwind.css"` on your app profile and import `@import "./corex.tailwind.css";` in `app.css`. Step-by-step setup is in [Styled](styled.html).

Registry id vs recipe filename: `action` → `button.css`, `navigate` → `link.css`. Recipe splits (`dialog_modal`, `dialog_side`, `tree_navigation`) emit as separate files under `recipes/`.

## Config map

| Concern | Config | Key | Affects |
| --- | --- | --- | --- |
| Theme tokens | `:corex_design` | `:themes` | Colors, spacing, radii on `[data-theme][data-mode]` |
| Default theme/mode | `:corex_design` | `:default_theme`, `:default_mode` | Root HTML defaults |
| CSS bundle size | `:corex_design` | `:include_recipes` | Which component CSS files emit |
| Part-tree overrides | `:corex_design` | `:styles` | Global and per-id component styling |
| Recipe overrides | `:corex_design` | `:recipes` | Host modules that replace built-in CSS |
| Contrast floors | `:corex_design` | `:accessibility_level` | Ink token generation (`:a`, `:aa`, `:aaa`) |
| Output path | `:corex_design` | profile keys (e.g. `:my_app`) | `output` |

Every semantic role in `colors.light` / `colors.dark` must appear in `config :corex, semantics`.

## Built-in themes

Omit `:themes` to use neo, uno, duo, and leo presets. Set defaults:

```elixir
config :corex_design,
  default_theme: :neo,
  default_mode: :light
```

Keep `config :my_app, :themes` (picker ids) aligned with the keys in `:themes`. See [Theming](theming.html).

## Custom theme

```elixir
config :corex,
  semantics: ~w(accent brand alert info success selected)a

config :corex_design,
  themes: %{
    acme: %{
      extends: :neo,
      seeds: %{"brand" => "#E11D48"},
      colors: %{
        light: %{semantic: %{brand: %{bg: "brand", lightness: 42, ink: %{color: "base", ratio: 7}}}},
        dark: %{}
      },
      dimensions: %{radius_scale: 1.2, space_scale: 1.0, radius: %{md: 0.5}}
    }
  }
```

Move large theme maps to `import_config "corex_themes.exs"` if you prefer.

### Profiles and output path

Scope the path with a profile atom (used by dev watchers):

```elixir
config :corex_design,
  my_app: [output: "assets/css/corex.tailwind.css"]
```

Compile writes a modular tree next to that file: `layers/`, `recipes/{id}.css`, and a root shim you import from `app.css`. See [Styled](styled.html).

### Validation examples

Valid:

```elixir
config :corex_design,
  themes: %{
    custom: %{
      extends: :neo,
      seeds: %{"brand" => "#E11D48"},
      colors: %{light: %{semantic: %{}}, dark: %{semantic: %{}}}
    }
  }
```

Invalid seed hex (`"not-a-color"`) or an unknown semantic role (not in `config :corex, semantics`) fails at compile time.

## Token layers at runtime

| Layer | CSS | Role |
| --- | --- | --- |
| Runtime palette | `--color-{role}`, `--color-ui-ink`, `--color-{role}-ink` on `[data-theme][data-mode]` | Fills and contrast pairs |
| Dimensions | `--space-*`, `--radius-*`, `--text-*`, `--container-*` | Spacing, type, radii |
| Part anatomy | `[data-part]`, `[data-scope]` | Stable hooks inside components for JS and scoped CSS |

Tailwind utilities such as `text-ui-ink`, `bg-layer`, `gap-space-lg`, and `rounded-xl` map to the same tokens when you `@source` the Corex tree.

### Semantic colors on components

Use the `semantic` attr (not a separate `color` attr):

```heex
<.action semantic="accent" size="lg" class="button">Save</.action>
```

Allowed values come from `config :corex, semantics`. See [Unstyled](unstyled.html).

## Part-tree styles (`:styles`)

Override component parts at compile time or per render without `<style>` tags in templates.

Precedence (low to high): built-in recipe defaults, global config, per-id config, host `semantic` / `size` axes, HEEx `style={...}` host CSS variables.

```elixir
config :corex_design,
  styles: %{
    accordion: %{
      all: %{
        item: %{indicator: %{open: [rotate: 180]}}
      },
      instances: %{
        "faq" => %{
          item: %{
            trigger: %{
              open: [color: color(:brand_ink), unset: [:background_color]]
            }
          }
        }
      }
    }
  }
```

- **`all`**: rules for every instance of that component.
- **`instances`**: string keys scoped to `#faq` / `#sidebar-nav` in compiled CSS.
- **HEEx `style`**: same nested map shape; sets `--corex-accordion-...` custom properties on the host.

```heex
<.accordion id="faq" class="accordion" semantic="brand" />

<.accordion
  id="faq"
  style={%{item: %{trigger: %{focus: [text_decoration: :underline]}}}}
/>
```

## Recipe overrides

Register a module under `:recipes` to replace or extend built-in CSS. Recipes merge by id; component anatomy and behavior stay fixed.

```elixir
defmodule MyApp.Design.Recipes do
  @behaviour Corex.Design.RecipeSource

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes.Button

  def recipes do
    [
      Button.recipe()
      |> Recipe.merge_variants(
           semantic: [brand: %{background_color: {:color, :brand}}]
         )
    ]
  end
end

config :corex_design, recipes: [MyApp.Design.Recipes]
```

For the full key reference, see `Corex.Design.Config.options_docs/0` in Hex docs.

## Accessibility and contrast reports

```elixir
config :corex_design, accessibility_level: :aa
```

Per-theme `accessibility` can override light/dark text floors. There is no runtime `data-accessibility` attribute; only `data-theme` and `data-mode` switch tokens.

Generate WCAG evidence for design reviews:

```bash
mix corex.design.report
mix corex.design.report --format json --theme neo --mode dark
mix corex.design.report --strict
```

`--strict` exits non-zero when text pairs fail (useful in CI).

## Related

- [Unstyled](unstyled.html) — axis vocabulary and `config :corex`
- [Styled](styled.html) — importing Corex Design CSS
- [Theming](theming.html) — theme picker and `data-theme`
- [Dark mode](dark_mode.html) — `data-mode`
