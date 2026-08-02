## Phoenix Integration Tests

This project contains integration tests for Phoenix-generated projects and Corex.

### CI (`integration-tests` job)

CI (`.github/workflows/elixir.yml`) installs **`phx_new`** and locally built **`corex_new`**, then runs,
in order:

The matrix runs **latest** `phx_new` on each OTP / Elixir row, then repeats all three rows with **pinned
`phx_new 1.8.7`** (aligned with `installer/mix.exs` `@phoenix_version`) so `corex.new` stays compatible
with older Phoenix installers as well as current Hex releases.

1. **`mix test --exclude extended --exclude database`**  -  fast, untagged work (no DB).
2. **`mix test --only database`**  -  uses the job’s **Postgres 15** service on **localhost:5432**
   (`PGHOST`, `PGUSER`, `PGPASSWORD`, `PGPORT`, `DATABASE_URL` set in the workflow). Includes both
   `database: :postgresql` and `database: :sqlite3` tags.
3. **`mix test --only extended`**  -  longer scenarios.

The **`dev_corex_new_test.exs`** module focuses on **`mix corex.new ... --dev <repo>`** (esbuild ESM,
hooks, `config :corex`, `use Corex`, `corex.mjs`). The filename keeps `dev_corex` for history; the
CLI flag is **`--dev <repo>`**, not `--dev-corex`.

From the **repository root**, install **`phx_new`** and local **`corex_new`**, then:

    $ cd integration_test
    $ mix deps.get
    $ mix test

**Postgres required:** default `mix test` includes `:database`-tagged tests. PostgreSQL scenarios
expect Postgres on **`localhost:5432`**. SQLite3-tagged tests do not need a service. Database-tagged
tests call `mix ecto.create` / `ecto.migrate` via `code_generator_case.ex` before starting the app.

To run only the dev checkout test:

    $ mix test test/code_generation/dev_corex_new_test.exs

## Running tests

To install dependencies, run:

    $ mix deps.get

Then run the suite (includes `:database` tags; needs Postgres for postgresql-tagged cases):

    $ mix test

Skip database tests locally without Postgres:

    $ mix test --exclude database

Or run only the dev checkout test:

    $ mix test test/code_generation/dev_corex_new_test.exs

To run only tests that target a specific database:

    $ mix test --only database:postgresql
    $ mix test --only database:sqlite3

To run every test tagged with `:database` (PostgreSQL and SQLite3):

    $ mix test --only database

For local runs that need Postgres on **`localhost:5432`**, use **`docker-compose.yml`**:

    $ docker-compose up

Or with Docker Compose installed, **`./docker.sh`** starts services and runs `mix test --include database`.

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
