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
npm install
mix assets.build
mix test
npm run check
```

Optional quality checks before a PR (same as `mix pre.publish`):

```bash
mix lint
mix docs
```

`mix lint` runs `format --check-formatted`, `credo --strict`, `oeditus_credo --strict`, and `sobelow --exit` (ExSlop checks are enabled in `.credo.exs`).

### E2e app (`e2e/`)

The demo and browser tests live here. See also [`e2e/README.md`](e2e/README.md).

Linting uses the same `.credo.exs` rules as the Corex library (Credo, ExSlop, and `mix oeditus_credo --strict`).

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
| `priv/design/corex/` | Corex Design tokens and component CSS |
| `priv/static/` | Built JS bundles (generated; run `mix assets.build`) |
| `e2e/` | Demo LiveViews, Playwright-style tests, `doc_examples.ex` |
| `installer/` | `corex_new` Mix installer |
| `guides/` | Hexdocs guides |
| `test/` | Unit tests for the library |

Design CSS is copied into the installer on `mix assets.build` (`installer/priv/corex_design/`).

## Pull requests

1. Fork and branch from `main` (`feat/…`, `fix/…`, or `docs/…`).
2. Keep changes focused; one logical change per PR when possible.
3. Run the checks that match your change (see below).
4. Open a PR against `main` with a short summary and a test plan (what you ran, what you clicked).
5. CI must pass (unit, e2e, installer, integration jobs on [GitHub Actions](.github/workflows/elixir.yml)).

We use [Conventional Commits](https://www.conventionalcommits.org/) style when it helps reviewers scan history, but it is not enforced by tooling.

## What to run for your change

| Change type | Suggested checks |
| ----------- | ---------------- |
| Elixir component / API | `mix test`, `mix compile`, `mix docs` |
| TypeScript hook | `npm run check`, `mix assets.build`, relevant e2e tests |
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
- JavaScript: `npm run check` (Prettier + ESLint).

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
