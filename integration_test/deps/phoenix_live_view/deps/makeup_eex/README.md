# MakeupEEx

A [Makeup](https://github.com/elixir-makeup/makeup/) lexer for the EEx and HEEx languages.

## Installation

Add `makeup_eex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:makeup_eex, "~> 2.0"},
    # If using HEEx also add:
    # {:makeup_html, ">= 0.0.0"}
  ]
end
```

This package provides two lexers:

* `EExLexer` - this lexer is automatically registered for the `eex` and `html_eex` languages
* `HEExLexer` - this lexer is automatically registered for the `heex` language

It also automatically registers the `heex` language within the `~H` sigil.

Please note that for HEEx, as well as `html_eex`, you need to install a separate lexer for HTML, such as [makeup_html](https://hex.pm/packages/makeup_html).
