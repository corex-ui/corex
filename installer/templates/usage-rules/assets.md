# Corex Design System

Styling, Tailwind v4, BEM, and design tokens. Everything for consistent styling in Corex apps.

## Tailwind v4

- No `tailwind.config.js`; use `@import "tailwindcss" source(none);` and `@source` for content paths in `app.css`.
- Never use `@apply` in custom CSS.
- Do not add inline `<script>` in templates; use `app.js`/`app.css` as entrypoints.

## Corex Design (optional)

- Install with `mix corex.design` if not present.
- When enabled: import Corex CSS in `app.css`; do not remove these imports unless `--no-design`.

## BEM convention (CSS, not BEAM)

- **Critical:** BEM = Block Element Modifier (CSS). BEAM = Bogdan/Björn's Erlang Abstract Machine (Erlang VM). Do not confuse them.
- Block: base class, e.g. `button`. Element: `button__label`. Modifier: `button--accent`, `button--lg`.
- Use Corex token utilities: `w-ui`, `h-ui`, `gap-ui-gap`, `bg-ui`, `text-ui`, `text-ui--text`, `border-ui`, etc.

## data-scope and data-part

- Corex components expose `data-scope` and `data-part` for styling.
- Target in CSS: `[data-scope="native-input"][data-part="root"]`, etc.

## Component classes

- Many Corex components accept a `class` for layout/styling, e.g. `class="button button--accent button--lg"`.
