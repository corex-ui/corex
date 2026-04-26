# Changelog (e2e demo app)

## Unreleased (Beta routing)

- Documented the routing contract in `e2e/docs/beta-page-matrix.md` and naming notes in `e2e/docs/naming-spec.md`.
- **Router / nav**: Removed non-Zag live routes that implied Zag-only surfaces (data list/table playground–patterns stack, layout heading playground/patterns, native-input playground/API/events/patterns, navigate playground, combobox `/fetch`). Data table **deep** routes (stream, sorting, selection, full) remain; listbox **stream** is linked from the sidebar.
- **Combobox**: Server-filtered country list moved from `/combobox/fetch` into **`/combobox/patterns`** (`#country-combobox`).
- **Corex**: `Corex.Tooltip` assigns `:id` before building connect structs so auto-generated ids work. `Corex.Tabs.Connect` uses hyphenated DOM ids (`tabs-#{id}-list`, `tabs-#{id}-content-…`, etc.) and the tabs hook forwards the same shape via `@zag-js/tabs` `ids` so SSR and runtime agree; `aria-controls` and `aria-labelledby` now resolve cleanly in the DOM and author code can use `document.querySelector("#tabs-my-id-content-lorem")` without escaping `:`.
- **Tabs a11y**: `mix test test/components/tabs_test.exs` is green on `/en/tabs/{anatomy,api,events,patterns,playground}`. If you change `Corex.Tabs.Connect` or `assets/components/tabs.ts`, clear stale digested assets before re-running feature tests: `rm -rf e2e/priv/static/assets && mix esbuild e2e && mix tailwind e2e --minify`.
- **Layout heading**: Added static **`/layout-heading/style`** for parity with other non-Zag layout docs.
