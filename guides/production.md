# Production

Corex is built from the ground up to be ready, efficient, and easy to use from development to production. This guide covers the steps to build and run your app with Corex in a production environment on your local machine.

Deployment guide is coming soon.

## Environment

Create a secret in your terminal:

```bash
mix phx.gen.secret
```

Create a `.env` file at the root of your project and add it to `.gitignore`.

Set your secret and database (for local testing you can use the dev database):

```bash
export SECRET_KEY_BASE="__YOUR_SECRET__"
export DATABASE_URL="ecto://postgres:postgres@localhost/my_app_dev"
```

Load the variables in your shell:

```bash
source .env
```

## Build and run

```bash
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix phx.server
```

Visit http://localhost:4000/

Open your browser’s Network tab to inspect the compiled, digested assets in the production environment.
