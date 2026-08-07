# Security Policy

## Supported Versions

Security fixes are provided for the latest release on the `main` branch and the most recent tagged release on Hex.

## Reporting a Vulnerability

Do not open public GitHub issues for security vulnerabilities.

Report security issues privately to the maintainers. See [CONTRIBUTING.md](CONTRIBUTING.md) for contact details.

Include a description of the issue, steps to reproduce, and impact if known. We will acknowledge receipt and work on a fix or mitigation as appropriate.

## Advisories

### 0.2.0 — Redirect / `data-to` scheme allowlist

`Corex.Url` and the shared JS redirect helper strip leading C0 control and space
codepoints (≤ `0x20`) before scheme checks, matching WHATWG URL parsing. Without
this, a destination such as `<<1, "javascript:…">>` could be treated as a relative
path and later execute in the browser (same class as LiveView CVE-2026-58228).

Consumers should also run Phoenix LiveView **≥ 1.2.7** and Phoenix **≥ 1.8.9** for
upstream `<.link>` / navigation fixes.
