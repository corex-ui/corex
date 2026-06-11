# Changelog

## 0.2.0

### `corex_design` on Hex

The design pipeline ships as a separate package, `{:corex_design, "~> 0.2"}`, published from `design/` in this repository. It depends on `{:corex, "~> 0.2"}`. Monorepo development keeps `path: ".."`; Hex publish sets `COREX_DESIGN_PUBLISH=1` (see `design/README.md`).

### Elixir design pipeline (design-only)

The design system has a compile-time Elixir pipeline that replaces the
Node/Style-Dictionary build for the default path.

- **Token engine** (`Corex.Design.Tokens.Colors`, `Corex.Design.Emit.Tokens`):
  OKLCH color generation and dimension scales from host theme config for every
  theme (neo, uno, duo, leo) and mode. Pure Elixir; no Node required for the
  default build.
- **Recipe engine** (`Corex.Design.Recipe`): recipe DSL (`base`, `variants`,
  `compound_variants`) compiled to CSS via `Corex.Design.Emit.SxRecipe` and
  `Corex.Design.Emit.TailwindRecipe`.
- **Compiler** (`Mix.Tasks.Compile.CorexDesign`): writes the Tailwind bundle
  under `assets/css/` (`corex.tailwind.css`, `layers/`, `recipes/`,
  `aggregates/`).
- **Layout patterns**: `box`, `stack`, `row`, `grid`, `container`, `spacer`,
  `divider` Phoenix components with BEM modifiers on `class`.

### Dumb components (`Corex.Bem.Variants`)

Components carry no runtime style engine: they merge BEM modifiers into `class`
and forward caller classes. Styling lives in optional `:corex_design` stylesheets.

- **`Corex.Bem.Variants`**: declares style axes per component; generates `attr/3`
  and `corex_style_class/1` (BEM class passthrough). Kinds: `:component`, `:layout`,
  `:polymorphic`.
- BEM emit is off by default. Set `config :corex, emit_style_classes: true` for
  headless apps, or configure `config :corex, Corex.Design` for automatic emit
  with Corex Design.
- `<.action semantic="accent" size="lg">` merges `button button--semantic-accent button--size-lg`
  on `class`. Generated CSS targets the same BEM selectors.
- **Theme validation**: `mix corex.design.validate` checks theme config via
  NimbleOptions schemas.
- **Recipe listing**: `mix corex.design.list` prints recipe ids for
  `include_recipes`.
- **Template lint**: `mix corex.design.lint` checks HEEx style literals against
  exported design vocabulary.

### Breaking

- **Semantic tokens aligned with axis values:** `neutral` and `selected` roles and
  `--color-neutral-*` / `--color-selected-*` tokens are removed. Use `base` and
  `--color-base-*` instead. Open, selected, and checked UI follows the host
  `semantic` role (`base` when unset).
- **Size vs text axes (accordion pilot):** `size` is spacing and control geometry
  only; `text` sets typography on trigger, indicator, and content. They no longer
  share font scale.
- **Removed `mix corex.design`** (copy task) and the hand-authored `priv/design/`
  tree from the `:corex` package. Per-component vendoring into `assets/corex/` is
  no longer supported.
- **Migration:** add `{:corex_design, "~> 0.2"}`, register the `:corex_design`
  compiler, set `config :corex, Corex.Design, output: "assets/css/corex.tailwind.css", ...`,
  run `mix compile`, and replace per-component
  `@import "../corex/components/..."` lines with `@import "./corex.tailwind.css";`
  in `app.css`. The legacy `config :corex_design` namespace is not supported.
- New apps with `--theme` wire `:corex_design`, the compiler, and CSS imports via
  the installer.
## 0.1.1

### Bug fixes

- [menu] Fix submenu leaks and LiveView drift on open menus ([#58](https://github.com/corex-ui/corex/issues/58))
- [menu] Scope server `set_open/3` to the targeted menu
- [combobox] Preserve custom item slots after LiveView updates
- [toast] Sanitize action URLs
- [data-table] Harden sort and selection params
- [pagination] Validate page URLs
- [redirect] Validate redirect schemes
- [date-picker] Reduce unnecessary re-renders

### Enhancements

- [menu] Item and trigger layout aligned with select, combobox, and listbox
- [combobox] Default `close_on_select` to `true`
- [docs] Restore `mix corex.new` on Hexdocs
- [mcp] Security hardening

## 0.1.0

Initial Corex stable release.
