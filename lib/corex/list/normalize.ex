defmodule Corex.List.Normalize do
  @moduledoc false

  def has_groups?(items) when is_list(items) do
    Enum.any?(items, &Map.get(&1, :group))
  end

  def group_by_group(items) when is_list(items) do
    items
    |> Enum.group_by(&Map.get(&1, :group))
    |> Enum.sort_by(fn {g, _} -> g || "" end)
  end

  def normalize_groups(items) when is_list(items) do
    if has_groups?(items) do
      items
      |> Enum.reduce({[], MapSet.new()}, &reduce_group/2)
      |> elem(0)
      |> Enum.reverse()
    else
      []
    end
  end

  defp reduce_group(item, {acc, seen}) do
    g = Map.get(item, :group)

    cond do
      is_nil(g) -> {acc, seen}
      MapSet.member?(seen, g) -> {acc, seen}
      true -> {[g | acc], MapSet.put(seen, g)}
    end
  end

  def entry_value(entry) when is_map(entry) do
    entry
    |> Map.new(fn {k, v} -> {to_string(k), v} end)
    |> Map.get("value")
    |> case do
      nil -> ""
      v -> to_string(v)
    end
  end

  def entry_selected?(entry, value_list) when is_map(entry) and is_list(value_list) do
    Enum.member?(value_list, entry_value(entry))
  end

  def normalize_items(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.List.Item{} = item ->
        %{
          value: item.value,
          label: item.label,
          disabled: item.disabled,
          group: item.group,
          to: item.to,
          redirect: normalize_list_item_redirect(item.redirect),
          new_tab: item.new_tab,
          meta: item.meta || %{}
        }

      %{label: _} = map ->
        map =
          map
          |> Map.put_new(:value, Corex.ItemBuilder.generate_id("list"))

        %{
          value: Map.fetch!(map, :value),
          label: Map.get(map, :label),
          disabled: !!Map.get(map, :disabled, false),
          group: Map.get(map, :group),
          to: Map.get(map, :to),
          redirect: normalize_list_item_redirect(Map.get(map, :redirect)),
          new_tab: !!Map.get(map, :new_tab, false),
          meta: Map.get(map, :meta) || %{}
        }

      other ->
        raise ArgumentError, """
        Items must be Corex.List.Item or maps with :label (and optional :value).

        Got:
        #{inspect(other)}
        """
    end)
  end

  defp normalize_list_item_redirect(nil), do: nil
  defp normalize_list_item_redirect(false), do: false
  defp normalize_list_item_redirect(:href), do: :href
  defp normalize_list_item_redirect(:patch), do: :patch
  defp normalize_list_item_redirect(:navigate), do: :navigate

  defp normalize_list_item_redirect(other),
    do:
      raise(
        ArgumentError,
        "invalid item :redirect, expected nil, false, :href, :patch, or :navigate, got: #{inspect(other)}"
      )
end
