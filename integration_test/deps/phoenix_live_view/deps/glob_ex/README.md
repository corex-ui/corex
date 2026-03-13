# GlobEx

[![Hex.pm versions](https://img.shields.io/hexpm/v/glob_ex.svg?style=flat-square)](https://hex.pm/packages/glob_ex)
[![GitHub: CI status](https://img.shields.io/github/actions/workflow/status/hrzndhrn/glob_ex/ci.yml?branch=main&style=flat-square)](https://github.com/hrzndhrn/glob_ex/actions)
[![Coveralls: coverage](https://img.shields.io/coverallsCoverage/github/hrzndhrn/glob_ex?style=flat-square)](https://coveralls.io/github/hrzndhrn/glob_ex)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://github.com/hrzndhrn/glob_ex/blob/main/LICENSE.md)

An implementation of `glob`.

GlobEx offers among others the functions `GlobEx.ls/1` and `GlobEx.match?/2`.
Furthermore, the sigil `~g||` is provided.

The function `GlobEx.ls/1` returns the same result as `Path.wildcard/2`.
`GlobEx.match?/2` can be used to check whether a `path` is matching a given
`glob`.

## Example

```elixir
iex(1)> import GlobEx.Sigils
GlobEx.Sigils
iex(2)> GlobEx.match?(~g|{lib,test}/**/*.{ex,exs}|, "test/test_helper.exs")
true
iex(3)> GlobEx.match?(~g|{lib,test}/**/*.{ex,exs}|, "test/unknown.exs")
true
iex(4)> GlobEx.match?(~g|{lib,test}/**/*.{ex,exs}|, "test/unknown.foo")
false
iex(5)> GlobEx.ls(~g|{lib,test}/**/*.{ex,exs}|)
["lib/glob_ex.ex", "lib/glob_ex/compiler.ex", "lib/glob_ex/compiler_error.ex",
 "lib/glob_ex/sigils.ex", "test/glob_ex/compiler_test.exs",
 "test/glob_ex_test.exs", "test/test_helper.exs"]
iex(6)> GlobEx.ls(~g|*.exs|) # ignores files with a starting dot
["mix.exs"]
iex(7)> GlobEx.ls(~g|*.exs|d) # files starting with a dot will not be treated specially
[".credo.exs", ".formatter.exs", "mix.exs"]
```

## Benchmarks

The repo contains some benchmarks.

The benchmark [`ls_bench`](https://github.com/hrzndhrn/glob_ex/blob/main/bench/reports/ls_bench.md)
shows that `GlobEx.ls/2` and `Path.wildcard/2` are equally fast.

Another [benchmark](https://github.com/hrzndhrn/glob_ex/blob/main/bench/reports/match_bench.md) compares `GlobEx.match?/2` with
[`GlobPath.match/3`](https://hexdocs.pm/path_glob/PathGlob.html#match?/3).
