defmodule Corex.Menu.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Menu.Anatomy.{
    Content,
    Group,
    GroupLabel,
    Indicator,
    Item,
    Positioner,
    Props,
    Root,
    Trigger
  }

  alias Corex.Connect.ItemNav
  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [get_boolean: 1]

  @spec ignore_hook(String.t()) :: JS.t()
  def ignore_hook(id) when is_binary(id) do
    JS.ignore_attributes(["data-loading"], to: Selectors.css_id("menu:#{id}"))
  end

  @spec props(Props.t() | map()) :: map()
  def props(assigns) do
    positioning = Map.get(assigns, :positioning, %Corex.Positioning{})

    base = %{
      "id" => assigns.id,
      "data-close-on-select" => get_boolean(assigns.close_on_select),
      "data-loop-focus" => get_boolean(assigns.loop_focus),
      "data-typeahead" => get_boolean(assigns.typeahead),
      "data-composite" => get_boolean(assigns.composite),
      "data-default-highlighted-value" => assigns.value,
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-aria-label" => assigns.aria_label,
      "data-on-select" => assigns.on_select,
      "data-on-select-client" => assigns.on_select_client,
      "data-redirect" => get_boolean(assigns.redirect),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }

    Map.merge(base, Corex.Positioning.to_dataset(positioning))
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}:root"
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:root")
    )
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "trigger",
      "type" => "button",
      "tabindex" => if(assigns.disabled, do: -1, else: 0),
      "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
      "disabled" => assigns.disabled,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}:trigger"
    }
  end

  def ignore_trigger(assigns) do
    JS.ignore_attributes(Trigger.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:trigger")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "indicator",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}:indicator"
    }
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:indicator")
    )
  end

  @spec positioner(Positioner.t()) :: map()
  def positioner(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "positioner",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}:popper",
      "hidden" => "true"
    }
  end

  def ignore_positioner(assigns) do
    JS.ignore_attributes(Positioner.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:popper")
    )
  end

  @spec content(Content.t()) :: map()
  def content(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "content",
      "role" => "menu",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}:content",
      "hidden" => "true"
    }
  end

  def ignore_content(assigns) do
    JS.ignore_attributes(Content.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:content")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => get_boolean(assigns.disabled),
      "disabled" => assigns.disabled,
      "role" => "menuitem",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "#{assigns.id}/#{assigns.value}",
      "data-nested-menu" => assigns.nested_menu_id,
      "data-has-nested" => get_boolean(assigns.has_nested)
    }

    ItemNav.put_item_nav_attrs(base, assigns)
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("#{assigns.id}/#{assigns.value}")
    )
  end

  @spec separator(Root.t()) :: map()
  def separator(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "separator",
      "role" => "separator",
      "aria-orientation" => "horizontal",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  @spec item_group_label(GroupLabel.t()) :: map()
  def item_group_label(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "item-group-label",
      "id" => "menu:#{assigns.id}:group-label:#{assigns.group_id}",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_item_group_label(assigns) do
    JS.ignore_attributes(GroupLabel.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:group-label:#{assigns.group_id}")
    )
  end

  @spec item_group(Group.t()) :: map()
  def item_group(assigns) do
    %{
      "data-scope" => "menu",
      "data-part" => "item-group",
      "data-id" => assigns.group_id,
      "id" => "menu:#{assigns.id}:group:#{assigns.group_id}",
      "role" => "group",
      "aria-labelledby" => "menu:#{assigns.id}:group-label:#{assigns.group_id}",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical")
    }
  end

  def ignore_item_group(assigns) do
    JS.ignore_attributes(Group.ignored_attrs(),
      to: Selectors.css_id("menu:#{assigns.id}:group:#{assigns.group_id}")
    )
  end

  @spec nested_menu(Root.t()) :: map()
  def nested_menu(assigns) do
    %{
      "data-scope" => "menu",
      "data-nested" => "menu",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "menu:#{assigns.id}"
    }
  end
end
