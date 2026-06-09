# Changelog

## 0.1.1

### Fixed

- **Toast**: Sanitize action URLs; dispose toast group on hook destroy.
- **Menu**: Fix submenu subscription accumulation; align SSR element ids with Zag so LiveView patches keep an open menu anchored and interactive (closes [#58](https://github.com/corex-ui/corex/issues/58)). Thanks to [@jessejanderson](https://github.com/jessejanderson) for reporting.
- **Combobox**: Align SSR element ids with Zag; preserve custom `:item` and `:item_indicator` slot content after select/clear LiveView updates; default `close_on_select` to `true`.
- **DataTable**: Harden sort and selection against forged client params.
- **Pagination**: Validate page URLs; omit unsafe `data-to`.
- **Redirect**: Validate redirect destination schemes.
- **Date Picker**: Reduce unnecessary re-renders.
- **MCP**: Security hardening.
- **Docs**: Restore `mix corex.new` on Hexdocs.

## 0.1.0

Initial Corex stable release.
