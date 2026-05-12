# Corex API and event naming (e2e + hooks)

This document aligns LiveView `handle_event/3`, HEEx `on_*` assigns, client hooks, and pushed payloads. Details live next to each component in `lib/components` and `assets/hooks`.

## E2E demo page titles and playgrounds

- **Page titles**  -  `ComponentName · Type` (middle dot `·`). Examples: `Checkbox · Playground`, `Listbox · API`. See `E2eWeb.DemoPage` in `e2e/lib/e2e_web/components/demo_page.ex` for the full suffix list.
- **Subtitles**  -  omit on new pages unless there is a one-line product note. No tutorial copy in `demo_page` or `demo_section`.
- **Playgrounds**  -  render with **`<.demo_playground>`** (sidebar + canvas). **Direction** (LTR/RTL) uses **`<.playground_dir_toggle>`** and appears **first** in the control strip when the component supports `dir`. Other controls follow: other `toggle_group` axes, then `select`, then `switch`, as applicable.

## Server

- **`handle_event`**  -  snake_case event name string; for API demos prefer a clear prefix such as `api_*` where it matches `E2eWeb.Demos.*` snippets.
- **HEEx `on_*`**  -  kebab-case attribute names on components map to machine events (see each component’s `attr` list). Values are the event name string passed to `phx-click` / `phx-change` wiring through Corex connect helpers.
- **`push_event`**  -  use a stable JSON map; include **`"id"`** (or the component-specific id field documented on the hook) whenever the client must filter to one instance.

## Client hooks

- **`readPayloadId` / `idMatches`**  -  from `assets/lib/respond-to.ts`; use for every `window.addEventListener("phx:…")` handler so only the targeted DOM node runs when multiple instances exist on the page.
- **`notifyChange`**  -  use for forwarding user-driven updates to LiveView with the payload shape expected by the matching `handle_event` clause.
- **Custom DOM events**  -  prefer the `corex:*` family dispatched by shared helpers in `assets/hooks/corex.ts` where applicable; keep names aligned with Phoenix `@doc` on the component.

## Verified grep

- After renames, search the e2e app for stale imperative **`phx-*`** usage on Corex-controlled surfaces and fix in favor of documented `on_*` / `Corex.*` APIs.
