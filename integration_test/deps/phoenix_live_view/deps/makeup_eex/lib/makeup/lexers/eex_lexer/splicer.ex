defmodule Makeup.Lexers.EExLexer.Splicer do
  @moduledoc false

  alias Makeup.Lexer
  alias Makeup.Lexer.Postprocess

  def lex_outside(tokens, outside_lexer, opts) do
    chunks = split_outside_and_inside(tokens)
    {outside_chunks, inside_chunks} = Enum.unzip(chunks)
    outside_lexed_chunks = lex_and_split_outside(outside_chunks, outside_lexer, opts)

    all_lexed_chunks = Enum.zip(outside_lexed_chunks, inside_chunks)

    all_lexed_chunks
    |> Enum.map(fn {a, b} -> [a, b] end)
    |> List.flatten()
  end

  defp outside_text({_, %{outside_text: true}, _}), do: true
  defp outside_text(_), do: false

  defp inside_content(token), do: not outside_text(token)

  defp split_outside_and_inside([]) do
    []
  end

  defp split_outside_and_inside(tokens) do
    {outside, rest1} = Enum.split_while(tokens, &outside_text/1)
    {inside, rest2} = Enum.split_while(rest1, &inside_content/1)

    [{outside, inside} | split_outside_and_inside(rest2)]
  end

  defp lex_and_split_outside(outside_chunks, lexer, opts) do
    sized_chunks =
      for tokens <- outside_chunks do
        binary = Lexer.unlex(tokens)
        size = byte_size(binary)
        {size, binary}
      end

    {sizes, binaries} = Enum.unzip(sized_chunks)

    text = Enum.join(binaries)

    # The token values must be binaries so that we can
    # easily split them according to the binary sizes
    # of the chunks
    tokens =
      text
      |> lexer.lex(opts)
      |> Postprocess.token_values_to_binaries()

    _token_chunks = chunk_tokens_by_size(tokens, sizes)
  end

  @doc false

  def chunk_tokens_by_size([], []) do
    []
  end

  def chunk_tokens_by_size(tokens, [0 | sizes]) do
    # If the size of the chunk is zero, then there are no tokens;
    # The list of tokens is the empty list
    [[] | chunk_tokens_by_size(tokens, sizes)]
  end

  def chunk_tokens_by_size(tokens, [size | sizes]) do
    # if the token size is not zero, there must be at least
    # one token for us to consume
    {toks, remainder} = get_new_token_chunk(tokens, size)
    [toks | chunk_tokens_by_size(remainder, sizes)]
  end

  @doc false
  def get_new_token_chunk([], 0 = _size) do
    {[], []}
  end

  def get_new_token_chunk([token | tokens], size) do
    tok_size = token_size(token)

    cond do
      size == 0 ->
        # Don't add any more tokens to the first part
        {[], tokens}

      tok_size < size ->
        {toks, remainder} = get_new_token_chunk(tokens, size - tok_size)
        # Split the token list into two
        {[token | toks], remainder}

      tok_size > size ->
        {ttype, meta, bin} = token
        # Split the token into two
        # - split the binaries
        <<bin1::bytes-size(size), bin2::bytes>> = bin
        # - create two new tokens
        tok1 = {ttype, meta, bin1}
        tok2 = {ttype, meta, bin2}

        remainder = [tok2 | tokens]

        {[tok1], remainder}

      tok_size == size ->
        {[token], tokens}
    end
  end

  defp token_size({_, _, binary}) do
    byte_size(binary)
  end
end
