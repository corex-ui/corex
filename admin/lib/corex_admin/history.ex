defmodule CorexAdmin.History do
  @moduledoc """
  Optional **data** adapter for the Show History tab.

  Corex Admin does not capture writes — host contexts (and database triggers)
  do. Implement `history/3` and set `history:` on the resource. The tab is
  Corex `tabs` + `data_list` only.

  First-party readers:

  - `CorexAdmin.History.Carbonite` — optional `:carbonite` dep (query API)
  - `CorexAdmin.History.Threadline` — optional Threadline `history/3`

  Never mount Threadline's operator console, or any other admin UI, inside
  Corex Admin.
  """

  alias CorexAdmin.History.Version

  @callback history(schema_or_source :: term(), id :: term(), opts :: keyword()) :: [Version.t()]

  @doc "Returns versions from `spec.history`, or `[]` when no adapter is set."
  def fetch(%{history: nil}, _id, _opts), do: []

  def fetch(%{history: mod, history_opts: history_opts, schema: schema}, id, opts)
      when is_atom(mod) and not is_nil(mod) do
    if Code.ensure_loaded?(mod) and function_exported?(mod, :history, 3) do
      List.wrap(mod.history(schema, id, Keyword.merge(history_opts, opts)))
    else
      []
    end
  end

  def fetch(_, _, _), do: []
end
