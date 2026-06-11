# Corex Design

[![Hex.pm Version](https://img.shields.io/hexpm/v/corex_design)](https://hex.pm/packages/corex_design)
[![Hex.pm License](https://img.shields.io/hexpm/l/corex_design)](https://hex.pm/packages/corex_design)

Optional compile-time design pipeline for [Corex](https://hexdocs.pm/corex). Generates theme tokens and component CSS from Elixir recipes into a Tailwind bundle under `assets/css/`.

Requires **Elixir ~> 1.18**, **OTP 27+**, and `{:corex, "~> 0.2"}`.

## Installation

```elixir
def deps do
  [
    {:corex, "~> 0.2"},
    {:corex_design, "~> 0.2"}
  ]
end
```

Register the compiler in your host `mix.exs`:

```elixir
compilers: Mix.compilers() ++ [:corex_design]
```

Configure output and themes:

```elixir
config :corex, Corex.Design,
  output: "assets/css/corex.tailwind.css"
```

Import the bundle from your app CSS:

```css
@import "./corex.tailwind.css";
```

See [Styled](https://hexdocs.pm/corex/styled.html) and [Design configuration](https://hexdocs.pm/corex/design-config.html) on Hexdocs for the full setup.

## Development (monorepo)

From the `design/` directory in the Corex repository:

```bash
mix deps.get
mix lint
mix test
mix docs
```

`mix lint` runs format, compile (warnings as errors), Credo (`--strict`), and Sobelow.

The `:corex` dependency resolves to the sibling checkout (`path: ".."`) for local work and CI.

## Publishing to Hex

Hex packages cannot depend on path deps. Before `mix hex.publish`, use the Hex dependency override:

```bash
COREX_DESIGN_PUBLISH=1 mix deps.get
COREX_DESIGN_PUBLISH=1 mix hex.publish
```

With `COREX_DESIGN_PUBLISH=1`, `mix.exs` declares `{:corex, "~> 0.2.0"}` instead of `path: ".."`.

## Documentation

- [Corex.Design](https://hexdocs.pm/corex_design) — API and configuration
- [Corex guides](https://hexdocs.pm/corex/design.html) — how design fits in Phoenix apps
