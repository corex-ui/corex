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
| `:generators` | keyword | `[]` | Generator options; `:layout` lists layout modules for `mix corex.gen.live` / `mix corex.gen.html` |

Example:

```elixir
config :corex,
  debug: false,
  generators: [layout: [MyAppWeb.Layouts]]
```

## MCP

MCP is configured on the endpoint, not under `config :corex`. See [MCP](MCP.html). Enable only in `:dev` (or `:test` in generated apps); never in `:prod`.

## Related

- [Localize](localize.html) — locales and Gettext setup
- [MCP](MCP.html) — development tooling endpoint
- [Installation](installation.html) — first-time setup
