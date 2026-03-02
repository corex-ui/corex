defmodule GlobEx do
  @moduledoc """
  Provides glob expressions for Elixir.

  A glob expression looks like an ordinary path, except that the following
  "wildcard characters" are interpreted in a special way:

    * `?` - matches one character.
    * `*` - matches any number of characters up to the end of the filename, the
      next dot, or the next slash.
    * `**` - two adjacent `*`'s used as a single pattern will match all
      files and zero or more directories and subdirectories.
    * `[char1,char2,...]` - matches any of the characters listed; two
      characters separated by a hyphen will match a range of characters.
      Do not add spaces before and after the comma as it would then match
      paths containing the space character itself.
    * `{item1,item2,...}` - matches one of the alternatives.
      Do not add spaces before and after the comma as it would then match
      paths containing the space character itself.

  Other characters represent themselves. Only paths that have
  exactly the same character in the same position will match. Note
  that matching is case-sensitive: `"a"` will not match `"A"`.

  Directory separators must always be written as `/`, even on Windows.
  You may call `Path.expand/1` to normalize the path before invoking
  this function.

  A character preceded by \ loses its special meaning.
  Note that \ must be written as \\ in a string literal.
  For example, "\\?*" will match any filename starting with ?.

  Glob expressions can be created using `compile/2`, `compile!/2` or the sigils 
  ~g (see `GlobEx.Sigils.sigil_g/2`) or ~G (see `GlobEx.Sigils.sigil_G/2`).

  ```elixir
  # A simple glob expressions matching all `.exs` files in a tree. By default,
  # the patterns `*` and `?` do not match files starting with a `.`.
  ~g|**/*.exs|

  # The modifier `d` let the glob treat files starting with a `.` as any other
  # file.
  ~g|**/*.exs|d
  ```
  """

  alias GlobEx.CompileError
  alias GlobEx.Compiler

  defstruct source: "", match_dot: false, compiled: []

  @type t :: %__MODULE__{source: binary(), match_dot: boolean(), compiled: [term()]}

  @cwd ~c"."
  @root ~c"/"

  @doc """
  Compiles the glob expression and raises GlobEx.CompileError in case of errors.

  See the module documentation for how to write a glob expression and
  `compile/2` for the available options.
  """
  @spec compile!(binary(), keyword()) :: t()
  def compile!(glob, opts \\ []) do
    case compile(glob, opts) do
      {:ok, glob} -> glob
      {:error, exception} -> raise exception
    end
  end

  @doc """
  Compiles the glob expression.

  It returns `{:ok, regex}` in case of success, `{:error, reason}` otherwise.

  See the module documentation for how to write a glob expression.

  By default, the patterns `*` and `?` do not match files starting with a `.`.
  This behaviour can be change with the option `:match_dot`.

  ## Options

    * `:match_dot` - (boolean) if `false`, the special wildcard characters `*` and `?`
      will not match files starting with a `.`. If `true`, files starting with
      a `.` will not be treated specially. Defaults to `false`.

  ## Examples

      iex> GlobEx.compile("src/**/?oo.ex")
      {:ok, ~g|src/**/?oo.ex|}

      iex> GlobEx.compile("src/{a,b/?oo.ex")
      {:error, %GlobEx.CompileError{reason: {:missing_delimiter, 5}, input: "src/{a,b/?oo.ex"}}
  """
  @spec compile(binary(), keyword()) :: {:ok, t()} | {:error, CompileError.t()}
  def compile(glob, opts \\ []) do
    match_dot = Keyword.get(opts, :match_dot, false)

    case Compiler.compile(glob) do
      {:ok, compiled} ->
        {:ok, %GlobEx{source: glob, compiled: compiled, match_dot: match_dot}}

      {:error, reason} ->
        {:error, %CompileError{reason: reason, input: glob}}
    end
  end

  @doc """
  Traverses paths according to the given `glob` expression and returns a list of
  matches.

  See the module documentation for how to write a glob expression.

  ## Examples

      iex> GlobEx.ls(~g|{lib,test}/**/*.{ex,exs}|)
      [
        "lib/glob_ex.ex",
        "lib/glob_ex/compiler.ex",
        "lib/glob_ex/compiler_error.ex",
        "lib/glob_ex/sigils.ex",
        "test/glob_ex/compiler_test.exs",
        "test/glob_ex_test.exs",
        "test/test_helper.exs"
      ]
  """
  @spec ls(t()) :: [Path.t()]
  def ls(%GlobEx{compiled: compiled, match_dot: match_dot}) do
    compiled
    |> list(match_dot)
    |> Enum.reduce([], fn path, acc ->
      [:unicode.characters_to_binary(path) | acc]
    end)
    |> Enum.sort()
  end

  @doc """
  Returns a boolean indicating whether there was a match or not.

  See the module documentation on how to write a glob expression.

  Hidden files starting with a `.` will only be matched  if `match_dot` is 
  `true` or the `~g`/`~G` has the modifier `d`. However, if the glob expression 
  consists of an exact path to a hidden file, this path is also matched. 

  ## Examples

      iex> GlobEx.match?(~g|{lib,test}/**/*.{ex,exs}|, "lib/foo/bar.ex")
      true

      iex> GlobEx.match?(~g|{lib,test}/**/*.{ex,exs}|, "lib/foo/bar.java")
      false

  Examples for exact path to a hidden file:

      iex> GlobEx.match?(~g|lib/.foo.ex|, "lib/.foo.ex")
      true

      iex> GlobEx.match?(~g|**/.foo.ex|, "lib/.foo.ex")
      false

      iex> GlobEx.match?(~g|**/.foo.ex|d, "lib/.foo.ex")
      true
  """
  @spec match?(t(), Path.t()) :: boolean()
  def match?(%GlobEx{compiled: compiled, match_dot: match_dot}, path) do
    path = split(path, [[]])

    with {compiled, path} <- exact(compiled, path) do
      match?(compiled, match_dot, path)
    end
  end

  defp match?([{:exact, ~c".."} | glob], match_dot, [comp | path]) do
    if ~c".." == comp, do: match?(glob, match_dot, path), else: false
  end

  defp match?([:double_star], _match_dot, []) do
    false
  end

  defp match?([:double_star], true, _path) do
    true
  end

  defp match?([:double_star], false, path) do
    not hidden?(path)
  end

  defp match?([:double_star, pattern | rest] = glob, match_dot, [comp | path]) do
    with true <- match_dot?(comp, match_dot) do
      case match_comp?(comp, pattern) do
        true -> match?(rest, match_dot, path) or match?(glob, match_dot, path)
        false -> match?(glob, match_dot, path)
      end
    end
  end

  defp match?([:root, {:exact, exact} | glob], match_dot, [[], comp | path]) do
    if exact == comp do
      with {glob, path} <- exact(glob, path) do
        match?(glob, match_dot, path)
      end
    else
      false
    end
  end

  defp match?([], _match_dot, []) do
    true
  end

  defp match?([], _match_dot, _path) do
    false
  end

  defp match?(_glob, _match_dot, []) do
    false
  end

  defp match?([pattern | glob], match_dot, [comp | path]) do
    with true <- match_comp?(comp, match_dot, pattern) do
      match?(glob, match_dot, path)
    end
  end

  defp exact([{:exact, exact} | glob], [comp | path]) do
    if exact == comp, do: exact(glob, path), else: false
  end

  defp exact([], []), do: true

  defp exact(glob, path), do: {glob, path}

  defp list([:root | glob], match_dot), do: list(glob, match_dot, [@root])

  defp list([{:root, vol} | glob], match_dot) do
    list(glob, match_dot, [vol])
  end

  defp list(glob, match_dot), do: list(glob, match_dot, [@cwd])

  defp list(_glob, _match_dot, []), do: []

  defp list([], _match_dot, result), do: result

  defp list([{:exact, _file} | _glob] = glob, match_dot, [match]) when match in [@cwd, @root] do
    list_exact(glob, match_dot, match)
  end

  defp list([{:exact, _file} | _glob] = glob, match_dot, [[_vol | ~c":/"] = match]) do
    list_exact(glob, match_dot, match)
  end

  defp list([:double_star], match_dot, matches) do
    trees(matches, match_dot)
  end

  defp list([:double_star, next | glob], match_dot, matches) do
    matches = double_star_matches(matches, match_dot, next, [])
    list(glob, match_dot, matches)
  end

  defp list([{:exact, ~c".."} | glob], match_dot, matches) do
    matches = for match <- matches, :filelib.is_dir(match), do: join(match, ~c"..")

    list(glob, match_dot, matches)
  end

  defp list([pattern | glob], match_dot, matches) do
    matches =
      for match <- matches,
          comp <- list_dir(match),
          match_comp?(comp, match_dot, pattern) do
        match = if match == ~c"/", do: ~c"", else: match
        join(match, comp)
      end

    list(glob, match_dot, matches)
  end

  defp list_exact([{:exact, file} | glob], match_dot, dir) do
    {path, glob} = path(file, glob)

    path =
      case dir do
        @cwd -> path
        @root -> ~c"/" ++ path
        vol -> vol ++ path
      end

    case file_exists?(path) do
      true -> list(glob, match_dot, [path])
      false -> []
    end
  end

  defp path(path, [{:exact, file} | glob]) do
    path(:filename.join(path, file), glob)
  end

  defp path(path, glob), do: {path, glob}

  defp match_comp?([?. | _rest], false, _pattern) do
    false
  end

  defp match_comp?(comp, _match_dot, pattern) do
    match_comp?(comp, pattern)
  end

  defp match_comp?(comp, {:exact, exact}) do
    exact == comp
  end

  defp match_comp?(_comp, :star) do
    true
  end

  defp match_comp?(comp, {:seq, seq}) do
    seq?(seq, comp)
  end

  defp match_comp?(comp, {:ends_with, ends_with}) do
    ends_with?(comp, ends_with)
  end

  defp match_comp?(comp, {:alt, alt}) do
    Enum.any?(alt, fn
      :empty -> true
      [pattern] -> match_comp?(comp, pattern)
    end)
  end

  defp match_comp?([comp], {:one_of, one_of}) do
    comp in one_of
  end

  defp match_comp?(comp, :root) do
    comp == []
  end

  defp match_comp?(_comp, {:one_of, _one_of}) do
    false
  end

  defp match_dot?([?. | _charlist], false) do
    false
  end

  defp match_dot?(_charlist, _match_dot) do
    true
  end

  defp join(@cwd, right) do
    right
  end

  defp join(left, right) do
    left ++ [?/ | right]
  end

  defp seq?([:star], _file) do
    true
  end

  defp seq?([x | seq], [x | file]) do
    seq?(seq, file)
  end

  defp seq?([:question | seq], [_x | file]) do
    seq?(seq, file)
  end

  defp seq?([], []) do
    true
  end

  defp seq?([_ | _], []) do
    false
  end

  defp seq?([:star, next | seq], [next | file]) do
    seq?(seq, file)
  end

  defp seq?([:star, next | _rest] = seq, [_char | file]) when is_integer(next) do
    seq?(seq, file)
  end

  defp seq?([:star | seq], file) do
    with false <- seq?(seq, file) do
      seq?([:star | seq], tl(file))
    end
  end

  defp seq?([{:alt, _alt} = pattern], file) do
    match_comp?(file, pattern)
  end

  defp seq?([{:one_of, one_of} | seq], [char | file]) do
    with true <- char in one_of do
      seq?(seq, file)
    end
  end

  defp seq?(_seq, _file) do
    false
  end

  defp ends_with?(a, b), do: a |> :lists.reverse() |> do_ends_with?(b)

  defp do_ends_with?(_a, []), do: true
  defp do_ends_with?([x | as], [x | bs]), do: do_ends_with?(as, bs)
  defp do_ends_with?(_a, _b), do: false

  @compile {:inline, list_dir: 1}
  defp list_dir(cwd) do
    case :file.list_dir(cwd) do
      {:ok, files} -> files
      _else -> []
    end
  end

  defp trees(dirs, match_dot, acc \\ []) do
    dirs =
      for dir <- dirs,
          sub_dir <- list_dir(dir),
          match_dot?(sub_dir, match_dot),
          do: join(dir, sub_dir)

    case dirs do
      [] -> acc
      dirs -> trees(dirs, match_dot, dirs ++ acc)
    end
  end

  defp double_star_matches([], _match_dot, _pattern, acc), do: acc

  defp double_star_matches(matches, match_dot, pattern, acc) do
    {matches, acc} =
      for match <- matches,
          item <- list_dir(match),
          reduce: {[], acc} do
        {matches, acc} -> double_star_match(item, match_dot, pattern, match, matches, acc)
      end

    double_star_matches(matches, match_dot, pattern, acc)
  end

  defp double_star_match([?. | _rest], false, _pattern, _match, matches, acc) do
    {matches, acc}
  end

  defp double_star_match(item, _match_dot, pattern, match, matches, acc) do
    path = join(match, item)

    case match_comp?(item, pattern) do
      true -> {[path | matches], [path | acc]}
      false -> {[path | matches], acc}
    end
  end

  defp split(<<>>, [head | tail]) do
    :lists.reverse([:lists.reverse(head) | tail])
  end

  defp split(<<?/>>, [head | tail]) do
    :lists.reverse([:lists.reverse(head) | tail])
  end

  defp split(<<?/, rest::binary>>, [head | tail]) do
    split(rest, [[], :lists.reverse(head) | tail])
  end

  defp split(<<char::utf8, rest::binary>>, [comp | acc]) do
    split(rest, [[char | comp] | acc])
  end

  defp file_exists?(file) do
    # On Windows, "pathname/.." will seem to exist even if pathname does not
    # refer to a directory.
    case :os.type() do
      {:win32, _} -> do_file_exists?(file)
      _else -> File.exists?(file)
    end
  end

  defp do_file_exists?([vol, ?:, ?/ | file]) do
    file
    |> IO.chardata_to_string()
    |> do_file_exists?([vol | ~c":/"])
  end

  defp do_file_exists?(file) do
    file
    |> IO.chardata_to_string()
    |> do_file_exists?(@cwd)
  end

  defp do_file_exists?(file, dir) when is_binary(file) do
    file
    |> split([[]])
    |> do_file_exists?(dir)
  end

  defp do_file_exists?([comp, ~c".." | path], acc) do
    dir = :filename.join(acc, comp)

    case :filelib.is_dir(dir) do
      true -> do_file_exists?(path, :filename.join(dir, ~c".."))
      false -> false
    end
  end

  defp do_file_exists?([comp | path], acc) do
    acc = :filename.join(acc, comp)
    do_file_exists?(path, acc)
  end

  defp do_file_exists?([], acc), do: File.exists?(acc)

  defp hidden?(path) do
    Enum.any?(path, fn
      [?. | _rest] -> true
      _comp -> false
    end)
  end

  @doc false
  # Unescape map function used by Macro.unescape_string.
  def unescape_map(:newline), do: true
  def unescape_map(?f), do: ?\f
  def unescape_map(?n), do: ?\n
  def unescape_map(?r), do: ?\r
  def unescape_map(?t), do: ?\t
  def unescape_map(?v), do: ?\v
  def unescape_map(?a), do: ?\a
  def unescape_map(_), do: false

  defimpl Inspect do
    def inspect(%{source: source, match_dot: match_dot}, _opts) do
      modifier = if match_dot, do: "d", else: ""

      {escaped, _} =
        source
        |> normalize(<<>>)
        |> Code.Identifier.escape(?|, :infinity, &escape_map/1)

      IO.iodata_to_binary([?~, ?g, ?|, escaped, ?|, modifier])
    end

    defp normalize(<<?\\, ?\\, rest::binary>>, acc),
      do: normalize(rest, <<acc::binary, ?\\, ?\\>>)

    defp normalize(<<?\\, ?|, rest::binary>>, acc), do: normalize(rest, <<acc::binary, ?|>>)
    defp normalize(<<char, rest::binary>>, acc), do: normalize(rest, <<acc::binary, char>>)
    defp normalize(<<>>, acc), do: acc

    defp escape_map(?\a), do: [?\\, ?a]
    defp escape_map(?\f), do: [?\\, ?f]
    defp escape_map(?\n), do: [?\\, ?n]
    defp escape_map(?\r), do: [?\\, ?r]
    defp escape_map(?\t), do: [?\\, ?t]
    defp escape_map(?\v), do: [?\\, ?v]
    defp escape_map(_), do: false
  end
end
