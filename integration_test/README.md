## Phoenix Integration Tests

This project contains integration tests for Phoenix-generated projects and Corex.

### CI (`integration-tests` job)

CI (`.github/workflows/elixir.yml`) installs **`phx_new`** and locally built **`corex_new`**, then runs,
in order:

1. **`mix test`** — matches local default; `test_helper.exs` sets `exclude: [:database]`, so untagged work runs here.
2. **`mix test --include database:postgresql`** — uses the job’s **Postgres 15** service on **localhost:5432**
   (`PGHOST`, `PGUSER`, `PGPASSWORD`, `PGPORT`, `DATABASE_URL` set in the workflow).
3. **`mix test --include database:sqlite3`** — no extra service (file-based SQLite).

**MySQL** and **MSSQL** tagged tests are **not** run in CI; run them locally with **`docker-compose`** (or equivalent)
and **`mix test --include database:mysql`** / **`database:mssql`**, or **`mix test --include database`** for everything.

The **`dev_corex_new_test.exs`** module focuses on **`mix corex.new ... --dev <repo>`** (esbuild ESM,
hooks, `config :corex`, `use Corex`, `corex.mjs`). The filename keeps `dev_corex` for history; the
CLI flag is **`--dev <repo>`**, not `--dev-corex`.

From the **repository root**, install **`phx_new`** and local **`corex_new`**, then:

    $ cd integration_test
    $ mix deps.get
    $ mix test

To run only the dev checkout test:

    $ mix test test/code_generation/dev_corex_new_test.exs

## Running tests

To install dependencies, run:

    $ mix deps.get

Then run the default suite (same slice as CI step 1; excludes `:database`):

    $ mix test

Or run only the dev checkout test:

    $ mix test test/code_generation/dev_corex_new_test.exs

To run the full suite with tests that target a specific database:

    $ mix test --include database:postgresql
    $ mix test --include database:mysql
    $ mix test --include database:mssql
    $ mix test --include database:sqlite3

For **MySQL**, **MSSQL**, or a single machine that matches **`mix test --include database`**, use
`docker-compose.yml`:

    $ docker-compose up

Then:

    $ mix test --include database

Or with Docker Compose installed, **`./docker.sh`** starts services and runs that include.

CI does **not** start MySQL/MSSQL containers; use compose (or install those servers) when you need those tags locally.

## How tests are written

In order to have consistent, repeatable builds, all dependencies for all phoenix
project variations are listed in `mix.exs` and locked via `mix.lock`. If a
dependency version needs to be updated, it can be updated with `mix.exs` or
using `mix deps.update <dep name>`.

It is also important to note that dependencies are initially compiled with
`MIX_ENV=test` and then copied to `_build/dev_` to improve test speed.
Therefore, dependencies should not be listed in `mix.exs` with an `only: <env>`
option.

All generator scenarios use **`mix corex.new`** (Phoenix `phx.new` under the hood). There is no
`igniter_new` archive requirement for these tests.
