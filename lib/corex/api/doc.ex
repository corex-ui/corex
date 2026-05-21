defmodule Corex.Api.Doc do
  @moduledoc false

  @doc false
  defmacro api_doc(contents) do
    quote do
      @doc type: :api
      @doc unquote(contents)
    end
  end

  @doc false
  defmacro api_doc_short(contents) do
    quote do
      @doc type: :api
      @doc unquote(contents)
    end
  end

  @doc false
  defmacro api_doc_hidden do
    quote do
      @doc false
    end
  end
end
