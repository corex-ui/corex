defmodule GlobEx.Compiler do
  @moduledoc false

  @escape [?*, ??, ?\\, ?[, ?], ?{, ?}, ?-, ?#, ?,]

  def compile("") do
    {:error, :empty}
  end

  def compile(glob) when is_binary(glob) do
    compile(glob, [], 0, [])
  end

  defp compile(glob, result, _pos, patterns) when glob in [<<>>, <<?/>>] do
    result = result |> interim(patterns) |> List.wrap()

    {:ok, result}
  end

  # root
  defp compile(<<?/, rest::binary>>, [], 0, []) do
    with {:ok, next} <- compile(rest, [], 1, []) do
      {:ok, add(:root, next)}
    end
  end

  # windows root
  defp compile(<<vol, ?:, ?/, rest::binary>>, [], 0, []) do
    with {:ok, next} <- compile(rest, [], 1, []) do
      {:ok, add({:root, [vol | ~c":/"]}, next)}
    end
  end

  # slash
  defp compile(<<?/, rest::binary>>, results, pos, patterns) do
    result = interim(results, patterns)

    with {:ok, next} <- compile(rest, [], pos + 1, []) do
      {:ok, add(result, next)}
    end
  end

  # escape
  defp compile(<<?\\, char::utf8, rest::binary>>, results, pos, patterns) when char in @escape do
    compile(rest, [char | results], pos + 2, patterns)
  end

  # ** pattern
  defp compile(<<?*, ?*, rest::binary>>, [], pos, patterns) do
    pattern =
      case rest do
        <<>> -> :double_star
        <<?/>> -> :double_star
        <<?/, _rest::binary>> -> :double_star
        _else -> :star
      end

    compile(rest, [pattern], pos + 2, [pattern | patterns])
  end

  defp compile(<<?*, ?*, rest::binary>>, results, pos, patterns) do
    compile(rest, [:star | results], pos + 2, [:star | patterns])
  end

  # * pattern
  defp compile(<<?*, rest::binary>>, results, pos, patterns) do
    compile(rest, [:star | results], pos + 1, [:star | patterns])
  end

  # ? pattern
  defp compile(<<??, rest::binary>>, results, pos, patterns) do
    compile(rest, [:question | results], pos + 1, [:question | patterns])
  end

  # group pattern
  defp compile(<<?[, rest::binary>>, compiled, pos, patterns) do
    case group(rest, [], pos) do
      {:ok, rest, one_of, pos} ->
        compile(rest, [{:one_of, one_of} | compiled], pos, [:group | patterns])

      {:error, :missing_delimiter} ->
        {:error, {:missing_delimiter, pos + 1}}
    end
  end

  # alt pattern
  defp compile(<<?{, rest::binary>>, compiled, pos, patterns) do
    case alt(rest, <<>>, [], pos + 1) do
      {:ok, rest, alt, pos} ->
        compile(rest, [{:alt, alt} | compiled], pos, [:alt | patterns])

      {:error, :missing_delimiter} ->
        {:error, {:missing_delimiter, pos + 1}}
    end
  end

  # litteral
  defp compile(<<char::utf8, rest::binary>>, result, pos, patterns) do
    compile(rest, [char | result], pos + 1, patterns)
  end

  defp group(<<?], ?[, rest::binary>>, [], pos) do
    group(rest, ~c"][", pos + 2)
  end

  defp group(<<?\\, char::utf8, rest::binary>>, any_of, pos) when char in @escape do
    group(rest, [char | any_of], pos + 2)
  end

  defp group(<<?], rest::binary>>, any_of, pos) do
    {:ok, rest, any_of, pos + 1}
  end

  defp group(<<?/, _rest::binary>>, _any_of, _pos) do
    {:error, :missing_delimiter}
  end

  defp group(<<>>, _any_of, _pos) do
    {:error, :missing_delimiter}
  end

  defp group(<<from::utf8, ?-, to::utf8, rest::binary>>, any_of, pos) do
    any_of = any_of ++ to_list(from, to)
    group(rest, any_of, pos + 3)
  end

  defp group(<<char::utf8, rest::binary>>, any_of, pos) do
    group(rest, [char | any_of], pos + 1)
  end

  defp take_section(<<?/, rest::binary>>, acc) do
    {acc, <<?/, rest::binary>>}
  end

  defp take_section(<<>>, acc) do
    {acc, ""}
  end

  defp take_section(<<char::utf8, rest::binary>>, acc) do
    take_section(rest, <<acc::binary, char::utf8>>)
  end

  defp alt(<<?\\, char::utf8, rest::binary>>, item, acc, pos) when char in @escape do
    alt(rest, <<item::binary, char::utf8>>, acc, pos + 2)
  end

  defp alt(<<?}, rest::binary>>, item, acc, pos) do
    {section, rest} = take_section(rest, <<>>)

    acc = Enum.map([item | acc], fn item -> <<item::binary, section::binary>> end)

    with {:ok, alt} <- alt_compile(acc, [], pos) do
      {:ok, rest, alt, pos + 1}
    end
  end

  defp alt(<<>>, _item, _acc, _pos) do
    {:error, :missing_delimiter}
  end

  defp alt(<<?/, _rest::binary>>, _item, _acc, _pos) do
    {:error, :missing_delimiter}
  end

  defp alt(<<?,, rest::binary>>, item, acc, pos) do
    alt(rest, <<>>, [item | acc], pos + 1)
  end

  defp alt(<<char::utf8, rest::binary>>, item, acc, pos) do
    alt(rest, <<item::binary, char::utf8>>, acc, pos + 1)
  end

  defp alt_compile([], acc, _pos) do
    {:ok, acc}
  end

  defp alt_compile([item | list], acc, pos) do
    pos = pos - String.length(item)

    with {:ok, result} <- alt_compile(item, pos) do
      alt_compile(list, [result | acc], pos - 1)
    end
  end

  defp alt_compile("", _pos), do: {:ok, :empty}

  defp alt_compile(item, pos), do: compile(item, [], pos, [])

  defp interim([:star], _patterns) do
    :star
  end

  defp interim(result, [:star]) do
    star_merge(result)
  end

  # unwrap
  defp interim([result], _ptterns) when is_atom(result) or is_tuple(result) do
    result
  end

  defp interim(result, []) do
    {:exact, Enum.reverse(result)}
  end

  defp interim([{:alt, alt}, char, :star] = result, _pattern) when is_integer(char) do
    case all_exact?(alt) do
      true ->
        alt =
          Enum.map(alt, fn [{:exact, list}] -> [{:ends_with, Enum.reverse([char | list])}] end)

        {:alt, alt}

      false ->
        {:seq, Enum.reverse(result)}
    end
  end

  defp interim(result, _patterns) do
    {:seq, Enum.reverse(result)}
  end

  defp star_merge(result) do
    case Enum.reverse(result) do
      [:star | exact] -> {:ends_with, Enum.reverse(exact)}
      result -> {:seq, result}
    end
  end

  defp all_exact?(items) do
    Enum.all?(items, fn
      [{:exact, _list}] -> true
      _else -> false
    end)
  end

  defp add(:double_star, [:double_star | _rest] = result), do: result

  defp add(:double_star, [:star | rest]), do: [:double_star | rest]

  defp add(result, next), do: [result | next]

  defp to_list(a, b) when a > b, do: []

  defp to_list(a, b), do: to_list(a, b, [])

  defp to_list(a, a, list), do: [a | list]

  defp to_list(a, b, list), do: to_list(a + 1, b, [a | list])
end
