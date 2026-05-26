defmodule Corex.Helpers do
  @moduledoc false

  def get_boolean(true), do: ""
  def get_boolean(false), do: nil
  def get_boolean(nil), do: nil

  def get_default_boolean(controlled, value) do
    if !controlled && value, do: "", else: nil
  end

  def get_boolean(controlled, value) do
    if controlled do
      if value, do: "", else: nil
    else
      nil
    end
  end

  def data_state(bool, true_val, false_val), do: if(bool, do: true_val, else: false_val)

  def validate_value!([]), do: []

  def validate_value!(value) when is_list(value) do
    if Enum.all?(value, &is_binary/1) do
      value
    else
      raise ArgumentError, value_error(value)
    end
  end

  def validate_value!(value), do: raise(ArgumentError, value_error(value))

  def value_error(value), do: "value must be a list of strings, got: #{inspect(value)}"

  def normalize_string_list_value!(value) when is_list(value), do: validate_value!(value)

  def normalize_string_list_value!(value) when is_binary(value) do
    case String.trim(value) do
      "" ->
        []

      trimmed ->
        trimmed
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
        |> validate_value!()
    end
  end

  def normalize_string_list_value!(value, graphemes: true) when is_binary(value) do
    trimmed = String.trim(value)

    cond do
      trimmed == "" ->
        []

      String.contains?(trimmed, ",") ->
        trimmed |> String.split(",", trim: true) |> validate_value!()

      true ->
        trimmed |> String.graphemes() |> validate_value!()
    end
  end

  def normalize_string_list_value!(value, _opts), do: validate_value!(value)

  def validate_tabs_value!(nil), do: nil
  def validate_tabs_value!(value) when is_binary(value), do: value

  def validate_tabs_value!(value),
    do: raise(ArgumentError, "value must be a string or nil, got: #{inspect(value)}")

  def validate_content_items_required!(%{items: nil} = _assigns, component) do
    raise ArgumentError, """
    #{component} requires :items to be a list of %Corex.Content.Item{} structs.

    Example:

        items = Corex.Content.new([
          [label: "Trigger text", content: "Content text"],
          [label: "Another trigger", content: "More content", disabled: true]
        ])
        <.#{String.downcase(component)} items={items} />
    """
  end

  def validate_content_items_required!(%{items: items} = assigns, _component)
      when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Content.Item) do
        raise ArgumentError, """
        Invalid item in :items attribute. Expected %Corex.Content.Item{} struct, got: #{inspect(item)}

        Please use Corex.Content.new/1:

        items = Corex.Content.new([
          [label: "Trigger text", content: "Content text"],
          [label: "Another trigger", content: "More content", disabled: true]
        ])
        """
      end
    end)

    assigns
  end

  def validate_content_items_required!(assigns, _component), do: assigns

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

  @doc """
  Inserts `key => value` into `map` only when `value` is not nil.

  Used by `Connect` modules to skip optional data attributes that should not
  appear in the rendered HTML when they have no value.
  """
  @spec maybe_put(map(), term(), term()) :: map()
  def maybe_put(map, _key, nil), do: map
  def maybe_put(map, key, value), do: Map.put(map, key, value)

  def joined_csv_values([]), do: nil

  def joined_csv_values(values) when is_list(values) do
    Enum.map_join(values, ",", &to_string/1)
  end

  def controlled_dataset_values(true, joined) when is_binary(joined), do: {joined, nil}
  def controlled_dataset_values(false, joined) when is_binary(joined), do: {nil, joined}
  def controlled_dataset_values(_controlled, _joined), do: {nil, nil}

  def controlled_string_value(true, value) when is_binary(value), do: {value, nil}
  def controlled_string_value(false, value) when is_binary(value), do: {nil, value}
  def controlled_string_value(_controlled, _value), do: {nil, nil}

  def maybe_put_data_dir(map, nil), do: map
  def maybe_put_data_dir(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "data-dir", dir)
  def maybe_put_data_dir(map, _), do: map

  def maybe_put_dir(map, nil), do: map
  def maybe_put_dir(map, dir) when dir in ["ltr", "rtl"], do: Map.put(map, "dir", dir)
  def maybe_put_dir(map, _), do: map

  def maybe_put_data_dir_from(map, assigns) when is_map(assigns),
    do: maybe_put_data_dir(map, Map.get(assigns, :dir))

  def maybe_put_dir_from(map, assigns) when is_map(assigns),
    do: maybe_put_dir(map, Map.get(assigns, :dir))

  @spec respond_to_fields(keyword()) :: %{String.t() => String.t()}
  def respond_to_fields(opts) when is_list(opts) do
    case Keyword.get(opts, :respond_to, :server) do
      :both ->
        %{respond_to: "both"}

      :server ->
        %{respond_to: "server"}

      :client ->
        %{respond_to: "client"}

      other ->
        raise ArgumentError,
              "invalid :respond_to, expected :both, :server, or :client, got: #{inspect(other)}"
    end
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
