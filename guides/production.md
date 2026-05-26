# Production

## Introduction

You build and run a Phoenix app with Corex in production locally. Corex ships as plain HEEx plus ESM JavaScript; `mix assets.deploy` minifies and digests the same CSS and per-hook chunks you use in development.

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| `SECRET_KEY_BASE` | `mix phx.gen.secret` |
| Database URL | Production or local stand-in |
| ESM Esbuild | `--format=esm --splitting` from [Manual installation](manual_installation.html) |

## How it works

1. `MIX_ENV=prod mix compile` builds the release artifacts.
2. `mix assets.deploy` runs Tailwind and Esbuild with `--minify`, then digests files under `priv/static`.
3. With splitting enabled, you get an entry chunk plus one chunk per lazy hook under `priv/static/assets/js/`.

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

## Related

- [Manual installation](manual_installation.html) — Esbuild ESM setup
- [Design](design.html) — CSS you import is the same in prod
