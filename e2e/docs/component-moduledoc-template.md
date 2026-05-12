# Corex component @moduledoc (convention)

## Voice

Use second person and short imperatives: add an `id`, call `set_value`, listen in `handle_event`. Prefer one idea per sentence. Link cross-cutting behavior to [API](api.html) and [Events](events.html) instead of repeating `respond_to` or three-way client/server tables.

## Section order

H2 blocks in this order when the component needs them: **Anatomy**, **API**, **Events**, **Patterns**, **Style**, **Form**. Omit empty sections. Optional **Animation** as its own H2 when a component has distinct animation modes.

Do not merge API and Events into one H2; they map to the package guides.

## Anatomy

- Preamble: one paragraph plus an upstream Zag link.
- Avoid a redundant feature list that mirrors ExDoc nav.
- Prefer **## Anatomy** over **## Examples** so every component uses the same heading.
- **Tab UI** (`<!-- tabs-open -->` … `<!-- tabs-close -->`): only where multiple `###` panes under Anatomy (or one pair under Compound) reduce noise. Each tab is a `###` heading. Do not wrap **## Patterns** or **## Animation** in tab markers.
- **Item map / list-driven fields**: under Anatomy, subsection **Item fields**, for `items={Content.new(...)}` only, not Manual or Compound.
- Keep Anatomy copy lean: at most **six** tab panes unless the component truly needs more; otherwise use Patterns for edge cases.

## API and Events

- **## API**: one short paragraph, link `api.html`, then a **small** table or list: Elixir helpers, DOM `CustomEvent` command types (if any), and when an `id` is required. One minimal HEEx example that shows server vs `phx-click` vs client is enough; do not paste the same `items={...}` block for every variant.
- **## Events**: link `events.html`, then `on_*`, `*_client`, and hook response names with payload keys for **this** component only.

## Form

Phoenix form integration uses a top-level **## Form** when present. MCP may expose a `form` scope when the registry lists it.

## `attr` / `slot` documentation (code)

- One line per `doc:` when possible. ExDoc renders these in the Attributes list; avoid multi-paragraph `doc:` strings.
- Common assign wording (reuse verbatim where it fits):
  - **`id`**: DOM id for the component root; required for imperative API and DOM commands (see [API](api.html)).
  - **`class`**: HTML class; use with Corex design modifier classes when you import design CSS.
  - **`controlled`**: LiveView owns the value; pair with `on_*` handlers as in [Events](events.html).
  - **`value`**: Current or initial value; shape depends on the component.
  - **`field`**: Phoenix form field from `Phoenix.Component.to_form/2`; see **## Form** when documented.
  - **Event assigns** (`on_value_change`, etc.): LiveView event name for `pushEvent`; params documented under **## Events**.
  - **`rest` (`:global`)**: Forwarded to the root element; see [Phoenix.Component attributes](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#module-attributes) (global HTML attributes, `phx-*`, LiveView bindings).

See `Corex.Accordion` and `Corex.AngleSlider` in `lib/components/` for reference layouts.
