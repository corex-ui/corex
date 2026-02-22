defmodule Corex.Listbox.Connect do
  @moduledoc false
  alias Corex.Listbox.Anatomy.{
    Props,
    Root,
    Label,
    ValueText,
    Input,
    Content,
    ItemGroup,
    ItemGroupLabel,
    Item,
    ItemText,
    ItemIndicator
  }

  import Corex.Helpers, only: [validate_value!: 1]

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  defp encode_collection(items) when is_list(items) do
    Enum.map(items, fn
      %Corex.List.Item{} = item ->
        %{
          "id" => item.id,
          "value" => item.id,
          "label" => item.label,
          "disabled" => !!item.disabled,
          "group" => item.group
        }

      m when is_map(m) ->
        %{
          "id" => Map.get(m, :id) || Map.get(m, "id"),
          "value" => Map.get(m, :value) || Map.get(m, "value") || Map.get(m, :id),
          "label" => Map.get(m, :label) || Map.get(m, "label"),
          "disabled" => !!Map.get(m, :disabled, false),
          "group" => Map.get(m, :group)
        }
    end)
  end

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-collection" => Corex.Json.encode!(encode_collection(assigns.collection)),
      "data-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-controlled" => data_attr(assigns.controlled),
      "data-disabled" => data_attr(assigns.disabled),
      "data-dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "data-loop-focus" => data_attr(assigns.loop_focus),
      "data-selection-mode" => assigns.selection_mode,
      "data-select-on-highlight" => data_attr(assigns.select_on_highlight),
      "data-deselectable" => data_attr(assigns.deselectable),
      "data-typeahead" => data_attr(assigns.typeahead),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "listbox:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "listbox:#{assigns.id}:label"
    }
  end

  @spec value_text(ValueText.t()) :: map()
  def value_text(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "value-text",
      "id" => "listbox:#{assigns.id}:value-text"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "input",
      "id" => "listbox:#{assigns.id}:input"
    }
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "content",
      "dir" => assigns.dir,
      "id" => "listbox:#{assigns.id}:content"
    }
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "item-group",
      "data-id" => assigns.group_id,
      "id" => "listbox:#{assigns.id}:item-group:#{assigns.group_id}"
    }
  end

  @spec item_group_label(ItemGroupLabel.t()) :: map()
  def item_group_label(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "item-group-label",
      "id" => "listbox:#{assigns.id}:item-group-label:#{assigns.html_for}"
    }
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "item",
      "data-value" => assigns.value,
      "id" => "listbox:#{assigns.id}:item:#{assigns.value}"
    }
  end

  defp item_value(item) do
    Map.get(item, :value) || Map.get(item, "value") || Map.get(item, :id) || Map.get(item, "id") ||
      ""
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    val = item_value(assigns.item)

    %{
      "data-scope" => "listbox",
      "data-part" => "item-text",
      "id" => "listbox:#{assigns.id}:item-text:#{val}"
    }
  end

  @spec item_indicator(ItemIndicator.t()) :: map()
  def item_indicator(assigns) do
    val = item_value(assigns.item)

    %{
      "data-scope" => "listbox",
      "data-part" => "item-indicator",
      "id" => "listbox:#{assigns.id}:item-indicator:#{val}"
    }
  end
end
