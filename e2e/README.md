# E2E

End-to-end Phoenix + LiveView application used to develop, exercise, and validate **Corex UI components**.

This application acts as examples and tests for different rendering and interaction modes, as well as for end-to-end and accessibility testing.

## Getting started

Clone the Corex repository and move into the E2E application:

```bash
git clone https://github.com/corex-ui/corex
cd corex/e2e
```

## Requirements

- Elixir ~> 1.17
- Erlang/OTP compatible with Elixir 1.17 (CI runs 1.17 / OTP 26 and 1.18 / OTP 27–28)
- PostgreSQL (running locally)

Make sure PostgreSQL is running before continuing.

## Database setup

Create and migrate the database:

```bash
mix ecto.setup
```

This will:

- Create the database
- Run migrations

## Install dependencies and assets

```bash
mix setup
```

This will:

- Fetch Elixir dependencies
- Install Tailwind and Esbuild
- Build frontend assets

## Run the server

```bash
mix phx.server
```

Then visit:

```
http://localhost:4000
```

## Try in production

Build and run in prod mode locally (same DB as dev for a quick check):

```bash
# From the corex repo root: build Corex assets
cd .. && mix assets.build && cd e2e

# Set required prod env (use dev DB for local test)
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL="ecto://postgres:postgres@localhost/e2e_dev"

# Build digested assets and run
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix phx.server
```

Then open `http://localhost:4000`. Prod uses digested, minified assets (smaller `app.js` and chunks).

## Purpose

This project is **not a library**. It exists to:

- Showcase Corex UI components in realistic usage scenarios
- Validate LiveView + JS hook integration
- Test controlled and uncontrolled component behavior
- Exercise async and loading states
- Run E2E and accessibility tests

## Example types

Components are demonstrated using several architectural patterns:

### Controller-based views

Classic Phoenix controller + template examples.  
Used to validate server-rendered HTML and progressive enhancement.

### LiveView

Standard LiveView implementations where components manage state through assigns and LiveView events.

### Controlled mode

Examples where component state is **fully controlled by LiveView**, typically by passing explicit values (e.g. `value`, `open`, `checked`).  
Used to test synchronization, external state updates, and edge cases.

### Async mode

Examples that introduce **asynchronous behavior**, such as delayed data loading or background updates, to ensure components behave correctly under non-instant conditions.

## Tests

Run the full test suite:

```bash
mix test
```

This includes:

- LiveView tests
- Wallaby browser-based E2E tests
- Accessibility audits

## Gigalixir (free tier, 0.5 GB)

The public demo deploys from this app with `git push gigalixir`. Runtime config in `config/runtime.exs` uses a small DB pool (`POOL_SIZE` default 2), fewer Bandit acceptors, and LiveView `hibernate_after` for idle sockets.

Set BEAM allocator flags on the app (one-time, from the `e2e` directory):

```bash
gigalixir config:set ERL_FLAGS="+MBas aobf +MHas aobf +MPas aobf +MDas aobf +MFas aobf +MBacul 0 +MHacul 0 +MBsmbcs 64 +MBlmbcs 128 +MHsmbcs 64 +MHlmbcs 128 +MMscs 20 +SDcpu 2:2 +sbwt none +sbwtdcpu none +sbwtdio none"
```

After deploy, check idle memory:

```bash
gigalixir ps:remote_console
:erlang.memory()
```

Target: `:total` under ~180 MB at idle with headroom before LiveView connections.

## Notes

- This app depends on Corex via a local path dependency (`path: "../"`).
- Intended for development, experimentation, and regression testing.
- The Gigalixir demo is a constrained production deploy of this app.