defmodule TextDiff do
  @moduledoc ~S'''
  Formats the diff between two strings.

  ## Examples

      iex> code = """
      ...> defmodule Foo do
      ...>   @moduledoc   false
      ...>
      ...>   def foo, do:  :foo
      ...>
      ...>   def three_times(x) do
      ...>     {x,
      ...>      x,x}
      ...>   end
      ...>
      ...>   def bar(x) do
      ...>     {:bar, x}
      ...>   end
      ...> end\
      ...> """
      ...> formatted = code |> Code.format_string!() |> IO.iodata_to_binary()
      ...> code
      ...> |> TextDiff.format(formatted, color: false)
      ...> |> IO.iodata_to_binary()
      """
       1  1   |defmodule Foo do
       2    - |  @moduledoc   false
          2 + |  @moduledoc false
       3  3   |
       4    - |  def foo, do:  :foo
          4 + |  def foo, do: :foo
       5  5   |
       6  6   |  def three_times(x) do
       7    - |    {x,
       8    - |     x,x}
          7 + |    {x, x, x}
       9  8   |  end
      10  9   |
           ...|
      """
  '''

  @newline "\n"
  @blank " "
  @line_num_pad @blank
  @cr "↵"

  @format [
    separator: "|",
    gutter: [
      del: " - ",
      eq: "   ",
      ins: " + ",
      skip: "..."
    ],
    colors: [
      del: [text: :red, space: :red_background],
      ins: [text: :green, space: :green_background],
      skip: [text: :yellow],
      separator: [text: :yellow]
    ]
  ]

  @default_opts [
    after: 2,
    before: 2,
    color: true,
    line: 1,
    line_numbers: true,
    tokenizer: {__MODULE__, :default_tokenizer, []},
    colorizer: {__MODULE__, :default_colorizer, []},
    format: @format
  ]

  @doc ~S'''
  Formats the diff between two strings.

  The returned `iodata` shows the lines with changes and 2 lines before and
  after the changed positions. The string contains also a gutter with line
  number and a `-` or `+` for removed and added lines. Multiple lines without
  changes are marked with `...` in the gutter.

  ## Options

    * `:after` - the count of lines printed after each change. Defaults to `2`.
    * `:before` - the count of lines printed before each change. Defaults to `2`.
    * `:color` - enables color in the output. Defaults to `true`.
    * `:line_numbers` - enables line numbers. Defaults to `true`.
    * `:line` - the line number of the first line. Defaults to `1`.
    * `:tokenizer` - a function that splits a line of text into distinct tokens
      that should be compared when creating a colorized diff of a single line.
      The default tokenizer prioritizes highlighting entire words, so a line
      that updates `two` to `three` would appear as removing `two` and adding
      `three`, instead of keeping the `t`, removing `wo`, and adding `hree`.
      `:tokenizer` may be a function that accepts a single argument or an MFA
      tuple, where the line of text will be prepended to the given arguments.
    * `:colorizer` - a function that accepts a string and a color token (`:red`,
      `:green`, etc.) and returns iodata with that formatting applied. May be
      a function that accepts 2 arguments or an MFA tuple, where the string and
      color will be prepended to the given arguments. Defaults to a colorizer
      based on `IO.ANSI.format/1`.
    * `:format` - optional keyword list of formatting options. See "Formatting"
      below.

  ## Formatting

  Alternative formatting options can be passed to control the gutter, colors,
  and the separator between the gutter and line of text in the rendered diff.
  The separator is the same for all lines, but the gutter and colors differ
  depending on the operation: `:eq`, `:del`, `:ins`, `:skip`.

  The options (and their defaults) are:

    * `:separator` - `"|"`
    * `:gutter`
      * `:eq` - `"   "`
      * `:del` - `" - "`
      * `:ins` - `" + "`
      * `:skip` - `"..."`
    * `:colors`
      * `:del` - `[text: :red, space: :red_background]`
      * `:ins` - `[text: :green, space: :green_background]`
      * `:skip` - `[text: :yellow]`
      * `:separator` - `[text: :yellow]`

  These top-level formatting options will be merged into passed options. For
  example, you could change only the `:separator` with:

      format(string1, string2, format: [separator: "~ "])

  See `IO.ANSI` for info on colors.

  ## Examples

      iex> code = """
      ...> defmodule Bar do
      ...>   @moduledoc false
      ...>
      ...>   bar(x, y) do
      ...>     z = x + y
      ...>     {x,y  , z}
      ...>   end
      ...>
      ...>   bar(x, y, z) do
      ...>     {x, y, z}
      ...>   end
      ...> end\
      ...> """
      iex> formatted = code |> Code.format_string!() |> IO.iodata_to_binary()
      iex> code
      ...> |> TextDiff.format(formatted, color: false)
      ...> |> IO.iodata_to_binary()
      """
           ...|
       4  4   |  bar(x, y) do
       5  5   |    z = x + y
       6    - |    {x,y  , z}
          6 + |    {x, y, z}
       7  7   |  end
       8  8   |
           ...|
      """
      iex> code
      ...> |> TextDiff.format(formatted, color: false, after: 1, before: 1)
      ...> |> IO.iodata_to_binary()
      """
           ...|
       5  5   |    z = x + y
       6    - |    {x,y  , z}
          6 + |    {x, y, z}
       7  7   |  end
           ...|
      """
      iex> code
      ...> |> TextDiff.format(formatted, color: false, line_numbers: false)
      ...> |> IO.iodata_to_binary()
      """
      ...|
         |  bar(x, y) do
         |    z = x + y
       - |    {x,y  , z}
       + |    {x, y, z}
         |  end
         |
      ...|
      """
  '''
  @spec format(String.t(), String.t(), keyword()) :: iodata()
  def format(code, code, opts \\ default_opts())

  def format(code, code, _opts), do: []

  def format(old, new, opts) do
    opts =
      @default_opts
      |> Keyword.merge(opts)
      |> Keyword.update(:format, [], &Keyword.merge(@format, &1))

    crs? = String.contains?(old, "\r") || String.contains?(new, "\r")

    old = String.split(old, "\n")
    new = String.split(new, "\n")

    max = max(length(new), length(old))
    line_num_digits = max |> Integer.digits() |> length()
    opts = Keyword.put(opts, :line_num_digits, line_num_digits)

    {line, opts} = Keyword.pop!(opts, :line)

    old
    |> List.myers_difference(new)
    |> insert_cr_symbols(crs?)
    |> diff_to_iodata({line, line}, opts)
  end

  @spec default_opts() :: keyword()
  def default_opts, do: @default_opts

  defp diff_to_iodata(diff, line_nums, opts, iodata \\ [])

  defp diff_to_iodata([], _line_nums, _opts, iodata), do: Enum.reverse(iodata)

  defp diff_to_iodata([{:eq, [""]}], _line_nums, _opts, iodata), do: Enum.reverse(iodata)

  defp diff_to_iodata([{:eq, lines}], line_nums, opts, iodata) do
    lines_after = Enum.take(lines, opts[:after])
    iodata = lines(iodata, {:eq, lines_after}, line_nums, opts)

    iodata =
      case length(lines) > opts[:after] do
        false -> iodata
        true -> lines(iodata, :skip, opts)
      end

    Enum.reverse(iodata)
  end

  defp diff_to_iodata([{:eq, lines} | diff], {line, line}, opts, [] = iodata) do
    {start, lines_before} = Enum.split(lines, opts[:before] * -1)

    iodata =
      case length(lines) > opts[:before] do
        false -> iodata
        true -> lines(iodata, :skip, opts)
      end

    line = line + length(start)
    iodata = lines(iodata, {:eq, lines_before}, {line, line}, opts)

    line = line + length(lines_before)
    diff_to_iodata(diff, {line, line}, opts, iodata)
  end

  defp diff_to_iodata([{:eq, lines} | diff], line_nums, opts, iodata) do
    case length(lines) > opts[:after] + opts[:before] do
      true ->
        {lines1, lines2, lines3} = split(lines, opts[:after], opts[:before] * -1)

        iodata =
          iodata
          |> lines({:eq, lines1}, line_nums, opts)
          |> lines(:skip, opts)
          |> lines({:eq, lines3}, add_line_nums(line_nums, length(lines1) + length(lines2)), opts)

        line_nums = add_line_nums(line_nums, length(lines))

        diff_to_iodata(diff, line_nums, opts, iodata)

      false ->
        iodata = lines(iodata, {:eq, lines}, line_nums, opts)
        line_nums = add_line_nums(line_nums, length(lines))

        diff_to_iodata(diff, line_nums, opts, iodata)
    end
  end

  defp diff_to_iodata([{:del, [del]}, {:ins, [ins]} | diff], line_nums, opts, iodata) do
    iodata = lines(iodata, {:chg, del, ins}, line_nums, opts)
    diff_to_iodata(diff, add_line_nums(line_nums, 1), opts, iodata)
  end

  defp diff_to_iodata([{kind, lines} | diff], line_nums, opts, iodata) do
    iodata = lines(iodata, {kind, lines}, line_nums, opts)
    line_nums = add_line_nums(line_nums, length(lines), kind)

    diff_to_iodata(diff, line_nums, opts, iodata)
  end

  defp split(list, count1, count2) do
    {split1, split2} = Enum.split(list, count1)
    {split2, split3} = Enum.split(split2, count2)
    {split1, split2, split3}
  end

  defp lines(iodata, :skip, opts) do
    line_num =
      if opts[:line_numbers] do
        String.duplicate(@blank, opts[:line_num_digits] * 2 + 1)
      else
        ""
      end

    gutter = colorize(opts[:format][:gutter][:skip], :skip, false, opts)
    separator = colorize(opts[:format][:separator], :separator, false, opts)

    [[line_num, gutter, separator, @newline] | iodata]
  end

  defp lines(iodata, {:chg, del, ins}, line_nums, opts) do
    {del, ins} = line_diff(del, ins, opts)

    [
      [gutter(line_nums, :ins, opts), ins, @newline],
      [gutter(line_nums, :del, opts), del, @newline]
      | iodata
    ]
  end

  defp lines(iodata, {kind, lines}, line_nums, opts) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(iodata, fn {line, offset}, iodata ->
      line_nums = add_line_nums(line_nums, offset, kind)
      [[gutter(line_nums, kind, opts), colorize(line, kind, false, opts), @newline] | iodata]
    end)
  end

  defp gutter(line_nums, kind, opts) do
    [
      maybe_line_num(line_nums, kind, opts),
      colorize(opts[:format][:gutter][kind], kind, false, opts),
      colorize(opts[:format][:separator], :separator, false, opts)
    ]
  end

  defp maybe_line_num(line_nums, operation, opts) do
    if opts[:line_numbers] do
      line_num(line_nums, operation, opts)
    else
      []
    end
  end

  defp line_num({line_num_old, line_num_new}, :eq, opts) do
    old =
      line_num_old
      |> to_string()
      |> String.pad_leading(opts[:line_num_digits], @line_num_pad)

    new =
      line_num_new
      |> to_string()
      |> String.pad_leading(opts[:line_num_digits], @line_num_pad)

    [old, @blank, new]
  end

  defp line_num({line_num_old, _line_num_new}, :del, opts) do
    old =
      line_num_old
      |> to_string()
      |> String.pad_leading(opts[:line_num_digits], @line_num_pad)

    new = String.duplicate(@blank, opts[:line_num_digits])
    [old, @blank, new]
  end

  defp line_num({_line_num_old, line_num_new}, :ins, opts) do
    old = String.duplicate(@blank, opts[:line_num_digits])

    new =
      line_num_new
      |> to_string()
      |> String.pad_leading(opts[:line_num_digits], @line_num_pad)

    [old, @blank, new]
  end

  defp line_diff(del, ins, opts) do
    tokenizer = Keyword.fetch!(opts, :tokenizer)

    diff =
      List.myers_difference(
        apply_option_fun(tokenizer, [del]),
        apply_option_fun(tokenizer, [ins])
      )

    Enum.reduce(diff, {[], []}, fn {op, iodata}, {del, ins} ->
      str = IO.iodata_to_binary(iodata)

      case op do
        :eq -> {[del | iodata], [ins | iodata]}
        :del -> {[del | colorize(str, :del, true, opts)], ins}
        :ins -> {del, [ins | colorize(str, :ins, true, opts)]}
      end
    end)
  end

  defp colorize(str, kind, space, opts) do
    colorizer = Keyword.fetch!(opts, :colorizer)

    case {get_color(opts, kind), space} do
      {nil, _} ->
        str

      {%{text: text_color, space: space_color}, true} ->
        str
        |> String.split(~r/[\t\s]+/, include_captures: true)
        |> Enum.map(fn
          <<start::binary-size(1), _::binary>> = str when start in ["\t", "\s"] ->
            apply_option_fun(colorizer, [str, space_color])

          str ->
            apply_option_fun(colorizer, [str, text_color])
        end)

      {%{text: text_color}, _} ->
        apply_option_fun(colorizer, [str, text_color])
    end
  end

  defp get_color(opts, kind) do
    colors = opts[:format][:colors]

    if Keyword.fetch!(opts, :color) && Keyword.has_key?(colors, kind) do
      Map.new(colors[kind])
    else
      nil
    end
  end

  defp add_line_nums({line_num_old, line_num_new}, lines, kind \\ :eq) do
    case kind do
      :eq -> {line_num_old + lines, line_num_new + lines}
      :ins -> {line_num_old, line_num_new + lines}
      :del -> {line_num_old + lines, line_num_new}
    end
  end

  defp insert_cr_symbols(diffs, false), do: diffs
  defp insert_cr_symbols(diffs, true), do: do_insert_cr_symbols(diffs, [])

  defp do_insert_cr_symbols([], acc), do: Enum.reverse(acc)

  defp do_insert_cr_symbols([{:del, del}, {:ins, ins} | rest], acc) do
    {del, ins} = do_insert_cr_symbols(del, ins, {[], []})
    do_insert_cr_symbols(rest, [{:ins, ins}, {:del, del} | acc])
  end

  defp do_insert_cr_symbols([diff | rest], acc) do
    do_insert_cr_symbols(rest, [diff | acc])
  end

  defp do_insert_cr_symbols([left | left_rest], [right | right_rest], {left_acc, right_acc}) do
    {left, right} = insert_cr_symbol(left, right)
    do_insert_cr_symbols(left_rest, right_rest, {[left | left_acc], [right | right_acc]})
  end

  defp do_insert_cr_symbols([], right, {left_acc, right_acc}) do
    left = Enum.reverse(left_acc)
    right = right_acc |> Enum.reverse() |> Enum.concat(right)
    {left, right}
  end

  defp do_insert_cr_symbols(left, [], {left_acc, right_acc}) do
    left = left_acc |> Enum.reverse() |> Enum.concat(left)
    right = Enum.reverse(right_acc)
    {left, right}
  end

  defp insert_cr_symbol(left, right) do
    case {String.ends_with?(left, "\r"), String.ends_with?(right, "\r")} do
      {bool, bool} -> {left, right}
      {true, false} -> {String.replace(left, "\r", @cr), right}
      {false, true} -> {left, String.replace(right, "\r", @cr)}
    end
  end

  defp apply_option_fun(fun, args) when is_function(fun) and is_list(args) do
    apply(fun, args)
  end

  defp apply_option_fun({m, f, a}, args)
       when is_atom(m) and is_atom(f) and is_list(a) and is_list(args) do
    apply(m, f, args ++ a)
  end

  @doc false
  def default_tokenizer(line) do
    String.split(line, ~r/[^a-zA-Z0-9_]/, include_captures: true, trim: true)
  end

  @doc false
  def default_colorizer(str, color) do
    IO.ANSI.format([color, str])
  end
end
