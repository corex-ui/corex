defmodule Makeup.Lexers.EExLexer do
  @moduledoc """
  EEx lexer.
  """

  import NimbleParsec
  alias Makeup.Lexer.Combinators, as: C
  import Makeup.Lexer.Groups

  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Lexers.EExLexer.Splicer

  @behaviour Makeup.Lexer

  ###################################################################
  # Step #1: tokenize the input (into a list of tokens)
  ###################################################################

  modified_inline_comment =
    string("#")
    |> concat(
      repeat(
        lookahead_not(
          choice([
            string("\n"),
            string("%>")
          ])
        )
        |> utf8_char([])
      )
    )
    |> C.token(:comment_single)

  elixir_expr =
    choice([
      modified_inline_comment,
      parsec({ElixirLexer, :root_element})
    ])

  text_outside_eex =
    times(
      lookahead_not(string("<%"))
      |> utf8_char([]),
      min: 1
    )
    |> C.token(:text)
    |> map({__MODULE__, :__as_outside_text__, []})

  def __as_outside_text__({ttype, meta, value}) do
    {ttype, Map.put(meta, :outside_text, true), value}
  end

  eex_comment = C.string_like("<%!--", "--%>", [], :comment)
  eex_escape = C.many_surrounded_by(elixir_expr, "<%%", "%>", :punctuation)
  eex_show = C.many_surrounded_by(elixir_expr, "<%=", "%>", :punctuation)
  eex_pipe = C.many_surrounded_by(elixir_expr, "<%|", "%>", :punctuation)
  eex_slash = C.many_surrounded_by(elixir_expr, "<%/", "%>", :punctuation)
  eex_exec = C.many_surrounded_by(elixir_expr, "<%", "%>", :punctuation)

  root_element_combinator =
    choice([
      # EEx expressions
      eex_comment,
      eex_escape,
      eex_show,
      eex_pipe,
      eex_slash,
      eex_exec,
      # Text outside EEx
      text_outside_eex
    ])

  # By default, don't inline the lexers.
  # Inlining them increases performance by ~20%
  # at the cost of doubling the compilation times...
  @inline false

  @doc false

  # If the token is already tagged as belonging to a language, we respect that
  # and don't change the language
  def __as_eex_language__({_ttype, %{language: _}, _value} = token) do
    token
  end

  def __as_eex_language__({ttype, meta, value}) do
    {ttype, Map.put(meta, :language, :eex), value}
  end

  @impl Makeup.Lexer
  defparsec(
    :root_element,
    root_element_combinator |> map({__MODULE__, :__as_eex_language__, []}),
    inline: @inline,
    export_combinator: true
  )

  @impl Makeup.Lexer
  defparsec(
    :root,
    repeat(parsec(:root_element)),
    inline: @inline,
    export_combinator: true
  )

  ###################################################################
  # Step #2: postprocess the list of tokens
  ###################################################################

  # Public API
  @impl Makeup.Lexer
  def postprocess(tokens, _opts \\ []), do: tokens

  ###################################################################
  # Step #3: highlight matching delimiters
  ###################################################################

  @impl Makeup.Lexer
  defgroupmatcher(:match_groups,
    eex_comment: [
      open: [
        [{:punctuation, %{language: :eex}, "<%#"}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ],
    eex_escape: [
      open: [
        [{:punctuation, %{language: :eex}, "<%%"}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ],
    eex_show: [
      open: [
        [{:punctuation, %{language: :eex}, "<%="}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ],
    eex_pipe: [
      open: [
        [{:punctuation, %{language: :eex}, "<%|"}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ],
    eex_slash: [
      open: [
        [{:punctuation, %{language: :eex}, "<%/"}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ],
    eex_exec: [
      open: [
        [{:punctuation, %{language: :eex}, "<%"}]
      ],
      close: [
        [{:punctuation, %{language: :eex}, "%>"}]
      ]
    ]
  )

  # Finally, the public API for the lexer
  @impl Makeup.Lexer
  def lex(text, opts \\ []) do
    group_prefix = Keyword.get(opts, :group_prefix, random_prefix(10))
    match_groups? = Keyword.get(opts, :match_groups, true)
    outer_lexer = Keyword.get(opts, :outer_lexer, nil)
    {:ok, tokens, "", _, _, _} = root(text)

    tokens =
      tokens
      |> postprocess([])
      |> ElixirLexer.postprocess([])

    all_tokens =
      case outer_lexer do
        nil ->
          tokens

        lexer when is_atom(lexer) ->
          lex_outer(tokens, lexer, [], group_prefix)

        {lexer, outer_opts} ->
          lex_outer(tokens, lexer, outer_opts, group_prefix)

        fun when is_function(outer_lexer, 0) ->
          {lexer, outer_opts} = fun.()
          lex_outer(tokens, lexer, outer_opts, group_prefix)
      end

    case match_groups? do
      true ->
        all_tokens
        |> match_groups(group_prefix)
        |> ElixirLexer.match_groups(group_prefix <> "-ex")

      _ ->
        all_tokens
    end
  end

  defp lex_outer(tokens, outer_lexer, outer_opts, group_prefix) do
    new_group_prefix = group_prefix <> "-out"
    outer_opts = Keyword.put(outer_opts, :group_prefix, new_group_prefix)
    Splicer.lex_outside(tokens, outer_lexer, outer_opts)
  end
end
