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

  def normalize_checkbox_checked(true), do: true
  def normalize_checkbox_checked(false), do: false
  def normalize_checkbox_checked(:indeterminate), do: :indeterminate
  def normalize_checkbox_checked("indeterminate"), do: :indeterminate
  def normalize_checkbox_checked("true"), do: true
  def normalize_checkbox_checked("false"), do: false
  def normalize_checkbox_checked(nil), do: false

  def normalize_checkbox_checked(_), do: false

  def checkbox_checked_attr_value(true), do: "true"
  def checkbox_checked_attr_value(false), do: "false"
  def checkbox_checked_attr_value(:indeterminate), do: "indeterminate"

  def checkbox_checked_controlled_attr(controlled, checked) do
    if controlled, do: checkbox_checked_attr_value(normalize_checkbox_checked(checked)), else: nil
  end

  def checkbox_checked_default_attr(controlled, checked) do
    c = normalize_checkbox_checked(checked)

    if controlled do
      nil
    else
      if c == false, do: nil, else: checkbox_checked_attr_value(c)
    end
  end

  def checkbox_native_checked(checked) do
    normalize_checkbox_checked(checked) == true
  end

  def checkbox_visual_state(checked) do
    case normalize_checkbox_checked(checked) do
      true -> "checked"
      false -> "unchecked"
      :indeterminate -> "indeterminate"
    end
  end

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

  def validate_tabs_value!(value),
    do: raise(ArgumentError, "value must be a string or nil, got: #{inspect(value)}")

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

  def validate_content_items_required!(%{items: items} = assigns, _component)
      when is_list(items) do
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
    |> then(fn m -> Map.get(m, "value") || Map.get(m, "id") end)
    |> case do
      nil -> ""
      v -> to_string(v)
    end
  end

  def entry_selected?(entry, value_list) when is_map(entry) and is_list(value_list) do
    Enum.member?(value_list, entry_value(entry))
  end

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
          id: item.id,
          value: item.id,
          label: item.label,
          disabled: item.disabled,
          group: item.group,
          to: item.to,
          redirect: normalize_list_item_redirect(item.redirect),
          new_tab: item.new_tab,
          meta: item.meta || %{}
        }

      %{id: _, label: _} = map ->
        %{
          id: Map.get(map, :id),
          value: Map.get(map, :value) || Map.get(map, :id),
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
        Items must be Corex.List.Item or maps with :id and :label.

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
