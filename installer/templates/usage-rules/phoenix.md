# Phoenix and LiveView

Phoenix routing, LiveView, streams, forms, and HEEx. Corex-specific overlays included.

## Router

- Scopes with alias: `scope "/admin", AppWeb.Admin do ...` → `Admin.UserLive`.
- `live_session` for shared assigns (e.g. `current_user`, `current_scope`).
- `pipe_through :browser` for HTML routes.
- Use verified routes: `~p"/users/#{user}"` instead of string interpolation.
- Do not create extra aliases for routes; the scope alias applies.

## Request flow

- Endpoint → Router → Controller or LiveView. No `Phoenix.View`; use HEEx/function components.

## LiveView

- LiveView modules: `AppWeb.UserLive`, `AppWeb.Admin.ProductLive` (suffix `Live`).
- **Always** wrap content with `<Layouts.app flash={@flash} ...>` and pass required assigns (`current_scope` when using `live_session` with authenticated routes).
- `current_scope` errors: fix by passing `current_scope` to Layouts and placing routes in the correct `live_session`.
- Use `push_navigate` and `push_patch`; use `<.link navigate={}>` and `<.link patch={}>` (or Corex `<.navigate>`).
- Never use deprecated `live_redirect`/`live_patch`.
- Avoid LiveComponents unless there is a clear need.
- `<.flash_group>` (or Corex `<.toast_group>`) only in Layouts.

## LiveView streams

- Use streams for large collections to avoid memory issues.
- `stream(socket, :items, items)`, `stream(socket, :items, items, reset: true)`, `stream_insert`, `stream_delete`.
- Template: `phx-update="stream"` and `id` on container; iterate `@streams.items` as `{id, item}`.
- Streams are not enumerable; refetch and re-stream with `reset: true` to filter.
- Track counts/empty state in separate assigns.
- Never use `phx-update="append"` or `"prepend"`.

## Forms

- Use `to_form/2` from changesets or params; never expose raw changesets in templates.
- Template: `<.form for={@form} id="unique-id" phx-change="validate" phx-submit="save">`, then `@form[:field]`.
- Never use `<.form let={f}>`; always `<.form for={@form}>`.
- Always use a unique DOM id for forms.

## HEEx

- Use `~H` or `.html.heex`; never `~E`.
- Class: use list syntax `class={["base", @flag && "extra"]}`.
- No `if/else if`; use `cond` or `case`.
- Use `phx-no-curly-interpolation` for literal `{` `}` in code blocks.
- Use `<%= for x <- @list do %>`; never `Enum.each` for rendering.
- HEEx comments: `<%!-- --%>`.
