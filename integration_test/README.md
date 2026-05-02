## Phoenix Integration Tests

This project contains integration tests for Phoenix-generated projects and Corex.

### Current default (`--dev`)

Until new Corex / `corex_new` versions are published to Hex, CI can run an end-to-end test that
generates an app with **`mix corex.new ... --dev <repo>`** and asserts esbuild ESM flags,
JS hooks, `config :corex`, `use Corex` in the web module, and `corex.mjs` imports in `app.js`.

From the **repository root**, install Mix archives **`phx_new`** and local **`corex_new`**
(`mix archive.build` in `installer/`, then `mix archive.install` the generated `.ez`), then:

    $ cd integration_test
    $ mix deps.get
    $ mix test test/code_generation/dev_corex_new_test.exs

The test module filename keeps `dev_corex` for history; the CLI flag is **`--dev <repo>`**, not `--dev-corex`.

Older database-backed code generation tests are kept under `test/code_generation/` but are not
run in CI until the suite is re-enabled after publish.

## Running tests

To install dependencies, run:

    $ mix deps.get

Then run the focused dev checkout test (recommended):

    $ mix test test/code_generation/dev_corex_new_test.exs

To run the full suite with tests that target a specific database:

    $ mix test --include database:postgresql
    $ mix test --include database:mysql
    $ mix test --include database:mssql
    $ mix test --include database:sqlite3

For convenience, there is also a `docker-compose.yml` file that allows for starting up all of the supported databases locally.

    $ docker-compose up

This allows all tests to be run with the following command

    $ mix test --include database

Or alternatively, with docker and docker compose installed, you can just run `./docker.sh`.

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
