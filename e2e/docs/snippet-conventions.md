# Snippet conventions (e2e code tabs + Hex moduledoc)

User-facing strings (`*_code`, `*_heex`, `events_*`, `api_*`) must be copy-paste ready outside the e2e app.

## Component classes

On the host, use the base class plus Corex BEM modifiers only:

```heex
<.checkbox class="checkbox checkbox--accent" />
<.carousel class="carousel carousel--accent carousel--rounded-xl" />
```

Omit `id` on the component in snippets unless the example is API or client-event wiring (`getElementById`, `Corex.Component.set_*`). E2e previews keep `id` in `*_example` for tests only.

Allowed on related primitives in slots when needed: `class="icon"` on `<.heroicon>`, `class="button button--sm"` on `<.action>`.

## Forbidden in snippets

Layout Tailwind on wrapper elements:

- `class="flex flex-col gap-2"` on `<motion.div>` or `<form>`
- `class="layout__row"`, `w-full` on forms used only for demo layout
- Extra wrappers whose only job is page layout

Put layout in `*_example` functions and LiveView previews only.

## Data and routes

- Inline `Corex.List.new([...])`, `Corex.Content.new([...])`, `Corex.Image.new("/images/beach.jpg", alt: "...")`
- Not `E2eWeb.Demos.*.gallery_images()` or `basic_items()`
- Routes in generic Hex snippets: `to="#"`, `action="/your/path"`, `src="/images/avatar.png"`
- E2e controller form previews and their doc snippets (routes under `/:locale`): `action={~p"/component/form"}`

## Elixir event handlers

```elixir
def handle_event("event_name", params, socket) do
  IO.inspect(params, label: "event_name")
  {:noreply, socket}
end
```

Use `E2eWeb.Demos.DocExamples.event_handler_snippet/2` for consistency.

## JavaScript vs TypeScript

- JS: `const el = document.getElementById(...)` and untyped listeners
- TS: `const el: HTMLElement | null`, `(event: Event)`, `CustomEvent<DetailType>` — never delegate TS to JS verbatim

Listener tabs use `console.log(event.detail)`. LiveView `pushEvent` belongs in colocated hooks only.

## Code tabs by page type

| Page | Tabs |
|------|------|
| Anatomy / Style | Heex |
| Events server | Heex + Elixir |
| Events client | Heex + JS + TS |
| API client binding | Heex |
| API client JS | Heex + JS + TS |
| API server | Heex + Elixir |
| Form (LiveView) | Heex + Elixir (+ File for uploads) |
| Pattern (LiveView + data) | Heex + Elixir + Data |

## Shared fragments

Prefer [`doc_examples.ex`](../lib/e2e_web/demos/doc_examples.ex) `code_*` functions for repeated item lists and event handler bodies.

## Checklist before merging

- [ ] Snippet has no `E2eWeb.`, `~p"`, `MyApp.`
- [ ] Snippet has no layout `flex` / `gap-` on wrappers
- [ ] Host has `class="<component>"` (+ modifiers if documenting style)
- [ ] JS and TS tabs differ when both exist
- [ ] Hex moduledoc matches e2e tab content for the same example
