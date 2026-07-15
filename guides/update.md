# Updating Corex

How to pull a newer Corex release into your app and refresh design assets.

## Elixir dependency

In `mix.exs`:

```elixir
{:corex, "~> 0.2.0"}
```

`~> 0.2.0` keeps you on **0.2.x** (patch and minor releases on that line). To move from **0.1.x**, change the requirement after reading [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md).

If you use Corex Design, also depend on the separate Hex package:

```elixir
{:corex_design, "~> 0.2", runtime: false, only: :dev}
```

Add `:corex_design` to your project's `compilers` when you want design assets to rebuild on `mix compile` (see [Manual installation](manual_installation.html)).

```bash
mix deps.update corex corex_design
mix deps.get
mix compile
```

## Design assets

When the release notes mention CSS, tokens, or design files:

```bash
mix corex.design.build
```

Or run a full asset build:

```bash
mix assets.build
```

### Migrating from `mix corex.design`

If your app still uses copied design files without the `corex_design` dependency:

1. Add `{:corex_design, "~> 0.2", runtime: false, only: :dev}` to `mix.exs`
2. Add `config :corex_design` to `config/config.exs` (see [Manual installation](manual_installation.html))
3. Add `"corex.design.build"` to `assets.build` and `assets.deploy`
4. Remove any vendored copy of design CSS under the old installer path
5. Run `mix deps.get && mix corex.design.build`

Remove `config :corex_design, variants:` if present. Bundle filtering uses `components:` and `semantics:` only.

### Ignore generated CSS

Add this to `.gitignore` (new apps with design get it from `mix corex.new`):

```gitignore
/assets/corex/
```

If `assets/corex/` is already in git history, untrack it and keep local files:

```bash
echo '/assets/corex/' >> .gitignore
git rm -r --cached assets/corex
git commit -m "Stop tracking generated Corex Design CSS"
```

History still contains old blobs until you rewrite history (usually unnecessary). After untracking, run `mix corex.design.build` on every clone / CI before Tailwind or asset builds.

## Migrating from 0.1.x to 0.2.0

### Prefer a single CSS import

Replace layered imports with the umbrella entry (generated under `assets/corex/`):

```css
@import "../corex/corex.css";
@source "../corex";
```

Layered imports (`main.css` + `theme/*.css` + `components.css`) still work if you filter themes or components yourself; new apps and the e2e demo use `corex.css`.

### Modifier classes

Per-component BEM palette/size modifiers are gone. Use shared `ui-*` classes on the host:

| 0.1.x | 0.2.0 |
|-------|-------|
| `button button--accent` | `button ui-accent` |
| `accordion accordion--lg` | `accordion ui-size-lg` |
| `timer timer--rounded-xl` | `timer ui-rounded-xl` |
| `button button--accent button--solid` | `button ui-accent ui-solid` |
| `button button--ghost` / `button--outline` | removed (use default subtle, or `ui-solid`) |

Stack freely: `class="accordion ui-accent ui-size-lg ui-rounded-xl"`.

Axes: **semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **variant** (`ui-solid` only; subtle is default), **size** (`ui-size-sm` … `ui-size-xl`), **radius** (`ui-rounded-*`). Full reference: [modifier guide](modifiers.html).

### Token renames

If you authored CSS against Corex tokens:

| 0.1.x / early naming | 0.2.0 |
|----------------------|-------|
| `{role}-ink` (on filled surfaces) | `{role}-contrast` |
| `ink-{role}` (text on neutral surfaces) | `{role}-text` |
| `--theme-color-*` aliases | removed; use `--color-*` |
| `selected-*` token aliases | removed |

Generated theme CSS may still expose short-lived legacy aliases; prefer the 0.2 names in new CSS.

### Config and package layout

- Design is the optional **`corex_design`** Hex package (not vendored under the installer).
- `mix corex.design` and `--designex` are retired; use `mix corex.design.build`.
- Default `mix corex.new` adds `corex_design` and runs the design build.
- Controlled mode on form fields applies only to **select, radio, switch, checkbox** (not every input).

## After upgrading

1. Read [CHANGELOG.md](https://github.com/corex-ui/corex/blob/main/CHANGELOG.md) for breaking or additive changes.
2. Grep your templates for `--accent`, `--ghost`, `--outline`, and per-component size/radius BEM classes; rewrite to `ui-*`.
3. Run your usual checks (`mix test`, `mix assets.build`, and any e2e suite you use).
4. Spot-check pages that use components you rely on (forms, overlays, tables).

For a full manual install path (first-time setup), see [Manual installation](manual_installation.html).
