defmodule Corex.Listbox.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Listbox.Anatomy.{
    Content,
    Item,
    ItemGroup,
    ItemGroupLabel,
    ItemIndicator,
    ItemText,
    Label,
    Props,
    Root
  }

  alias Corex.Connect.ItemNav
  alias Phoenix.LiveView.JS

  alias Corex.ValueBinding

  import Corex.Helpers,
    only: [
      validate_value!: 1,
      get_boolean: 1
    ]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    vlist = (assigns.value || []) |> validate_value!()
    {value_str, default_value_str} = ValueBinding.list_pair(vlist, assigns.controlled)

    items_json =
      Map.get(assigns, :items_json) || Corex.Dataset.encode_json(assigns.items)

    %{
      "id" => assigns.id,
      "data-items" => items_json,
      "data-value" => value_str,
      "data-default-value" => default_value_str,
      "data-controlled" => get_boolean(assigns.controlled),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-loop-focus" => get_boolean(assigns.loop_focus),
      "data-selection-mode" => assigns.selection_mode,
      "data-select-on-highlight" => get_boolean(assigns.select_on_highlight),
      "data-deselectable" => get_boolean(assigns.deselectable),
      "data-typeahead" => get_boolean(assigns.typeahead),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-redirect" => get_boolean(assigns.redirect)
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "label",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:label"
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:label")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "content",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:content"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:content")
    )
  end

  @spec item_group(ItemGroup.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "item-group",
      "data-id" => assigns.group_id,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:item-group:#{assigns.group_id}"
    }
  end

  def ignore_item_group(assigns) do
    JS.ignore_attributes(ItemGroup.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:item-group:#{assigns.group_id}")
    )
  end

  @spec item_group_label(ItemGroupLabel.t()) :: map()
  def item_group_label(assigns) do
    %{
      "data-scope" => "listbox",
      "data-part" => "item-group-label",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:item-group-label:#{assigns.html_for}"
    }
  end

  def ignore_item_group_label(assigns) do
    JS.ignore_attributes(ItemGroupLabel.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:item-group-label:#{assigns.html_for}")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "listbox",
      "data-part" => "item",
      "data-value" => assigns.value,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:item:#{assigns.value}"
    }

    ItemNav.put_item_nav_attrs(base, assigns)
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:item:#{assigns.value}")
    )
  end

  defp item_value(item) when is_map(item) do
    item
    |> Map.new(fn {k, v} -> {to_string(k), v} end)
    |> then(fn m -> Map.get(m, "value") || "" end)
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    val = item_value(assigns.item)

    %{
      "data-scope" => "listbox",
      "data-part" => "item-text",
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "listbox:#{assigns.id}:item-text:#{val}"
    }
  end

  def ignore_item_text(assigns) do
    val = item_value(assigns.item)

    JS.ignore_attributes(ItemText.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:item-text:#{val}")
    )
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

  def ignore_item_indicator(assigns) do
    val = item_value(assigns.item)

    JS.ignore_attributes(ItemIndicator.ignored_attrs(),
      to: Selectors.css_id("listbox:#{assigns.id}:item-indicator:#{val}")
    )
  end
end
