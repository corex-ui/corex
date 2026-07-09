# Modifier axes

Corex Design components use flat BEM modifiers on the host element. Stack axes on the root class, for example `accordion accordion--accent accordion--lg accordion--rounded-xl`.

Modifier classes require the component recipe CSS from Corex Design (`mix corex.design.build` with the `corex_design` dependency).

## Semantic

Semantic palette roles from design tokens. Applied to interactive surfaces (triggers, controls, panels).

| Role | Example |
| ---- | ------- |
| Default | `button` |
| Accent | `button button--accent` |
| Brand | `button button--brand` |
| Alert | `button button--alert` |
| Info | `button button--info` |
| Success | `button button--success` |

Semantic modifiers set palette CSS variables on the host (`--{component}-fill`, `--{component}-ink-text`, and related tokens). They do not change surface treatment by themselves.

## Variant

Surface treatment for interactive parts. Orthogonal to semantic role. Default is **subtle** (neutral surface with semantic text ink where applicable).

| Treatment | Example |
| --------- | ------- |
| Subtle (default) | `button` or `button button--accent` |
| Solid | `button button--accent button--variant-solid` |
| Ghost | `button button--info button--variant-ghost` |
| Outline | `button button--accent button--variant-outline` |

Stack semantic and variant modifiers on the host: `accordion accordion--brand accordion--variant-ghost accordion--lg`.

Not every component exposes a variant axis (for example `typo`, `icon`, `scrollbar`). Check that component's Hexdocs **Style** section.

Bundle filtering: `config :corex_design, variants: ~w(solid ghost outline)a` trims unused variant utilities. Subtle is always included as default anatomy.

Components without a variant axis include `typo`, `icon`, `marquee`, `scrollbar`, `layout-heading`, and `keyframes` (semantic and size only, or utility-only recipes).

## Size

Density step (`sm`, `md`, `lg`, `xl`). One suffix scales **font size**, **padding**, **gap**, and **control min-height** together. There is no separate text-size modifier axis.

| Step | Example |
| ---- | ------- |
| Default | `button` |
| SM | `button button--sm` |
| MD | `button button--md` |
| LG | `button button--lg` |
| XL | `button button--xl` |

## Radius

Corner radius on roundable surfaces (`--rounded-*`). Orthogonal to size and semantic role.

| Step | Example |
| ---- | ------- |
| Default | `button` |
| None | `button button--rounded-none` |
| SM | `button button--rounded-sm` |
| MD | `button button--rounded-md` |
| LG | `button button--rounded-lg` |
| XL | `button button--rounded-xl` |
| Full | `button button--rounded-full` |

Not every component exposes a radius axis (for example `icon`, `link`, `typo`).

## Width and max width

Corex uses a single container ladder from `9xs` through `9xl` for named sizing. Theme files define `--theme-container-*`; the semantic bridge exposes `--container-*` and links width utilities to that ladder.

Tailwind resolves `max-w-*` and `min-w-*` from the `--container-*` namespace when present. Height utilities (`max-h-*`, `min-h-*`, `h-*`) otherwise use the spacing scale only. Corex adds `--max-width-*`, `--min-width-*`, `--max-height-*`, and `--min-height-*` theme variables that point at `--container-*` so width and height sizing utilities share the same named steps.

### Intrinsic default (no utility class)

Each component sets its own host width in component CSS:

| Host width | Behavior |
| ---------- | -------- |
| `width: 100%` (fill) | Stretches to the parent; an intrinsic `max-width: var(--container-*)` caps the root when set |
| `width: fit-content` (fit) | Shrinks to content; optional `max-width` caps the shrink-wrapped box |

Without `max-w-*` or `w-*`, width comes from that CSS, not from a shared Tailwind default.

### Width (`w-*`)

Use `w-{step}` to set a fixed width on the host. Steps include `auto`, `full`, `fit`, and the container ladder (`9xs` … `9xl`).

Fill components often use `w-full` in a narrow column. Fit-content controls (angle slider, toggle group, pin input) use named steps when you need an explicit width.

### Max width (`max-w-*`)

Use `max-w-{step}` to replace or add an upper width bound on the host. Steps include `none`, `full`, and the container ladder (`9xs` … `9xl`).

On fill hosts, `max-w-*` overrides the intrinsic cap. On fit-content hosts, it limits how wide the shrink-wrapped box may grow.

### Min width and height

`min-w-{step}` uses the same container ladder. `max-h-{step}` and `min-h-{step}` use the container-linked height namespaces (`--max-height-*`, `--min-height-*`), not spacing numbers, so `max-h-md` matches a container token.

Part-level caps inside a component (clipboard input, checkbox label) stay in component anatomy CSS; host `max-w-*` does not restyle those inner parts unless documented for that component.

Use complete class names in app source (for example `max-w-5xs`, not `"max-w-" <> step`). Tailwind scans source as plain text and skips dynamically built names. The `@theme` tokens supply values once a utility class is detected; use `@source inline()` only when runtime class assembly cannot be avoided.

## Naming

Pattern: `<component> <component>--<axis>-<step>` or `<component> <component>--<semantic-role>` for semantic styling.

Combine freely: `dialog dialog--brand dialog--lg dialog--rounded-lg`.

Each component Hexdocs **Style** section lists the concrete classes for that component.
