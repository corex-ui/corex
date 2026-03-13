# TextDiff

[![Hex.pm versions](https://img.shields.io/hexpm/v/text_diff.svg?style=flat-square)](https://hex.pm/packages/text_diff)
[![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/text_diff/)
[![GitHub: CI status](https://img.shields.io/github/actions/workflow/status/hrzndhrn/text_diff/ci.yml?branch=main&style=flat-square)](https://github.com/hrzndhrn/text_diff/actions)
[![Coveralls: coverage](https://img.shields.io/coverallsCoverage/github/hrzndhrn/text_diff?style=flat-square)](https://coveralls.io/github/hrzndhrn/text_diff)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://github.com/hrzndhrn/text_diff/blob/main/LICENSE.md)

`TextDiff` returns a formatted diff between two strings.

## Installation

The package can be installed by adding `text_idff` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:text_diff, "~> 0.1"}
  ]
end
```

## Example

```elixir
iex> code = """
...> defmodule Foo do
...>   @moduledoc   false
...>
...>   def foo, do:  :foo
...>
...>   def three_times(x) do
...>     {x,
...>      x,x}
...>   end
...>
...>   def bar(x) do
...>     {:bar, x}
...>   end
...> end\
...> """
...> formatted = code |> Code.format_string!() |> IO.iodata_to_binary()
...> code
...> |> TextDiff.format(formatted, color: false)
...> |> IO.iodata_to_binary()
...> |> IO.puts()
"""
1  1   |defmodule Foo do
2    - |  @moduledoc   false
  2 + |  @moduledoc false
3  3   |
4    - |  def foo, do:  :foo
  4 + |  def foo, do: :foo
5  5   |
6  6   |  def three_times(x) do
7    - |    {x,
8    - |     x,x}
  7 + |    {x, x, x}
9  8   |  end
10  9   |
   ...|
"""
```
The colorised diff is shown below:

![Colorised diff](images/diff.png)
