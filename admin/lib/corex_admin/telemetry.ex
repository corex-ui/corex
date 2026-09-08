defmodule CorexAdmin.Telemetry do
  @moduledoc false

  @doc "Spans `[:corex_admin, :action]` with resource slug and action only — never payloads."
  @spec span(String.t(), atom(), (-> result)) :: result when result: term()
  def span(slug, action, fun) when is_binary(slug) and is_atom(action) and is_function(fun, 0) do
    metadata = %{resource: slug, action: action}

    :telemetry.span([:corex_admin, :action], metadata, fn ->
      result = fun.()
      {result, metadata}
    end)
  end
end
