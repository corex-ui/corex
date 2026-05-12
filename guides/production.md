# Production

Corex is built to be production-ready: every component compiles to plain HEEx + ESM JavaScript, the JS bundle is split per-component so unused hooks are never shipped, and the design CSS layers are the same files you used in development. This guide covers building and running your app with Corex in a local production environment. A full deployment guide is coming.

## 1. Environment

Generate a secret:

```bash
mix phx.gen.secret
```

Create a `.env` file at the root of your project (and add it to `.gitignore`). Set your secret and database  -  for local testing you can point at the dev database:

```bash
export SECRET_KEY_BASE="__YOUR_SECRET__"
export DATABASE_URL="ecto://postgres:postgres@localhost/my_app_dev"
```

Load it in your shell:

```bash
source .env
```

## 2. Build and run

Three commands compile, build the digested assets (CSS + ESM JS), and start the server:

```bash
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix phx.server
```

`mix assets.deploy` runs Tailwind and Esbuild with `--minify` and then digests the output. Because the Corex JS bundle is built with `--format=esm --splitting`, you'll see one entry chunk plus a per-component chunk under `priv/static/assets/js/`.

Visit [http://localhost:4000/](http://localhost:4000/).

Open your browser's Network tab to inspect the digested asset filenames and confirm each component chunk only loads when that component appears on a page.
