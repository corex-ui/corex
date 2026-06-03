# Changelog

## 0.1.1

### Fixed

- **Toast**: Sanitize action URLs; dispose toast group on hook destroy.
- **Menu**: Fix submenu subscription accumulation.
- **DataTable**: Harden sort and selection against forged client params.
- **Pagination**: Validate page URLs; omit unsafe `data-to`.
- **Redirect**: Validate redirect destination schemes.
- **Combobox**, **Date Picker**: Reduce unnecessary re-renders.
- **MCP**: Security hardening.
- **Docs**: Restore `mix corex.new` on Hexdocs.

## 0.1.0

Initial Corex stable release.
