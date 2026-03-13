defmodule Rewrite.Source.Ex do
  @moduledoc ~s'''
  An implementation of `Rewrite.Filetype` to handle Elixir source files.

  The module uses the [`sourceror`](https://github.com/doorgan/sourceror) package
  to provide an [extended AST](https://hexdocs.pm/sourceror/readme.html#sourceror-s-ast)
  representation of an Elixir file.

  `Ex` extends the `source` by the key `:quoted`.

  ## Updating and resyncing `:quoted`

  When `:quoted` becomes updated, content becomes formatted to the Elixir source
  code. To keep the code in `:content` in sync with the AST in `:quoted`, the
  new code is parsed to a new `:quoted`. That means that
  `Source.update(source, :quoted, quoted)` also updates the AST.

  The resyncing of `:quoted` can be suppressed with the option
  `resync_quoted: false`.

  ## Examples

      iex> source = Source.Ex.from_string("Enum.reverse(list)")
      iex> Source.get(source, :quoted)
      {{:., [trailing_comments: [], line: 1, column: 5],
        [
          {:__aliases__,
           [
             trailing_comments: [],
             leading_comments: [],
             last: [line: 1, column: 1],
             line: 1,
             column: 1
           ], [:Enum]},
          :reverse
        ]},
       [
         trailing_comments: [],
         leading_comments: [],
         closing: [line: 1, column: 18],
         line: 1,
         column: 6
       ], [{:list, [trailing_comments: [], leading_comments: [], line: 1, column: 14], nil}]}
      iex> quoted = Code.string_to_quoted!("""
      ...> defmodule MyApp.New do
      ...>   def      foo do
      ...>   :foo
      ...> end
      ...> end
      ...> """)
      iex> source = Source.update(source, :quoted, quoted)
      iex> Source.updated?(source)
      true
      iex> Source.get(source, :content)
      """
      defmodule MyApp.New do
        def foo do
          :foo
        end
      end
      """
      iex> Source.get(source, :quoted) == quoted
      false

  Without resyncing `:quoted`:

      iex> project = Rewrite.new(filetypes: [{Source.Ex, resync_quoted: false}])
      iex> path = "test/fixtures/source/simple.ex"
      iex> project = Rewrite.read!(project, path)
      iex> source = Rewrite.source!(project, path)
      iex> quoted = Code.string_to_quoted!("""
      ...> defmodule MyApp.New do
      ...>   def      foo do
      ...>   :foo
      ...> end
      ...> end
      ...> """)
      iex> source = Source.update(source, :quoted, quoted)
      iex> Source.get(source, :quoted) == quoted
      true
  '''

  alias Rewrite.DotFormatter
  alias Rewrite.Source
  alias Rewrite.Source.Ex
  alias Sourceror.Zipper

  @enforce_keys [:quoted]
  defstruct [:quoted, opts: []]

  @type t :: %Ex{
          quoted: Macro.t(),
          opts: keyword()
        }

  @extensions [".ex", ".exs"]
  @default_path "nofile.ex"

  @behaviour Rewrite.Filetype

  @impl Rewrite.Filetype
  def extensions, do: @extensions

  @impl Rewrite.Filetype
  def default_path, do: @default_path

  @doc """
  Returns a `%Rewrite.Source{}` with an added `:filetype`.
  """
  @impl Rewrite.Filetype
  def from_string(string, opts \\ [])

  def from_string(string, opts) when is_list(opts) do
    string
    |> Source.from_string(opts)
    |> add_filetype(opts)
  end

  # @deprecated: use from_string/2 with opts as second argument
  def from_string(string, path) when is_binary(path) do
    from_string(string, path: path)
  end

  @doc """
  Returns a `%Rewrite.Source{}` with an added `:filetype`.

  The `content` reads from the file under the given `path`.

  ## Options

    * `:resync_quoted`, default: `true` - forcing the re-parsing when the source
      field `quoted` is updated.
  """
  @impl Rewrite.Filetype
  def read!(path, opts \\ []) do
    path
    |> Source.read!()
    |> add_filetype(opts)
  end

  @impl Rewrite.Filetype
  def handle_update(%Source{filetype: %Ex{} = ex}, :path, _opts), do: ex

  def handle_update(%Source{filetype: %Ex{} = ex} = source, :content, _opts) do
    %Ex{ex | quoted: Sourceror.parse_string!(source.content)}
  end

  @impl Rewrite.Filetype
  def handle_update(%Source{} = source, :quoted, value, opts) do
    %Source{filetype: %Ex{} = ex} = source

    quoted = quoted(value, ex.quoted)

    if ex.quoted == quoted do
      []
    else
      {quoted, code} = update_quoted(source, quoted, opts)

      [content: code, filetype: %Ex{ex | quoted: quoted}]
    end
  end

  defp quoted(updater, current) when is_function(updater, 1), do: updater.(current)
  defp quoted(quoted, _current), do: quoted

  defp update_quoted(%Source{filetype: %Ex{} = ex} = source, quoted, opts) do
    file = if source.path, do: source.path, else: "nofile.ex"
    dot_formatter = Keyword.get(opts, :dot_formatter, DotFormatter.default())
    code = DotFormatter.format_quoted!(dot_formatter, file, quoted)

    quoted =
      case resync_quoted?(ex) do
        true -> Sourceror.parse_string!(code)
        false -> quoted
      end

    {quoted, code}
  end

  @impl Rewrite.Filetype
  def undo(%Source{filetype: %Ex{} = ex} = source) do
    Source.filetype(source, %Ex{ex | quoted: Sourceror.parse_string!(source.content)})
  end

  @impl Rewrite.Filetype
  def fetch(%Source{filetype: %Ex{} = ex}, :quoted) do
    {:ok, ex.quoted}
  end

  def fetch(%Source{}, _key), do: :error

  @impl Rewrite.Filetype
  def fetch(%Source{filetype: %Ex{}, history: history} = source, :quoted, version)
      when version >= 1 and version <= length(history) + 1 do
    value = source |> Source.get(:content, version) |> Sourceror.parse_string!()

    {:ok, value}
  end

  def fetch(%Source{filetype: %Ex{}}, _key, _version), do: :error

  @doc """
  Returns the current modules for the given `source`.
  """
  @spec modules(Source.t()) :: [module()]
  def modules(%Source{filetype: %Ex{} = ex}) do
    get_modules(ex.quoted)
  end

  @doc ~S'''
  Returns the modules of a `source` for the given `version`.

  ## Examples

      iex> bar =
      ...>   """
      ...>   defmodule Bar do
      ...>      def bar, do: :bar
      ...>   end
      ...>   """
      iex> foo =
      ...>   """
      ...>   defmodule Baz.Foo do
      ...>      def foo, do: :foo
      ...>   end
      ...>   """
      iex> source = Source.Ex.from_string(bar)
      iex> source = Source.update(source, :content, bar <> foo)
      iex> Source.Ex.modules(source)
      [Baz.Foo, Bar]
      iex> Source.Ex.modules(source, 2)
      [Baz.Foo, Bar]
      iex> Source.Ex.modules(source, 1)
      [Bar]
  '''
  @spec modules(Source.t(), Source.version()) :: [module()]
  def modules(%Source{filetype: %Ex{}, history: history} = source, version)
      when version >= 1 and version <= length(history) + 1 do
    source |> Source.get(:content, version) |> Sourceror.parse_string!() |> get_modules()
  end

  defp add_filetype(source, opts) do
    opts = if opts, do: Keyword.take(opts, [:formatter_opts, :resync_quoted])

    ex =
      struct!(Ex,
        quoted: Sourceror.parse_string!(source.content),
        opts: opts
      )

    Source.filetype(source, ex)
  end

  defp get_modules(code) do
    code
    |> Zipper.zip()
    |> Zipper.traverse([], fn
      %Zipper{node: {:defmodule, _meta, [module | _args]}} = zipper, acc ->
        {zipper, [concat(module) | acc]}

      zipper, acc ->
        {zipper, acc}
    end)
    |> elem(1)
    |> Enum.uniq()
    |> Enum.filter(&is_atom/1)
  end

  defp concat({:__aliases__, _meta, module}), do: Module.concat(module)

  defp resync_quoted?(%Ex{opts: opts}), do: Keyword.get(opts, :resync_quoted, true)

  defimpl Inspect do
    def inspect(_source, _opts) do
      "#Rewrite.Source.Ex<.ex,.exs>"
    end
  end

  @deprecated "Use the formatting functionlity provided by Rewrite.DotFormatter instead."
  def put_formatter_opts(source, _opts), do: source

  @deprecated "Use the formatting functionlity provided by Rewrite.DotFormatter instead."
  def format(source, _formatter_opts \\ nil) do
    dot_formatter =
      case DotFormatter.read() do
        {:ok, dot_formatter} -> dot_formatter
        {:error, _error} -> DotFormatter.default()
      end

    source
    |> Source.format!(dot_formatter: dot_formatter)
    |> Source.get(:content)
  end
end
