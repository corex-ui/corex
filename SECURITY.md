# Security Policy

## Supported Versions

Security fixes are provided for the latest release on the `main` branch and the most recent tagged release on Hex.

## Reporting a Vulnerability

Do not open public GitHub issues for security vulnerabilities.

Report privately with [GitHub Security Advisories](https://github.com/corex-ui/corex/security/advisories/new). Include a description, steps to reproduce, and impact if known. We will acknowledge receipt and work on a fix or mitigation as appropriate.

Enable private reporting on this repository (GitHub → Settings → Code security → Private vulnerability reporting) if that form is not yet available.

## Trust boundaries

Corex is a UI component library and a pair of Mix generators (`mix corex.gen.live` / `mix corex.gen.html`). It is not an application framework’s auth layer.

- **Generated routes stay unauthenticated**, same as `mix phx.gen.live`. Add your own authentication and authorization.
- **`e2e/` is a published showcase** used to develop and demo Corex. It is not a starter app. Copy examples from component Hexdocs / demo sections and from the generators, not by forking `e2e/`.

## Redirect / `data-to` allowlist

`Corex.Url` and the shared JS redirect helper strip leading C0 control and space
codepoints (≤ `0x20`) before scheme checks, matching WHATWG URL parsing. Destinations
that still contain NUL, CR, or LF after that strip are rejected.

**Elixir vs JavaScript schemes (intentional):**

| Surface | Allowed |
| ------- | ------- |
| `Corex.Url` (SSR `data-to`, `<.link>`-style hrefs) | relative paths, `http`, `https`, `mailto`, `tel` |
| JS `sanitizeRedirectDestination` (hook `window.location` / `liveSocket.js()`) | relative paths, `http`, `https` |

`mailto` and `tel` are for server-rendered links, not hook-driven redirects.

## Trusted HTML (developer-controlled only)

These APIs inject HTML. Pass **developer-authored or already-sanitized** markup only — never untrusted user input.

- **Toast action labels.** `labelHtml` is set only for `%Phoenix.LiveView.Rendered{}` or `{:safe, _}`. Plain string labels use `textContent`. Client `create` ignores `:action`.
- **`Corex.Code`.** Makeup output is injected with `Phoenix.HTML.raw/1`. An HTML-capable lexer can emit markup.

## MCP

[`corex_mcp`](https://hex.pm/packages/corex_mcp) is a **dev-only** Plug (`/corex/mcp`). It refuses to start in `:prod` unless `force: true`. Defaults: loopback-only, Origin rejection on POST/config, read-only tools (no shell). See the [MCP guide](guides/MCP.md#security) for `allow_remote_access` and related options.

## LiveView / Phoenix versions

Corex still depends on `{:phoenix_live_view, "~> 1.1 or ~> 1.2"}` so generated apps on LiveView 1.1 resolve (CHANGELOG 0.2.0, [#65](https://github.com/corex-ui/corex/pull/65)). That pin does **not** replace upgrading LiveView.

For upstream `<.link>` / navigation fixes (same class as LiveView CVE-2026-58228), run Phoenix LiveView **≥ 1.2.7** and Phoenix **≥ 1.8.9**. Corex’s own URL allowlist is independent of that upgrade.

## Advisories

### 0.2.0 — Redirect / `data-to` scheme allowlist

Without stripping leading C0/space, a destination such as `<<1, "javascript:…">>`
could be treated as a relative path and later execute in the browser (same class
as LiveView CVE-2026-58228).
