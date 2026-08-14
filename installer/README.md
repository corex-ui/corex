# Corex New

Mix archive that scaffolds a new Phoenix app with [Corex](https://hex.pm/packages/corex). It runs `mix phx.new` (always with `--no-install`), then writes Corex layouts, HEEx, plugs, hooks, and asset stubs, and wires optional Design and MCP by default.

Upgrading an existing app from 0.1.x: [Updating Corex](https://hexdocs.pm/corex/update.html). Adding Corex to an existing Phoenix app: [Manual installation](https://hexdocs.pm/corex/manual_installation.html).

## Requirements

- **Elixir** `~> 1.17`
- **`phx_new` archive** installed (`mix archive.install hex phx_new`)

LiveView, HTML, esbuild, and full Phoenix assets stay enabled — there are no `--no-live` / `--no-html` / `--no-esbuild` / `--no-assets` switches here.

## Packages

| Package | Kind | Purpose | `mix corex.new` |
|---------|------|---------|-----------------|
| [`corex`](https://hex.pm/packages/corex) | Hex dep | Unstyled Phoenix components, hooks, LiveView API | Always |
| [`corex_design`](https://hex.pm/packages/corex_design) | Hex dep (`runtime: false`) | Config-driven tokens, themes, and component CSS ([Design](https://hexdocs.pm/corex/design.html)) | On by default; `--no-design` to skip |
| [`corex_mcp`](https://hex.pm/packages/corex_mcp) | Hex dep (`only: [:dev, :test]`) | Dev MCP server for AI component and design discovery ([MCP](https://hexdocs.pm/corex/MCP.html)); never enable in `:prod` | On by default; `--no-mcp` to skip |
| [`corex_new`](https://hex.pm/packages/corex_new) | Mix archive | Greenfield generator (`mix corex.new`) | Install once with `mix archive.install hex corex_new` |

## Install

```bash
mix archive.install hex phx_new
mix archive.install hex corex_new
```

## Quick start

```bash
mix corex.new my_app
```

Design and MCP are on by default. Skip either with `--no-design` or `--no-mcp`.
`--no-design` ships a static neo/light `assets/corex/` export (no `corex_design` dep); `--mode` / `--theme` / `--a11y` still require Design.

Full feature set (theme / mode / locale scaffolding):

```bash
mix corex.new my_app --mode --theme --lang
```

Optional accessibility prefs UI (implies Design):

```bash
mix corex.new my_app --a11y
```

Phoenix flags are forwarded to `phx.new`. See **`mix help corex.new`** or **`Mix.Tasks.Corex.New`** for every Corex-only flag.

## Local development

Remove any previous archive, then build and install from this directory:

```bash
mix archive.uninstall corex_new
cd installer
MIX_ENV=prod mix do archive.build + archive.install
```

## Become a sponsor

Corex is open source. If you rely on it in production or want to help sustain development, [become a sponsor on GitHub](https://github.com/sponsors/corex-ui).

<p>
<a href="https://netoum.com"><img src="images/netoum.svg" alt="Netoum" height="40"></a>
</p>
