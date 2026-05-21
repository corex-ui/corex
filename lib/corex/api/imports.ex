defmodule Corex.Api.Imports do
  @moduledoc false

  defmacro __using__(opts) do
    api = Keyword.fetch!(opts, :to)

    quote do
      import Corex.Api.Doc
      alias unquote(api), as: Api
    end
  end
end
