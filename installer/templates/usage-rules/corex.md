# Corex stack

- **Components:** `use Corex` in `*_web.ex` imports Corex components. Use `<.heroicon>`, `<.select>`, `<.toggle_group>`, `<.toast_group>`, `<.toast_client_error>`, `<.toast_server_error>`, `<.dialog>`, `<.native_input>`, `<.checkbox>`, `<.action>`, `<.navigate>` and other Corex components instead of custom CoreComponents.
- **Buttons and links:** Use `<.action>` for buttons (actions and submit); use `<.navigate>` for links (navigation, href, patch). Do not use raw `<button>` or `<.button>` for in-page actions.
- **Layout:** Use `<Layouts.app flash={@flash} ...>`; pass `current_scope` when using authenticated or `live_session` routes.
- **Design tokens:** When design is enabled, styling uses Corex tokens and `assets/corex` (themes, typo, layout, button, etc.). Do not remove or bypass Corex CSS imports in `app.css` unless the project was generated with `--no-design`.
- **Flash / toasts:** Flash is rendered by the layout (e.g. `<.toast_group>`). Use `put_flash` in the socket and Corex toast components for errors and reconnection.
