# E2E Beta page matrix (routing contract)

This file classifies each Corex demo component and lists which **page types** exist in the e2e app. **Non-Zag** components usually expose only **Anatomy** (and **Style** or **Form** where applicable); they typically do **not** ship Playground, API, Events, or Pattern routes (**data table** is an exception with a unified Pattern page). **Zag** components follow the Accordion shell for those live pages where the primitive supports them. **Deep** routes are extra LiveViews kept for real scenarios (streams, sorting, combobox async, and so on).

| Component | Class | Anatomy | Style | Form | Playground | API | Events | Patterns | Animation | Deep / extra |
|-----------|--------|---------|-------|------|------------|-----|--------|----------|-----------|--------------|
| accordion | Zag | yes | yes | — | yes | yes | yes | yes | yes | — |
| action | non-Zag | yes | yes | — | — | — | — | — | — | — |
| angle-slider | Zag + form | yes | yes | yes | yes | yes | yes | yes | — | live-form, controlled |
| avatar | Zag | yes | yes | — | yes | yes | yes | — | — | — |
| carousel | Zag | yes | yes | — | yes | yes | yes | — | — | — |
| checkbox | Zag + form | yes | yes | yes | yes | yes | yes | yes | — | live-form, controlled |
| clipboard | Zag | yes | yes | — | yes | yes | yes | — | — | — |
| collapsible | Zag | yes | yes | — | yes | yes | yes | yes | — | — |
| code | non-Zag | yes | yes | — | — | — | — | — | — | — |
| color-picker | Zag + form | yes | — | yes | yes | yes | yes | — | — | live-form |
| combobox | Zag + form | yes | yes | yes | yes | yes | yes | yes (incl. server filter) | — | live-form |
| data-list | non-Zag | yes | — | — | — | — | — | — | — | — |
| data-table | non-Zag | yes | — | — | — | — | — | yes (unified) | — | `/data-table/patterns` only (anatomy is static) |
| date-picker | Zag + form | yes | — | yes | yes | yes | yes | yes | — | live-form, controlled |
| dialog | Zag | yes | — | — | yes | yes | yes | yes | yes | — |
| editable | Zag + form | yes | yes | yes | yes | yes | yes | — | — | live-form |
| floating-panel | Zag | yes | — | — | yes | yes | yes | yes | — | — |
| layout-heading | non-Zag | yes | yes | — | — | — | — | — | — | — |
| listbox | Zag | yes | — | — | yes | yes | yes | yes | — | stream |
| marquee | Zag | yes | — | — | — | yes | yes | — | — | — |
| menu | Zag | yes | — | — | yes | yes | yes | yes | — | — |
| native-input | non-Zag + form | yes | — | yes | — | — | — | — | — | live-form |
| navigate | non-Zag | yes | yes | — | — | — | — | — | — | — |
| number-input | Zag + form | yes | yes | yes | yes | yes | yes | yes | — | live-form |
| password-input | Zag + form | yes | — | yes | yes | yes | yes | — | — | live-form |
| pin-input | Zag + form | yes | — | yes | yes | yes | yes | — | — | live-form |
| radio-group | Zag + form | yes | — | yes | yes | yes | yes | yes | — | live-form |
| select | Zag + form | yes | yes | yes | yes | yes | yes | yes | — | live-form, controlled |
| signature | Zag + form | yes | — | yes | yes | yes | yes | yes | — | live-form |
| switch | Zag + form | yes | yes | yes | yes | yes | yes | yes | — | live-form, controlled |
| tabs | Zag | yes | — | — | yes | yes | yes | yes | — | — |
| timer | Zag | yes | — | — | yes | yes | yes | yes | — | — |
| toast | Zag | — | — | — | yes | yes | — | yes | — | — |
| toggle-group | Zag | yes | — | — | yes | yes | yes | yes | — | — |
| tooltip | Zag | yes | — | — | yes | yes | yes | — | — | — |
| tree-view | Zag | yes | yes | — | yes | yes | yes | yes | yes | — |

## Events pages (Zag)

Events LiveViews document server `handle_event` flows and client-side listeners. When lists or tables are part of the narrative, prefer **streams** and **`<.data_table>`** as in the Accordion reference implementation.

## Combobox async search

Server-driven search for **airports** and **cities** lives on **`/combobox/patterns`** (`#combobox-patterns-airports-doc`, `#combobox-patterns-cities-doc`).

## Router reconciliation notes

- **Number input · Events** — `/:locale/number-input/events` is registered as `NumberInputEventsLive`; the matrix marks **Events** as **yes** (not “—”).
- **Navigate** — anatomy and style only; there is no `/navigate/playground` route (playground column stays **—**).
- **Data list** — static anatomy at `/:locale/data-list/anatomy` only; no playground/API/events (unchanged).
