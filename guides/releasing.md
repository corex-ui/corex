# Releasing Corex

Maintainer checklist for publishing **corex** (Hex library + npm) and **corex_new** (installer archive).

## Version bump

Update `@version` / `"version"` in:

- `mix.exs` (root)
- `package.json`
- `installer/mix.exs`
- Path deps in `e2e/mix.exs` and `integration_test/mix.exs` if they pin a literal version

Add an `## Unreleased` or version section to `CHANGELOG.md`.

## Pre-publish checks

From the repo root:

```bash
mix pre.publish
mix test
mix assets.build
npm run check
cd e2e && mix test
cd ../installer && mix test
cd ../integration_test && mix test
MIX_ENV=docs mix docs
```

Spot-check API docs: open `doc/index.html`, confirm imperative helpers under **API** have descriptions and examples (see [API function documentation](api_documentation.html)).

Commit built assets under `priv/static/` when hooks or bundles changed.

## Publish Hex

```bash
mix hex.publish   # :corex package
cd installer && mix hex.publish   # :corex_new
```

## Publish npm

```bash
npm publish
```

## Tag and GitHub release

```bash
git tag v0.1.0
git push origin v0.1.0
```

Create a GitHub release with notes from `CHANGELOG.md`.

## Smoke test

```bash
mix archive.install hex phx_new
mix archive.install hex corex_new
mix corex.new smoke_test --no-install
```

Confirm the generated app compiles and `mix phx.server` starts.
