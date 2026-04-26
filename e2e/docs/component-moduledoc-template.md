# Corex component @moduledoc (convention)

- Preamble: one paragraph + upstream link. Avoid a redundant “Features” list that mirrors the ExDoc nav.
- H2: **Anatomy**, **API**, **Events**, **Patterns**, **Style**, **Form** (omit when empty). Optional **Animation** as its own H2 when needed.
- **Item map / list-driven fields** belong under **## Anatomy** in a dedicated subsection (e.g. **Item fields**). Use that table for `items={Content.new(...)}` modes only, not for Manual or Compound.
- **Phoenix form** content uses a top-level **## Form** so it is easy to find; MCP may expose a `form` scope when the registry lists it.
- **Tab UI** (`<!-- tabs-open -->` … `<!-- tabs-close -->`): use **only** where multiple `###` panes are needed under **## Anatomy** (or one pair under Compound for alternate examples). Each tab is a **`###` heading**. Do not wrap **## Patterns** or **## Animation** in tab markers. Avoid nesting `###` in a way that flattens all headings under one H2: list-driven examples use sibling `###` blocks (e.g. **Basic**, **Open and disabled**) so slices and the tabbed UI stay consistent.

See `Corex.Accordion` and `Corex.AngleSlider` in `lib/components/` for worked examples.
