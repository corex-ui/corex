defmodule Rewrite.DotFormatter do
  @moduledoc """
  Provides an alternative API to the Elixir dot formatter.

  The `DotFormatter` has the same functionality as the code that provides the
  `mix format` task. But `DotFormatter` provides a struct for the evaluated
  formatter config to provide a more convenient API.
  """

  alias Rewrite.DotFormatter
  alias Rewrite.DotFormatterError
  alias Rewrite.Source

  @type formatter :: (term() -> String.t())

  @type timestamp :: integer()

  @type t :: %DotFormatter{
          force_do_end_blocks: boolean() | nil,
          import_deps: [atom()] | nil,
          inputs: [GlobEx.t()] | nil,
          locals_without_parens: [{atom(), arity()}] | nil,
          normalize_bitstring_modifiers: boolean() | nil,
          normalize_charlists_as_sigils: boolean() | nil,
          path: Path.t() | nil,
          plugin_opts: keyword(),
          plugins: [module()] | nil,
          sigils: [{atom(), function()}] | nil,
          source: String.t() | nil,
          subdirectories: [GlobEx.t()] | nil,
          subs: [t()],
          timestamp: timestamp() | nil
        }

  @root "."
  @default_dot_formatter ".formatter.exs"

  @formatter_opts [
    :force_do_end_blocks,
    :import_deps,
    :inputs,
    :locals_without_parens,
    :normalize_bitstring_modifiers,
    :normalize_charlists_as_sigils,
    :plugins,
    :sigils,
    :subdirectories
  ]

  @dot_formatter_fields [
    subs: [],
    source: nil,
    plugin_opts: [],
    timestamp: nil,
    path: nil
  ]

  defstruct @formatter_opts ++ @dot_formatter_fields

  @doc """
  Returns which features this plugin should plug into.
  """
  @callback features(Keyword.t()) :: [sigils: [atom()], extensions: [binary()]]

  @doc """
  Receives a string to be formatted with options and returns said string.
  """
  @callback format(String.t(), keyword()) :: String.t()

  @doc """
  Converts a quoted expression to an algebra document using Elixir's formatter
  rules.

  This function works as an replacement for `Code.quoted_to_algebra/2`.
  """
  @callback quoted_to_algebra(Macro.t(), keyword()) :: Inspect.Algebra.t()

  @doc """
  Reads the `.formatter.exs` file in the current directory or the given
  `%Rewrite{}` project.

  If a `%Rewrite{}` project is given to the function, the formatter is searched
  in the project and the latest version from the source is used. As a fallback,
  it will search the file system for the required files.

  The function returns a `%DotFormatter{}` struct with all sub-formatters.

  ## Options

    * `remove_plugins` - a list of plugins to remove from the formatter.

    * `replace_plugins` - a list of `{old, new}` tuples to replace plugins in
      the formatter.

    * `ignore_unknown_deps` - ingores unknown dependencies in `:import_deps`
      when set to `true`. Defaults to `false`.

    * `ignore_missing_sub_formatters` - ignores missign sub formatters when set
      to `true`, Defaults to `false`.
  """
  @spec read(rewrite :: Rewrite.t() | keyword() | nil, keyword()) ::
          {:ok, t()} | {:error, DotFormatterError.t()}
  def read(rewrite \\ nil, opts \\ [])

  def read(opts, []) when is_list(opts), do: read(nil, opts)

  def read(rewrite, opts), do: read(rewrite, opts, @root)

  defp read(rewrite, opts, path) do
    dot_formatter_path = dot_formatter_path(path, opts)
    opts = Keyword.put(opts, :reload_plugins, false)

    with {:ok, term, timestamp} <- read_dot_formatter(rewrite, dot_formatter_path) do
      eval(rewrite, opts, path, dot_formatter_path, term, timestamp)
    end
  end

  defp eval(rewrite, opts, path, dot_formatter_path, term, timestamp) do
    with {:ok, term} <- validate(term, dot_formatter_path, path),
         {:ok, dot_formatter} <- new(term, dot_formatter_path, timestamp),
         {:ok, dot_formatter} <- eval_deps(dot_formatter, opts),
         {:ok, dot_formatter} <- eval_subs(dot_formatter, rewrite, opts),
         {:ok, dot_formatter} <- update_plugins(dot_formatter, opts) do
      load_plugins(dot_formatter)
    end
  end

  @doc """
  Same as `read/2`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec read!(rewrite :: Rewrite.t() | nil, keyword()) :: t()
  def read!(rewrite \\ nil, opts \\ []) do
    case read(rewrite, opts) do
      {:ok, dot_formatter} -> dot_formatter
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Returns a `%DotFormatter` for the given `config`.

  The `opts` has the same format as the `.formatter.exs` file.
  """
  @spec create(Rewrite.t() | nil, keyword()) :: {:ok, t()} | {:error, DotFormatterError.t()}
  def create(rewrite \\ nil, opts) do
    config = opts
    opts = [reload_plugins: false]
    dot_formatter_path = @default_dot_formatter
    path = @root
    timestamp = DateTime.utc_now() |> DateTime.to_unix()

    eval(rewrite, opts, path, dot_formatter_path, config, timestamp)
  end

  @doc """
  Same as `create/2`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec create!(Rewrite.t() | nil, keyword()) :: t()
  def create!(rewrite \\ nil, config) do
    case create(rewrite, config) do
      {:ok, dot_formatter} -> dot_formatter
      {:error, error} -> raise error
    end
  end

  @doc """
  Updates the given `dot_formatter`.

  The function checks if the `dot_formatter` is up to date. If not, the `eval`
  function is called.

  Accepts the same options as `eval/2`.
  """
  @spec update(t(), Rewrite.t() | keyword() | nil, keyword()) ::
          {:ok, t()} | {:error, DotFormatterError.t()}
  def update(dot_formatter, rewrite \\ nil, opts \\ [])

  def update(%DotFormatter{} = dot_formatter, opts, []) when is_list(opts) do
    update(dot_formatter, nil, opts)
  end

  def update(%DotFormatter{} = dot_formatter, rewrite, opts) do
    if up_to_date?(dot_formatter, rewrite) do
      {:ok, dot_formatter}
    else
      read(rewrite, opts)
    end
  end

  defp update_plugins(dot_formatter, opts) do
    with {:ok, updated} <- remove_plugins(dot_formatter, opts[:remove_plugins]),
         {:ok, updated} <- replace_plugins(updated, opts[:replace_plugins]) do
      if Keyword.get(opts, :reload_plugins, true) do
        reload_plugins(updated, dot_formatter)
      else
        {:ok, updated}
      end
    end
  end

  defp remove_plugins(dot_formatter, nil), do: {:ok, dot_formatter}

  defp remove_plugins(dot_formatter, remove_plugins) when is_list(remove_plugins) do
    dot_formatter =
      map(dot_formatter, fn dot_formatter ->
        Map.update!(dot_formatter, :plugins, fn plugins ->
          Enum.reject(plugins, fn plugin -> plugin in remove_plugins end)
        end)
      end)

    {:ok, dot_formatter}
  end

  defp remove_plugins(_dot_formatter, remove_plugins) do
    {:error, %DotFormatterError{reason: {:invalid_remove_plugins, remove_plugins}}}
  end

  defp replace_plugins(dot_formatter, nil), do: {:ok, dot_formatter}

  defp replace_plugins(dot_formatter, replace_plugins) when is_list(replace_plugins) do
    dot_formatter =
      map(dot_formatter, fn dot_formatter ->
        do_replace_plugins(dot_formatter, replace_plugins)
      end)

    {:ok, dot_formatter}
  end

  defp replace_plugins(_dot_formatter, replace_plugins) do
    {:error, %DotFormatterError{reason: {:invalid_replace_plugins, replace_plugins}}}
  end

  defp do_replace_plugins(dot_formatter, replace_plugins) do
    Map.update!(dot_formatter, :plugins, fn plugins ->
      Enum.map(plugins, fn plugin -> new_plugin(replace_plugins, plugin) end)
    end)
  end

  defp new_plugin(replace_plugins, plugin) do
    Enum.find_value(replace_plugins, plugin, fn {old, new} ->
      if plugin == old, do: new
    end)
  end

  defp reload_plugins(dot_formatter, dot_formatter), do: {:ok, dot_formatter}
  defp reload_plugins(dot_formatter, _old_dot_formatter), do: load_plugins(dot_formatter)

  defp dot_formatter_path(@root, opts) do
    Keyword.get(opts, :dot_formatter, @default_dot_formatter)
  end

  defp dot_formatter_path(path, _opts) do
    Path.join(path, @default_dot_formatter)
  end

  @doc """
  Returns an empty `%DotFormatter{}` struct with inputs set to `**`.

  This is useful when no `.formatter.exs` file is present.
  """
  @spec default :: t()
  def default, do: %DotFormatter{inputs: [GlobEx.compile!("**")]}

  defp new(term, dot_formatter_path, timestamp) do
    source = Path.basename(dot_formatter_path)
    path = relative_to_cwd(dot_formatter_path)

    with {:ok, term} <- update_inputs(term, path) do
      {formatter_opts, plugin_opts} = Keyword.split(term, @formatter_opts)

      data =
        formatter_opts
        |> Keyword.put_new(:plugins, [])
        |> Keyword.merge(
          source: source,
          path: path,
          plugin_opts: plugin_opts,
          timestamp: timestamp
        )

      {:ok, struct!(DotFormatter, data)}
    end
  end

  defp relative_to_cwd(path) do
    path =
      path
      |> Path.dirname()
      |> Path.relative_to_cwd()

    if path == @root, do: "", else: path
  end

  defp update_inputs(term, path) do
    case Keyword.fetch(term, :inputs) do
      {:ok, inputs} ->
        with {:ok, inputs} <- inputs |> List.wrap() |> update_inputs(path, []) do
          {:ok, Keyword.put(term, :inputs, inputs)}
        end

      :error ->
        {:ok, term}
    end
  end

  defp update_inputs([], _path, acc), do: {:ok, acc}

  defp update_inputs([input | inputs], path, acc) when is_binary(input) do
    case path |> Path.join(input) |> GlobEx.compile(match_dot: true) do
      {:ok, glob} -> update_inputs(inputs, path, [glob | acc])
      {:error, reason} -> {:error, %DotFormatterError{reason: reason}}
    end
  end

  defp update_inputs([input | _inputs], _path, _acc) do
    {:error, %DotFormatterError{reason: {:invalid_input, input}}}
  end

  defp validate(term, dot_formatter_path, path) when is_list(term) do
    subdirectories = Keyword.get(term, :subdirectories, [])
    inputs = Keyword.get(term, :inputs, [])
    import_deps = Keyword.get(term, :import_deps, [])
    locals_without_parens = Keyword.get(term, :locals_without_parens, [])

    cond do
      not Keyword.keyword?(locals_without_parens) ->
        {:error,
         %DotFormatterError{
           reason: {:invalid_locals_without_parens, locals_without_parens},
           path: dot_formatter_path
         }}

      not is_list(inputs) and not is_binary(inputs) ->
        {:error,
         %DotFormatterError{
           reason: {:invalid_inputs, inputs},
           path: dot_formatter_path
         }}

      not is_list(subdirectories) ->
        {:error,
         %DotFormatterError{
           reason: {:invalid_subdirectories, subdirectories},
           path: dot_formatter_path
         }}

      not is_list(import_deps) ->
        {:error,
         %DotFormatterError{
           reason: {:invalid_import_deps, import_deps},
           path: dot_formatter_path
         }}

      subdirectories == [] && inputs == [] && path != @root ->
        {:error,
         %DotFormatterError{
           reason: :no_inputs_or_subdirectories,
           path: dot_formatter_path
         }}

      true ->
        {:ok, term}
    end
  end

  defp validate(_term, dot_formatter_path, _path) do
    {:error,
     %DotFormatterError{
       reason: :invalid_term,
       path: dot_formatter_path
     }}
  end

  @doc """
  Creates a `%DotFormatter{}` struct from a the given `formatter_opts`.

  This function ignores the sub-formatters of the given `formatter_opts`. It is
  also assumes that the plugins are already loaded.
  """
  @spec from_formatter_opts(keyword(), keyword()) :: t()
  def from_formatter_opts(formatter_opts, opts \\ []) do
    {formatter_opts, plugin_opts} = Keyword.split(formatter_opts, @formatter_opts)

    data =
      formatter_opts
      |> Keyword.put(:plugin_opts, plugin_opts)
      |> Keyword.put_new(:plugins, [])

    opts = Keyword.put(opts, :reload_plugins, false)

    {:ok, dot_formatter} =
      DotFormatter
      |> struct!(data)
      |> update_plugins(opts)

    dot_formatter
  end

  @doc """
  Returns the `%DotFormatter{}` struct for the given `path` or `nil` when not
  found.
  """
  @spec get(t(), path :: Path.t()) :: t()
  def get(%DotFormatter{} = dot_formatter, path) do
    if dot_formatter.path == path do
      dot_formatter
    else
      Enum.find(dot_formatter.subs, fn sub -> get(sub, path) end)
    end
  end

  @doc """
  Returns `true` if the given `dot_formatter` is up to date.

  The function only checks the timestamps in the `dot_formatter` struct with the
  timestamp of the underlying file or source in the `project`.
  """
  @spec up_to_date?(t(), project :: Rewrite.t() | nil) :: boolean()
  def up_to_date?(dot_formatter, project \\ nil) do
    dot_formatter
    |> reduce(fn dot_formatter, acc ->
      up_to_date? = dot_formatter.timestamp == timestamp(dot_formatter, project)
      [up_to_date? | acc]
    end)
    |> Enum.all?()
  end

  defp timestamp(dot_formatter, nil) do
    file = file(dot_formatter)

    case File.stat(file, time: :posix) do
      {:ok, %{mtime: timestamp}} -> timestamp
      {:error, _reason} -> 0
    end
  end

  defp timestamp(dot_formatter, project) do
    file = file(dot_formatter)

    case Rewrite.source(project, file) do
      {:ok, %{timestamp: timestamp}} -> timestamp
      {:error, _reason} -> timestamp(dot_formatter, nil)
    end
  end

  defp file(dot_formatter), do: Path.join(dot_formatter.path, dot_formatter.source)

  @doc """
  Formats the files in the current directory that are specified by the given
  `dot_formatter`.

  The options are the same as for `DotFormatter.read/2`.

  To format a `%Rewrite{}` project, use `Rewrite.format/2`.
  """
  @spec format(t() | nil, keyword()) :: :ok | {:error, DotFormatterError.t()}
  def format(%DotFormatter{} = dot_formatter, opts \\ []) when is_list(opts) do
    with {:ok, dot_formatter} <- update_plugins(dot_formatter, opts),
         {:ok, expanded} <- expand(dot_formatter, opts) do
      expanded
      |> Task.async_stream(
        async_stream_formatter(opts),
        ordered: false,
        timeout: :infinity
      )
      |> Enum.reduce({[], []}, &collect_status/2)
      |> check()
    end
  end

  @doc false
  @spec format_rewrite(t(), Rewrite.t(), keyword()) ::
          {:ok, Rewrite.t()} | {:error, DotFormatterError.t()}
  def format_rewrite(%DotFormatter{} = dot_formatter, %Rewrite{} = project, opts \\ []) do
    with {:ok, dot_formatter} <- update_plugins(dot_formatter, opts),
         {:ok, expanded} <- expand(dot_formatter, project, opts) do
      expanded
      |> Task.async_stream(
        async_stream_formatter(project, opts),
        ordered: false,
        timeout: :infinity
      )
      |> Enum.reduce({[], []}, &collect_status/2)
      |> update_source(project, opts)
    end
  end

  defp async_stream_formatter(opts) do
    check_formatted? = Keyword.get(opts, :check_formatted, false)

    case check_formatted? do
      false ->
        fn {file, formatter} ->
          try do
            input = File.read!(file)
            output = formatter.(input)
            File.write!(file, output)
          rescue
            exception ->
              {:exit, file, exception, __STACKTRACE__}
          end
        end

      true ->
        fn {file, formatter} ->
          try do
            input = File.read!(file)
            output = formatter.(input)
            if input == output, do: :ok, else: {:not_formatted, {file, input, output}}
          rescue
            exception ->
              {:exit, file, exception, __STACKTRACE__}
          end
        end
    end
  end

  defp async_stream_formatter(project, opts) do
    check_formatted? = Keyword.get(opts, :check_formatted, false)

    case check_formatted? do
      false ->
        fn {file, formatter} ->
          try do
            input = project |> Rewrite.source!(file) |> Source.get(:content)
            output = formatter.(input)
            if input == output, do: :ok, else: {:ok, file, output}
          rescue
            exception ->
              {:exit, file, exception, __STACKTRACE__}
          end
        end

      true ->
        fn {file, formatter} ->
          try do
            input = project |> Rewrite.source!(file) |> Source.get(:content)
            output = formatter.(input)
            if input == output, do: :ok, else: {:not_formatted, {file, input, output}}
          rescue
            exception ->
              {:exit, file, exception, __STACKTRACE__}
          end
        end
    end
  end

  defp collect_status({:ok, :ok}, acc), do: acc

  defp collect_status({:ok, {:ok, file, content}}, {exits, formatted}) do
    {exits, [{file, content} | formatted]}
  end

  defp collect_status({:ok, {:exit, file, error, _meta}}, {exits, not_formatted}) do
    {[{file, error} | exits], not_formatted}
  end

  defp collect_status({:ok, {:not_formatted, file}}, {exits, not_formatted}) do
    {exits, [file | not_formatted]}
  end

  defp check({[], []}), do: :ok

  defp check({exits, not_formatted}) do
    {:error, %DotFormatterError{reason: :format, not_formatted: not_formatted, exits: exits}}
  end

  defp update_source({[], formatted} = result, project, opts) do
    if Keyword.get(opts, :check_formatted, false) do
      check(result)
    else
      project =
        Enum.reduce(formatted, project, fn {path, content}, project ->
          Rewrite.update!(project, path, fn source ->
            Source.update(source, :content, content, opts)
          end)
        end)

      {:ok, project}
    end
  end

  @doc """
  Formats the given `file` using the given `dot_formatter` and `opts`.

  The options are the same as for `Code.format_string!/2`.
  """
  @spec format_file(t(), Path.t(), keyword()) :: :ok | {:error, DotFormatterError.t()}
  def format_file(%DotFormatter{} = dot_formatter, file, opts \\ []) do
    with {:ok, content} <- read_file(file),
         {:ok, formatted} <- format_string(dot_formatter, file, content, opts) do
      write(file, formatted)
    end
  end

  defp read_file(path) do
    with {:error, reason} <- File.read(path) do
      {:error, %DotFormatterError{reason: {:read, reason}, path: path}}
    end
  end

  defp write(path, content) do
    with {:error, reason} <- File.write(path, content) do
      {:error, %DotFormatterError{reason: {:write, reason}, path: path}}
    end
  end

  @doc false
  def format_source(%DotFormatter{} = dot_formatter, %Rewrite{} = project, file, opts \\ []) do
    Rewrite.update(project, file, fn source ->
      content = Source.get(source, :content)

      with {:ok, formatted} <- format_string(dot_formatter, file, content, opts) do
        Source.update(source, :content, formatted)
      end
    end)
  end

  @doc """
  Formats the given `string` using the specified `dot_formatter`, `file`, and
  `options`.

  The `file` is used to determine the formatter.

  Returns an :ok tuple with the formatted string on success, or an error tuple
  on failure.
  """
  @spec format_string(t(), Path.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def format_string(%DotFormatter{} = dot_formatter, file, string, opts \\ [])
      when is_binary(file) and is_binary(string) and is_list(opts) do
    opts = Keyword.put_new(opts, :file, file)
    formatter = formatter_for_file(dot_formatter, file, opts)

    {:ok, formatter.(string)}
  rescue
    error -> {:error, error}
  end

  @doc """
  Same as `format_string/4`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec format_string!(t(), Path.t(), String.t(), keyword()) :: String.t()
  def format_string!(%DotFormatter{} = dot_formatter, file, string, opts \\ [])
      when is_binary(file) and is_binary(string) and is_list(opts) do
    case format_string(dot_formatter, file, string, opts) do
      {:ok, formatted} -> formatted
      {:error, reason} -> raise reason
    end
  end

  @doc """
  A convenience function for `format_string/4` to format a string.

  This function reads the `%DotFormatter{}` with the given `opts` and calls
  `format_string/4`. The used file name defaults to `nofile.ex` and can be set
  in the `opts`.

  ## Options

    * The funciton accepts the same options as `read/2`.

    * `:file` - the file name to use. Defaults to `nofile.ex`.

  """
  @spec format_string(String.t(), keyword()) ::
          {:ok, String.t()} | {:error, DotFormatterError.t()}
  def format_string(string, opts \\ []) do
    file = Keyword.get(opts, :file, "nofile.ex")

    with {:ok, dot_formatter} <- read(nil, opts) do
      format_string(dot_formatter, file, string)
    end
  end

  @doc """
  Same as `format_string/2`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec format_string!(String.t(), keyword()) :: String.t()
  def format_string!(string, opts \\ []) do
    case format_string(string, opts) do
      {:ok, formatted} -> formatted
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Converts the given `quoted` expression to a string using the given
  `dot_formatter`, `file` and `opts`.

  The `file` is used to determine the formatter. If no formatter is found, an
  error tuple is returned.

  Returns an :ok tuple with the formatted string on success, or an error tuple
  on failure.
  """
  @spec format_quoted(t(), Path.t(), Macro.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def format_quoted(dot_formatter, file, quoted, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:file, file)
      |> Keyword.put(:from, :quoted)

    formatter = formatter_for_file(dot_formatter, file, opts)

    {:ok, formatter.(quoted)}
  rescue
    error ->
      {:error, error}
  end

  @doc """
  Same as `format_quoted/4`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec format_quoted(t(), Path.t(), Macro.t(), keyword()) :: String.t()
  def format_quoted!(dot_formatter, file, quoted, opts \\ []) do
    case format_quoted(dot_formatter, file, quoted, opts) do
      {:ok, formatted} -> formatted
      {:error, error} -> raise error
    end
  end

  @doc """
  A convenience function for `format_quoted/4` to format a string.

  This function reads the `%DotFormatter{}` with the given `opts` and calls
  `format_quoted/4`. The used file name defaults to `nofile.ex` and can be set
  in the `opts`.

  ## Options

    * The funciton accepts the same options as `read/2`.

    * `:file` - the file name to use. Defaults to `nofile.ex`.

  """
  @spec format_quoted(String.t(), keyword()) ::
          {:ok, String.t()} | {:error, DotFormatterError.t()}
  def format_quoted(string, opts \\ []) do
    opts = Keyword.put_new(opts, :inputs, "**/*")
    file = Keyword.get(opts, :file, "nofile.ex")
    with {:ok, dot_formatter} <- read(nil, opts), do: format_quoted(dot_formatter, file, string)
  end

  @doc """
  Same as `format_quoted/2`, but raises a `Rewrite.DotFormatterError` exception
  in case of failure.
  """
  @spec format_quoted!(String.t(), keyword()) :: String.t()
  def format_quoted!(string, opts \\ []) do
    case format_quoted(string, opts) do
      {:ok, formatted} -> formatted
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Returns the formatter options for the given `dot_formatter`.

  This functions ignores the sub-formatters of the given `dot_formatter`.
  """
  @spec formatter_opts(t()) :: keyword()
  def formatter_opts(%DotFormatter{} = dot_formatter) do
    dot_formatter
    |> Map.take(@formatter_opts)
    |> Enum.filter(fn {_key, value} ->
      if is_list(value), do: not Enum.empty?(value), else: not is_nil(value)
    end)
    |> Enum.concat(dot_formatter.plugin_opts)
  end

  @doc """
  Returns the formatter options for the given `dot_formatter` and `file`.

  This fucntion searches the formatter for the given `file` and returns the
  formater options for that formatter in an `:ok` tuple.

  If no formatter or multiple formatters are found, an `:error` tuple is
  returned.
  """
  @spec formatter_opts_for_file(t(), Path.t()) :: keyword()
  def formatter_opts_for_file(%DotFormatter{} = dot_formatter, file) when is_binary(file) do
    dot_formatter
    |> dot_formatter_for_file(file)
    |> formatter_opts()
  end

  @doc """
  Returns an `:ok` tuple with a list of `{path, formatter}` tuples for the given
  `dot_formatter`.

  In case of an conflict, an `:error` tuple is returned. A conflicting file is a
  file that is referenced by more than one formatter.

  The formatter is a two arity function that takes a string as input and
  options to format the string. For more information see `formatter_for_file/3`.
  """
  @spec expand(t(), Rewrite.t() | keyword() | nil, keyword()) ::
          {:ok, [{Path.t(), formatter()}]} | {:error, DotFormatterError.t()}
  def expand(dot_formatter, project \\ nil, opts \\ [])

  def expand(dot_formatter, opts, []) when is_list(opts) do
    expand(dot_formatter, nil, opts)
  end

  def expand(dot_formatter, project, opts) do
    expanded = do_expand(dot_formatter, project, opts)

    case get_conflicts(expanded, dot_formatter) do
      [] -> {:ok, expanded}
      conflicts -> {:error, %DotFormatterError{reason: {:conflicts, conflicts}}}
    end
  end

  defp do_expand(%DotFormatter{} = dot_formatter, nil, opts) do
    list =
      dot_formatter
      |> files()
      |> filter_by_modified_after(opts)
      |> do_expand_files(dot_formatter, opts)

    Enum.reduce(dot_formatter.subs, list, fn sub, acc ->
      do_expand(sub, nil, opts) ++ acc
    end)
  end

  defp do_expand(%DotFormatter{} = dot_formatter, project, opts) do
    project
    |> filter_by_modified_after(opts)
    |> do_expand_sources(dot_formatter, opts)
  end

  defp do_expand_files(files, dot_formatter, opts) do
    formatter_opts = formatter_opts(dot_formatter)
    identity_formatters = Keyword.get(opts, :identity_formatters, false)

    Enum.reduce(files, [], fn file, acc ->
      formatter = formatter(dot_formatter, formatter_opts, file)

      if !identity_formatters && formatter == (&Function.identity/1) do
        acc
      else
        [{file, formatter} | acc]
      end
    end)
  end

  defp do_expand_sources(sources, dot_formatter, opts) do
    Enum.reduce(sources, [], fn source, acc ->
      case dot_formatters_for_input(dot_formatter, source.path) do
        [] -> acc
        dot_formatters -> do_expand_sources(dot_formatters, source, opts, acc)
      end
    end)
  end

  defp do_expand_sources(dot_formatters, source, opts, acc) do
    identity_formatters = Keyword.get(opts, :identity_formatters, false)

    dot_formatters
    |> Enum.flat_map(fn dot_formatter ->
      formatter_opts = formatter_opts(dot_formatter)
      formatter = formatter(dot_formatter, formatter_opts, source.path)

      if !identity_formatters && formatter == (&Function.identity/1) do
        []
      else
        [{source.path, formatter}]
      end
    end)
    |> Enum.concat(acc)
  end

  defp filter_by_modified_after(input, nil), do: input

  defp filter_by_modified_after(input, opts) when is_list(opts) do
    filter_by_modified_after(input, Keyword.get(opts, :modified_after))
  end

  defp filter_by_modified_after(files, timestamp) when is_list(files) do
    Enum.filter(files, fn file -> File.stat!(file, time: :posix).mtime > timestamp end)
  end

  defp filter_by_modified_after(%Rewrite{} = project, timestamp) do
    Enum.filter(project, fn source -> source.timestamp > timestamp end)
  end

  @doc """
  Returns a list of conflicting files and their dot-formatter paths in the given
  `dot_formatter`.

  A conflicting file is a file that is referenced by more than one formatter.
  """
  @spec conflicts(t(), Rewrite.t() | nil) :: [{Path.t(), [dot_formatter_path]}]
        when dot_formatter_path: Path.t()
  def conflicts(dot_formatter, rewrite \\ nil)

  def conflicts(%DotFormatter{} = dot_formatter, rewrite)
      when is_struct(rewrite, Rewrite) or is_nil(rewrite) do
    case expand(dot_formatter, rewrite) do
      {:ok, _expanded} -> []
      {:error, %DotFormatterError{reason: {:conflicts, conflicts}}} -> conflicts
    end
  end

  defp get_conflicts(expanded, dot_formatter) do
    expanded
    |> Enum.frequencies_by(fn {file, _formatter} -> file end)
    |> Enum.reduce([], fn {file, count}, acc ->
      if count > 1, do: [file | acc], else: acc
    end)
    |> Enum.map(fn file ->
      dot_formatters =
        dot_formatter
        |> dot_formatters_for_input(file)
        |> Enum.map(fn %{path: path, source: source} -> Path.join(path, source) end)

      {file, dot_formatters}
    end)
  end

  @doc """
  Returns a list of all `:inputs` from the given `dot_formatter` and any
  sub-formatters.
  """
  @spec inputs(t()) :: [GlobEx.t()]
  def inputs(%DotFormatter{} = dot_formatter) do
    inputs =
      dot_formatter
      |> Map.get(:inputs, [])
      |> List.wrap()

    sub_inputs = Enum.flat_map(dot_formatter.subs, &inputs/1)

    inputs ++ sub_inputs
  end

  @doc """
  Returns a formatter function to be used for the given `file`.

  The returned function takes a string or an Elixir AST and returns the formatted
  string. The option `:from` takes the value `:string` or `:quoted` to determine
  which input type is used by the formatter, defaulting to `:string`.

  The function also accepts the same options as `Code.format_string!/2`, these
  are used when the formatter is called.
  """
  @spec formatter_for_file(DotFormatter.t(), Path.t(), keyword()) :: formatter()
  def formatter_for_file(%DotFormatter{} = dot_formatter, file, opts \\ [])
      when is_binary(file) do
    dot_formatter = dot_formatter_for_file(dot_formatter, file)
    formatter_opts = dot_formatter |> formatter_opts |> Keyword.merge(opts)
    formatter(dot_formatter, formatter_opts, file)
  end

  @doc """
  Returns a `%DotFormatter{}` struct with the result of invoking `fun` on the
  given `dot_formatter` and any sub-formatters.
  """
  @spec map(DotFormatter.t(), (DotFormatter.t() -> DotFormatter.t())) :: DotFormatter.t()
  def map(%DotFormatter{} = dot_formatter, fun) do
    dot_formatter = fun.(dot_formatter)

    Map.update!(dot_formatter, :subs, fn subs ->
      Enum.map(subs, fn sub -> map(sub, fun) end)
    end)
  end

  @doc """
  Invokes `fun` for each `dot_formatter` and any sub-formatters with the
  accumulator.
  """
  @spec reduce(t(), acc, (t(), acc -> acc)) :: acc when acc: term()
  def reduce(%DotFormatter{} = dot_formatter, acc \\ [], fun) do
    acc = fun.(dot_formatter, acc)

    Enum.reduce(dot_formatter.subs, acc, fn sub, acc ->
      reduce(sub, acc, fun)
    end)
  end

  # This function searches the Dot-Formatters tree for Dot-Formatters whose
  # :inputs option references the given file.
  defp dot_formatters_for_input(dot_formatter, file, acc \\ []) do
    match? =
      dot_formatter.inputs
      |> List.wrap()
      |> Enum.any?(fn glob ->
        GlobEx.match?(glob, file)
      end)

    acc = if match?, do: [dot_formatter | acc], else: acc

    Enum.reduce(dot_formatter.subs, acc, fn sub, acc ->
      dot_formatters_for_input(sub, file, acc)
    end)
  end

  # This function returns the "nearest" dot-formatter in the tree that fits to
  # the given file. The :inputs option must not match the file.
  defp dot_formatter_for_file(dot_formatter, file) do
    Enum.find_value(dot_formatter.subs, dot_formatter, fn sub_formatter ->
      size = byte_size(sub_formatter.path)

      case file do
        <<prefix::binary-size(size), dir_separator, _::binary>>
        when prefix == sub_formatter.path and dir_separator in [?\\, ?/] ->
          dot_formatter_for_file(sub_formatter, file)

        _ ->
          nil
      end
    end)
  end

  defp formatter(dot_formatter, formatter_opts, file) do
    ext = Path.extname(file)
    plugins = plugins_for_extension(dot_formatter.plugins, formatter_opts, ext)
    {from, formatter_opts} = Keyword.pop(formatter_opts, :from, :string)
    formatter_opts = Keyword.merge(formatter_opts, file: file, extension: ext)

    cond do
      not Enum.empty?(plugins) ->
        plugin_formatter(from, plugins, formatter_opts)

      ext in [".ex", ".exs"] ->
        elixir_formatter(from, formatter_opts)

      true ->
        &Function.identity/1
    end
  end

  defp plugin_formatter(:string, plugins, formatter_opts) do
    fn input ->
      Enum.reduce(plugins, input, fn plugin, input ->
        plugin.format(input, formatter_opts)
      end)
    end
  end

  defp plugin_formatter(:quoted, [plugin | plugins], formatter_opts) do
    fn input ->
      {formatter_opts, plugins} =
        if function_exported?(plugin, :quoted_to_algebra, 2) do
          formatter_opts =
            Keyword.put(formatter_opts, :quoted_to_algebra, &plugin.quoted_to_algebra/2)

          {formatter_opts, plugins}
        else
          formatter_opts =
            Keyword.put(formatter_opts, :quoted_to_algebra, &Code.quoted_to_algebra/2)

          {formatter_opts, [plugin | plugins]}
        end

      # If not set, explicitly set locals_without_parens to [] to prevent
      # Sourceror from trying to fetch locals_without_parens.
      formatter_opts = Keyword.put_new(formatter_opts, :locals_without_parens, [])

      input = Sourceror.to_string(input, formatter_opts) <> "\n"

      Enum.reduce(plugins, input, fn plugin, input ->
        plugin.format(input, formatter_opts)
      end)
    end
  end

  defp elixir_formatter(:string, formatter_opts) do
    fn input ->
      case Code.format_string!(input, formatter_opts) do
        [] -> ""
        "" -> ""
        formatted -> IO.iodata_to_binary([formatted, ?\n])
      end
    end
  end

  defp elixir_formatter(:quoted, formatter_opts) do
    fn input ->
      formatter_opts = Keyword.put(formatter_opts, :quoted_to_algebra, &Code.quoted_to_algebra/2)

      # If not set, explicitly set locals_without_parens to [] to prevent
      # Sourceror from trying to fetch locals_without_parens.
      formatter_opts = Keyword.put_new(formatter_opts, :locals_without_parens, [])

      Sourceror.to_string(input, formatter_opts) <> "\n"
    end
  end

  defp plugins_for_extension(nil, _formatter_opts, _ext), do: []

  defp plugins_for_extension(plugins, formatter_opts, ext) do
    Enum.filter(plugins, fn plugin ->
      ext in List.wrap(plugin.features(formatter_opts)[:extensions])
    end)
  end

  defp files(dot_formatter) do
    dot_formatter.inputs
    |> List.wrap()
    |> Enum.flat_map(&GlobEx.ls/1)
    |> Enum.filter(&File.regular?/1)
  end

  defp read_dot_formatter(project \\ nil, path)

  defp read_dot_formatter(nil, path) do
    if File.regular?(path) do
      {term, _binding} = Code.eval_file(path)
      timestamp = File.stat!(path, time: :posix).mtime
      {:ok, term, timestamp}
    else
      {:error, %DotFormatterError{reason: :dot_formatter_not_found, path: path}}
    end
  end

  defp read_dot_formatter(project, path) do
    case Rewrite.source(project, path) do
      {:ok, source} ->
        {term, _binding} = source |> Source.get(:content) |> Code.eval_string()
        {:ok, term, source.timestamp}

      {:error, %Rewrite.Error{reason: :nosource}} ->
        read_dot_formatter(nil, path)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp eval_deps(%{import_deps: nil} = dot_formatter, _opts), do: {:ok, dot_formatter}

  defp eval_deps(%{import_deps: deps} = dot_formatter, opts) do
    with {:ok, deps_paths} <- deps_paths(deps, opts),
         {:ok, locals_without_parens} <- locals_without_parens(deps_paths) do
      dot_formatter =
        Map.update!(dot_formatter, :locals_without_parens, fn list ->
          list |> List.wrap() |> Enum.concat(locals_without_parens) |> Enum.uniq()
        end)

      {:ok, dot_formatter}
    end
  end

  defp locals_without_parens(deps_paths) do
    result =
      Enum.reduce_while(deps_paths, [], fn {dep, path}, acc ->
        case read_dot_formatter(path) do
          {:ok, term, _timestamp} ->
            locals_without_parens = term[:export][:locals_without_parens] || []
            {:cont, acc ++ locals_without_parens}

          {:error, %DotFormatterError{reason: :dot_formatter_not_found}} ->
            {:halt,
             {:error,
              %DotFormatterError{
                reason: {:dep_not_found, dep},
                path: Path.relative_to(path, File.cwd!())
              }}}

          {:error, _reason} = error ->
            {:halt, error}
        end
      end)

    case result do
      {:error, _reason} = error -> error
      locals_without_parens -> {:ok, locals_without_parens}
    end
  end

  defp eval_subs(%DotFormatter{} = dot_formatter, project, opts) do
    subdirectories = dot_formatter.subdirectories || []

    result =
      Enum.reduce_while(subdirectories, [], fn subdirectory, acc ->
        with {:ok, dirs} <- dirs(dot_formatter.path, subdirectory),
             {:ok, subs} <- do_eval_subs(project, opts, dirs, subdirectory) do
          {:cont, subs ++ acc}
        else
          error -> {:halt, error}
        end
      end)

    case result do
      {:error, _reason} = error -> error
      result -> {:ok, %{dot_formatter | subs: result}}
    end
  end

  defp do_eval_subs(project, opts, dirs, subdirectory) do
    result =
      Enum.reduce_while(dirs, [], fn dir, acc ->
        if dir |> Path.join(@default_dot_formatter) |> File.regular?() do
          case read(project, opts, dir) do
            {:ok, dot_formatter} -> {:cont, [dot_formatter | acc]}
            error -> {:halt, error}
          end
        else
          {:cont, acc}
        end
      end)

    case result do
      {:error, _reason} = error ->
        error

      [] ->
        if opts[:ignore_missing_sub_formatters] do
          {:ok, []}
        else
          {:error, %DotFormatterError{reason: {:no_subs, subdirectory}}}
        end

      subs when is_list(subs) ->
        if length(subs) == length(dirs) or opts[:ignore_missing_sub_formatters] do
          {:ok, subs}
        else
          {:error, %DotFormatterError{reason: {:missing_subs, subdirectory}}}
        end
    end
  end

  defp load_plugins(%{plugins: nil} = dot_formatter), do: {:ok, dot_formatter}

  defp load_plugins(%{plugins: plugins} = dot_formatter) do
    if plugins != [] do
      Mix.Task.run("loadpaths", [])
    end

    if not Enum.all?(plugins, &Code.ensure_loaded?/1) do
      Mix.Task.run("compile", [])
    end

    formatter_opts = formatter_opts(dot_formatter)

    result =
      Enum.reduce_while(plugins, [], fn plugin, acc ->
        cond do
          not Code.ensure_loaded?(plugin) ->
            {:halt, %DotFormatterError{reason: {:plugin_not_found, plugin}}}

          not function_exported?(plugin, :features, 1) ->
            {:halt, %DotFormatterError{reason: {:undefined_features, plugin}}}

          true ->
            {:cont, get_sigils(plugin, formatter_opts) ++ acc}
        end
      end)

    case result do
      sigils when is_list(sigils) ->
        with {:ok, subs} <- load_plugins(dot_formatter.subs, []) do
          sigils = sigils(sigils, formatter_opts)
          {:ok, %{dot_formatter | sigils: sigils, subs: subs}}
        end

      error ->
        {:error, error}
    end
  end

  defp load_plugins([], subs), do: {:ok, Enum.reverse(subs)}

  defp load_plugins([sub | tail], subs) do
    with {:ok, dot_formatter} <- load_plugins(sub) do
      load_plugins(tail, [dot_formatter | subs])
    end
  end

  defp get_sigils(plugin, formatter_opts) do
    if Code.ensure_loaded?(plugin) and function_exported?(plugin, :features, 1) do
      formatter_opts
      |> plugin.features()
      |> Keyword.get(:sigils, [])
      |> List.wrap()
      |> Enum.map(fn sigil -> {sigil, plugin} end)
    else
      []
    end
  end

  defp sigils([], _formatter_opts), do: nil

  defp sigils(sigils, formatter_opts) do
    sigils
    |> Enum.reverse()
    |> Enum.group_by(
      fn {sigil, _plugin} -> sigil end,
      fn {_sigil, plugin} -> plugin end
    )
    |> Enum.map(fn {sigil, plugins} ->
      fun = fn input, opts ->
        Enum.reduce(plugins, input, fn plugin, input ->
          plugin.format(input, opts ++ formatter_opts)
        end)
      end

      {sigil, fun}
    end)
  end

  defp dirs(path, glob) do
    glob = Path.join(path, glob)

    case GlobEx.compile(glob, match_dot: true) do
      {:ok, glob} ->
        {:ok, glob |> GlobEx.ls() |> Enum.filter(&File.dir?/1)}

      {:error, reason} ->
        {:error, %DotFormatterError{reason: reason}}
    end
  end

  defp deps_paths(deps, opts) do
    paths = Mix.Project.deps_paths()
    ignore_unknown_deps = Keyword.get(opts, :ignore_unknown_deps, false)

    result =
      Enum.reduce_while(deps, [], fn dep, acc ->
        case Map.fetch(paths, dep) do
          {:ok, path} ->
            {:cont, [{dep, Path.join(path, @default_dot_formatter)} | acc]}

          :error when ignore_unknown_deps ->
            {:cont, acc}

          :error ->
            {:halt, %DotFormatterError{reason: {:dep_not_found, dep}}}
        end
      end)

    if is_list(result), do: {:ok, result}, else: {:error, result}
  end
end
