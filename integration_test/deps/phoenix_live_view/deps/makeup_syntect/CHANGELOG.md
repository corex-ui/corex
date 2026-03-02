# Changelog

## v0.1.4

* Updated syntect and two-face dependencies.
  * Adds support for `debsources`, `GDScript`, `Idris`, `Odin`, `Typst`, `VHDL` syntaxes

## v0.1.3

Moved `makeup_syntect` to the [elixir-makeup](https://github.com/elixir-makeup) GitHub origanization.

## v0.1.2

### Bug fixes

* Ensure HTML id and class attributes are properly handled when empty for HEEx

## v0.1.1

### Bug fixes

* Properly classify HTML attributes as `:name_attribute` instead of `:name_entity`

### Enhancements

* Allow to configure extra syntaxes to load at compile time through the `:extra_syntax_folders` configuration option. These are also registered into Makeup.

## v0.1.0

Initial release.
