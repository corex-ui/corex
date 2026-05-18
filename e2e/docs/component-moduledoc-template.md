# Corex component @moduledoc (convention)

Reference implementation: `Corex.Accordion` in [`lib/components/accordion.ex`](../../lib/components/accordion.ex). E2e demos must stay in sync: [`e2e/lib/e2e_web/demos/<component>_demo.ex`](../lib/e2e_web/demos/) `*_code` / `*_elixir` strings match the same section in moduledoc.

## Voice

Use second person and short imperatives: add an `id`, call `set_value`, listen in `handle_event`. Keep **API** and **Events** as separate H2 sections on each component instead of repeating `respond_to` or three-way client/server tables at module level.

## Section order

H2 blocks in this order when the component needs them (see [`beta-page-matrix.md`](beta-page-matrix.md)): **Anatomy**, **API**, **Events**, **Patterns**, **Animation**, **Style**, **Form**. Omit empty sections.

Do not merge API and Events into one H2.

## Copy-ready examples

Every HEEx, Elixir, or JS block in moduledoc must compile if pasted into a LiveView (or run in the browser for client listeners).

- Inline full data: `Corex.Content.new([...])`, `Corex.List.new([...])` — no `items={...}`, no `@items` without showing the assign in the same or preceding block.
- Always `class="<root>"` (e.g. `accordion`, `checkbox`, `listbox`).
- Stable `id="..."` when the component or API requires it.
- Prefer **three** list/content items unless the demo needs more (stream add-item flows).
- Reuse canonical data from [`E2eWeb.Demos.DocExamples`](../lib/e2e_web/demos/doc_examples.ex) in demos; **inline the same literals** in moduledoc so Hexdocs readers do not depend on e2e.

Anti-patterns to fix: ellipsis (`...`) anywhere in examples, abbreviated slots, moduledoc vs e2e mismatch for the same tab, wrapping copy-paste blocks in `<Layouts.app>` (use only the minimal HEEx the example needs; layout shells belong on e2e pages, not in `*_demo.ex` / moduledoc tabs). Support modules under `lib/corex/` follow the same rule: every HEEx example must be complete and copy-paste ready.

## Anatomy

- Preamble: one paragraph plus Zag link (Zag components).
- Use **## Anatomy**, not **## Examples**.
- `<!-- tabs-open -->` … `<!-- tabs-close -->` when multiple `###` variants; each tab is an h3 (`### Minimal`, etc.). Max ~6 tabs unless necessary.
- **Item fields** subsection only for `items={Content.new(...)}` list-driven anatomy.
- Full component markup per tab.

## API

- Short intro (stable `id` when required).
- One table: `Function | Action | Returns` with links to `function/N`.
- No per-function prose at module level. Read-helper reply tables live on function `@doc` only.

## Events

- **Only** `on_*` interaction events.
- **Server events** table: `Event | When | Payload`.
- **Client events** table: `Event | When | event.detail` (or documented shape).
- Optional `<!-- tabs-open -->` with one `### on_*` tab per event (full HEEx + handler or listener).
- No read-helper replies here (those belong on API functions).

## Patterns

- Short intro per pattern; `<!-- tabs-open -->` when multiple (Async, Controlled, Stream, …).
- Full LiveView modules or minimal complete fragments; same data shapes as Anatomy.

## Animation

Only when the matrix lists Animation (accordion, dialog, tree-view). Tabs: **JS**, **Instant**, **Custom** (h3).

## Style

- Heading **## Style** (not Styling).
- `data-scope` / `data-part` selectors, CSS imports, one line on stacking modifiers on the host.
- `<!-- tabs-open -->` for modifier axes from `priv/design/corex/components/<name>.css`: **Color**, **Size**, **Text**, **Rounded**, **Max width** when used.
- Each tab: table `Modifier | Classes` (e.g. `accordion accordion--accent`).
- `max-w-*` on host where templates use Tailwind width — no extra explanation.

## Form

Top-level **## Form** for form components; do not merge into Anatomy.

- When the component has a `slot :error`, every Form example must include `<:error :let={msg}>` (match checkbox: heroicon + message).
- `invalid` is **opt-in**: do not rely on the field clause to set it. Show `invalid` only in a dedicated “Invalid” anatomy tab or an example explicitly labeled for invalid styling (e.g. `invalid={@form[:field].errors != []}` after `used_input?`).
- Field clause maps `field.errors` to `@errors` when `Phoenix.Component.used_input?(field)`; error text can render without `invalid={true}`.

## Translation modules

Components with a `translation` assign expose `Corex.<Component>.Translation` (see ExDoc for that module).

- **Module `@moduledoc`** — table `Field | Default | Used for` (same style as the API section).
- **Callers** pass a partial struct only: `translation={%Corex.MyComponent.Translation{placeholder: gettext("…")}}`.
- **Component render path** merges with gettext defaults internally (`Translation.resolve/1` is `@doc false`).

```elixir
translation = Translation.resolve(assigns.translation)
```

Do not hardcode English in `defstruct` defaults or inline `%Translation{...}` without gettext in the render function.

## `attr` / `slot` documentation (code)

- One line per `doc:` when possible.
- Reuse assign wording from existing components (`id`, `class`, `controlled`, `value`, `field`, `on_*`, `rest`).

## Shared demo data

[`doc_examples.ex`](../lib/e2e_web/demos/doc_examples.ex):

| Function | Use |
| -------- | --- |
| `content_items/0` | Accordion, collapsible, content-driven patterns |
| `content_items_with_meta/0` | Custom slots with `meta` |
| `list_items/0` | Listbox, select, combobox, menu |
| `radio_items/0` | Radio group |
| `list_items_grouped/0` | Grouped listbox/select |
| `pagination_defaults/0` | Pagination controlled examples |

## Per-component workflow

1. Matrix row → allowed H2 sections.
2. `priv/design/corex/components/<name>.css` → Style tabs.
3. Restructure `@moduledoc` in `lib/components/<component>.ex`.
4. Update `e2e/.../demos/<component>_demo.ex` for the same sections.
5. `mix compile` + `mix docs`.
