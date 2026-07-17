# Modifier axes

Shared host classes for Corex Design components. Stack axes on the root, for example `accordion ui-accent ui-size-lg ui-rounded-xl`.

Requires `mix corex.design.build` (`corex_design`). Per-component supported classes are listed on each component’s Hexdocs **Style** section on [corex](https://hexdocs.pm/corex).

## Semantic

Semantic palette roles from design tokens. Applied to interactive surfaces (triggers, controls, panels).

| Role | Example |
| ---- | ------- |
| Default | `button` |
| Accent | `button ui-accent` |
| Brand | `button ui-brand` |
| Alert | `button ui-alert` |
| Info | `button ui-info` |
| Success | `button ui-success` |

Semantic classes set shared control palette variables on the host (`--ctl-fill`, `--ctl-fill-hover`, `--ctl-ink-text`, and related tokens). They do not change surface treatment by themselves.

Bundle filtering: `config :corex_design, semantics: ~w(base accent)a` trims unused `ui-{role}` utilities from `utilities.css`.

## Variant

Surface treatment for interactive parts. Orthogonal to semantic role. Default is **subtle** (neutral `ui` fill + border, semantic text ink when a palette class is present).

| Treatment | Surface | Example |
| --------- | ------- | ------- |
| Subtle (default) | Neutral `ui` fill + border | `button` or `button ui-accent` |
| Solid | Full semantic fill + on-color ink | `button ui-accent ui-solid` |

Add `ui-solid` for a filled control. Subtle needs no class.

## Size

Density step (`sm`, `md`, `lg`, `xl`). One suffix scales **font size**, **padding**, **gap**, and **control min-height** together via `--ctl-*` sizing variables.

| Step | Example |
| ---- | ------- |
| Default | `button` |
| SM | `button ui-size-sm` |
| MD | `button ui-size-md` |
| LG | `button ui-size-lg` |
| XL | `button ui-size-xl` |

## Radius

Corner radius on roundable surfaces. Orthogonal to size and semantic role.

| Step | Example |
| ---- | ------- |
| Default | `button` |
| None | `button ui-rounded-none` |
| SM | `button ui-rounded-sm` |
| MD | `button ui-rounded-md` |
| LG | `button ui-rounded-lg` |
| XL | `button ui-rounded-xl` |
| Full | `button ui-rounded-full` |

Not every component exposes a radius axis (for example `icon`, `link`, `typo`).

## Shape (buttons only)

| Class | Example |
| ----- | ------- |
| Square | `button ui-trigger--square` |
| Circle | `button ui-trigger--circle` |

## Width and max width

Corex uses a single container ladder from `9xs` through `9xl` for named sizing. Theme files define `--theme-container-*`; the semantic bridge exposes `--container-*`.

Each component sets its own host width in component CSS. Use Tailwind `w-*` and `max-w-*` utilities with container steps on the host when you need explicit bounds.

## Max height

Opt-in clamp for scrollable content panels. Put `ui-max-height-*` on the **host**; the recipe applies `--ctl-max-height` to `[data-part="content"]` (or accordion `item-content`) with overflow and scrollbar only when the modifier is present.

| Step | Example |
| ---- | ------- |
| XS | `select ui-max-height-xs` |
| SM | `accordion ui-max-height-sm` |
| MD | `menu ui-max-height-md` |

Uses the same `--container-*` ladder as width. Combobox keeps a default content max-height; the modifier overrides it.

## Naming

Pattern: `<component> ui-<role> ui-solid ui-size-<step> ui-rounded-<step> ui-max-height-<step>`.

Combine freely: `dialog ui-brand ui-size-lg ui-rounded-lg ui-solid`.

Each component Hexdocs **Style** section lists supported classes for that component.

## Overrides

Override design tokens on `:root`, `[data-theme]`, or on a component host:

```css
[data-theme="neo"][data-mode="light"] {
  --color-accent: #0055aa;
}

.my-panel {
  --ctl-radius: var(--radius-xl);
}
```

Regenerate the bundle after changing `config :corex_design`; token and palette overrides in CSS do not require a rebuild.
