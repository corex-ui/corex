# Configuration

## Introduction

Corex uses a small set of application environment keys. Most apps only need Phoenix Gettext configuration for translated component labels.

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
| `:debug` | boolean | `false` | When `true`, MCP request logging is verbose instead of silenced |
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

MCP is configured on the endpoint, not under `config :corex`. See [MCP](MCP.html). Enable only in `:dev` (or `:test` in generated apps); never in `:prod`.

## Related

- [Localize](localize.html) — locales and Gettext setup
- [MCP](MCP.html) — development tooling endpoint
- [Installation](installation.html) — first-time setup
