## mix corex.new

Provides the `mix corex.new` installer as a Mix archive.

It runs `mix phx.new` with forwarded Phoenix flags (always with `--no-install`),
then writes Corex-owned layouts, HEEx, plugs, hooks, and asset stubs using EEx
scaffolds, and adds the `corex_design` dependency plus token config for generated CSS in `assets/corex/`. LiveView, HTML, esbuild, and full Phoenix assets stay enabled  -  there are no `--no-live` / `--no-html` / `--no-esbuild` / `--no-assets` switches here.

To install from Hex, run:

    $ mix archive.install hex corex_new

To build and install it locally, first remove any previous archive:

    $ mix archive.uninstall corex_new

Then:

    $ cd installer
    $ MIX_ENV=prod mix do archive.build + archive.install

See `mix help corex.new` for the full list of flags.

For adding Corex to an **existing** Phoenix app, follow the
[manual installation guide](https://hexdocs.pm/corex/manual_installation.html).
