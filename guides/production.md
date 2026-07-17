# Production

## Introduction

You build and run a Phoenix app with Corex in production. Corex ships as plain HEEx plus ESM JavaScript; `mix assets.deploy` minifies and digests the same CSS and per-hook chunks you use in development.

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| `SECRET_KEY_BASE` | `mix phx.gen.secret` |
| Database URL | Production or local stand-in |
| ESM Esbuild | `--format=esm --splitting` from [Manual installation](manual_installation.html) |
| Design (if used) | `corex.design.build` runs before Tailwind/Esbuild in `assets.deploy` |
| MCP | Mount only in `:dev` / `:test`; never enable in `:prod` |

## How it works

1. `MIX_ENV=prod mix compile` builds the app.
2. `mix assets.deploy` should run `mix corex.design.build` (when you use Design), then Tailwind and Esbuild with `--minify`, then digest files under `priv/static`.
3. With ESM splitting, you get an entry chunk plus one chunk per lazy hook under `priv/static/assets/js/`.

## Steps

Generate a secret:

```bash
mix phx.gen.secret
```

Set environment variables (example `.env`, add to `.gitignore`):

```bash
export SECRET_KEY_BASE="__YOUR_SECRET__"
export DATABASE_URL="ecto://postgres:postgres@localhost/my_app_dev"
```

```bash
source .env
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix phx.server
```

Visit [http://localhost:4000/](http://localhost:4000/).

For a release, run the same asset pipeline in your release build (Docker/`mix release`) so `priv/static` includes digested CSS and JS. Keep `plug Corex.MCP` out of the production endpoint.

## Related

- [Manual installation](manual_installation.html) — Esbuild ESM and Design aliases
- [Design](design.html) — CSS you import is the same in prod
- [MCP](MCP.html) — never enable in `:prod`
