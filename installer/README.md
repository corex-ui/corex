## mix corex.new

Provides `corex.new` installer as an archive.

To install from Hex, run:

    $ mix archive.install hex corex_new

To build and install it locally,
ensure any previous archive versions are removed:

    $ mix archive.uninstall corex_new

Then run:

    $ cd installer
    $ MIX_ENV=prod mix do archive.build + archive.install
