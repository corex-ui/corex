defmodule Corex.Helpers do
  @moduledoc false

  defdelegate get_boolean(v), to: Corex.Attrs
  defdelegate get_default_boolean(controlled, value), to: Corex.Attrs
  defdelegate get_boolean(controlled, value), to: Corex.Attrs
  defdelegate data_state(bool, true_val, false_val), to: Corex.Attrs
  defdelegate maybe_put(map, key, value), to: Corex.Attrs
  defdelegate joined_csv_values(values), to: Corex.Attrs
  defdelegate maybe_put_data_dir(map, dir), to: Corex.Attrs
  defdelegate maybe_put_dir(map, dir), to: Corex.Attrs
  defdelegate maybe_put_data_dir_from(map, assigns), to: Corex.Attrs
  defdelegate maybe_put_dir_from(map, assigns), to: Corex.Attrs
  defdelegate respond_to_fields(opts), to: Corex.Attrs

  defdelegate controlled_dataset_values(controlled, joined), to: Corex.ValueBinding
  defdelegate controlled_string_value(controlled, value), to: Corex.ValueBinding

  defdelegate has_groups?(items), to: Corex.List.Normalize
  defdelegate group_by_group(items), to: Corex.List.Normalize
  defdelegate normalize_groups(items), to: Corex.List.Normalize
  defdelegate entry_value(entry), to: Corex.List.Normalize
  defdelegate entry_selected?(entry, value_list), to: Corex.List.Normalize
  defdelegate normalize_items(items), to: Corex.List.Normalize

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
end
