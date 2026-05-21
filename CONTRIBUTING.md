# Contributing to Corex

Thank you for helping improve Corex. This guide covers local setup, where code lives, conventions the maintainers expect, and how to open a pull request.

## Ways to contribute

- Fix bugs or improve accessibility behavior (Zag.js hooks, ARIA, keyboard).
- Add or refine components, design tokens, or documentation.
- Extend the e2e demo app so new behavior is visible and testable.
- Improve guides, moduledoc, or translation defaults.

For large features (new components, API changes), open an issue first so we can align on scope and naming.

## Development setup

### Requirements

- **Elixir** `~> 1.17` and a compatible **Erlang/OTP** (CI runs 1.17 / OTP 26 and 1.18 / OTP 27–28).
- **Node.js** 24 and **npm** (root package: hooks, esbuild, lint).
- **pnpm** 10.x for the e2e app assets.
- **PostgreSQL** for e2e and some integration tests.

### Core library (repo root)

```bash
git clone https://github.com/corex-ui/corex.git
cd corex
mix deps.get
pnpm install
mix assets.build
mix test
pnpm run check
```

### Test coverage

- **`:corex` (root):** 90% minimum via Coveralls on `lib/`, excluding struct-only and Mix codegen modules listed in `coveralls.json` (see file for the current skip list).
- **`:corex_new` (installer):** 90% via `mix test --cover` in `installer/`.
- **e2e / integration_test:** functional tests; not counted in root Coveralls.
- **`assets/` (Vitest + TypeScript):** `pnpm test` runs Vitest (hooks, components, lib); `pnpm run lint:js` runs typecheck, Prettier, ESLint, and generated `.d.ts` check (CI **Lint** job); `pnpm run check` runs `pnpm test` then `pnpm run lint:js` (local pre-PR). `pnpm run typecheck` and `pnpm run lint` are also available individually.

Optional quality checks before a PR (same as `mix pre.publish`):

```bash
mix lint
mix docs
```

`mix lint` runs `format --check-formatted`, `credo --strict`, and `sobelow --exit`. OeditusCredo and ExSlop checks are enabled in `.credo.exs` and run via `mix credo --strict` (not `mix oeditus_credo`, which uses a separate default config).

### E2e app (`e2e/`)

The demo and browser tests live here. See also [`e2e/README.md`](e2e/README.md).

Linting uses the same `.credo.exs` rules as the Corex library (Credo, ExSlop, and OeditusCredo checks via `mix credo --strict`).

```bash
cd e2e
mix deps.get
mix lint
mix ecto.setup
pnpm install
mix setup
mix phx.server
```

Visit [http://localhost:4000](http://localhost:4000).

### Installer (`installer/`)

```bash
cd installer
mix deps.get
mix test
```

### Integration tests (`integration_test/`)

Generates apps with `corex.new` and asserts install paths. Requires `mix archive.install hex phx_new` and a built local `corex_new` archive (see [`.github/workflows/elixir.yml`](.github/workflows/elixir.yml)).

## Repository layout

| Path | Purpose |
| ---- | ------- |
| `lib/components/` | Phoenix components (`Corex.*`), moduledoc, `attr` / `slot` |
| `lib/components/<name>/` | Connect, anatomy, translation modules |
| `assets/hooks/` | LiveView hooks (TypeScript, Zag.js) |
| `assets/lib/` | Shared TS helpers (`util`, `respond-to`, `read-props`, …); tests in `assets/lib/*.test.ts` |
| `assets/components/` | Zag `Component` subclasses; colocated `*.test.ts` per module (helpers + smoke); all modules in `components-contract.test.ts` and `components-smoke.test.ts` |
| `assets/hooks/` | LiveView hooks; hook-specific logic in `hooks/<name>.ts` + `hooks/<name>.test.ts`; wiring in `hooks-wiring.test.ts` |
| `priv/design/corex/` | Corex Design tokens and component CSS (source of truth in the package) |
| `priv/static/` | Built JS bundles (generated; run `mix assets.build`) |
| `e2e/` | Demo LiveViews, Playwright-style tests, `doc_examples.ex` |
| `installer/` | `corex_new` Mix installer |
| `guides/` | Hexdocs guides |
| `test/` | Unit tests for the library |

Design CSS is copied into the installer on `mix assets.build` (`installer/priv/corex_design/`). Consumer apps get a vendored copy via `mix corex.design` into `assets/corex/` (not checked into the `:corex` library repo).

## Pull requests

1. Fork and branch from `main` (`feat/…`, `fix/…`, or `docs/…`).
2. Keep changes focused; one logical change per PR when possible.
3. Run the checks that match your change (see below).
4. Open a PR against `main` with a short summary and a test plan (what you ran, what you clicked).
5. CI must pass on [GitHub Actions](.github/workflows/elixir.yml): **Lint** (Elixir + TypeScript static checks), **Hooks** (Vitest), **Unit tests**, **E2E tests**, **Installer tests**, **Integration tests**.

We use [Conventional Commits](https://www.conventionalcommits.org/) style when it helps reviewers scan history, but it is not enforced by tooling.

## What to run for your change

| Change type | Suggested checks |
| ----------- | ---------------- |
| Elixir component / API | `mix test`, `mix compile`, `mix docs` |
| TypeScript `assets/lib/` | `pnpm test` or `pnpm run check` |
| TypeScript `assets/components/` or `assets/hooks/` | `pnpm test` + `mix assets.build` |
| TypeScript hook (behavior in browser) | `pnpm run check`, `mix assets.build`, relevant e2e tests |

### TypeScript test layout (`pnpm test`)

| Path | Expectation |
| ---- | ----------- |
| `assets/lib/*.ts` | Colocated `assets/lib/<name>.test.ts` for every module except `core.ts` (abstract base) |
| `assets/components/*.ts` | Tests under `assets/test/component/` (per-module + `components-contract.test.ts` + `components-smoke.test.ts`) |
| `assets/hooks/*.ts` | Tests under `assets/test/hooks/` (per-hook lifecycle + parser tests + `hooks-contract.test.ts`) |
| `assets/test/helpers/` | Shared DOM fixtures (`dom.ts`, `component-fixture.ts`, `component-smoke.ts`, `mock-live-socket.ts`, `expect-hook.ts`) |

New shared helper → `assets/lib/<name>.test.ts`. New component or hook tests → `assets/test/component/<name>.test.ts` or `assets/test/hooks/<name>.test.ts`. Export small pure functions from hooks when logic is not otherwise testable.
| Design CSS | `mix assets.build`, visual check in e2e styling pages |
| Moduledoc only | `mix docs` (fix any warnings) |
| Installer | `cd installer && mix test` |
| E2e LiveView / demo | `cd e2e && mix test` |
| New public API | Unit test + e2e demo or test covering the behavior |

Coverage is tracked on CI (Coveralls); aim not to lower coverage on touched modules.

## Component and documentation conventions

Reference: [`Corex.Accordion`](lib/components/accordion.ex) moduledoc and [`E2eWeb.DocPageMatrix`](e2e/lib/e2e_web/doc_page_matrix.ex) for which doc page types exist per component.

### Moduledoc structure

Use H2 sections in this order when applicable: **Anatomy**, **API**, **Events**, **Patterns**, **Animation**, **Style**, **Form**. Omit sections the component does not need. Match page keys in `E2eWeb.DocPageMatrix` when adding e2e doc routes.

- Examples in moduledoc must be copy-paste ready (inline `Corex.Content.new/1`, stable `id`, root `class`).
- Keep e2e demo code (`e2e/lib/e2e_web/demos/*_demo.ex`) in sync with the same examples.
- Shared list data: [`E2eWeb.Demos.DocExamples`](e2e/lib/e2e_web/demos/doc_examples.ex).

### Translations

Components with a `translation` assign use `Corex.<Component>.Translation`:

- `default/0` — strings via `Corex.Gettext.gettext/1`
- `merge/2` — partial overrides; `nil` / `""` fall back via `Corex.Translation.take/2`
- Module `@moduledoc` — table `Field | Default | Used for`
- `attr(:translation, …, default: nil)` and `Map.get(assigns, :translation)` before merge

### `attr` and `slot`

Every `attr` and `slot` should have a `doc:` (except `rest` / `:global`).

### Code style

- Run `mix format` on Elixir changes.
- No comments in source unless required by tooling (see project rules).
- JavaScript: `pnpm run check` (Vitest + `lint:js`).

### Corex Design CSS

- Modifiers use BEM-style classes on the host: `accordion accordion--accent accordion--lg`.
- Implement modifiers with `@utility <component>--*` in `priv/design/corex/components/<name>.css`.
- Document Color / Size (and other axes) in the component **Style** section as modifier tables.

## Adding or changing a component (checklist)

1. Zag hook under `assets/hooks/` and register in the build if new.
2. Elixir component, Connect, anatomy, tests under `test/`.
3. Optional design CSS under `priv/design/corex/components/`.
4. E2e anatomy / API / events / styling / patterns pages as needed.
5. Moduledoc + `Translation` module if user-facing strings exist.
6. `mix assets.build`, `mix test`, `cd e2e && mix test`.

## Reporting issues

Include Elixir/OTP versions, browser if UI-related, minimal reproduction (e2e route or HEEx snippet), and expected vs actual behavior. Security issues: please report privately to the maintainers rather than in a public issue.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE) used by this project.
