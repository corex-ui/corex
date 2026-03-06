# Phoenix

- **Router:** Scopes, `live_session`, `pipe_through :browser`, aliasing (e.g. `scope "/", AppWeb`).
- **LiveView:** Wrap with `<Layouts.app>`, pass `current_scope` when required; `<.flash_group>` only in Layouts; use `push_navigate` / `push_patch` and `<.link navigate={}>` / `patch={}`.
- **Endpoint:** Request pipeline; no `Phoenix.View` (use components/HEEx).
- **Forms:** `to_form/2`, `<.form for={@form}>`, `@form[:field]`; do not expose raw changesets in templates.
