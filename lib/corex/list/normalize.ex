defmodule Corex.List.Normalize do
  @moduledoc false

  @spec has_groups?([map()]) :: boolean()
  def has_groups?(items) when is_list(items) do
    Enum.any?(items, &Map.get(&1, :group))
  end

  @spec group_by_group([map()]) :: [{term(), [map()]}]
  def group_by_group(items) when is_list(items) do
    items
    |> Enum.group_by(&Map.get(&1, :group))
    |> Enum.sort_by(fn {g, _} -> g || "" end)
  end

  @doc """
  Reads the `:value` of a normalized entry as a string.

  Entries reaching this function have already been through `normalize_items/1`,
  so keys are atoms and `:value` is present. The `nil` clause covers entries
  whose `:value` was explicitly set to `nil`.
  """
  @spec entry_value(map()) :: String.t()
  def entry_value(%{value: nil}), do: ""
  def entry_value(%{value: value}), do: to_string(value)
  def entry_value(entry) when is_map(entry), do: ""

  @spec entry_selected?(map(), [String.t()]) :: boolean()
  def entry_selected?(entry, value_list) when is_map(entry) and is_list(value_list) do
    Enum.member?(value_list, entry_value(entry))
  end

  @doc """
  Normalizes a form field value into the string list the list components select on.

  An unset field arrives as `nil`, `""`, or the literal `"[]"` that a multi-select
  hidden input round-trips, and all three mean "nothing selected". Blank entries
  inside a list are dropped for the same reason.
  """
  @spec field_value_list(term()) :: [String.t()]
  def field_value_list(value) when is_list(value) do
    value
    |> Enum.map(&to_string/1)
    |> Enum.reject(&blank_field_value?/1)
  end

  def field_value_list(value) do
    if blank_field_value?(value), do: [], else: [to_string(value)]
  end

  defp blank_field_value?(value) when value in [nil, "", "[]", []], do: true
  defp blank_field_value?(_value), do: false

  @doc """
  Adds the disabled data and ARIA attributes when the entry is disabled.
  """
  @spec put_disabled_attrs(map(), map()) :: map()
  def put_disabled_attrs(attrs, %{disabled: disabled}) when disabled not in [nil, false] do
    attrs
    |> Map.put("data-disabled", "")
    |> Map.put("aria-disabled", "true")
  end

  def put_disabled_attrs(attrs, _entry), do: attrs

  @doc """
  Joins the labels of the selected entries for display on a trigger.

  Returns `nil` rather than `""` when nothing resolves, so callers can fall back
  to their placeholder with `||`. Values with no matching entry are skipped: a
  form can hold a value that is no longer in the item list.
  """
  @spec selected_label([map()], [String.t()]) :: String.t() | nil
  def selected_label(_items, []), do: nil

  def selected_label(items, value_list) when is_list(value_list) do
    value_list
    |> Enum.map(fn value -> Enum.find(items, &(entry_value(&1) == value)) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.map_join(", ", & &1.label)
    |> case do
      "" -> nil
      labels -> labels
    end
  end

  @doc """
  Renders the selection for the hidden input a plain form submit reads.

  Multi-select posts a comma-joined list because the browser sends one input
  value; single select posts the bare value.
  """
  @spec value_for_hidden_input([String.t()], term()) :: String.t()
  def value_for_hidden_input([], _multiple), do: ""
  def value_for_hidden_input([value | _rest], multiple) when multiple in [nil, false], do: value
  def value_for_hidden_input(value_list, _multiple), do: Enum.join(value_list, ",")

  @doc """
  Normalizes `items` into the plain maps the list components render.

  Entries that are neither `Corex.List.Item` nor a map with `:label` are dropped
  with a warning rather than raising: items are frequently built from database
  rows or event params, and one malformed row should not take down the LiveView.
  """
  @spec normalize_items(list()) :: [map()]
  def normalize_items(items) when is_list(items) do
    items
    |> Enum.map(&normalize_item/1)
    |> Enum.reject(&is_nil/1)
  end

  defp normalize_item(%Corex.List.Item{} = item) do
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
  end

  defp normalize_item(%{label: _} = map) do
    map = Map.put_new(map, :value, Corex.ItemBuilder.generate_id("list"))

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
  end

  defp normalize_item(other) do
    Corex.Dev.warn(
      "list items must be Corex.List.Item structs or maps with :label, got: " <>
        "#{inspect(other)}; dropping it"
    )

    nil
  end

  defp normalize_list_item_redirect(nil), do: nil
  defp normalize_list_item_redirect(false), do: false
  defp normalize_list_item_redirect(:href), do: :href
  defp normalize_list_item_redirect(:patch), do: :patch
  defp normalize_list_item_redirect(:navigate), do: :navigate

  defp normalize_list_item_redirect(other) do
    Corex.Dev.warn(
      "invalid item :redirect, expected nil, false, :href, :patch, or :navigate, got: " <>
        "#{inspect(other)}; treating it as no redirect"
    )

    nil
  end
end
