# E2E Beta page matrix (routing contract)

This file classifies each Corex demo component and lists which **page types** exist in the e2e app. **Non-Zag** components usually expose only **Anatomy** (and **Style** or **Form** where applicable); they typically do **not** ship Playground, API, Events, or Pattern routes (**data table** is an exception with a unified Pattern page). **Zag** components follow the Accordion shell for those live pages where the primitive supports them. **Deep** routes are extra LiveViews kept for real scenarios (streams, sorting, combobox async, and so on).

| Component | Class | Anatomy | Style | Form | Playground | API | Events | Patterns | Animation | Deep / extra |
|-----------|--------|---------|-------|------|------------|-----|--------|----------|-----------|--------------|
| accordion | Zag | yes | yes |  -  | yes | yes | yes | yes | yes |  -  |
| action | non-Zag | yes | yes |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
| angle-slider | Zag + form | yes | yes | yes | yes | yes | yes | yes |  -  | live-form, controlled |
| avatar | Zag | yes | yes |  -  | yes | yes | yes |  -  |  -  |  -  |
| carousel | Zag | yes | yes |  -  | yes | yes | yes |  -  |  -  |  -  |
| checkbox | Zag + form | yes | yes | yes | yes | yes | yes | yes |  -  | live-form, controlled |
| clipboard | Zag | yes | yes |  -  | yes | yes | yes |  -  |  -  |  -  |
| collapsible | Zag | yes | yes |  -  | yes | yes | yes | yes |  -  |  -  |
| code | non-Zag | yes | yes |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
| color-picker | Zag + form | yes |  -  | yes | yes | yes | yes |  -  |  -  | live-form |
| combobox | Zag + form | yes | yes | yes | yes | yes | yes | yes (incl. server filter) |  -  | live-form |
| data-list | non-Zag | yes |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
| data-table | non-Zag | yes |  -  |  -  |  -  |  -  |  -  | yes (unified) |  -  | `/data-table/patterns` only (anatomy is static) |
| date-picker | Zag + form | yes |  -  | yes | yes | yes | yes | yes |  -  | live-form, controlled |
| dialog | Zag | yes |  -  |  -  | yes | yes | yes | yes | yes |  -  |
| editable | Zag + form | yes | yes | yes | yes | yes | yes |  -  |  -  | live-form |
| file-upload | Zag + form | yes |  -  | yes | yes | yes | yes |  -  |  -  | controller form |
| file-upload-live | LV uploads | yes |  -  | yes | yes |  -  |  -  |  -  |  -  | live-form |
| floating-panel | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  |  -  |
| layout-heading | non-Zag | yes | yes |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
| listbox | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  | stream |
| marquee | Zag | yes |  -  |  -  |  -  | yes | yes |  -  |  -  |  -  |
| menu | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  |  -  |
| native-input | non-Zag + form | yes |  -  | yes |  -  |  -  |  -  |  -  |  -  | live-form |
| navigate | non-Zag | yes | yes |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
| number-input | Zag + form | yes | yes | yes | yes | yes | yes | yes |  -  | live-form |
| password-input | Zag + form | yes |  -  | yes | yes | yes | yes |  -  |  -  | live-form |
| pin-input | Zag + form | yes |  -  | yes | yes | yes | yes |  -  |  -  | live-form |
| radio-group | Zag + form | yes |  -  | yes | yes | yes | yes | yes |  -  | live-form |
| select | Zag + form | yes | yes | yes | yes | yes | yes | yes |  -  | live-form, controlled |
| signature | Zag + form | yes |  -  | yes | yes | yes | yes | yes |  -  | live-form |
| switch | Zag + form | yes | yes | yes | yes | yes | yes | yes |  -  | live-form, controlled |
| tabs | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  |  -  |
| timer | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  |  -  |
| toast | Zag |  -  |  -  |  -  | yes | yes |  -  | yes |  -  |  -  |
| toggle-group | Zag | yes |  -  |  -  | yes | yes | yes | yes |  -  |  -  |
| tooltip | Zag | yes |  -  |  -  | yes | yes | yes |  -  |  -  |  -  |
| tree-view | Zag | yes | yes |  -  | yes | yes | yes | yes | yes |  -  |

## Events pages (Zag)

Events LiveViews document server `handle_event` flows and client-side listeners. When lists or tables are part of the narrative, prefer **streams** and **`<.data_table>`** as in the Accordion reference implementation.

## Combobox async search

Server-driven filtering on **`/combobox/patterns`** lives in **`#combobox-patterns-server-filter-doc`** (flat list) and **`#combobox-patterns-server-filter-grouped-doc`** (grouped). The live previews use E2e.Place; the Heex/Elixir tabs show self-contained copy-paste samples.

## Router reconciliation notes

- **Number input · Events**  -  `/:locale/number-input/events` is registered as `NumberInputEventsLive`; the matrix marks **Events** as **yes** (not " - ").
- **Navigate**  -  anatomy and style only; there is no `/navigate/playground` route (playground column stays ** - **).
- **Data list**  -  static anatomy at `/:locale/data-list/anatomy` only; no playground/API/events (unchanged).

## Wallaby component behavior checklist (Zag)

When adding end-to-end coverage for a new Zag primitive (pattern follows Accordion and Listbox):

1. Register each doc route in [`e2e/lib/e2e_web/router.ex`](e2e/lib/e2e_web/router.ex) and keep demo section `id` values stable.
2. Add `E2eWeb.ComponentBehaviorSpec.page/2` tuples for `{path, ready_css}` per page type (anatomy, playground, api, events, patterns, `:controlled` for angle slider only, animation when applicable). Pilots today: accordion, angle slider, checkbox, combobox, listbox, switch.
3. Add `e2e/test/support/models/<component>_model.ex` with `wait_root_no_loading/2` on the hook host, section-level hook readiness, and click helpers scoped by `data-scope` / `data-part` or stable `id` prefixes from `Corex.<Component>.Connect`.
4. Add `e2e/test/components/<component>_test.exs` with `use Wallaby.Feature`, `Localize.put_locale(:en)` in `setup`, and describes mirroring the doc surface (anatomy, api, events, patterns).
5. For delayed LiveView or client APIs (focus, item state), poll with `wait_for_has/3` or a small model helper instead of a single fixed `Process.sleep`.
6. For accessibility across themes and modes, reuse `E2eWeb.A11yThemeMode.combos/0`, `visit_ready_with_theme_mode/5`, and scoped `check_accessibility/2` after meaningful UI states (accordion, listbox, checkbox, angle-slider, combobox, and switch playground pilots run this matrix).

## Fast server tests vs Wallaby vs controller tests

| Layer | Use for | Does not replace |
|-------|---------|------------------|
| **Wallaby** (`use Wallaby.Feature`) | Real Chrome, `phx-hook`, Zag machines, `data-loading`, layout toast script on `#layout-toast`, keyboard and focus | Cheap feedback on pure `handle_event` branches |
| **ConnCase + `Phoenix.LiveViewTest`** (`live/2`, `form/2`, `render_change` / `render_submit`, `assert_push_event`) | Server-side LiveView events, rendered HEEx (errors, `phx-*` wiring), `push_event` payloads such as `toast-create` | Hook JS, client-only behavior, a11y automation |
| **`Phoenix.ConnTest`** (no LiveView) | Static routes, controller POST + redirect + flash, non-LV forms | LiveView state or colocated hook behavior |
| **Unit tests** (`Ecto.Changeset`, `Phoenix.Component.to_form/2`) | Field `name` / `id`, validation messages, changeset branches without mounting a page | Proof that a route or template renders the right markup |

Existing examples: `e2e/test/components/switch_form_live_push_test.exs` (Switch live form, including strict paths), `e2e/test/components/checkbox_form_live_test.exs`, `e2e/test/components/angle_slider_form_live_test.exs`, `e2e/test/components/pin_input_form_live_test.exs`, `e2e/test/components/radio_group_form_live_test.exs`, `e2e/test/components/number_input_form_live_test.exs`, `e2e/test/components/password_input_form_live_test.exs`, `e2e/test/components/select_form_live_test.exs`, `e2e/test/components/color_picker_form_live_test.exs`, `e2e/test/components/date_picker_form_live_test.exs`, `e2e/test/components/editable_form_live_test.exs`, `e2e/test/components/signature_form_live_test.exs`, `e2e/test/components/native_input_form_live_test.exs`, `e2e/test/components/combobox_form_live_test.exs`, and `e2e/test/components/file_upload_form_live_test.exs` for LiveView forms; `e2e/test/components/accordion_events_live_test.exs`, `e2e/test/components/switch_events_live_test.exs`, `e2e/test/components/dialog_events_live_test.exs` (`live(..., on_error: :warn)` where the doc page has duplicate static ids), `e2e/test/components/checkbox_events_live_test.exs`, `e2e/test/components/color_picker_events_live_test.exs`, `e2e/test/components/date_picker_events_live_test.exs`, `e2e/test/components/carousel_events_live_test.exs`, `e2e/test/components/collapsible_events_live_test.exs`, `e2e/test/components/angle_slider_events_live_test.exs`, `e2e/test/components/avatar_events_live_test.exs`, `e2e/test/components/clipboard_events_live_test.exs`, `e2e/test/components/combobox_events_live_test.exs`, `e2e/test/components/editable_events_live_test.exs`, `e2e/test/components/floating_panel_events_live_test.exs`, `e2e/test/components/listbox_events_live_test.exs`, `e2e/test/components/marquee_events_live_test.exs`, `e2e/test/components/menu_events_live_test.exs`, `e2e/test/components/number_input_events_live_test.exs`, `e2e/test/components/password_input_events_live_test.exs`, `e2e/test/components/pin_input_events_live_test.exs`, `e2e/test/components/radio_group_events_live_test.exs`, `e2e/test/components/select_events_live_test.exs`, `e2e/test/components/signature_events_live_test.exs`, `e2e/test/components/tabs_events_live_test.exs`, `e2e/test/components/timer_events_live_test.exs`, `e2e/test/components/toggle_group_events_live_test.exs`, `e2e/test/components/tooltip_events_live_test.exs`, `e2e/test/components/tree_view_events_live_test.exs`, and `e2e/test/components/file_upload_live_test.exs` (includes `/file-upload/events` `render_click`) for LiveView `render_click` on component event pages (many use `live(..., on_error: :warn)` like `dialog_events_live_test.exs` where preview and code-tab markup duplicate ids); `e2e/test/components/live_doc_route_smoke_test.exs` for mounting doc playground, API, patterns, animation, and controlled routes from `E2eWeb.DocA11yRoutes` (`live(..., on_error: :warn)` on each route where duplicate ids appear on those doc pages); `e2e/test/components/switch_test.exs` and `e2e/test/components/combobox_test.exs` for Switch and Combobox Wallaby `ComponentBehaviorSpec` pilots (including theme/mode scoped axe on playgrounds); `e2e/test/e2e/form/terms_and_angle_slider_form_test.exs`, `e2e/test/e2e/form/preferences_form_test.exs`, `e2e/test/e2e/form/pin_input_form_test.exs`, `e2e/test/e2e/form/select_form_test.exs`, and `e2e/test/e2e/form/combobox_form_test.exs` for form metadata and changeset messages. Keep Wallaby pilots on checkbox, angle slider, combobox, and switch routes where Zag and the toast hook matter.
