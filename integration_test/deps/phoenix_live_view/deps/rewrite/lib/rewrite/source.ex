defmodule Rewrite.Source do
  @moduledoc """
  A representation of some source in a project.

  The `%Source{}` contains the `content` of the file given by `path`. The module
  contains `update/3` to update the `path` and/or the `content`. The changes are
  recorded in the `history` list.

  The struct also holds `issues` for the source.

  The different versions of `content` and `path` are available via `get/3`.

  A source is extensible via `filetype`, see `Rewrite.Filetype`.
  """

  alias Rewrite.DotFormatter
  alias Rewrite.Source
  alias Rewrite.SourceError
  alias Rewrite.SourceKeyError

  defstruct [
    :from,
    :path,
    :content,
    :hash,
    :owner,
    :filetype,
    :timestamp,
    history: [],
    issues: [],
    private: %{}
  ]

  @type opts :: keyword()

  @typedoc """
  A `timestamp` as `integer` seconds since epoch.
  """
  @type timestamp :: integer()

  @typedoc """
  The `version` of a `%Source{}`. The version `1` indicates that the source has
  no changes.
  """
  @type version :: pos_integer()

  @type kind :: :content | :path

  @type by :: module()
  @type owner :: module()

  @type key :: atom()
  @type value :: term()
  @type updater :: (term() -> term())

  @type content :: String.t()
  @type extension :: String.t()

  @type from :: :file | :string

  @type issue :: term()

  @type filetype :: map()

  @typedoc """
  The `struct` representing a source.

  ## Fields

    * `content` - of the `source`.

    * `filetype` - a `struct` implementing the behaviour `Rewrite.Filetype`.
      The `filetype` is nil when no additional implementation for the `filetype`
      is available.

    * `from` - contains `:file` or `:string` depending on whether the `source`
      is created from a file or a string.

    * `hash` - of the `source`. The `hash` is built from the `content` and
      `path`.

    * `history` - of the `source`.

    * `issues` - of the `source`.

    * `owner` - of the `source`.

    * `path` - of the `source`. Can be `nil` if the `source` was created by a
      `string`.

    * `private` - a field for user defined data.

    * `timestamp` - is set to the timestamp of the last modification of the file
      on disk at the time it was read.

      If the `source` was created by a `string`, the timestamp is the creation
      time.

      The timestamp will be updated when the `source` is updated.
  """
  @type t :: %Source{
          path: Path.t() | nil,
          content: String.t(),
          hash: non_neg_integer(),
          history: [{kind(), by(), String.t()}],
          issues: [{version(), issue()}],
          filetype: filetype(),
          timestamp: timestamp(),
          from: from(),
          owner: owner(),
          private: map()
        }

  @doc ~S'''
  Creates a new `%Source{}` from the given `path`.

  ## Examples

      iex> source = Source.read!("test/fixtures/source/hello.txt")
      iex> source.content
      """
      hello
      """
  '''
  @spec read!(Path.t(), opts) :: t()
  def read!(path, opts \\ []) do
    content = File.read!(path)
    mtime = File.stat!(path, time: :posix).mtime
    owner = Keyword.get(opts, :owner, Rewrite)

    new(
      content: content,
      path: path,
      owner: owner,
      from: :file,
      timestamp: mtime
    )
  end

  defp new(fields) do
    content = Keyword.fetch!(fields, :content)
    path = Keyword.get(fields, :path)

    struct!(
      Source,
      content: content,
      from: Keyword.fetch!(fields, :from),
      hash: hash(path, content),
      owner: Keyword.get(fields, :owner, Rewrite),
      path: path,
      timestamp: Keyword.fetch!(fields, :timestamp)
    )
  end

  @doc """
  Creates a new `%Source{}` from the given `string`.

  ## Options

    * `:owner` - an association to the module that owns the `source`.

    * `:dot_formatter` - a formatter for the `source`.

    * `path` - the path of the `source`.

  ## Examples

      iex> source = Source.from_string("hello")
      iex> source.content
      "hello"
      iex> source.path
      nil
      iex> source.owner
      Rewrite

      iex> source = Source.from_string("hello", path: "hello.md", owner: MyApp)
      iex> source.path
      "hello.md"
      iex> source.owner
      MyApp

  """
  @spec from_string(String.t(), opts()) :: t()
  def from_string(content, opts \\ [])

  def from_string(content, opts) when is_list(opts) do
    new(
      content: content,
      path: Keyword.get(opts, :path),
      owner: Keyword.get(opts, :owner, Rewrite),
      from: :string,
      timestamp: now(),
      dot_formatter: Keyword.get(opts, :dot_formatter)
    )
  end

  # @deprecated "Use the from_string functions with `opts` instead."
  def from_string(content, path) when is_binary(path) do
    from_string(content, path: path)
  end

  @doc ~S"""
  Writes the source to disk.

  Returns `{:ok, source}` when the file was written successfully. The returned
  `source` does not include any previous changes or issues.

  If there's an error, this function returns `{:error, error}` where `error`
  is a `Rewrite.SourceError`. You can raise it manually with `raise/1`.

  Returns `{:error, error}` with `reason: :nopath` if the current `path` is nil.

  Returns `{:error, error}` with `reason: :changed` if the file was changed
  since reading. See also `file_changed?/1`. The option `force: true` forces
  overwriting a changed file.

  If the source `:path` was updated then the old file will be deleted.

  Missing directories are created.

  ## Options

    * `:force`, default: `false` - forces the saving to overwrite changed files.

    * `:rm`, default: `true` - prevents file deletion when set to `false`.

  ## Examples

      iex> ":test" |> Source.from_string() |> Source.write()
      {:error, %SourceError{reason: :nopath, path: nil, action: :write}}

      iex> path = "tmp/foo.txt"
      iex> File.write(path, "foo")
      iex> source = path |> Source.read!() |> Source.update(:content, "bar")
      iex> Source.updated?(source)
      true
      iex> {:ok, source} = Source.write(source)
      iex> File.read(path)
      {:ok, "bar\n"}
      iex> Source.updated?(source)
      false

      iex> source = Source.from_string("bar")
      iex> Source.write(source)
      {:error, %SourceError{reason: :nopath, path: nil, action: :write}}
      iex> source |> Source.update(:path, "tmp/bar.txt") |> Source.write()
      iex> File.read("tmp/bar.txt")
      {:ok, "bar\n"}

      iex> path = "tmp/ping.txt"
      iex> File.write(path, "ping")
      iex> source = Source.read!(path)
      iex> new_path = "tmp/pong.ex"
      iex> source = Source.update(source, :path, new_path)
      iex> Source.write(source)
      iex> File.exists?(path)
      false
      iex> File.read(new_path)
      {:ok, "ping\n"}

      iex> path = "tmp/ping.txt"
      iex> File.write(path, "ping")
      iex> source = Source.read!(path)
      iex> new_path = "tmp/pong.ex"
      iex> source = Source.update(source, :path, new_path)
      iex> Source.write(source, rm: false)
      iex> File.exists?(path)
      true

      iex> path = "tmp/ping.txt"
      iex> File.write(path, "ping")
      iex> source = path |> Source.read!() |> Source.update(:content, "peng")
      iex> File.write(path, "pong")
      iex> Source.write(source)
      {:error, %SourceError{reason: :changed, path: "tmp/ping.txt", action: :write}}
      iex> {:ok, _source} = Source.write(source, force: true)
  """
  @spec write(t(), opts()) :: {:ok, t()} | {:error, SourceError.t()}
  def write(%Source{} = source, opts \\ []) do
    force = Keyword.get(opts, :force, false)
    rm = Keyword.get(opts, :rm, true)
    write(source, force, rm)
  end

  defp write(%Source{path: nil}, _force, _rm) do
    {:error, SourceError.exception(reason: :nopath, action: :write)}
  end

  defp write(%Source{history: []} = source, _force, _rm), do: {:ok, source}

  defp write(%Source{path: path, content: content} = source, force, rm) do
    if file_changed?(source) && !force do
      {:error, SourceError.exception(reason: :changed, path: source.path, action: :write)}
    else
      with :ok <- maybe_rm(source, rm),
           :ok <- mkdir_p(path),
           :ok <- file_write(path, eof_newline(content)) do
        {:ok, %{source | hash: hash(path, content), history: [], issues: []}}
      end
    end
  end

  defp file_write(path, content) do
    with {:error, reason} <- File.write(path, content) do
      {:error, SourceError.exception(reason: reason, path: path, action: :write)}
    end
  end

  defp mkdir_p(path) do
    path |> Path.dirname() |> File.mkdir_p()
  end

  defp maybe_rm(_source, false), do: :ok

  defp maybe_rm(source, true) do
    case {Source.updated?(source, :path), Source.get(source, :path, 1)} do
      {false, _path} ->
        :ok

      {true, nil} ->
        :ok

      {true, path} ->
        with {:error, reason} <- File.rm(path) do
          {:error, SourceError.exception(reason: reason, path: path, action: :write)}
        end
    end
  end

  @doc """
  Same as `write/1`, but raises a `Rewrite.SourceError` exception in case of
  failure.
  """
  @spec write!(t()) :: t()
  def write!(%Source{} = source) do
    case write(source) do
      {:ok, source} -> source
      {:error, error} -> raise error
    end
  end

  @doc """
  Tries to delete the file `source`.

  Returns `:ok` if successful, or `{:error, reason}` if an error occurs.

  Note the file is deleted even if in read-only mode.
  """
  @spec rm(t()) :: :ok | {:error, SourceError.t()}
  def rm(%Source{path: nil}), do: {:error, %SourceError{reason: :nopath, action: :rm}}

  def rm(%Source{path: path}) do
    with {:error, reason} <- File.rm(path) do
      {:error, %SourceError{reason: reason, action: :rm, path: path}}
    end
  end

  @doc """
  Same as `rm/1`, but raises a `Rewrite.SourceError` exception in case of
  failure. Otherwise `:ok`.
  """
  @spec rm!(t()) :: :ok
  def rm!(%Source{} = source) do
    with {:error, reason} <- rm(source), do: raise(reason)
  end

  @doc """
  Returns the `version` of the given `source`. The value `1` indicates that the
  source has no changes.
  """
  @spec version(t()) :: version()
  def version(%Source{history: history}), do: length(history) + 1

  @doc """
  Returns the owner of the given `source`.
  """
  @spec owner(t()) :: module()
  def owner(%Source{owner: owner}), do: owner

  @doc """
  Adds the given `issues` to the `source`.
  """
  @spec add_issues(t(), [issue()]) :: t()
  def add_issues(%Source{} = source, []), do: source

  def add_issues(%Source{issues: list} = source, issues) do
    version = version(source)
    issues = issues |> Enum.map(fn issue -> {version, issue} end) |> Enum.concat(list)

    %Source{source | issues: issues}
  end

  @doc """
  Adds the given `issue` to the `source`.
  """
  @spec add_issue(t(), issue()) :: t()
  def add_issue(%Source{} = source, issue), do: add_issues(source, [issue])

  @doc """
  Returns all issues of the given `source`.
  """
  @spec issues(t()) :: [issue()]
  def issues(source) do
    source
    |> Map.get(:issues, [])
    |> Enum.map(fn {_version, issue} -> issue end)
  end

  @doc """
  Assigns a private `key` and `value` to the `source`.

  This is not used or accessed by Rewrite, but is intended as private storage
  for users or libraries that wish to store additional data about a source.

  ## Examples

      iex> source =
      ...>   "a + b"
      ...>   |> Source.from_string()
      ...>   |> Source.put_private(:origin, :example)
      iex> source.private[:origin]
      :example
  """
  @spec put_private(t(), key(), value()) :: t()
  def put_private(%Source{} = source, key, value) do
    Map.update!(source, :private, &Map.put(&1, key, value))
  end

  @doc ~S"""
  Updates the `content` or the `path` of a `source`.

  The given `value` can be of type `t:value/0` or an updater function that gets
  the current value and returns the new value.

  ## Examples

      iex> source =
      ...>   "foo"
      ...>   |> Source.from_string()
      ...>   |> Source.update(:path, "test/fixtures/new.exs", by: Example)
      ...>   |> Source.update(:content, "bar")
      iex> source.history
      [{:content, Rewrite, "foo"}, {:path, Example, nil}]
      iex> source.content
      "bar"

      iex> source =
      ...>   "foo"
      ...>   |> Source.from_string()
      ...>   |> Source.update(:content, fn content -> content <> "bar" end)
      iex> source.content
      "foobar"

  With a `Rewrite.Source.Ex`. Note that the AST is generated by `Sourceror`.

      iex> source =
      ...>   ":a"
      ...>   |> Source.Ex.from_string()
      ...>   |> Source.update(:quoted, fn quoted ->
      ...>     {:__block__, meta, [atom]} = quoted
      ...>     {:__block__, meta, [{:ok, atom}]}
      ...>   end)
      iex> source.content
      "{:ok, :a}\n"

  If the new value is equal to the current value, no history will be added.

      iex> source =
      ...>   "42"
      ...>   |> Source.from_string()
      ...>   |> Source.update(:content, "21", by: Example)
      ...>   |> Source.update(:content, "21", by: Example)
      iex> source.history
      [{:content, Example, "42"}]
  """
  @spec update(Source.t(), key(), value() | updater(), opts()) :: Source.t()
  def update(source, key, value, opts \\ [])

  def update(%Source{} = source, key, value, opts)
      when key in [:content, :path] and is_list(opts) do
    legacy = Map.fetch!(source, key)
    value = value(value, legacy)

    case legacy == value do
      true ->
        source

      false ->
        by = Keyword.get(opts, :by, Rewrite)

        source
        |> update_timestamp()
        |> do_update(key, value)
        |> update_history(key, by, legacy)
        |> update_filetype(key, opts)
    end
  end

  def update(%Source{filetype: %module{}} = source, key, value, opts)
      when is_atom(key) and is_list(opts) do
    updates = module.handle_update(source, key, value, opts)

    case updates do
      [] ->
        source

      updates ->
        filetype = Keyword.get(updates, :filetype, source.filetype)
        content = Keyword.get(updates, :content, source.content)
        by = Keyword.get(opts, :by, Rewrite)

        source
        |> Map.put(:filetype, filetype)
        |> update_content(content, by)
        |> update_timestamp()
    end
  end

  # @deprecated "Use the update functions with `opts` instead."
  def update(source, by, key, content) do
    update(source, key, content, by: by)
  end

  defp value(updater, legacy) when is_function(updater, 1), do: updater.(legacy)
  defp value(value, _legacy), do: value

  defp update_timestamp(source), do: %{source | timestamp: now()}

  defp do_update(%Source{} = source, :path, path) do
    %{source | path: path}
  end

  defp do_update(%Source{} = source, :content, content) do
    %{source | content: content}
  end

  defp update_filetype(%Source{filetype: nil} = source, _key, _opts), do: source

  defp update_filetype(%Source{filetype: %module{}} = source, key, opts) when is_atom(key) do
    filetype = module.handle_update(source, key, opts)

    %{source | filetype: filetype}
  end

  defp update_content(source, nil, _by), do: source

  defp update_content(source, content, by) do
    legacy = Map.fetch!(source, :content)

    case legacy == content do
      true ->
        source

      false ->
        source
        |> do_update(:content, content)
        |> update_history(:content, by, legacy)
    end
  end

  @doc """
  Sets the `timestamp` to the current POSIX timestamp.

  Does not touch the underlying file.
  """
  @spec touch(t()) :: t()
  def touch(source), do: touch(source, now())

  @doc """
  Sets the `timestamp` of the given `source` to the given `timestamp`.

  Does not touch the underlying file.
  """
  @spec touch(t(), timestamp()) :: t()
  def touch(source, timestamp), do: %{source | timestamp: timestamp}

  @doc """
  Returns `true` if the source was updated.

  The optional argument `kind` specifies whether only `:code` changes or `:path`
  changes are considered. Defaults to `:any`.

  ## Examples

      iex> source = Source.from_string("foo")
      iex> Source.updated?(source)
      false
      iex> source = Source.update(source, :content, "bar")
      iex> Source.updated?(source)
      true
      iex> Source.updated?(source, :path)
      false
      iex> Source.updated?(source, :content)
      true
  """
  @spec updated?(t(), kind :: :content | :path | :any) :: boolean()
  def updated?(source, kind \\ :any)

  def updated?(%Source{history: []}, _kind), do: false

  def updated?(%Source{history: _history}, :any), do: true

  def updated?(%Source{history: history}, kind) when kind in [:content, :path] do
    Enum.any?(history, fn
      {^kind, _by, _value} -> true
      _update -> false
    end)
  end

  @doc """
  Returns `true` if the file has been modified since it was read.

  If the key `:from` does not contain `:file` the function returns `false`.

  ## Examples

      iex> File.write("tmp/hello.txt", "hello")
      iex> source = Source.read!("tmp/hello.txt")
      iex> Source.file_changed?(source)
      false
      iex> File.write("tmp/hello.txt", "Hello, world!")
      iex> Source.file_changed?(source)
      true
      iex> source = Source.update(source, :path, nil)
      iex> Source.file_changed?(source)
      true
      iex> File.write("tmp/hello.txt", "hello")
      iex> Source.file_changed?(source)
      false
      iex> File.rm!("tmp/hello.txt")
      iex> Source.file_changed?(source)
      true

      iex> source = Source.from_string("hello")
      iex> Source.file_changed?(source)
      false
  """
  @spec file_changed?(Source.t()) :: boolean
  def file_changed?(%Source{from: from}) when from != :file, do: false

  def file_changed?(%Source{} = source) do
    path = get(source, :path, 1)

    case File.read(path) do
      {:ok, content} -> hash(path, content) != source.hash
      _error -> true
    end
  end

  @doc """
  Returns `true` if the `source` has issues for the given `version`.

  The `version` argument also accepts `:actual` and `:all` to check whether the
  `source` has problems for the actual version or if there are problems at all.

  ## Examples

      iex> source =
      ...>   "a + b"
      ...>   |> Source.Ex.from_string(path: "some/where/plus.exs")
      ...>   |> Source.add_issue(%{issue: :foo})
      ...>   |> Source.update(:path, "some/where/else/plus.exs")
      ...>   |> Source.add_issue(%{issue: :bar})
      iex> Source.has_issues?(source)
      true
      iex> Source.has_issues?(source, 1)
      true
      iex> Source.has_issues?(source, :all)
      true
      iex> source = Source.update(source, :content, "a - b")
      iex> Source.has_issues?(source)
      false
      iex> Source.has_issues?(source, 2)
      true
      iex> Source.has_issues?(source, :all)
      true
  """
  @spec has_issues?(t(), version() | :actual | :all) :: boolean
  def has_issues?(source, version \\ :actual)

  def has_issues?(%Source{issues: issues}, :all), do: not_empty?(issues)

  def has_issues?(%Source{} = source, :actual) do
    has_issues?(source, version(source))
  end

  def has_issues?(%Source{issues: issues, history: history}, version)
      when version >= 1 and version <= length(history) + 1 do
    issues
    |> Enum.filter(fn {for_version, _issue} -> for_version == version end)
    |> not_empty?()
  end

  @doc """
  Gets the value for `:content`, `:path` in `source` or a specific `key` in
  `filetype`.

  Raises `Rewrite.SourceKeyError` if the `key` can't be found.
  """
  @spec get(Source.t(), key()) :: value()
  def get(%Source{path: path}, :path), do: path

  def get(%Source{content: content}, :content), do: content

  def get(%Source{filetype: nil}, key) when is_atom(key) do
    raise SourceKeyError, key: key
  end

  def get(%Source{filetype: %module{}} = source, key) do
    case module.fetch(source, key) do
      {:ok, value} -> value
      :error -> raise SourceKeyError, key: key
    end
  end

  @doc """
  Gets the value for `:content`, `:path` in `source` or a specific `key` in
  `filetype` for the given `version`.

  Raises `Rewrite.SourceKeyError` if the `key` can't be found.

  ## Examples

      iex> bar =
      ...>   \"""
      ...>   defmodule Bar do
      ...>      def bar, do: :bar
      ...>   end
      ...>   \"""
      iex> foo =
      ...>   \"""
      ...>   defmodule Foo do
      ...>      def foo, do: :foo
      ...>   end
      ...>   \"""
      iex> source = Source.Ex.from_string(bar)
      iex> source = Source.update(source, :content, foo)
      iex> Source.get(source, :content) == foo
      true
      iex> Source.get(source, :content, 2) == foo
      true
      iex> Source.get(source, :content, 1) == bar
      true

      iex> source =
      ...>   "hello"
      ...>   |> Source.from_string(path: "some/where/hello.txt")
      ...>   |> Source.update(:path, "some/where/else/hello.txt")
      ...> Source.get(source, :path, 1)
      "some/where/hello.txt"
      iex> Source.get(source, :path, 2)
      "some/where/else/hello.txt"

  """
  @spec get(Source.t(), key(), version()) :: value()
  def get(%Source{history: history} = source, key, version)
      when key in [:content, :path] and
             version >= 1 and version <= length(history) + 1 do
    value = Map.fetch!(source, key)

    history
    |> Enum.take(length(history) - version + 1)
    |> Enum.reduce(value, fn
      {^key, _by, value}, _value -> value
      _version, value -> value
    end)
  end

  def get(%Source{filetype: nil}, key, _version) do
    raise SourceKeyError, key: key
  end

  def get(%Source{filetype: %moudle{}} = source, key, version) do
    case moudle.fetch(source, key, version) do
      {:ok, value} -> value
      :error -> raise SourceKeyError, key: key
    end
  end

  @doc ~S'''
  Returns iodata showing all diffs of the given `source`.

  See `TextDiff.format/3` for options.

  ## Examples

      iex> code = """
      ...> def foo( x ) do
      ...>   {:x,
      ...>     x}
      ...> end
      ...> """
      iex> formatted = code |> Code.format_string!() |> IO.iodata_to_binary()
      iex> source = Source.Ex.from_string(code)
      iex> source |> Source.diff() |> IO.iodata_to_binary()
      ""
      iex> source
      ...> |> Source.update(:content, formatted)
      ...> |> Source.diff(color: false)
      ...> |> IO.iodata_to_binary()
      """
      1   - |def foo( x ) do
      2   - |  {:x,
      3   - |    x}
        1 + |def foo(x) do
        2 + |  {:x, x}
      4 3   |end
      5 4   |
      """
  '''
  @spec diff(t(), opts()) :: iodata()
  def diff(%Source{} = source, opts \\ []) do
    TextDiff.format(
      source |> get(:content, 1) |> eof_newline(),
      source |> get(:content) |> eof_newline(),
      opts
    )
  end

  @doc """
  Calculates the current hash from the given `source`.
  """
  @spec hash(t()) :: non_neg_integer()
  def hash(%Source{path: path, content: content}), do: hash(path, content)

  defp hash(path, code), do: :erlang.phash2({path, code})

  @doc """
  Sets the `filetype` for the `source`.
  """
  @spec filetype(t(), filetype()) :: t()
  def filetype(%Source{} = source, filetype), do: %Source{source | filetype: filetype}

  @doc """
  Returns true when `from` matches to value for key `:from`.

  ## Examples

      iex> source = Source.from_string("hello")
      iex> Source.from?(source, :file)
      false
      iex> Source.from?(source, :string)
      true
  """
  @spec from?(t(), :file | :string) :: boolean
  def from?(%Source{from: value}, from) when from in [:file, :string], do: value == from

  @doc """
  Undoes the given `number` of changes.

  ## Examples
      iex> a = Source.from_string("test-a", path: "test/foo.txt")
      iex> b = Source.update(a, :content, "test-b")
      iex> c = Source.update(b, :path, "test/bar.txt")
      iex> d = Source.update(c, :content, "test-d")
      iex> d |> Source.undo() |> Source.get(:content)
      "test-b"
      iex> d |> Source.undo(1) |> Source.get(:content)
      "test-b"
      iex> d |> Source.undo(2) |> Source.get(:path)
      "test/foo.txt"
      iex> d |> Source.undo(3) |> Source.get(:content)
      "test-a"
      iex> d |> Source.undo(9) |> Source.get(:content)
      "test-a"
      iex> d |> Source.undo(9) |> Source.updated?()
      false
      iex> d |> Source.undo(-9) |> Source.get(:content)
      "test-d"
  """
  @spec undo(t(), non_neg_integer()) :: t()
  def undo(source, number \\ 1)

  def undo(%Source{filetype: nil} = source, number) when number < 1, do: source

  def undo(%Source{filetype: %module{}} = source, 0), do: module.undo(source)

  def undo(%Source{history: []} = source, _number), do: undo(source, 0)

  def undo(%Source{history: [undo | history]} = source, number) do
    source =
      case undo do
        {:content, _by, content} -> %Source{source | history: history, content: content}
        {:path, _by, path} -> %Source{source | history: history, path: path}
      end

    undo(source, number - 1)
  end

  @doc ~s'''
  Formats the given `source`.

  If the `source` was formatted the `source` gets a new `:history` entry,
  otherwise the unchanged `source` is returned.

  ## Options

    * `by` - an `atom` or `module` that is used as `:by` key when the `source`
      is updated. Defaults to `Rewrite`.

    * `dot_formatter` - defaults to `Rewrite.DotFormatter.default/0`.

    * Accepts also the same options as `Code.format_string!/2`.

  ## Examples


      iex> source = Source.Ex.from_string("""
      ...> defmodule    Foo do
      ...>     def   foo(x),   do:    bar x
      ...>    end
      ...> """)
      iex> {:ok, formatted} = Source.format(source, force_do_end_blocks: true)
      iex> formatted.content
      """
      defmodule Foo do
        def foo(x) do
          bar(x)
        end
      end
      """
      iex> dot_formatter = DotFormatter.from_formatter_opts(locals_without_parens: [bar: 1])
      iex> {:ok, formatted} = Source.format(source,
      ...>   dot_formatter: dot_formatter, force_do_end_blocks: true
      ...> )
      iex> formatted.content
      """
      defmodule Foo do
        def foo(x) do
          bar x
        end
      end
      """
  '''
  @spec format(t(), opts()) :: {:ok, t()} | {:error, term()}
  def format(%Source{} = source, opts \\ []) do
    path = Map.get(source, :path) || default_path(source)
    dot_formatter = Keyword.get(opts, :dot_formatter, DotFormatter.default())
    by = Keyword.get(opts, :by, Rewrite)

    with {:ok, formatted} <- DotFormatter.format_string(dot_formatter, path, source.content, opts) do
      {:ok, update(source, :content, formatted, by: by)}
    end
  end

  @doc """
  Same as `format/2`, but raises an exception in case of failure.
  """
  @spec format(t(), opts()) :: t()
  def format!(%Source{} = source, opts \\ []) do
    case format(source, opts) do
      {:ok, source} -> source
      {:error, error} -> raise error
    end
  end

  @doc """
  The default `path` for the `source`.
  """
  @spec default_path(t()) :: Path.t()
  def default_path(%Source{filetype: %module{}}), do: module.default_path()
  def default_path(_source), do: "nofile"

  defp update_history(%Source{history: history} = source, key, by, legacy) do
    %{source | history: [{key, by, legacy} | history]}
  end

  defp not_empty?(enum), do: not Enum.empty?(enum)

  defp eof_newline(string), do: String.trim_trailing(string) <> "\n"

  defp now, do: :os.system_time(:second)

  defimpl Inspect do
    def inspect(source, _opts) do
      "#Rewrite.Source<#{source.path}>"
    end
  end
end
