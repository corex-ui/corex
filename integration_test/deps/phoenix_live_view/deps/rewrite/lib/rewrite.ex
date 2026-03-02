defmodule Rewrite do
  @moduledoc """
  `Rewrite` is a tool for modifying, adding and removing files in a `Mix` project.

  The package is intended for use in `Mix` tasks. `Rewrite` itself uses functions
  provided by `Mix`.

  With `Rewrite.read!/2` you can load the whole project. Then you can modify the
  project with a number of functions provided by `Rewrite` and `Rewrite.Source`
  without writing any changes back to the file system. All changes are stored in
  the source structs. Any version of a source is available in the project. To
  write the whole project back to the file system, the `Rewrite.write_all/2` can
  be used.

  Elixir source files can be modified by modifying the AST. For this `Rewrite`
  uses the `Sourceror` package to create the AST and to convert it back. The
  `Sourceror` package also provides all the utilities needed to manipulate the
  AST.

  Sources can also receive a `Rewrite.Issue` to document problems or information
  with the source.

  `Rewrite` respects the `.formatter.exs` in the project when rewriting sources.
  To do this, the formatter can be read by `Rewrite.DotFormatter` and the
  resulting DotFormatter struct can be used in the function to update the
  sources.
  """

  alias Rewrite.DotFormatter
  alias Rewrite.Error
  alias Rewrite.Source
  alias Rewrite.SourceError
  alias Rewrite.UpdateError

  defstruct sources: %{},
            extensions: %{},
            hooks: [],
            dot_formatter: nil,
            excluded: []

  @type t :: %Rewrite{
          sources: %{Path.t() => Source.t()},
          extensions: %{String.t() => [module()]},
          hooks: [module()],
          dot_formatter: DotFormatter.t() | nil,
          excluded: [Path.t()]
        }

  @type input :: Path.t() | wildcard() | GlobEx.t()
  @type wildcard :: IO.chardata()
  @type opts :: keyword()
  @type by :: module()
  @type key :: atom()
  @type updater :: (term() -> term())

  @doc """
  Creates an empty project.

  ## Options

    * `:filetypes` - a list of modules implementing the behavior
      `Rewrite.Filetype`. This list is used to add the `filetype` to the
      `sources` of the corresponding files. The list can contain modules
      representing a file type or a tuple of `{module(), keyword()}`. Rewrite
      uses the keyword list from the tuple as the options argument when a file
      is read.

      Defaults to `[Rewrite.Source, Rewrite.Source.Ex]`.

    * `:dot_formatter` - a `%DotFormatter{}` that is used to format sources.
      To get and update a dot formatter see `dot_formatter/2` and to create one
      see `Rewrite.DotFormatter`.

  ## Examples

      iex> project = Rewrite.new()
      iex> path = "test/fixtures/source/hello.txt"
      iex> project = Rewrite.read!(project, path)
      iex> project |> Rewrite.source!(path) |> Source.get(:content)
      "hello\\n"
      iex> project |> Rewrite.source!(path) |> Source.owner()
      Rewrite

      iex> project = Rewrite.new(filetypes: [{Rewrite.Source, owner: MyApp}])
      iex> path = "test/fixtures/source/hello.txt"
      iex> project = Rewrite.read!(project, path)
      iex> project |> Rewrite.source!(path) |> Source.owner()
      MyApp
  """
  @spec new(keyword()) :: t()
  def new(opts \\ []) do
    Rewrite
    |> struct!(
      extensions: extensions(opts),
      hooks: Keyword.get(opts, :hooks, [])
    )
    |> dot_formatter(Keyword.get(opts, :dot_formatter))
    |> handle_hooks(:new)
  end

  @doc """
  Creates a `%Rewrite{}` from the given `inputs`.

  ## Options

    * Accepts the same options as `new/1`.

    * 'exclude' - a list of paths and/or glob expressions to exclude sources
      from the project. The option also accepts a predicate function which is
      called for each source path.  The exclusion takes place before the file is
      read.
  """
  @spec new!(input() | [input()], opts) :: t()
  def new!(inputs, opts \\ []) do
    opts |> new() |> read!(inputs, opts)
  end

  @doc """
  Reads the given `input`/`inputs` and adds the source/sources to the `project`
  when not already readed.

  ## Options

    * `:force`, default: `false` - forces the reading of sources. With
      `force: true` updates and issues for an already existing source are
      deleted.

    * `:exclude` - a list of paths and/or glob expressions to exclude sources
      from the project. The option also accepts a predicate function which is
      called for each source path.  The exclusion takes place before the file is
      read.
  """
  @spec read!(t(), input() | [input()], opts()) :: t()
  def read!(%Rewrite{} = rewrite, inputs, opts \\ []) do
    reader = rewrite.sources |> Map.keys() |> reader(rewrite.extensions, opts)

    inputs = expand(inputs)

    {added, excluded, sources} =
      Rewrite.TaskSupervisor
      |> Task.Supervisor.async_stream_nolink(inputs, reader)
      |> Enum.reduce({[], [], rewrite.sources}, fn
        {:ok, {path, :excluded}}, {added, excluded, sources} ->
          {added, [path | excluded], sources}

        {:ok, {path, source}}, {added, excluded, sources} ->
          {[path | added], excluded, Map.put(sources, path, source)}

        {:exit, {error, _stacktrace}}, _sources when is_exception(error) ->
          raise error
      end)

    rewrite
    |> Map.put(:sources, sources)
    |> Map.update!(:excluded, fn list -> list |> Enum.concat(excluded) |> Enum.uniq() end)
    |> handle_hooks({:added, added})
  end

  defp reader(paths, extensions, opts) do
    force = Keyword.get(opts, :force, false)
    exclude? = opts |> Keyword.get(:exclude) |> exclude()

    fn path ->
      Logger.disable(self())

      if exclude?.(path) || File.dir?(path) || (!force && path in paths) do
        {path, :excluded}
      else
        source = read_source!(path, extensions)
        {path, source}
      end
    end
  end

  defp exclude(nil) do
    fn _path -> false end
  end

  defp exclude(list) when is_list(list) do
    globs =
      Enum.map(list, fn
        %GlobEx{} = glob -> glob
        path -> GlobEx.compile!(path)
      end)

    fn path ->
      Enum.any?(globs, fn glob -> GlobEx.match?(glob, path) end)
    end
  end

  defp exclude(fun) when is_function(fun, 1), do: fun

  defp read_source!(path, extensions) when not is_nil(path) do
    {source, opts} = extension_for_file(extensions, path)

    source.read!(path, opts)
  end

  @doc """
  Returns the extension of the given `file`.
  """
  @spec extension_for_file(t() | map(), Path.t() | nil) :: {module(), opts()}
  def extension_for_file(%Rewrite{extensions: extensions}, path) do
    extension_for_file(extensions, path)
  end

  def extension_for_file(extensions, path) do
    ext = if path, do: Path.extname(path)
    default = Map.fetch!(extensions, "default")

    case Map.get(extensions, ext, default) do
      {module, opts} -> {module, opts}
      module -> {module, []}
    end
  end

  @doc """
  Puts the given `source` to the given `rewrite` project.

  Returns `{:ok, rewrite}` if successful, `{:error, reason}` otherwise.

  ## Examples

      iex> project = Rewrite.new()
      iex> {:ok, project} = Rewrite.put(project, Source.from_string(":a", path: "a.exs"))
      iex> map_size(project.sources)
      1
      iex> Rewrite.put(project, Source.from_string(":b"))
      {:error, %Rewrite.Error{reason: :nopath}}
      iex> Rewrite.put(project, Source.from_string(":a", path: "a.exs"))
      {:error, %Rewrite.Error{reason: :overwrites, path: "a.exs"}}
  """
  @spec put(t(), Source.t()) :: {:ok, t()} | {:error, Error.t()}
  def put(%Rewrite{}, %Source{path: nil}), do: {:error, Error.exception(reason: :nopath)}

  def put(%Rewrite{sources: sources} = rewrite, %Source{path: path} = source) do
    case Map.has_key?(sources, path) do
      true ->
        {:error, Error.exception(reason: :overwrites, path: path)}

      false ->
        rewrite = %{rewrite | sources: Map.put(sources, path, source)}
        rewrite = handle_hooks(rewrite, {:added, [path]})

        {:ok, rewrite}
    end
  end

  @doc """
  Same as `put/2`, but raises a `Rewrite.Error` exception in case of failure.
  """
  @spec put!(t(), Source.t()) :: t()
  def put!(%Rewrite{} = rewrite, %Source{} = source) do
    case put(rewrite, source) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Deletes the source for the given `path` from the `rewrite`.

  The file system files are not removed, even if the project is written. Use
  `rm/2` or `rm!/2` to delete a file and source.

  If the source is not part of the `rewrite` project the unchanged `rewrite` is
  returned.

  ## Examples

      iex> {:ok, project} = Rewrite.from_sources([
      ...>   Source.from_string(":a", path: "a.exs"),
      ...>   Source.from_string(":b", path: "b.exs"),
      ...>   Source.from_string(":a", path: "c.exs")
      ...> ])
      iex> Rewrite.paths(project)
      ["a.exs", "b.exs", "c.exs"]
      iex> project = Rewrite.delete(project, "a.exs")
      iex> Rewrite.paths(project)
      ["b.exs", "c.exs"]
      iex> project = Rewrite.delete(project, "b.exs")
      iex> Rewrite.paths(project)
      ["c.exs"]
      iex> project = Rewrite.delete(project, "b.exs")
      iex> Rewrite.paths(project)
      ["c.exs"]
  """
  @spec delete(t(), Path.t()) :: t()
  def delete(%Rewrite{sources: sources} = rewrite, path) when is_binary(path) do
    %{rewrite | sources: Map.delete(sources, path)}
  end

  @doc """
  Drops the sources with the given `paths` from the `rewrite` project.

  The file system files are not removed, even if the project is written. Use
  `rm/2` or `rm!/2` to delete a file and source.

  If `paths` contains paths that are not in `rewrite`, they're simply ignored.

  ## Examples

      iex> {:ok, project} = Rewrite.from_sources([
      ...>   Source.from_string(":a", path: "a.exs"),
      ...>   Source.from_string(":b", path: "b.exs"),
      ...>   Source.from_string(":a", path: "c.exs")
      ...> ])
      iex> project = Rewrite.drop(project, ["a.exs", "b.exs", "z.exs"])
      iex> Rewrite.paths(project)
      ["c.exs"]
  """
  @spec drop(t(), [Path.t()]) :: t()
  def drop(%Rewrite{} = rewrite, paths) when is_list(paths) do
    Enum.reduce(paths, rewrite, fn source, rewrite -> delete(rewrite, source) end)
  end

  @doc """
  Tries to delete the `source` file in the file system and removes the `source`
  from the `rewrite` project.

  Returns `{:ok, rewrite}` if successful, or `{:error, error}` if an error
  occurs.

  Note the file is deleted even if in read-only mode.
  """
  @spec rm(t(), Source.t() | Path.t()) ::
          {:ok, t()} | {:error, Error.t() | SourceError.t()}
  def rm(%Rewrite{} = rewrite, %Source{} = source) do
    with :ok <- Source.rm(source) do
      {:ok, delete(rewrite, source.path)}
    end
  end

  def rm(%Rewrite{} = rewrite, source) when is_binary(source) do
    with {:ok, source} <- source(rewrite, source) do
      rm(rewrite, source)
    end
  end

  @doc """
  Same as `source/2`, but raises a `Rewrite.Error` exception in case of failure.
  """
  @spec rm!(t(), Source.t() | Path.t()) :: t()
  def rm!(%Rewrite{} = rewrite, source) when is_binary(source) or is_struct(source, Source) do
    case rm(rewrite, source) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Moves a source from one path to another.
  """
  @spec move(t(), Source.t() | Path.t(), Path.t(), module()) :: {:ok, t()} | {:error, term()}
  def move(rewrite, from, to, by \\ Rewrite)

  def move(%Rewrite{} = rewrite, from, to, by)
      when is_struct(from, Source) and is_binary(to) and is_atom(by) do
    case Map.has_key?(rewrite.sources, to) do
      true ->
        {:error, UpdateError.exception(reason: :overwrites, path: to, source: from)}

      false ->
        update(rewrite, from.path, fn source ->
          Source.update(source, :path, to, by: by)
        end)
    end
  end

  def move(%Rewrite{} = rewrite, from, to, by)
      when is_binary(from) and is_binary(to) and is_atom(by) do
    with {:ok, source} <- source(rewrite, from) do
      move(rewrite, source, to, by)
    end
  end

  @doc """
  Same as `move/4`, but raises an exception in case of failure.
  """
  @spec move!(t(), Source.t() | Path.t(), Path.t(), module()) :: t()
  def move!(%Rewrite{} = rewrite, from, to, by \\ Rewrite) do
    case move(rewrite, from, to, by) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns a sorted list of all paths in the `rewrite` project.
  """
  @spec paths(t()) :: [Path.t()]
  def paths(%Rewrite{sources: sources}) do
    sources |> Map.keys() |> Enum.sort()
  end

  @doc """
  Returns `true` if any source in the `rewrite` project returns `true` for
  `Source.updated?/1`.

  ## Examples

      iex> {:ok, project} = Rewrite.from_sources([
      ...>   Source.Ex.from_string(":a", path: "a.exs"),
      ...>   Source.Ex.from_string(":b", path: "b.exs"),
      ...>   Source.Ex.from_string("c", path: "c.txt")
      ...> ])
      iex> Rewrite.updated?(project)
      false
      iex> project = Rewrite.update!(project, "a.exs", fn source ->
      ...>   Source.update(source, :quoted, ":z")
      ...> end)
      iex> Rewrite.updated?(project)
      true
  """
  @spec updated?(t()) :: boolean()
  def updated?(%Rewrite{} = rewrite) do
    rewrite.sources |> Map.values() |> Enum.any?(fn source -> Source.updated?(source) end)
  end

  @doc ~S"""
  Creates a `%Rewrite{}` from the given sources.

  Returns `{:ok, rewrite}` for a list of regular sources.

  Returns `{:error, error}` for sources with a missing path and/or duplicated
  paths.
  """
  @spec from_sources([Source.t()], opts()) :: {:ok, t()} | {:error, term()}
  def from_sources(sources, opts \\ []) when is_list(sources) do
    {sources, missing, duplicated} =
      Enum.reduce(sources, {%{}, [], []}, fn %Source{} = source, {sources, missing, duplicated} ->
        cond do
          is_nil(source.path) ->
            {sources, [source | missing], duplicated}

          Map.has_key?(sources, source.path) ->
            {sources, missing, [source | duplicated]}

          true ->
            {Map.put(sources, source.path, source), missing, duplicated}
        end
      end)

    if Enum.empty?(missing) && Enum.empty?(duplicated) do
      rewrite = new(opts)

      rewrite = %{rewrite | sources: sources}

      rewrite =
        rewrite
        |> Map.put(:sources, sources)
        |> handle_hooks({:added_sources, sources})

      {:ok, rewrite}
    else
      {:error,
       Error.exception(
         reason: :invalid_sources,
         missing_paths: missing,
         duplicated_paths: duplicated
       )}
    end
  end

  @doc """
  Same as `from_sources/2`, but raises a `Rewrite.Error` exception in case of
  failure.
  """
  @spec from_sources!([Source.t()], opts()) :: t()
  def from_sources!(sources, opts \\ []) when is_list(sources) do
    case from_sources(sources, opts) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns all sources sorted by path.
  """
  @spec sources(t()) :: [Source.t()]
  def sources(%Rewrite{sources: sources}) do
    sources
    |> Map.values()
    |> Enum.sort_by(fn source -> source.path end)
  end

  @doc """
  Returns the `%Rewrite.Source{}` for the given `path`.

  Returns an `:ok` tuple with the found source, if not exactly one source is
  available an `:error` is returned.

  See also `sources/2` to get a list of sources for a given `path`.
  """
  @spec source(t(), Path.t()) :: {:ok, Source.t()} | {:error, Error.t()}
  def source(%Rewrite{sources: sources}, path) when is_binary(path) do
    with :error <- Map.fetch(sources, path) do
      {:error, Error.exception(reason: :nosource, path: path)}
    end
  end

  @doc """
  Same as `source/2`, but raises a `Rewrite.Error` exception in case of
  failure.
  """
  @spec source!(t(), Path.t()) :: Source.t()
  def source!(%Rewrite{} = rewrite, path) do
    case source(rewrite, path) do
      {:ok, source} -> source
      {:error, error} -> raise error
    end
  end

  @doc """
  Updates the given `source` in the `rewrite` project.

  This function will be usually used if the `path` for the `source` has not
  changed.

  Returns `{:ok, rewrite}` if successful, `{:error, error}` otherwise.
  """
  @spec update(t(), Source.t()) ::
          {:ok, t()} | {:error, Error.t()}
  def update(%Rewrite{}, %Source{path: nil}),
    do: {:error, Error.exception(reason: :nopath)}

  def update(%Rewrite{} = rewrite, %Source{} = source) do
    update(rewrite, source.path, source)
  end

  @doc """
  The same as `update/2` but raises a `Rewrite.Error` exception in case
  of an error.
  """
  @spec update!(t(), Source.t()) :: t()
  def update!(%Rewrite{} = rewrite, %Source{} = source) do
    case update(rewrite, source) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Updates a source for the given `path` in the `rewrite` project.

  If `source` a `Rewrite.Source` struct the struct is used to update the
  `rewrite` project.

  If `source` is a function the source for the given `path` is passed to the
  function and the result is used to update the `rewrite` project.

  Returns `{:ok, rewrite}` if the update was successful, `{:error, error}`
  otherwise.

  ## Examples

      iex> a = Source.Ex.from_string(":a", path: "a.exs")
      iex> b = Source.Ex.from_string(":b", path: "b.exs")
      iex> {:ok, project} = Rewrite.from_sources([a, b])
      iex> {:ok, project} = Rewrite.update(project, "a.exs", Source.Ex.from_string(":foo", path: "a.exs"))
      iex> project |> Rewrite.source!("a.exs") |> Source.get(:content)
      ":foo"
      iex> {:ok, project} = Rewrite.update(project, "a.exs", fn s -> Source.update(s, :content, ":baz") end)
      iex> project |> Rewrite.source!("a.exs") |> Source.get(:content)
      ":baz"
      iex> {:ok, project} = Rewrite.update(project, "a.exs", fn s -> Source.update(s, :path, "c.exs") end)
      iex> Rewrite.paths(project)
      ["b.exs", "c.exs"]
      iex> Rewrite.update(project, "no.exs", Source.from_string(":foo", path: "x.exs"))
      {:error, %Rewrite.Error{reason: :nosource, path: "no.exs"}}
      iex> Rewrite.update(project, "c.exs", Source.from_string(":foo"))
      {:error, %Rewrite.UpdateError{reason: :nopath, source: "c.exs"}}
      iex> Rewrite.update(project, "c.exs", fn _ -> b end)
      {:error, %Rewrite.UpdateError{reason: :overwrites, path: "b.exs", source: "c.exs"}}
  """
  @spec update(t(), Path.t(), Source.t() | function()) ::
          {:ok, t()} | {:error, Error.t() | UpdateError.t()}
  def update(%Rewrite{}, path, %Source{path: nil}) when is_binary(path) do
    {:error, UpdateError.exception(reason: :nopath, source: path)}
  end

  def update(%Rewrite{} = rewrite, path, %Source{} = source)
      when is_binary(path) do
    with {:ok, _stored} <- source(rewrite, path) do
      do_update(rewrite, path, source)
    end
  end

  def update(%Rewrite{} = rewrite, path, fun) when is_binary(path) and is_function(fun, 1) do
    with {:ok, stored} <- source(rewrite, path),
         {:ok, source} <- apply_update!(stored, fun) do
      do_update(rewrite, path, source)
    end
  end

  defp do_update(rewrite, path, source) do
    case path == source.path do
      true ->
        rewrite = %{rewrite | sources: Map.put(rewrite.sources, path, source)}
        rewrite = handle_hooks(rewrite, {:updated, path})
        {:ok, rewrite}

      false ->
        case Map.has_key?(rewrite.sources, source.path) do
          true ->
            {:error, UpdateError.exception(reason: :overwrites, path: source.path, source: path)}

          false ->
            sources = rewrite.sources |> Map.delete(path) |> Map.put(source.path, source)
            {:ok, %{rewrite | sources: sources}}
        end
    end
  end

  defp apply_update!(source, fun) do
    case fun.(source) do
      %Source{path: nil} ->
        {:error, UpdateError.exception(reason: :nopath, source: source.path)}

      %Source{} = source ->
        {:ok, source}

      got ->
        raise RuntimeError, """
        expected %Source{} from anonymous function given to Rewrite.update/3, got: #{inspect(got)}\
        """
    end
  end

  @doc """
  The same as `update/3` but raises a `Rewrite.Error` exception in case
  of an error.
  """
  @spec update!(t(), Path.t(), Source.t() | function()) :: t()
  def update!(%Rewrite{} = rewrite, path, new) when is_binary(path) do
    case update(rewrite, path, new) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Updates the source for the given `path` and `key` with the given `fun`.

  The function combines `update/3` and `Source.update/4` in one call.

  ## Examples

      iex> project =
      ...>   Rewrite.new()
      ...>   |> Rewrite.new_source!("test.md", "foo")
      ...>   |> Rewrite.update_source!("test.md", :content, fn content ->
      ...>     content <> "bar"
      ...>   end)
      ...>   |> Rewrite.update_source!("test.md", :content, &String.upcase/1, by: MyApp)
      iex> source = Rewrite.source!(project, "test.md")
      iex> source.content
      "FOOBAR"
      iex> source.history
      [{:content, MyApp, "foobar"}, {:content, Rewrite, "foo"}]
  """
  @spec update_source(t(), Path.t(), key(), updater(), opts()) ::
          {:ok, t()} | {:error, term()}
  def update_source(%Rewrite{} = rewrite, path, key, fun, opts \\ []) do
    update(rewrite, path, fn source ->
      Source.update(source, key, fun, opts)
    end)
  end

  @doc """
  The same as `update_source/5` but raises a `Rewrite.Error` exception in case
  of an error.
  """
  @spec update_source!(t(), Path.t(), key(), updater(), opts()) :: t()
  def update_source!(%Rewrite{} = rewrite, path, key, fun, opts \\ []) do
    case update_source(rewrite, path, key, fun, opts) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns `true` when the `%Rewrite{}` contains a `%Source{}` with the given
  `path`.

  ## Examples

      iex> {:ok, project} = Rewrite.from_sources([
      ...>   Source.from_string(":a", path: "a.exs")
      ...> ])
      iex> Rewrite.has_source?(project, "a.exs")
      true
      iex> Rewrite.has_source?(project, "b.exs")
      false
  """
  @spec has_source?(t(), Path.t()) :: boolean()
  def has_source?(%Rewrite{sources: sources}, path) when is_binary(path) do
    Map.has_key?(sources, path)
  end

  @doc """
  Returns `true` if any source has one or more issues.
  """
  @spec issues?(t) :: boolean
  def issues?(%Rewrite{sources: sources}) do
    sources
    |> Map.values()
    |> Enum.any?(fn %Source{issues: issues} -> not Enum.empty?(issues) end)
  end

  @doc """
  Counts the sources with the given `extname` in the `rewrite` project.
  """
  @spec count(t, String.t()) :: non_neg_integer
  def count(%Rewrite{sources: sources}, extname) when is_binary(extname) do
    sources
    |> Map.keys()
    |> Enum.count(fn path -> Path.extname(path) == extname end)
  end

  @doc """
  Invokes `fun` for each `source` in the `rewrite` project and updates the
  `rewirte` project with the result of `fun`.

  Returns a `{:ok, rewrite}` if any update is successful.

  Returns `{:error, errors, rewrite}` where `rewrite` is updated for all sources
  that are updated successful. The `errors` are the `errors` of `update/3`.
  """
  @spec map(t(), (Source.t() -> Source.t())) ::
          {:ok, t()} | {:error, [{:nosource | :overwrites | :nopath, Source.t()}]}
  def map(%Rewrite{} = rewrite, fun) when is_function(fun, 1) do
    {rewrite, errors} =
      Enum.reduce(rewrite, {rewrite, []}, fn source, {rewrite, errors} ->
        with {:ok, updated} <- apply_update!(source, fun),
             {:ok, rewrite} <- do_update(rewrite, source.path, updated) do
          {rewrite, errors}
        else
          {:error, error} -> {rewrite, [error | errors]}
        end
      end)

    if Enum.empty?(errors) do
      {:ok, rewrite}
    else
      {:error, errors, rewrite}
    end
  end

  @doc """
  Return a `rewrite` project where each `source` is the result of invoking
  `fun` on each `source` of the given `rewrite` project.
  """
  @spec map!(t(), (Source.t() -> Source.t())) :: t()
  def map!(%Rewrite{} = rewrite, fun) when is_function(fun, 1) do
    Enum.reduce(rewrite, rewrite, fn source, rewrite ->
      with {:ok, updated} <- apply_update!(source, fun),
           {:ok, rewrite} <- do_update(rewrite, source.path, updated) do
        rewrite
      else
        {:error, error} -> raise error
      end
    end)
  end

  @doc """
  Writes a source to disk.

  The function expects a path or a `%Source{}` as first argument.

  Returns `{:ok, rewrite}` if the file was written successful. See also
  `Source.write/2`.

  If the given `source` is not part of the `rewrite` project then it is added.
  """
  @spec write(t(), Path.t() | Source.t(), nil | :force) ::
          {:ok, t()} | {:error, Error.t() | SourceError.t()}
  def write(rewrite, path, force \\ nil)

  def write(%Rewrite{} = rewrite, path, force) when is_binary(path) and force in [nil, :force] do
    with {:ok, source} <- source(rewrite, path) do
      write(rewrite, source, force)
    end
  end

  def write(%Rewrite{} = rewrite, %Source{} = source, force) when force in [nil, :force] do
    with {:ok, source} <- Source.write(source) do
      {:ok, Rewrite.update!(rewrite, source)}
    end
  end

  @doc """
  The same as `write/3` but raises an exception in case of an error.
  """
  @spec write!(t(), Path.t() | Source.t(), nil | :force) :: t()
  def write!(%Rewrite{} = rewrite, source, force \\ nil) do
    case write(rewrite, source, force) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Writes all sources in the `rewrite` project to disk.

  This function calls `Rewrite.Source.write/1` on all sources in the `rewrite`
  project.

  Returns `{:ok, rewrite}` if all sources are written successfully.

  Returns `{:error, reasons, rewrite}` where `rewrite` is updated for all
  sources that are written successfully.

  ## Options

  + `exclude` - a list paths to exclude form writting.
  + `force`, default: `false` - forces the writting of unchanged files.
  """
  @spec write_all(t(), opts()) ::
          {:ok, t()} | {:error, [SourceError.t()], t()}
  def write_all(%Rewrite{} = rewrite, opts \\ []) do
    exclude = Keyword.get(opts, :exclude, [])
    force = if Keyword.get(opts, :force, false), do: :force, else: nil

    write_all(rewrite, exclude, force)
  end

  defp write_all(%Rewrite{sources: sources} = rewrite, exclude, force)
       when force in [nil, :force] do
    sources = for {path, source} <- sources, path not in exclude, do: source
    writer = fn source -> Source.write(source, force: force) end

    {rewrite, errors} =
      Rewrite.TaskSupervisor
      |> Task.Supervisor.async_stream_nolink(sources, writer)
      |> Enum.reduce({rewrite, []}, fn {:ok, result}, {rewrite, errors} ->
        case result do
          {:ok, source} -> {Rewrite.update!(rewrite, source), errors}
          {:error, error} -> {rewrite, [error | errors]}
        end
      end)

    if Enum.empty?(errors) do
      {:ok, rewrite}
    else
      {:error, errors, rewrite}
    end
  end

  @doc """
  Formats the given `rewrite` project with the given `dot_formatter`.

  Uses the formatter from `dot_formatter/2` if no formatter ist set by
  `:dot_formatter` in the options. The other options are the same as for
  `DotFormatter.read!/2`.
  """
  @spec format(t(), opts()) :: {:ok, t()} | {:error, term()}
  def format(%Rewrite{} = rewrite, opts \\ []) do
    dot_formatter = Keyword.get(opts, :dot_formatter, dot_formatter(rewrite))
    DotFormatter.format_rewrite(dot_formatter, rewrite, opts)
  end

  @doc """
  The same as `format/2` but raises an exception in case of an error.
  """
  @spec format!(t(), opts()) :: t()
  def format!(rewrite, opts \\ []) do
    case format(rewrite, opts) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Formats a source in a `rewrite` project.

  Uses the formatter from `dot_formatter/2` if no formatter ist set by
  `:dot_formatter` in the options. The other options are the same as for
  `Code.format_string!/2`.
  """
  @spec format_source(t(), Path.t() | Source.t(), keyword()) :: {:ok, t()} | {:error, term()}
  def format_source(rewrite, file, opts \\ [])

  def format_source(%Rewrite{} = rewrite, %Source{path: path}, opts) when is_binary(path) do
    format_source(rewrite, path, opts)
  end

  def format_source(%Rewrite{} = rewrite, file, opts) do
    dot_formatter = Keyword.get_lazy(opts, :dot_formatter, fn -> dot_formatter(rewrite) end)
    DotFormatter.format_source(dot_formatter, rewrite, file, opts)
  end

  @doc """
  The same as `format_source/3` but raises an exception in case of an error.
  """
  @spec format_source!(t(), Path.t() | Source.t(), keyword()) :: t()
  def format_source!(rewrite, file, opts \\ []) do
    case format_source(rewrite, file, opts) do
      {:ok, source} -> source
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns the `DotFormatter` for the given `rewrite` project.

  When no formatter is set, the default formatter from
  `Rewrite.DotFormatter.default/0` is returned. A dot formatter can be set with
  `dot_formatter/2`.
  """
  @spec dot_formatter(t()) :: DotFormatter.t()
  def dot_formatter(%Rewrite{dot_formatter: nil}), do: DotFormatter.default()
  def dot_formatter(%Rewrite{dot_formatter: dot_formatter}), do: dot_formatter

  @doc """
  Sets a `dot_formatter` for the given `rewrite` project.
  """
  @spec dot_formatter(t(), DotFormatter.t() | nil) :: t()
  def dot_formatter(%Rewrite{} = rewrite, dot_formatter)
      when is_struct(dot_formatter, DotFormatter) or is_nil(dot_formatter) do
    %{rewrite | dot_formatter: dot_formatter}
  end

  @doc """
  Creates a new `%Source{}` and puts the source to the `%Rewrite{}` project.

  The `:filetypes` option of the project is used to create the source. If
  options have been specified for the file type, the given options will be
  merged into those options.

  Use `create_source/4` if the source is not to be inserted directly into the
  project.
  """
  @spec new_source(t(), Path.t(), String.t(), opts()) :: {:ok, t()} | {:error, Error.t()}
  def new_source(%Rewrite{sources: sources} = rewrite, path, content, opts \\ [])
      when is_binary(path) do
    case Map.has_key?(sources, path) do
      true ->
        {:error, Error.exception(reason: :overwrites, path: path)}

      false ->
        source = create_source(rewrite, path, content, opts)
        put(rewrite, source)
    end
  end

  @doc """
  Same as `new_source/4`, but raises a `Rewrite.Error` exception in case of failure.
  """
  @spec new_source!(t(), Path.t(), String.t(), opts()) :: t()
  def new_source!(%Rewrite{} = rewrite, path, content, opts \\ []) do
    case new_source(rewrite, path, content, opts) do
      {:ok, rewrite} -> rewrite
      {:error, error} -> raise error
    end
  end

  @doc """
  Creates a new `%Source{}` without putting it to the `%Rewrite{}` project.

  The `:filetypes` option of the project is used to create the source. If
  options have been specified for the file type, the given options will be
  merged into those options. If no `path` is given, the default file type is
  created.

  The function does not check whether the `%Rewrite{}` project already has a
  `%Source{}` with the specified path.

  Use `new_source/4` if the source is to be inserted directly into the project.
  """
  @spec create_source(t(), Path.t() | nil, String.t(), opts()) :: Source.t()
  def create_source(%Rewrite{} = rewrite, path, content, opts \\ []) do
    {source, source_opts} = extension_for_file(rewrite, path)
    opts = source_opts |> Keyword.merge(opts) |> Keyword.put(:path, path)

    source.from_string(content, opts)
  end

  defp extensions(opts) do
    opts
    |> Keyword.get(:filetypes, [Source, Source.Ex])
    |> Enum.flat_map(fn
      Source ->
        [{"default", Source}]

      {Source, opts} ->
        [{"default", {Source, opts}}]

      {module, opts} ->
        Enum.map(module.extensions(), fn extension -> {extension, {module, opts}} end)

      module ->
        Enum.map(module.extensions(), fn extension -> {extension, module} end)
    end)
    |> Map.new()
    |> Map.put_new("default", Source)
  end

  defp expand(inputs) do
    inputs
    |> List.wrap()
    |> Stream.map(&compile_globs!/1)
    |> Stream.flat_map(&GlobEx.ls/1)
    |> Stream.uniq()
  end

  defp compile_globs!(str) when is_binary(str), do: GlobEx.compile!(str, match_dot: true)

  defp compile_globs!(glob) when is_struct(glob, GlobEx), do: glob

  defimpl Enumerable do
    def count(rewrite) do
      {:ok, map_size(rewrite.sources)}
    end

    def member?(rewrite, %Source{} = source) do
      member? = Map.get(rewrite.sources, source.path) == source
      {:ok, member?}
    end

    def member?(_rewrite, _other) do
      {:ok, false}
    end

    def slice(rewrite) do
      size = map_size(rewrite.sources)

      to_list = fn rewrite ->
        rewrite.sources |> Map.values() |> Enum.sort_by(fn source -> source.path end)
      end

      {:ok, size, to_list}
    end

    def reduce(rewrite, acc, fun) do
      sources = Map.values(rewrite.sources)
      Enumerable.List.reduce(sources, acc, fun)
    end
  end

  defp handle_hooks(%{hooks: []} = rewrite, _action), do: rewrite

  defp handle_hooks(rewrite, {:added_sources, sources}) do
    paths = Enum.map(sources, fn {path, _source} -> path end)
    handle_hooks(rewrite, {:added, paths})
  end

  defp handle_hooks(%{hooks: hooks} = rewrite, action) do
    Enum.reduce(hooks, rewrite, fn hook, rewrite ->
      case hook.handle(action, rewrite) do
        :ok ->
          rewrite

        {:ok, rewrite} ->
          rewrite

        unexpected ->
          raise Error.exception(
                  reason: :unexpected_hook_response,
                  message: """
                  unexpected response from hook, got: #{inspect(unexpected)}\
                  """
                )
      end
    end)
  end

  defimpl Inspect do
    def inspect(rewrite, _opts) do
      "#Rewrite<#{Enum.count(rewrite.sources)} source(s)>"
    end
  end
end
