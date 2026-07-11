# Corex Design

Optional config-driven token generation and static component CSS for Corex.

## Usage

Add `corex_design` as a build-time dependency, configure tokens, and build:

```elixir
# mix.exs
{:corex_design, "~> 0.2", runtime: false}
```

```elixir
config :corex_design,
  output: "assets/corex",
  default_theme: :neo,
  default_mode: :light,
  themes: nil,
  scales: [],
  components: nil,
  semantics: nil,
  variants: nil
```

`mix corex.design.build` writes `assets/corex/components.css`, a generated entry that `@import`s only the component recipes declared in `components:` (plus transitive deps such as `scrollbar` for `combobox`). Import that single file from `app.css`:

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components.css";
```

### Bundle filtering

| Key | Default | Effect |
|-----|---------|--------|
| `components` | `nil` (all) | Emit only listed `components/<id>.css` files |
| `semantics` | `nil` (all) | Emit only listed role color/ink tokens; trim semantic BEM utilities (`base` always included) |
| `variants` | `nil` (all) | Keep only `solid`, `ghost`, `outline` variant utilities (`subtle` is default anatomy) |

```elixir
components: ~w(button dialog accordion typo layout-heading)a,
semantics: ~w(accent brand alert)a,
variants: ~w(solid ghost outline)a
```

Legacy `scales: [semantic: ...]` is still read when `semantics:` is omitted; prefer `semantics:` for new apps.

```bash
mix corex.design.build
```

Generated apps from `mix corex.new` include the `corex_design` dependency and run `mix corex.design.build` into `assets/corex/`.

## Modifiers

Component CSS uses flat BEM modifiers only:

- **Semantic**: `accordion--accent`, `button--brand`
- **Size**: `button--lg`, `accordion--sm`
- **Radius**: `button--rounded-lg`, `dialog--rounded-xl`

Use Tailwind utilities for layout and sizing (`max-w-md`, `flex`, `gap-4`).

See [guides/modifiers.md](guides/modifiers.md) for the full modifier reference.

## Scale policy

### Host-configurable (`scales:`)

Override built-in step values per axis. Keys use config names; `space` maps to internal density.

```elixir
scales: [
  space: [md: 4],
  size: [md: 11],
  text: [md: 1.05],
  radius: [md: 0.5],
  weight: [normal: 450],
  semantic: ~w(accent brand alert info success)a
]
```

`scales:` overrides numeric step values for built-in size, space, text, radius, and weight axes. Prefer top-level `semantics:` to filter palette roles (see Bundle filtering above). Legacy `scales: [semantic: ...]` is an alias when `semantics:` is omitted.

These axes drive emitted theme CSS (`--theme-spacing-*`, `--theme-text-*`, `--theme-radius-*`, `--theme-font-weight-*`) and BEM size/radius modifiers.

### Per-theme multipliers (presets)

Theme presets scale fixed base ladders via `dimensions` in each preset:

- `space_scale`, `size_scale`, `text_scale`, `radius_scale` multiply token axes above
- `container_scale` scales the container width ladder
- `shadow_scale` scales shadow blur/spread templates

Font stacks are overridden per theme via preset `typography`, not via `scales:`.

### Fixed utility catalogs

Leading, tracking, shadows, blur, ease, animate, and breakpoints are fixed in `Corex.Design.Tokens.Scales`. They are Tailwind-adjacent namespaces, not part of the modifier model or `scales:` config.

If you override `scales: [text: ...]`, line-height tokens (`text_leading`) stay tied to the default text ladder until derived in a future release.

## Color generation

Token colors are generated with the [`color`](https://hex.pm/packages/color) hex package (OKLCH tonal scales and WCAG contrast solving).

Semantic ink for text and rings on neutral surfaces uses `--color-ink-{semantic}` (recipe wildcard `--color-ink-*`). Filled controls pair `--color-{semantic}` backgrounds with `--color-{semantic}-ink` text (wildcard `--color-*-ink`). Legacy bare `--color-{semantic}-ink` names remain as aliases in generated theme CSS only.

## Token layers

Theme color values are generated into `priv/css/tokens/themes/{theme}/color/{mode}.css` as runtime `--color-*` custom properties on `[data-theme][data-mode]`. Set both attributes on `<html>`. A single generated `tokens/semantic/color.css` registers the Tailwind `@theme inline` bridge. Deprecated `--theme-color-*` names alias back to `--color-*` for one release.

Maintainers regenerate theme token files with `mix bundle.build` in this package (updates `priv/css/tokens/themes/`). Verify component CSS in e2e with `cd e2e && mix assets.build`.
