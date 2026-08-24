# AGENTS.md

## Cursor Cloud specific instructions

Corex is an Elixir/Phoenix (LiveView) component-library monorepo with a TypeScript/Zag.js
hooks client. Standard developer commands live in `CONTRIBUTING.md` and each project's
`mix.exs` aliases / `package.json` scripts — prefer those as the source of truth. The notes
below only capture non-obvious, durable caveats for this environment.

### Toolchain (already provisioned)

- Elixir `1.19.5-otp-28`, Erlang `28.3.1`, and Node `24` are managed by `asdf` and exposed
  through `~/.asdf/shims`, which is already first on `PATH`. So `mix`, `elixir`, `node`, and
  `pnpm` (via Corepack, pinned to 10.33.0) work in a fresh shell with no extra sourcing.
- The update script only refreshes dependencies (`mix deps.get` per project + `pnpm install`).
  It intentionally does not build assets, run migrations, or start services.

### PostgreSQL (required for e2e + integration tests)

- PostgreSQL 16 is installed locally with role `postgres` / password `postgres` on
  `localhost:5432` (matches `e2e/config/*.exs`). It is NOT auto-started on a fresh VM.
- Start it before running the e2e app or any DB-backed tests:
  `sudo pg_ctlcluster 16 main start`

### Running the e2e app (the end-to-end product)

- `cd e2e && mix phx.server` serves the LiveView demo at http://localhost:4000.
- Routes are locale-prefixed: use e.g. `/en/accordion/playground`, `/en/combobox/playground`,
  or `/en/admins` (a demo-only DB-backed CRUD LiveView). Bare `/` redirects to `/en`.
- First run in a fresh checkout: `cd e2e && mix setup` (fetches deps, creates/migrates/seeds
  the DB, and builds assets). Live reload uses `inotify-tools` (installed); a missing-watcher
  warning is harmless.

### Non-obvious gotchas

- Root `mix assets.build` (and `mix setup`) end by shelling into `design/`
  (`mix corex.design.build`). The `design/` project's deps must be fetched first
  (`cd design && mix deps.get`) or it fails with a `MatchError` in `sync_no_design_corex_export/1`.
- JS lint/typecheck (`pnpm run typecheck`, `lint:js`, `check`) invoke `tsc`, but `typescript`
  is only a transitive (peer) dependency, so pnpm does not link `tsc` into `node_modules/.bin`
  and you get `tsc: not found`. Run those with the hoisted bin on `PATH`:
  `PATH="$PWD/node_modules/.pnpm/node_modules/.bin:$PATH" pnpm run check`.
  Plain `pnpm test` (Vitest) needs no workaround. (CI resolves `tsc` on GitHub runners, so this
  only affects local/cloud runs.)
- The e2e browser tests use Wallaby + headless Chrome and require `chromedriver` on `PATH`
  matching the installed Google Chrome (148). It is installed at `/usr/local/bin/chromedriver`.
  Without it, the entire e2e suite fails to boot (Wallaby raises at application start), not just
  the browser tests.
- The `e2e/` app installs JS assets with `pnpm install --frozen-lockfile --ignore-workspace`
  (it is a pnpm-workspace member but its assets are managed independently).

### Where things are

- Root library `corex` (repo root): `mix test`, `mix lint`, `mix assets.build`.
- `e2e/`: Phoenix demo + browser/a11y tests. `design/`, `mcp/`, `installer/`,
  `integration_test/` are separate Mix projects (each needs its own `mix deps.get`).
- `mix ci` (repo root) runs the packages + JS gate; e2e and integration_test are separate
  because they need Postgres.
