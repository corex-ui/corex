defmodule CorexAdmin.History.Threadline do
  @moduledoc """
  Reads Threadline `history/3` as `[CorexAdmin.History.Version.t()]`.

  Threadline is a **data source only**. Do not mount its operator console inside
  Corex Admin and do not deep-link `/audit` as the History UX.

      use CorexAdmin.Resource,
        history: CorexAdmin.History.Threadline
  """

  @behaviour CorexAdmin.History

  alias CorexAdmin.History.Version

  @impl true
  def history(schema_or_source, id, opts) do
    cond do
      mod = optional_module(["Threadline", "Audit"]) ->
        mod
        |> apply(:history, [schema_or_source, id, opts])
        |> List.wrap()
        |> Enum.map(&to_version/1)

      mod = optional_module(["Threadline"]) ->
        mod
        |> apply(:history, [schema_or_source, id, opts])
        |> List.wrap()
        |> Enum.map(&to_version/1)

      true ->
        []
    end
  end

  defp optional_module(parts) do
    mod = Module.safe_concat(parts)
    if history_exported?(mod), do: mod
  rescue
    ArgumentError -> nil
  end

  defp history_exported?(mod) when is_atom(mod) do
    Code.ensure_loaded?(mod) and function_exported?(mod, :history, 3)
  end

  defp to_version(%Version{} = version), do: version

  defp to_version(row) when is_map(row) do
    row = stringify_keys(if is_struct(row), do: Map.from_struct(row), else: row)

    %Version{
      id: Map.get(row, "id"),
      at: Map.get(row, "at") || Map.get(row, "inserted_at"),
      actor: Map.get(row, "actor"),
      action: to_string(Map.get(row, "action") || Map.get(row, "op") || "update"),
      changes: List.wrap(Map.get(row, "changes") || [])
    }
  end

  defp to_version(_), do: %Version{changes: []}

  defp stringify_keys(%{__struct__: _} = struct), do: stringify_keys(Map.from_struct(struct))

  defp stringify_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {to_string(key), value}
    end)
  end

  defp stringify_keys(_), do: %{}
end
