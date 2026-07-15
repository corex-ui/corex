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
- Run `mix corex.design.build` into `assets/corex/`
- Build frontend assets

`assets/corex/` is generated locally (gitignored). Edit `config :corex_design` in `config/config.exs` to customize tokens, then run `mix assets.build`.

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
cd e2e
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL="ecto://postgres:postgres@localhost/e2e_dev"
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
