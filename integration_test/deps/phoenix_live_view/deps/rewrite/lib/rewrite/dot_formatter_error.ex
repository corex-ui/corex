defmodule Rewrite.DotFormatterError do
  @moduledoc """
  An exception raised when an error is encountered while working with
  dot_formatters.
  """

  defexception [:reason, :path, :not_formatted, :exits]

  @type t :: %{reason: reason(), path: Path.t(), not_formatted: [Path.t()], exits: exits()}

  @type reason :: atom() | {atom(), term()}
  @type exits :: term()

  def message(%{reason: {:read, :enoent}, path: path}) do
    "Could not read file #{inspect(path)}: no such file or directory"
  end

  def message(%{reason: :invalid_term, path: path}) do
    "The file #{inspect(path)} does not contain a valid formatter config."
  end

  def message(%{reason: :dot_formatter_not_found, path: path}) do
    "#{path} not found"
  end

  def message(%{reason: {:invalid_subdirectories, subdirectories}, path: path}) do
    """
    Expected :subdirectories to return a list of directories, \
    got: #{inspect(subdirectories)}, in: #{inspect(path)}\
    """
  end

  def message(%{reason: {:invalid_import_deps, import_deps}, path: path}) do
    """
    Expected :import_deps to return a list of dependencies, \
    got: #{inspect(import_deps)}, in: #{inspect(path)}\
    """
  end

  def message(%{reason: {:invalid_remove_plugins, remove_plugins}}) do
    "Expected :remove_plugins to be a list of modules, got: #{inspect(remove_plugins)}"
  end

  def message(%{reason: {:invalid_replace_plugins, replace_plugins}}) do
    "Expected :replace_plugins to be a list of tuples, got: #{inspect(replace_plugins)}"
  end

  def message(%{reason: :no_inputs_or_subdirectories, path: path}) do
    "Expected :inputs or :subdirectories key in #{inspect(path)}"
  end

  def message(%{reason: {:dep_not_found, dep}}) do
    """
    Unknown dependency #{inspect(dep)} given to :import_deps in the formatter \
    configuration. Make sure the dependency is listed in your mix.exs for \
    environment :dev and you have run "mix deps.get"\
    """
  end

  def message(%{reason: :format, not_formatted: not_formatted, exits: exits}) do
    not_formatted = Enum.map(not_formatted, fn {file, _input, _formatted} -> file end)

    """
    Format errors - Not formatted: #{inspect(not_formatted)}, Exits: #{inspect(exits)}\
    """
  end

  def message(%{reason: {:conflicts, dot_formatters}}) do
    dot_formatters =
      Enum.map_join(dot_formatters, "\n", fn {file, formatters} ->
        "file: #{inspect(file)}, formatters: #{inspect(formatters)}"
      end)

    """
    Multiple formatter files specifying the same file in their :inputs options:
    #{dot_formatters}\
    """
  end

  def message(%{reason: %GlobEx.CompileError{} = error}) do
    "Invalid glob #{inspect(error.input)}, #{Exception.message(error)}"
  end

  def message(%{reason: {:invalid_input, input}}) do
    "Invalid input, got: #{inspect(input)}"
  end

  def message(%{reason: {:invalid_inputs, inputs}}) do
    "Invalid inputs, got: #{inspect(inputs)}"
  end

  def message(%{reason: {:invalid_locals_without_parens, locals_without_parens}}) do
    "Invalid locals_without_parens, got: #{inspect(locals_without_parens)}"
  end

  def message(%{reason: {:no_subs, dirs}}) do
    "No sub formatter(s) found in #{inspect(dirs)}"
  end

  def message(%{reason: {:missing_subs, dirs}}) do
    "Missing sub formatter(s) in #{inspect(dirs)}"
  end
end
