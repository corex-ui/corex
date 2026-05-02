## mix corex.new

Provides the `mix corex.new` installer as a Mix archive.

It runs `mix phx.new` with forwarded Phoenix flags (always with `--no-install`),
then renders Corex-owned files (layouts, root layout, home, plugs, app.js,
app.css) directly from templates. LiveView, HTML, esbuild, and full Phoenix assets stay enabled — there are no `--no-live` / `--no-html` / `--no-esbuild` / `--no-assets` switches here. No Igniter, no nested generators.

To install from Hex, run:

    $ mix archive.install hex corex_new

To build and install it locally, first remove any previous archive:

    $ mix archive.uninstall corex_new

Then, from the **corex** repository root (not only `installer/`), run `mix assets.build` once so `priv/design` is synced into `installer/templates/corex_design/`. That snapshot is what `mix corex.new` copies into `assets/corex/`; skip this only if that directory is already committed or freshly built.

Then:

    $ cd installer
    $ MIX_ENV=prod mix do archive.build + archive.install

See `mix help corex.new` for the full list of flags.

For adding Corex to an **existing** Phoenix app, follow the
[manual installation guide](https://hexdocs.pm/corex/manual_installation.html).
