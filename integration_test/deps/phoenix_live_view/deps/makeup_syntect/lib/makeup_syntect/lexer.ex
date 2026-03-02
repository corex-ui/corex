defmodule MakeupSyntect.Lexer do
  @moduledoc false

  @behaviour Makeup.Lexer

  @impl true
  def lex(text, opts) do
    MakeupSyntect.tokenize(text, opts)
  end

  @impl true
  def root_element(_), do: raise("Not implemented")

  @impl true
  def root(_), do: raise("Not implemented")

  @impl true
  def postprocess(_, _), do: raise("Not implemented")

  @impl true
  def match_groups(_, _), do: raise("Not implemented")
end
