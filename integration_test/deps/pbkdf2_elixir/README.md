# Pbkdf2

[![Build Status](https://travis-ci.com/riverrun/pbkdf2_elixir.svg?branch=master)](https://travis-ci.com/riverrun/pbkdf2_elixir)
[![Module Version](https://img.shields.io/hexpm/v/pbkdf2_elixir.svg)](https://hex.pm/packages/pbkdf2_elixir)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/pbkdf2_elixir/)
[![Total Download](https://img.shields.io/hexpm/dt/pbkdf2_elixir.svg)](https://hex.pm/packages/pbkdf2_elixir)
[![License](https://img.shields.io/hexpm/l/pbkdf2_elixir.svg)](https://github.com/riverrun/pbkdf2_elixir/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/riverrun/pbkdf2_elixir.svg)](https://github.com/riverrun/pbkdf2_elixir/commits/master)
[![Join the chat at https://gitter.im/comeonin/Lobby](https://badges.gitter.im/comeonin/Lobby.svg)](https://gitter.im/comeonin/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Pbkdf2 password hashing library for Elixir.

Pbkdf2 is a well-tested password-based key derivation function that can be
configured to remain slow and resistant to brute-force attacks even as
computational power increases.

## Comparison with the Plug.Crypto version of Pbkdf2

If you want the Pbkdf2 output to be in binary (raw) or hex format, you might
find [Plug.Crypto.KeyGenerator](https://hexdocs.pm/plug_crypto/Plug.Crypto.KeyGenerator.html)
more convenient.

## Installation

1.  Add `:pbkdf2_elixir` to the `deps` section of your `mix.exs` file:

    ```elixir
    def deps do
      [
        {:pbkdf2_elixir, "~> 2.0"}
      ]
    end
    ```

2.  Optional: during tests (and tests only), you may want to reduce the number of rounds
so it does not slow down your test suite. If you have a `config/test.exs`, you should
add:

    ```elixir
    config :pbkdf2_elixir, :rounds, 1
    ```

## Comeonin wiki

See the [Comeonin wiki](https://github.com/riverrun/comeonin/wiki) for more
information on the following topics:

* [Algorithms](https://github.com/riverrun/comeonin/wiki/Choosing-the-password-hashing-algorithm)
* [Requirements](https://github.com/riverrun/comeonin/wiki/Requirements)
* [Deployment](https://github.com/riverrun/comeonin/wiki/Deployment)
  * including information about using Docker
* [References](https://github.com/riverrun/comeonin/wiki/References)

## Contributing

There are many ways you can contribute to the development of this library, including:

* Reporting issues
* Improving documentation
* Sharing your experiences with others

## Copyright and License

Copyright (c) 2014-2021 David Whitlock (alovedalongthe@gmail.com)

This software is licensed under [the BSD-3-Clause license](./LICENSE.md).
