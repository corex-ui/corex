# Changelog

## Unreleased

- **Form `invalid` styling is opt-in for all `field={}` components** — `Corex.FormField.assign_form_field/2` no longer sets `invalid` from changeset errors. Error messages still render in `:error` slots; pass `invalid` or `invalid={Corex.FormField.invalid?(@form[:field])}` when you want alert borders.
- **Hex docs aligned with e2e demos** — Added [Forms](guides/forms.html) guide (invalid styling, custom errors, invalid-on-error). E2e `*_code` snippets and component `## Form` sections link to the guide. Doc parity (moduledoc vs demo code tabs) runs in `mix lint` for core components.

Stable **0.1.0** will follow this release candidate after RC feedback.

## 0.1.0-rc.0

First release candidate of Corex

### Features

- **Corex MCP** — Self-hosted MCP endpoint so tools like Cursor can list components and read docs from your running app. Enable only in development (`if Mix.env() == :dev do plug Corex.MCP end`); do not expose in production.
- **Corex Design System** — Token-based CSS, themes, light and dark mode, and ready-made modifier classes (`button--accent`, `dialog--lg`, and similar). Run `mix corex.design` to copy design assets into your app.
- **API and Events** — Open a dialog, set a slider, or expand an accordion from LiveView or JavaScript. Listen for user-driven changes with `on_*` attributes and `handle_event/3`. Documented on each component in Hexdocs.
- **Phoenix forms** — Inputs and pickers built for forms: checkbox, switch, select, combobox, date picker, color picker, number, password, and pin inputs, tags input, radio group, file upload, signature pad, and more—with controlled values and changeset-friendly wiring.
- **New Phoenix app** — `mix corex.new` generates a full application with Corex wired in. Optional flags add design assets, theme picker, dark mode, locales, and MCP.
- **Static sites with Tableau** — Use Corex on [Tableau](https://hex.pm/packages/tableau) sites (HEEx, Esbuild, Tailwind). Reference templates: [soonex](https://github.com/corex-ui/soonex) and [soonex_i18n](https://github.com/corex-ui/soonex_i18n).
- **Generators** — `mix corex.gen.live` and `mix corex.gen.html` scaffold LiveViews and controllers; `mix corex.design`, `mix corex.heroicon`, and `mix corex.code` help with assets and snippets.

### Components

Alphabetical list of everything available through `use Corex`. Entries marked **(Zag.js)** include a client hook and work with LiveView updates without losing state. The rest are Phoenix markup and helpers only (no separate JS import).

- Accordion (Zag.js)
- Action
- Angle Slider (Zag.js)
- Avatar (Zag.js)
- Carousel (Zag.js)
- Checkbox (Zag.js)
- Clipboard (Zag.js)
- Code
- Collapsible (Zag.js)
- Combobox (Zag.js)
- Color Picker (Zag.js)
- Data List
- Data Table
- Date Picker (Zag.js)
- Dialog (Zag.js)
- Editable (Zag.js)
- File Upload (Zag.js)
- File Upload Live
- Floating Panel (Zag.js)
- Heroicon
- Hidden Input
- Layout Heading
- Listbox (Zag.js)
- Marquee (Zag.js)
- Menu (Zag.js)
- Native Input
- Navigate
- Number Input (Zag.js)
- Pagination (Zag.js)
- Password Input (Zag.js)
- Pin Input (Zag.js)
- Radio Group (Zag.js)
- Select (Zag.js)
- Signature Pad (Zag.js)
- Switch (Zag.js)
- Tabs (Zag.js)
- Tags Input (Zag.js)
- Timer (Zag.js)
- Toast (Zag.js)
- Toggle (Zag.js)
- Toggle Group (Zag.js)
- Tooltip (Zag.js)
- Tree View (Zag.js)

### Changed

- **Form `invalid` is opt-in** — `field={}` no longer sets `invalid` from changeset errors on radio group, pin input, color picker, or editable (same as checkbox, switch, select). Pass `invalid` explicitly when you want invalid styling.
- **Radio group** — Size and color modifier utilities in CSS; full Zag API surface (`set_value`, `clear_value`, `focus`, `value`); form docs show the `:error` slot; e2e style page and pattern stream examples.
- **Carousel `page` is 1-based** — Same as pagination (`page={1}` is the first slide). The client hook translates to Zag’s 0-based snap index.
- **`controlled` removed** from carousel, combobox, editable, number input, and tree view. Use default-value assigns and events; controlled mode remains on accordion, angle slider, checkbox, collapsible, date picker, dialog, listbox, pagination, radio group, select, switch, tabs, tags input, toggle, and toggle group.

### Versioning (0.1.x)

With `{:corex, "~> 0.1.0-rc.0"}`, Hex resolves **0.1.0-rc.x** and later **0.1.x** on this line. Patch and minor 0.1 releases are **additive** (bug fixes, new attrs or components). Breaking API or behavior changes ship in **0.2.0**, with deprecation notes in CHANGELOG when possible. See [Updating Corex](guides/update.html).

**Migrating form `invalid` styling:** if you relied on changeset errors to style radio group, pin input, color picker, or editable automatically, pass `invalid` explicitly:

```heex
<.radio_group field={@form[:plan]} invalid={@form[:plan].errors != []} />
```

### Requirements

Elixir ~> 1.17, Phoenix ~> 1.8, LiveView ~> 1.1.
