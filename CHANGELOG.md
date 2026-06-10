# Changelog

## 0.2.0

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

### Dumb components (`Corex.Variants`)

Components carry no runtime style engine: they merge BEM modifiers into `class`
and forward caller classes. Styling lives in optional `:corex_design` stylesheets.

- **`Corex.Variants`**: declares style axes from `Corex.Scales`; generates
  `attr/3` and `corex_style_class/1` (BEM class passthrough).
  Three kinds: `:component`, `:layout`, `:appearance`.
- `<.action semantic="accent" size="lg">` merges `button button--semantic-accent button--size-lg`
  on `class`. Generated CSS targets the same BEM selectors.
- **Theme validation**: `mix corex.design.validate` checks theme config via
  NimbleOptions schemas.
- **Recipe listing**: `mix corex.design.list` prints recipe ids for
  `include_recipes`.

### Breaking

- **Removed `mix corex.design`** (copy task) and the hand-authored `priv/design/`
  tree from the `:corex` package. Per-component vendoring into `assets/corex/` is
  no longer supported.
- **Migration:** add `{:corex_design, "~> 0.2"}`, register the `:corex_design`
  compiler, set `config :corex_design` with `output: "assets/css/corex.tailwind.css"`
  on your app profile, run `mix compile`, and replace per-component
  `@import "../corex/components/..."` lines with `@import "./corex.tailwind.css";`
  in `app.css`.
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

Run `mix corex.design --force` in your app to refresh `assets/corex/` (CSS and tokens).

## 0.1.0

Initial Corex stable release.
