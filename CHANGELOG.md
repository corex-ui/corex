# Changelog

## 0.1.0

First release of Corex

### Features

- **Corex MCP** — In development, mount an MCP endpoint on your Phoenix app so tools like Cursor can list components and read up-to-date docs from the running project.
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

### Requirements

Elixir ~> 1.17, Phoenix ~> 1.8, LiveView ~> 1.1.
