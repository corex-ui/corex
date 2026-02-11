defmodule Corex.Menu.Connect do
  @moduledoc false
  alias Corex.Menu.Anatomy.{Props, Root, Trigger, Item, Group}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-controlled" => data_attr(assigns.controlled),
      "data-open" =>
        if assigns.controlled do
          data_attr(assigns.open)
        else
          nil
        end,
      "data-default-open" =>
        if assigns.controlled do
          nil
        else
          data_attr(assigns.open)
        end,
      "data-close-on-select" => data_attr(assigns.close_on_select),
      "data-loop-focus" => data_attr(assigns.loop_focus),
      "data-typeahead" => data_attr(assigns.typeahead),
      "data-composite" => data_attr(assigns.composite),
      "data-dir" => assigns.dir,
      "data-aria-label" => assigns.aria_label,
      "data-on-select" => assigns.on_select,
      "data-on-select-client" => assigns.on_select_client,
      "data-redirect" => data_attr(assigns.redirect),
      "data-on-open-change" => assigns.on_open_change,
      "data-on-open-change-client" => assigns.on_open_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir
        })
  end

  @spec trigger(Trigger.t()) :: map()
  def trigger(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "trigger"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "button",
          "tabindex" => if(assigns.disabled, do: -1, else: 0),
          "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
          "data-disabled" => data_attr(assigns.disabled),
          "disabled" => assigns.disabled,
          "dir" => assigns.dir,
          "id" => "menu:#{assigns.id}:trigger"
        })
  end

  @spec indicator(Root.t()) :: map()
  def indicator(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "indicator"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir
        })
  end

  @spec positioner(Root.t()) :: map()
  def positioner(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "positioner"
    }

    base =
      if assigns.changed do
        base
      else
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "menu:#{assigns.id}:positioner"
        })
      end

    base =
      if initially_open?(assigns.open) do
        base
      else
        Map.put(base, "hidden", "true")
      end

    base
  end

  @spec content(Root.t()) :: map()
  def content(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "content"
    }

    base =
      if assigns.changed do
        base
      else
        Map.merge(base, %{
          "role" => "menu",
          "dir" => assigns.dir,
          "id" => "menu:#{assigns.id}:content"
        })
      end

    base =
      if initially_open?(assigns.open) do
        base
      else
        Map.put(base, "hidden", "true")
      end

    base
  end

  defp initially_open?(true), do: true
  defp initially_open?(_), do: false

  @spec item(Item.t()) :: map()
  def item(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => data_attr(assigns.disabled)
    }

    base = if assigns.redirect == false, do: Map.put(base, "data-redirect", "false"), else: base
    base = if assigns.new_tab, do: Map.put(base, "data-new-tab", ""), else: base

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "role" => "menuitem",
          "dir" => assigns.dir,
          "id" => "menu:#{assigns.id}:item:#{assigns.value}",
          "data-nested-menu" => assigns.nested_menu_id,
          "data-has-nested" => data_attr(assigns.has_nested)
        })
  end

  @spec separator(Root.t()) :: map()
  def separator(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "separator"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "role" => "separator",
          "aria-orientation" => "horizontal",
          "dir" => assigns.dir
        })
  end

  @spec item_group_label(Group.t()) :: map()
  def item_group_label(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "item-group-label"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "id" => "menu:#{assigns.id}:group-label:#{assigns.group_id}",
          "dir" => assigns.dir
        })
  end

  @spec item_group(Group.t()) :: map()
  def item_group(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-part" => "item-group"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "id" => "menu:#{assigns.id}:group:#{assigns.group_id}",
          "role" => "group",
          "aria-labelledby" => "menu:#{assigns.id}:group-label:#{assigns.group_id}",
          "dir" => assigns.dir
        })
  end

  @spec nested_menu(Root.t()) :: map()
  def nested_menu(assigns) do
    base = %{
      "data-scope" => "menu",
      "data-nested" => "menu"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "id" => "menu:#{assigns.id}"
        })
  end
end
