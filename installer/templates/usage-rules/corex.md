# Corex stack

- **Components:** `use Corex` in `*_web.ex` imports Corex components. Use `<.heroicon>`, `<.select>`, `<.toggle_group>`, `<.toast_group>`, `<.toast_client_error>`, `<.toast_server_error>`, `<.dialog>`, `<.native_input>`, `<.checkbox>`, `<.button>` and other Corex components instead of custom CoreComponents.
- **Layout:** Use `<Layouts.app flash={@flash} ...>`; pass `current_scope` when using authenticated or `live_session` routes.
- **Design tokens:** When design is enabled, styling uses Corex tokens and `assets/corex` (themes, typo, layout, button, etc.). Do not remove or bypass Corex CSS imports in `app.css` unless the project was generated with `--no-design`.
- **Flash / toasts:** Flash is rendered by the layout (e.g. `<.toast_group>`). Use `put_flash` in the socket and Corex toast components for errors and reconnection.
