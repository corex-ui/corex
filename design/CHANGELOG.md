# Changelog

## 0.2.0

Initial Hex release of the Elixir design pipeline (previously shipped inside the Corex monorepo only).

### Breaking changes

- Removed accessibility levels, contrast reports, and `mix corex.design.report`.
- Removed `:extends` from host theme specs; use `Corex.Design.Theme.merge_specs/2` to customize presets.
- Ink and semantic contrast now uses each role's `ratio` field only (still via the `color` dependency).
- Theme color fills use `Color.Palette.tonal/2` stops (`stop`, optional `states`) instead of manual `lightness` percentages and global offset/ratio-base knobs.

- Token engine (`Corex.Design.Tokens`, `Corex.Design.Emit`) for OKLCH colors and dimension scales from theme config.
- Recipe engine (`Corex.Design.Recipe`, `Corex.Design.Recipes`) compiling BEM modifiers and Tailwind `@utility` axes.
- `:corex_design` compiler (`Mix.Tasks.Compile.CorexDesign`) writing `corex.tailwind.css` and modular `layers/` / `recipes/` output.
- Mix tasks: `corex.design.validate`, `corex.design.list`, `corex.design.build`, `corex.design.tailwind`.
- Requires `{:corex, "~> 0.2"}` and OTP 27+.
