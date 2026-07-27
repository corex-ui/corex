# Changelog

## 0.2.0 - 2026-07-26

### Breaking changes

#### Design system

- **Color-native tokens:** seeds + Oklch lightness / `Color.Palette.contrast` (no PaletteGen sampling). Public names end-to-end: `root`, `surface`, `ui`, `ink`, roles `accent`/`brand`/`alert`/`info`/`success`.
- **`layer` renamed to `surface`** (`--color-surface`, `bg-surface`).
- **Non-color tokens are public names only:** Publish writes `--radius-*`, `--spacing-*`, `--font-*`, `--duration-*`, … under `[data-theme]`. Semantic bridges are `@theme` identity registration (no `--theme-*` indirection).
- **Theme Spec lean:** `profile` and intent knobs (`radius_curve`, `elevation`, …) removed; personality is numeric Dimensions + fonts.
- **Recipes:** host/part selectors only (no `.ui-chrome-*`); disclosure/selection nest under role chrome.
- **Config:** `semantics:` only (no `scales: [semantic:]`). Nested legacy color maps rejected.
- **Accessibility:** `true` enables `:text` / `:focus` / `:links`; motion/contrast prefer OS media queries.
- **Installer defaults:** trimmed component list; `semantics: [:accent, :brand, :alert]`.
- **Design v1 chrome contract:** shared recipe chrome is generated once in `recipes.css` (no `@apply ui-trigger` / `ui-item` inlining). Host class (`class="accordion"`) remains the per-instance opt-in. Disclosure and selection rules nest under role chrome.
- **Paint rules:** idle follows the variant axis; disclosure (`open`) darkens only; selection (`on` / `checked` / `selected` / …) always fills with `--ctl-fill`.
- **`ui-outline` removed.** Variants are subtle (default), `ui-solid`, and `ui-ghost` only.
- **No variant axis on Selection or Field hosts:** `toggle`, `toggle-group`, `checkbox`, `radio-group`, `switch`, `tabs`, `pagination`, `tree-view`, `angle-slider`, plus `native-input`, `number-input`, `password-input`, `pin-input`, and `tags-input`. Drop `ui-solid` / `ui-ghost` / `ui-outline` from those hosts; field surface stays `ui-input` (semantic classes tint focus and accent ink only). Binary controls always paint the checked state with the semantic fill.
- **`--ctl-sel-*` removed.** Selection paint uses `--ctl-fill` / `--ctl-fill-ink`.
- **`ThemeDefinition` removed.** Keyword `config :corex_design` is the only config surface.
- **`ui-width-*` added;** prefer it over hand-written width CSS on Corex hosts.
- **New-app defaults:** without `--theme`, the installer scaffolds `themes: [:neo]` and `default_theme: :neo` (single theme). With `--theme`, all presets ship and the first listed id is default. Installer components: `toast`, `layout-heading`, `typo`, `icon`, `link`, `button`, `dialog`, `scrollbar`, `checkbox`, `native-input`, `select`, `toggle`, `badge`. The Design package fallback when `default_theme` is omitted from config remains `:uno`.
- **`mix corex.code` renamed to `mix corex.design.code`.** Update scripts and docs that call the old task name.

#### Components and API

- **Toast LiveView events are snake_case:** `toast-create` / `toast-update` / `toast-remove` / `toast-dismiss` → `toast_create` / `toast_update` / `toast_remove` / `toast_dismiss`. Toast payloads (push and `JS.dispatch` detail) use `group_id` (not `groupId`).
- **Toggle group event:** `toggle-group_set_value` → `toggle_group_set_value`.
- **Marquee push payload:** `marquee_id` → `id` (matches other component push payloads).
- **Pagination slots:** `:prev` / `:next` → `:prev_trigger` / `:next_trigger` (aligned with carousel / date-picker).
- **Color picker `label`:** string attr removed; use `<:label>` slot like peer form controls (defaults to "Select Color" when the slot is empty).
- **`file_upload_live`:** attr `:field` (upload atom) renamed to `:upload_name` to avoid colliding with FormField `:field`. The LiveView cancel payload key remains `upload_field`.
- **Attr types:** `positioning` on combobox / color_picker is `Corex.Positioning` (not `:map`). Combobox `on_value_change_client` is `:any` (aligned with select). Color picker presets encode via `Corex.Dataset.encode_json/1`.
- **Multi-value datasets use JSON** (`["a","b"]`) for `data-value` / `data-default-value` (and tree expanded/selected defaults). Comma-separated lists are no longer emitted.

#### Forms

- **Form components require `:id` when no `:field`:** form controls no longer auto-generate random ids via `System.unique_integer`. Pass `id` explicitly, or use `field={@form[:name]}` so Phoenix `FormField.id` is used. Non-form components still auto-generate ids when omitted. Random default `name-*` values on form controls were also removed (`name` defaults to `nil`).
- **Optional hook ids:** non-form hook hosts still allow omitting `:id`. When omitted, Corex derives from `:name` when present, otherwise a prefixed random id. Pass a stable `:id` when using `controlled` or server `on_*` handlers so LiveView patches do not remount the hook.
- **`FormField.assign_form_field/2` leaves `invalid` off by default.** Pass `auto_invalid` to derive alert borders from visible changeset errors (`used_input?/1`), or set `invalid={true}` / `invalid={false}` explicitly (explicit wins).
- **`form_field` / `field_used` are no longer public attrs** on select/combobox; they remain private assigns set by `field={...}`.

#### MCP

- **MCP moved to Hex package `corex_mcp`.** Add `{:corex_mcp, "~> 0.2", only: [:dev, :test]}` and keep `plug Corex.MCP` (mounted in `:dev` / `:test`). Config keys are under `config :corex_mcp` (`mcp_root`, `mcp_verbose_errors`, `debug`). Tools expanded: enriched `get_component` (attrs/slots/modifiers), plus `list_modifiers`, `get_component_style`, `list_themes`, `design_guide`.

Migration table (API renames in this release):

| Before | After |
|--------|-------|
| `toast-create` / `toast-update` / `toast-remove` / `toast-dismiss` | `toast_create` / `toast_update` / `toast_remove` / `toast_dismiss` |
| toast payload `groupId` | `group_id` |
| `toggle-group_set_value` | `toggle_group_set_value` |
| marquee push `%{marquee_id: …}` | `%{id: …}` |
| pagination `<:prev>` / `<:next>` | `<:prev_trigger>` / `<:next_trigger>` |
| color_picker `label="…"` | `<:label>…</:label>` |
| `file_upload_live` `field={:name}` | `upload_name={:name}` |
| combobox/color_picker `positioning` `:map` | `Corex.Positioning` |
| combobox `on_value_change_client` `:string` | `:any` |
| color_picker `Corex.Json.encode!(presets)` | `Corex.Dataset.encode_json(presets)` |
| `mix corex.code` | `mix corex.design.code` |

See the [update guide](guides/update.html) for migration notes.

### Enhancements

#### Design system

- **Design contract:** shared `ui-*` modifiers for semantic roles and surface treatment (`ui-solid`, `ui-ghost`) on button-like hosts. Compounds keep a subtle default; style pages use a canonical preview plus Semantic × variant matrices where the variant axis applies.
- **`Corex.Design.Config.Resolved` is a struct:** defaults and shape live in one place instead of being re-derived at each read site.
- **`Corex.Design.Theme.Spec` is a struct** (with `Spec.Mode` and `Spec.Dimensions`): normalized theme specs no longer need defensive `Map.get(spec, :dimensions, %{})` at each read. Emitted CSS is unchanged.
- **`Corex.Design.Config.Schema` / `Theme.Validator`:** NimbleOptions schema and theme validation are named for their jobs (replacing overlapping `*.Options` modules).
- **`Corex.Design.Keys`:** one place for reading spec maps that may use atom or string keys. Font and radius step names use closed allowlists that raise on a typo.
- **`Corex.Design.Filter.semantics/0` is `semantic_strings/0`:** returns strings while `default_semantics/0` returns atoms.
- **`Corex.Design.Components`:** single `(scope, part) -> role` table drives recipes, MCP axes, and demo matrices. `get!/1` names unknown ids; `fetch/1` returns `{:ok, meta} | :error`. Host width / default max are derived from anatomy CSS.
- **`Corex.Design.Emit.Css`:** shared banner, declaration, and block writers; emitters return iodata. Emitted CSS is byte-identical to the previous string concatenation.
- **Bundle writes `utilities.css` once** with `apply_utilities_semantics/2` on the way through (no read-back rewrite).
- **`modes:` / `semantics:`** filter light/dark packs and token generation at build time. Build prints emitted components, themes, modes, and semantics.
- **Design unit tests** cover theme validation, contrast, recipes, typography, CSS emit, Keys, and utilities filtering.

#### Components and API

- **Dialog:** `<:content class=...>` merges onto the content part.
- **Link:** underline grows on hover via scale; `ui-nav` is the chrome-less nav treatment (ink, no underline, `aria-current` color/weight).
- **Native radio:** circular indicator painted with control fill tokens (not a checkmark).
- **`use Corex.Component, :connect | :list | :api | :form`:** tiered preludes replace per-file `import Corex.Helpers` lists. `Corex.Helpers` is removed; functions live in `Corex.Attrs`, `Corex.Value`, `Corex.List.Normalize`, `Corex.ValueBinding`, `Corex.Api.RespondTo`, and `Corex.Content`.
- **`Corex.Attrs` presence attributes renamed:** `get_boolean` → `presence_attr`, `get_default_boolean` → `default_presence_attr`, `maybe_put_dir` / `maybe_put_data_dir` → `put_dir_attr` / `put_data_dir_attr` (and `_from_assigns` variants).
- **`Corex.Item`:** shared field set and `:items` validator for Content / List / Tree item structs. `Corex.Content.Item` `:meta` defaults to `%{}`.
- **`items` contract documented per module:** `Corex.List` accepts maps or structs and warns on bad rows; `Corex.Tree` and `Corex.Content` accept structs only and raise.
- **`Corex.Value`:** coercions for params (`coerce_string_list`, `parse_string_list`, `coerce_string_value`) warn and drop instead of raising where soft-normalize applies.

#### Forms

- **`form_control_attrs/1` in every form component:** shared `id` / `field` / `name` / `form` / `invalid` / `auto_invalid` / `controlled` / `disabled` / `read_only` / `required` attrs declared once by the macro.
- **`Corex.FormField.assign_stable_id/2`:** shared optional-id derivation for hook hosts.
- **`Corex.FormField.assign_unless_given/3`:** fills a form control assign from the field only when the caller left it blank.
- **`signature_pad` declares `form`:** the template already wired `@form`; the attr is now declared.

#### Assets / hooks

- **All 33 hooks use `createZagLiveHook`.** Hooks declare `key`, `controlledKeys`, and needed callbacks; the factory owns listener registries, controlled snapshots, and teardown.
- **Hook listeners use `dom` / `server` registries** passed to `mount` (no hand-rolled arrays that outlive remounts).
- **Shared collection and form helpers:** list-item refresh via collection kit; form sync through `phoenix-form-bridge`; tags use `parseJsonStringList`; respond-to emitters via `createValueEmitter`.
- **The npm package ships types** (`exports` `types` condition from `npm run build:types` / `prepack`).
- **`VanillaMachine` is typed per component** via `SchemaOf<typeof machine>` (no `VanillaMachine<any>`).
- **`noUncheckedIndexedAccess` is on;** `@zag-js/*` is on 1.42.0.

#### MCP and installer

- Enriched MCP component discovery and design tools (see Breaking changes for package move).
- Installer defaults align with design update themes and component allowlists.
- **`--a11y`** (default off) on `mix corex.new` and `mix corex.tableau.new`: scaffolds accessibility preference CSS, plug/hook (Phoenix), FOUC bridge, and panel UI. Implies `--design`.

#### Tooling

- **Dialyzer runs clean across all four packages** and gates CI with a cached PLT. `@spec` covers imperative APIs, anatomy structs, and previously unspecced public modules.
- **`mix ci` and `mix format.all`:** format checks, lint, tests, dialyzer, and `npm run check` from the root.
- **Credo `Specs` and `UnsafeToAtom`** on for the shared library surface.
- **eslint** reads browser globals from the `globals` package; `no-undef` is off for TypeScript.

#### Docs / e2e

- **Docs home:** controller-rendered landing with interactive component marquee, Why Corex feature grid, HEEx example, theming presets, and install CTA.
- Long component examples moved to `guides/components/` (accordion, checkbox, tree_view) with shorter moduledocs.

### Bug fixes

#### Design system

- **Design config validation:** `validate_themes` no longer skips `default_theme` checks; component/semantics errors return `{:error, _}` from `validate/1`.
- **A non-map theme spec is reported, not a crash** (`themes: %{neo: "solid"}`).
- **A malformed `scales:` value fails validation** (keyword list only).
- **A per-theme role with invalid `lightness` or a non-map role fails config validation** on the prepared spec.
- **`Corex.Design.Keys.get/3` preserves `false` and `nil`** when the key is present (no longer treated as missing via `||`).
- **`Corex.Design.mix_root/0` handles an empty project stack.**
- **Emitted token files are ordered by their scale ladder** (stable rebuilds / `GENERATED` hash).
- **Orphan generated theme/token CSS removed from the design package priv tree;** the bundle writes those files to the app output only.

#### Components and API

- **`Api.RespondTo`:** JS.dispatch selectors use `Corex.Selectors.css_id/1`.
- **`Corex.Url.allowed_href?/1` accepts any term;** allow `mailto:` and `tel:` (still block `javascript:`, `data:`, and protocol-relative URLs).
- **`Corex.Timer` names the offending segment** instead of only printing the allowed set.
- **Toast:** item destroy unsubscribes; remounting a group id disposes the previous machine; client `JS.dispatch` / anatomy helpers include `group_id`.
- **Combobox:** disable-only `data-items` updates no longer re-render list DOM (preserves HEEx item slots).
- **Pin-input:** ignore Zag `value` / `maxLength` on cells so focus can advance under LiveView.
- **Color picker:** `nil` / empty initial value defaults to `#000000`.
- **Timer:** digit/label ink follows `--ctl-ink-text` / muted tokens.

#### Assets / hooks

- **Lazy hooks:** `beforeUpdate` is queued and replayed during async chunk load.
- **Controlled hooks:** combobox, tags-input, date-picker, color-picker, editable, pin-input, and angle-slider re-apply server values on LiveView patches.
- **`Tabs.updateProps/1` and `Carousel.updateProps/1` return whether the props were applied.**
- **`ToastItem.updateProps/1` is a method** on the prototype chain like other overrides.

#### Docs / e2e

- **e2e:** remove Admin/User avatar file-upload demos from form suite.

### Internal

- **JSON via OTP `:json`:** `corex`, `corex_design`, and `corex_mcp` no longer depend on Jason. Use OTP 27+ or add `json_polyfill` on OTP 26.
- Shared `Corex.Connect.ItemNav` for item `to` / redirect / new_tab dataset attrs.
- DocParity anatomy mapping uses explicit markers (`Corex.DocParity.Markers` and optional `# @parity anatomy:` comments on demos).
- Demo id guard test ensures form `*_example` openings pass `id` or `field`.
- HEEx / design registry alignment locked by contract tests (`Corex.heex_only_ids/0`, `Components.css_only_ids/0`).
- Design compile signature hashes package `lib` + `priv/css` so path-dep anatomy edits invalidate the bundle.
- Coveralls no longer skips Animation / Flash / Toast.Action / Marquee.Anatomy.

## 0.1.2

### Bug fixes

- [pagination] Align link trigger `aria-label` with Connect SSR; omit labels on dead prev/next links ([#64](https://github.com/corex-ui/corex/pull/64))
- [menu] Fix trigger and items disabled state ([#61](https://github.com/corex-ui/corex/pull/61))
- [tooltip] Non-focusable trigger slot for composition (button/div triggers) ([#62](https://github.com/corex-ui/corex/pull/62))
- [deps] Widen `phoenix_live_view` to `~> 1.1` so generated apps on LiveView 1.1.x or 1.2.x resolve without forcing an upgrade ([#65](https://github.com/corex-ui/corex/pull/65))
- [installer] Join `NODE_PATH` env lists in `corex.new` config for Elixir 1.18 and tailwind 0.4.x
- [file-upload-live] Drop invalid `live_img_preview` sizing attrs; preview size comes from file-upload CSS

### Enhancements

- Integration tests: repeat all OTP / Elixir rows with pinned `phx_new 1.8.4` alongside latest

## 0.1.1

### Bug fixes

- [menu] Fix submenu leaks and LiveView drift on open menus ([#58](https://github.com/corex-ui/corex/issues/58))
- [menu] Scope server `set_open/3` to the targeted menu
- [combobox] Preserve custom item slots after LiveView updates
- [toast] Sanitize action URLs
- [data-table] Harden sort and selection params
- [pagination] Validate page URLs
- [redirect] Validate redirect schemes
- [date-picker] Reduce unnecessary re-renders

### Enhancements

- [menu] Item and trigger layout aligned with select, combobox, and listbox
- [combobox] Default `close_on_select` to `true`
- [docs] Restore `mix corex.new` on Hexdocs
- [mcp] Security hardening

Run `mix corex.design --force` in your app to refresh `assets/corex/` (CSS and tokens).

## 0.1.0

Initial Corex stable release.
