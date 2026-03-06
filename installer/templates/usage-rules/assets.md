# Assets

- **Tailwind v4:** `@import "tailwindcss" source(none);` and `@source` for content; no `tailwind.config.js`. When design is enabled, keep Corex `@import "../corex/..."` in `app.css`.
- No `@apply` in custom CSS; no inline `<script>` in templates; only `app.js` and `app.css` as entrypoints unless documented.
- Use Corex components and design tokens for consistency; prefer Tailwind utilities and Corex for layout and components.
