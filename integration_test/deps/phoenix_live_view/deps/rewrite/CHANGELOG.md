# Changelog

## 1.2.0 - 2025/10/09

+ Changes for Elixir 1.19
+ Required Elixir version set to `~> 1.14`
+ Clean up `extra_applications`

## 1.1.1 - 2024/11/15

+ Add option `ignore_missing_sub_formatters` in `Rewrite.DotFormatter.read/2` 
  and friends.

## 1.1.0 - 2024/11/09

+ Added `:exclude` option to `Rewrite.new!/2` and `Rewrite.read!/2`.

## 1.0.1 - 2024/11/03

+ Set `locals_for_parens` to `[]` for `Sourceror.to_string/2` if not set, to 
  prevent Sourceror from trying to fetch `locals_for_parens`.
+ Add option `:ignore_unknown_deps` to `DotFormatter.read/2` and friends.

## 1.0.0 - 2024/11/01

### Breaking changes

Version `1.0.0` comes with a lot of breaking changes and some improvements. 
The main change is to the formatting and handling of `.formatter.exs`. For this 
the module `Rewrite.DotFormatter` has been added. This module provides an API to 
the Elixir formatting functionality and the formatter configuration via
`.formatter.exs`.

Other changes concern the argument list of some functions, here some arguments
have been removed from the argument list and moved to the options.

+ `Rewrite.TextDiff` has been moved to its own package
  (hex: [text_diff](https://hex.pm/packages/text_diff)). 

+ Add `Rewrite.DotFormatter` to handle the formatting of sources and files.

+ The functions `Rewrite.Source.Ex.format/2`, 
  `Rewrite.Source.Ex.put_formatter_opts/2` and 
  `Rewrite.Source.Ex.merge_formatter_opts/2` are removed. 
  The formatting functionality has been moved to `Rewrite.DotFormatter`.

+ Add `Rewrite.create_source/4` to create a `Source` struct without adding it
  to the `Rewrite` project.

+ Add `Rewrite.new_source/4` to cretae a `Source` struct and add it to the 
  `Rewrite` project.

+ The `Rewrite.Source.update/4` function accepts now an updater function or a
  value.

+ Add `Rewrite.dot_formatter/1/2` to set and get formatters.

+ Add `Rewrite.format/2` and `Rewrite.format!/2` to format a project.

+ Add `Rewrite.format_source/3` to format a source in a project.

+ Add `Rewrite.Hook`, a behaviour to set as `:hooks` in a `%Rewrite{}` project.

+ Add `Rewrite.Source.default_path/0` and callback 
  `Rewrite.Filetype.default_path/0`.

+ `Rewrite.new/1`, `Rewrite.new!/2` and `Rewrite.read!/3` now expect an optional
  options list instead of a list of `Rewrite.Filetype`s.

+ The function `Rewrite.Source.form_string/3` and the callback 
  `Rewrite.Filetype.from_string/3` are changed to `from_string/2`. The argument
  `path` is now part of the options.

## 0.10.5 - 2024/06/15

+ Use file extension when filtering the formatter plugins.

## 0.10.4 - 2024/06/03

+ Honor `import_deps` in `formatter_opts`.

## 0.10.3 - 2024/05/30

+ Include files starting with `.`.

## 0.10.2 - 2024/05/27

+ Fix Elixir 1.17 deprecation warning.

## 0.10.1 - 2024/04/02

+ Update sourceror version.

## 0.10.0 - 2023/11/11

+ Add option `:sync_quoted` to `Source.Ex`.

## 0.9.1 - 2023/10/07

+ Read and write files async.

## 0.9.0 - 2023/09/15

+ Add options to the list of file types in `Rewrite.new/1` and `Rewrite.read!/2`.

## 0.8.0 - 2023/08/27

+ Use `sourceror` version `~> 0.13`.

## 0.7.1 - 2023/08/25

+ Update version requirement for `sourceror` to `~> 0.12.0`.
+ Add function `Rewrite.Source.issues/1`.

## 0.7.0 - 2023/07/17

### Breaking Changes

+ The module `Rewrite.Project` moves to `Rewrite`.

+ The `Rewrite.Source.hash` contains the hash of the read in file. The hash can
  be used to detect if the file was changed after the last reading.

+ `Rewrite` accetps only `sources` with a valid and unique path. From this, the
  handling of conflicting files is no longer part of `rewrite`.

+ `Source.content/2` and `Source.path/2` is replaced by `Source.get/3`.

+ Add `Rewrite.Filetype`.

## 0.6.3 - 2023/03/22

+ Fix `Source.format/3`.

## 0.6.2 - 2023/03/19

+ Search for `:dot_formatter_opts` in `Source.private` when formatting.

## 0.6.1 - 2023/02/26

+ Refactor source formatting.

## 0.6.0 - 2023/02/14

+ Add option `:colorizer` to `Rewrite.TextDiff.format/3`.

## 0.5.0 - 2023/02/10

+ Update `sourceror` to ~> 0.12.

+ Add `Rewrite.Source.put_private/3`, which allows for storing arbitrary data
  on a source.

## 0.4.2 - 2023/02/05

+ Add fix for `Rewrite.Source.format/2`.

+ Pin `sourceror` to 0.11.2.

## 0.4.1 - 2023/02/04

+ Support the `FreedomFormatter`.
+ Update `Rewrite.Source.save/1` to add a neline at the of file. Previously a
  newline was added at `Rewrite.Source.update/3`.

## 0.4.0 - 2023/02/02

+ Update `Rewrite.TextDiff.format/3` to include more formatting customization.

## 0.3.0 - 2022/12/10

+ Accept glob as `%GlobEx{}` as argument for `Rewrite.Project.read!/1`

## 0.2.0 - 2022/09/08

+ Remove `Rewrite.Issue`. The type of the field `issues` for `Rewrite.Source`
  becomes `[term()]`.

+ Remove `Rewrite.Source.debug_info/2` and `BeamFile` dependency.

+ Add `Rewrite.Project.sources_by_module/2`, `Rewrite.Project.source_by_module/2`
  and `RewriteProject.source_by_module!/2`.

+ Remove `Rewrite.Source.zipper/1`

+ Update `Rewrite.Source.update`. An update can now be made with `:path`, `:ast`,
  and `:code`. An update with a `Sourceror.Zipper.zipper()` is no longer
  supported.

+ Add `Rewrite.Source.from_ast/3`.

+ Add `Rewrite.Source.owner/1`.

## 0.1.1 - 2022/09/07

+ Update `Issue.new/4`.

## 0.1.0 - 2022/09/05

+ The very first version.

+ This package was previously part of Recode. The extracted modules were also
  refactored when they were moved to their own package.
