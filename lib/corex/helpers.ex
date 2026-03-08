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

  def validate_tabs_value!(nil), do: nil
  def validate_tabs_value!(value) when is_binary(value), do: value
  def validate_tabs_value!(value), do: raise(ArgumentError, "value must be a string or nil, got: #{inspect(value)}")

  def validate_content_items_required!(%{items: nil} = _assigns, component) do
    raise ArgumentError, """
    #{component} requires :items to be a list of %Corex.Content.Item{} structs.

    Example:

        items = Corex.Content.new([
          [trigger: "Trigger text", content: "Content text"],
          [trigger: "Another trigger", content: "More content", disabled: true]
        ])
        <.#{String.downcase(component)} items={items} />
    """
  end

  def validate_content_items_required!(%{items: items} = assigns, _component) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Content.Item) do
        raise ArgumentError, """
        Invalid item in :items attribute. Expected %Corex.Content.Item{} struct, got: #{inspect(item)}

        Please use Corex.Content.new/1:

        items = Corex.Content.new([
          [trigger: "Trigger text", content: "Content text"],
          [trigger: "Another trigger", content: "More content", disabled: true]
        ])
        """
      end
    end)

    assigns
  end

  def validate_content_items_required!(assigns, _component), do: assigns

  def content_items_data_json(items) when is_list(items) do
    items
    |> Enum.with_index()
    |> Enum.map(fn {item, i} ->
      %{"value" => item.id || "item-#{i}", "disabled" => !!item.disabled}
    end)
    |> Corex.Json.encode!()
  end

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
      |> Enum.reduce({[], MapSet.new()}, fn item, {acc, seen} ->
        g = Map.get(item, :group)
        cond do
          is_nil(g) -> {acc, seen}
          MapSet.member?(seen, g) -> {acc, seen}
          true -> {[g | acc], MapSet.put(seen, g)}
        end
      end)
      |> elem(0)
      |> Enum.reverse()
    else
      []
    end
  end

  def entry_value(entry) when is_map(entry) do
    to_string(
      Map.get(entry, :value) || Map.get(entry, :id) || Map.get(entry, "value") ||
        Map.get(entry, "id") || ""
    )
  end

  def entry_selected?(entry, value_list) when is_map(entry) and is_list(value_list) do
    Enum.member?(value_list, entry_value(entry))
  end

  def normalize_items(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.List.Item{} = item ->
        %{
          id: item.id,
          value: item.id,
          label: item.label,
          disabled: item.disabled,
          group: item.group
        }

      %{id: _, label: _} = map ->
        %{
          id: Map.get(map, :id),
          value: Map.get(map, :value) || Map.get(map, :id),
          label: Map.get(map, :label),
          disabled: !!Map.get(map, :disabled, false),
          group: Map.get(map, :group)
        }

      other ->
        raise ArgumentError, """
        Items must be Corex.List.Item or maps with :id and :label.

        Got:
        #{inspect(other)}
        """
    end)
  end
end
