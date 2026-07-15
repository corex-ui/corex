# Configuration

## Introduction

Corex uses a small set of application environment keys. Most apps only need Phoenix Gettext configuration for translated component labels.

## Config map

Theme CSS, the theme picker, and generator layout flags are three different knobs. Do not put picker allowlists under `config :corex`.

| Config | Role | Details |
| ------ | ---- | ------- |
| `config :corex` | Generators and debug | `debug`, `generators` (including `layout: [theme: true, mode: true]`) for `mix corex.gen.*` only. See below. |
| `config :corex_design` | Build-time CSS | Which theme CSS, components, and semantics `mix corex.design.build` emits (`themes`, `default_theme`, `default_mode`, …). See [Design](design.html). List allowed keys with `mix corex.design.options`. |
| `config :my_app, :themes` | Runtime picker allowlist | Which theme names plugs / Tableau `Config` / JS may switch among (default = first entry). See [Theming](theming.html). Keep this a subset of what `:corex_design` emits. |
| `config :corex_mcp` | MCP endpoint | Separate Hex package; see [MCP](https://hexdocs.pm/corex_mcp/MCP.html). |

Corex Design colors come from `[data-theme][data-mode]` on `<html>`. Build which theme CSS exists with `:corex_design`. Decide which names the UI may switch among with `:my_app` `:themes`. Persist with cookies / `phx:*` (Phoenix) or `data-*` localStorage (Tableau).

## Before you start

| Requirement | Notes |
| ----------- | ----- |
| Phoenix app | `config/config.exs` loaded at runtime |

## Translations (Gettext)

Corex reads the same backend as Phoenix templates:

```elixir
config :phoenix,
  gettext_backend: MyAppWeb.Gettext
```

Components with a `translation` assign (Select, Editable, Dialog, and others) use this backend for default labels when no struct is passed. See [Localize](localize.html).

## `config :corex`

| Key | Type | Default | Purpose |
| --- | ---- | ------- | ------- |
| `:debug` | boolean | `false` | When `true`, verbose logging in Corex (also enables MCP debug if `corex_mcp` is present) |
| `:generators` | keyword | `[]` | Options for `mix corex.gen.live` and `mix corex.gen.html` (see below) |

Generator keys:

| Key | Values | Purpose |
| --- | ------ | ------- |
| `:gettext` | `true`, `:sigils`, or omit | When `true`, generated copy uses `gettext/1`. When `:sigils`, uses `~t` (needs `gettext_sigils` in `html_helpers`). |
| `:gettext_sigils` | boolean | Alias for `gettext: :sigils` |
| `:layout` | keyword | `mode: true`, `theme: true`, `locale: true` wire `Layouts.app` assigns in generated LiveViews / HTML |

`mix corex.new --lang` writes `gettext: :sigils` and `layout: [locale: true]` (plus `mode` / `theme` when those flags are set). Generators also auto-detect `GettextSigils` in `lib/my_app_web.ex` when config is omitted.

Example:

```elixir
config :corex,
  debug: false,
  generators: [
    gettext: :sigils,
    layout: [locale: true, mode: true, theme: true]
  ]
```

Phoenix uses a similar pattern on the web app, for example `config :my_app, :generators, context_app: :my_app`. Corex reads `config :corex, :generators` for layout and translation behavior in `mix corex.gen.*`.

## MCP

MCP lives in the separate Hex package `corex_mcp`. Mount `plug Corex.MCP` on the endpoint and configure `config :corex_mcp` (see [MCP](https://hexdocs.pm/corex_mcp/MCP.html)). Enable only in `:dev` (or `:test` in generated apps); never in `:prod`.

## Related

- [Design](design.html): `config :corex_design` and bundle filtering
- [Theming](theming.html): runtime `data-theme` picker
- [Dark mode](dark_mode.html): runtime `data-mode` toggle
- [Localize](localize.html): locales and Gettext setup
- [MCP](https://hexdocs.pm/corex_mcp/MCP.html): development tooling endpoint (`corex_mcp`)
- [Installation](installation.html): first-time setup
