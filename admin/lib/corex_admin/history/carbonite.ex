defmodule CorexAdmin.History.Carbonite do
  @moduledoc """
  Reads Carbonite change rows as `[CorexAdmin.History.Version.t()]`.

  Add `{:carbonite, "~> 0.15"}` in the **host** mix.exs (optional for this
  package). Pass `history_opts: [repo: MyApp.Repo]`. Corex Admin never runs
  migrations or installs triggers.

      use CorexAdmin.Resource,
        history: CorexAdmin.History.Carbonite,
        history_opts: [repo: MyApp.Repo]
  """

  @behaviour CorexAdmin.History

  alias CorexAdmin.History.Version

  @impl true
  def history(schema_or_source, id, opts) do
    repo = Keyword.get(opts, :repo)

    cond do
      is_nil(repo) ->
        []

      not carbonite_loaded?() ->
        []

      true ->
        schema_or_source
        |> carbonite_changes(id, opts)
        |> repo.all()
        |> Enum.map(&to_version/1)
    end
  end

  defp carbonite_loaded? do
    Code.ensure_loaded?(Carbonite) and Code.ensure_loaded?(Carbonite.Query) and
      function_exported?(Carbonite.Query, :changes, 2)
  end

  defp carbonite_changes(schema, id, opts) when is_atom(schema) do
    record = struct(schema, id: id)
    Carbonite.Query.changes(record, Keyword.take(opts, [:prefix, :preload]))
  end

  defp carbonite_changes(record, _id, opts) when is_map(record) do
    Carbonite.Query.changes(record, Keyword.take(opts, [:prefix, :preload]))
  end

  defp to_version(change) when is_map(change) do
    change = stringify_keys(normalize_map(change))
    tx = stringify_keys(normalize_map(Map.get(change, "transaction") || %{}))
    meta = stringify_keys(normalize_map(Map.get(tx, "meta") || %{}))

    %Version{
      id: Map.get(change, "id"),
      at: Map.get(tx, "inserted_at") || Map.get(change, "inserted_at"),
      actor: meta_actor(meta, Map.get(tx, "meta")),
      action: to_string(Map.get(change, "op") || "update"),
      changes: version_changes(change)
    }
  end

  defp meta_actor(meta, raw_meta) when meta == %{} and is_binary(raw_meta), do: raw_meta
  defp meta_actor(meta, _raw_meta) when meta == %{}, do: nil
  defp meta_actor(meta, _raw_meta), do: Map.get(meta, "actor") || inspect_meta(meta)

  defp inspect_meta(meta) when meta == %{}, do: nil
  defp inspect_meta(meta), do: inspect(meta)

  defp version_changes(change) do
    data = stringify_keys(normalize_map(Map.get(change, "data") || %{}))
    previous = stringify_keys(normalize_map(Map.get(change, "changed_from") || %{}))
    changed = List.wrap(Map.get(change, "changed") || Map.keys(data))

    Enum.map(changed, fn field ->
      key = to_string(field)

      %{
        field: key,
        from: Map.get(previous, key),
        to: Map.get(data, key)
      }
    end)
  end

  defp stringify_keys(%{__struct__: _} = struct), do: stringify_keys(Map.from_struct(struct))

  defp stringify_keys(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {to_string(key), value}
    end)
  end

  defp stringify_keys(_), do: %{}

  defp normalize_map(%{__struct__: _} = struct), do: Map.from_struct(struct)
  defp normalize_map(map) when is_map(map), do: map
  defp normalize_map(_), do: %{}
end
