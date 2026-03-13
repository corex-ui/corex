defmodule GlobEx.Sigils do
  @moduledoc """
  This module provides the sigils `~g||` and `~G||`.
  """

  @doc ~S"""
  Handles the sigil `~g` for globs.

  See the module documentation `GlobEx` for how to write a glob expression.

  ## Examples

      iex> ~g|*.txt|
      ~g|*.txt|

      iex> ~g|*.#{"txt"}|
      ~g|*.txt|

      iex> GlobEx.match?(~g|f\#{a,b}|, "f#a")
      true
  """
  defmacro sigil_g(term, modifiers)

  defmacro sigil_g({:<<>>, _meta, [string]}, options) when is_binary(string) do
    binary = :elixir_interpolation.unescape_string(string, &GlobEx.unescape_map/1)
    glob = GlobEx.compile!(binary, match_dot: options == [?d])
    Macro.escape(glob)
  end

  defmacro sigil_g({:<<>>, meta, pieces}, options) do
    binary = {:<<>>, meta, unescape_tokens(pieces, &GlobEx.unescape_map/1)}
    quote(do: GlobEx.compile!(unquote(binary), match_dot: unquote(options) == [?d]))
  end

  @doc ~S"""
  Handles the sigil `~G` for globs.

  It returns a glob expression pattern without interpolations and without escape
  characters.

  See the module documentation `GlobEx` for how to write a glob expression.

  ## Examples

      iex> ~G|*.txt|
      ~g|*.txt|

      iex> GlobEx.match?(~G|f#{a,b}|, "f#a")
      true
  """
  defmacro sigil_G({:<<>>, _meta, [string]}, options) when is_binary(string) do
    glob = GlobEx.compile!(string, match_dot: options == [?d])
    Macro.escape(glob)
  end

  defp unescape_tokens(tokens, unescape_map) do
    :lists.map(
      fn token ->
        case is_binary(token) do
          true -> :elixir_interpolation.unescape_string(token, unescape_map)
          false -> token
        end
      end,
      tokens
    )
  end
end
