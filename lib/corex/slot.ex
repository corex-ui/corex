defmodule Corex.Slot do
  @moduledoc false

  @type slot_entry :: map()
  @type panel :: %{
          required(:value) => String.t(),
          required(:disabled) => boolean(),
          optional(atom()) => slot_entry() | nil
        }

  @default_fallback &__MODULE__.default_fallback/1
  @default_disabled &__MODULE__.default_disabled/1

  @doc "Fallback string key when a slot entry omits `value`."
  def default_fallback(index), do: "item-#{index}"

  @doc "Default disabled predicate when callers omit `:disabled`."
  def default_disabled(_entries), do: false

  @doc """
  Resolve a set of named slot lists into a list of panels keyed by `value`.

  See the moduledoc on the calling component for the exact shape; the
  returned panels carry the per-slot entries under their slot atom.
  """
  @spec resolve_panels!(%{atom() => list()}, keyword()) :: [panel()]
  def resolve_panels!(slot_lists, opts) when is_map(slot_lists) and is_list(opts) do
    required = Keyword.fetch!(opts, :required)
    optional = Keyword.get(opts, :optional, [])
    component = Keyword.get(opts, :component, "Component")
    disabled_fn = Keyword.get(opts, :disabled, @default_disabled)
    fallback_fn = Keyword.get(opts, :fallback, @default_fallback)

    pairs_by_kind =
      (required ++ optional)
      |> Map.new(fn kind ->
        list = Map.get(slot_lists, kind, []) || []
        pairs = resolve(list, fallback_fn)
        assert_unique!(pairs, kind, component)
        {kind, pairs}
      end)

    required_value_set = assert_required_values_match!(pairs_by_kind, required, component)
    assert_optional_subset!(pairs_by_kind, optional, required_value_set, component)

    canonical_kind = hd(required)
    by_value_for = fn kind -> Map.new(Map.fetch!(pairs_by_kind, kind)) end
    optional_by_value = Map.new(optional, &{&1, by_value_for.(&1)})
    required_by_value = Map.new(required, &{&1, by_value_for.(&1)})

    Enum.map(Map.fetch!(pairs_by_kind, canonical_kind), fn {value, _entry} ->
      entries =
        Map.new(required, fn k -> {k, Map.fetch!(required_by_value[k], value)} end)
        |> Map.merge(Map.new(optional, fn k -> {k, Map.get(optional_by_value[k], value)} end))

      Map.merge(entries, %{value: value, disabled: !!disabled_fn.(entries)})
    end)
  end

  defp resolve(list, fallback_fn) do
    list
    |> Enum.with_index()
    |> Enum.map(fn {entry, i} -> {resolved_value(entry, i, fallback_fn), entry} end)
  end

  defp resolved_value(entry, index, fallback_fn) do
    case slot_field(entry, :value) do
      v when is_binary(v) and v != "" -> v
      _ -> fallback_fn.(index)
    end
  end

  defp slot_field(entry, key) when is_atom(key) do
    Map.get(entry, key) || Map.get(entry, Atom.to_string(key))
  end

  defp assert_unique!(pairs, kind, component) do
    values = Enum.map(pairs, &elem(&1, 0))

    case values |> Enum.frequencies() |> Enum.filter(fn {_, n} -> n > 1 end) do
      [] ->
        :ok

      dups ->
        names = Enum.map_join(dups, ", ", fn {v, _} -> inspect(v) end)

        raise ArgumentError,
              "#{component} manual mode: duplicate value(s) #{names} in :#{kind} slots " <>
                "(use unique value or omit value for positional item-0, item-1, …)"
    end
  end

  defp assert_required_values_match!(pairs_by_kind, required, component) do
    [first | rest] = required
    first_set = pairs_by_kind |> Map.fetch!(first) |> values_set()

    Enum.each(rest, fn k ->
      set = pairs_by_kind |> Map.fetch!(k) |> values_set()

      if set != first_set do
        raise ArgumentError,
              "#{component} manual mode: :#{first} and :#{k} slot values must match exactly. " <>
                "#{first}: #{inspect(MapSet.to_list(first_set))}, " <>
                "#{k}: #{inspect(MapSet.to_list(set))}"
      end
    end)

    first_set
  end

  defp assert_optional_subset!(pairs_by_kind, optional, required_value_set, component) do
    Enum.each(optional, fn k ->
      pairs_by_kind
      |> Map.fetch!(k)
      |> Enum.each(&optional_slot_in_required!(&1, k, required_value_set, component))
    end)
  end

  defp optional_slot_in_required!({v, _}, k, required_value_set, component) do
    if MapSet.member?(required_value_set, v) do
      :ok
    else
      raise ArgumentError,
            "#{component} manual mode: :#{k} value #{inspect(v)} has no matching required slot"
    end
  end

  defp values_set(pairs), do: pairs |> Enum.map(&elem(&1, 0)) |> MapSet.new()
end
