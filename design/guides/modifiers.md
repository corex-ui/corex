# Modifier axes

Shared host classes for Corex Design components. Stack axes on the root, for example `accordion ui-accent ui-size-lg ui-rounded-xl`.

Requires `mix corex.design.build` (`corex_design`). Per-component supported classes are listed on each component Hexdocs **Style** section on [corex](https://hexdocs.pm/corex).

Import one entry: `@import "../corex/corex.css"`.

## Semantic

Semantic palette roles from design tokens. Applied to interactive surfaces (triggers, controls, panels).

| Role | Example |
| ---- | ------- |
| Default (base) | `button` or `button ui-base` |
| Accent | `button ui-accent` |
| Brand | `button ui-brand` |
| Alert | `button ui-alert` |
| Info | `button ui-info` |
| Success | `button ui-success` |

Semantic classes set shared control palette variables on the host (`--ctl-fill`, `--ctl-fill-hover`, `--ctl-ink-text`, and related tokens). They do not change surface treatment by themselves. Base is always present as default fill vars on every host.

Bundle filtering: `config :corex_design, semantics: ~w(accent brand)a` trims unused role tokens and `ui-{role}` utilities at generation time.

## Variant

Surface treatment for **Action** hosts (buttons, badges, links, compound triggers). Orthogonal to semantic role. Default is **subtle** (neutral `ui` fill + border, semantic text ink when a palette class is present).

| Treatment | Surface | Example |
| --------- | ------- | ------- |
| Subtle (default) | Neutral `ui` fill + border | `button` or `button ui-accent` |
| Solid | Full semantic fill + on-color ink | `button ui-accent ui-solid` |
| Ghost | Transparent fill and border; hover tint | `button ui-accent ui-ghost` |

Add `ui-solid` or `ui-ghost` for an explicit surface. Subtle needs no class.

**Selection hosts** (`toggle`, `toggle-group`, `checkbox`, `radio-group`, `switch`, `tabs`, `pagination`, `tree-view`, `angle-slider`, `slider`) and **Field hosts** (`native-input`, `number-input`, `password-input`, `pin-input`, `tags-input`) have **no variant axis**. Use semantic, size, and radius only — except **tree-view**, which has no radius axis (row items stay square).

How surfaces behave:

1. Idle chrome follows the variant (buttons and similar) or stays neutral (checkboxes, toggles, fields).
2. Open / disclosed panels darken slightly; they do not fill with the semantic color.
3. Selected / checked / on states use the semantic fill color.

**Link** also supports `ui-nav` for chrome-less nav items: no underline, ink by default, link-colored hover, and `aria-current="page"|"location"` for current weight and color (`class="link ui-nav"`).

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

## Shape (buttons, badges, and toggles)

| Class | Example |
| ----- | ------- |
| Square | `button ui-trigger--square`, `toggle ui-trigger--square` |
| Circle | `button ui-trigger--circle`, `toggle ui-ghost ui-size-sm ui-trigger--circle` |

For `toggle` and `select`, put the shape modifier on the **host** (`.toggle` / `.select`); design recipes forward it to the nested trigger part.

## Width

| Class | Example |
| ----- | ------- |
| Auto | `select ui-width-auto` |
| Fit | `button ui-width-fit` |
| Full | `accordion ui-width-full` |
| Container step | `select ui-width-4xs` |

## Max height

Opt-in clamp for scrollable content panels. Put `ui-max-height-*` on the **host**; the recipe applies `--ctl-max-height` to content parts with overflow and scrollbar only when the modifier is present.

| Step | Example |
| ---- | ------- |
| XS | `select ui-max-height-xs` |
| SM | `accordion ui-max-height-sm` |
| MD | `menu ui-max-height-md` |

Uses the same `--container-*` ladder as width.

## Naming

Pattern: `<component> ui-<role> ui-solid ui-size-<step> ui-rounded-<step> ui-width-<step> ui-max-height-<step>`.

Combine freely: `button ui-brand ui-size-lg ui-rounded-lg ui-solid`, `accordion ui-accent ui-ghost`, `dialog ui-brand ui-size-lg ui-rounded-lg`.

Each component Hexdocs **Style** section lists supported classes for that component.

## Custom themes

`config :corex_design, themes: %{my_theme: spec}` accepts a full theme map (`seeds`, flat Color-native mode tokens (`:l` / `:contrast`), `dimensions`, optional `typography`). Copy the shape from a built-in preset (`neo`, `uno`, `duo`, `leo`). `mix corex.new` without `--theme` scaffolds `themes: [:neo]` and `default_theme: :neo`.

## Overrides

Override design tokens on `:root`, `[data-theme]`, or on a component host:

```css
[data-theme="uno"][data-mode="light"] {
  --color-accent: #0055aa;
}

.my-panel {
  --ctl-radius: var(--radius-xl);
}
```

Regenerate the bundle after changing `config :corex_design`; token and palette overrides in CSS do not require a rebuild.
