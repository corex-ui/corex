defmodule Corex.Accordion.Connect do
  @moduledoc false
  alias Corex.Accordion.Anatomy.{Props, Root, Item}
  import Corex.Helpers, only: [validate_value!: 1]

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-collapsible" => data_attr(assigns.collapsible),
      "data-default-value" =>
        if assigns.controlled do
          nil
        else
          Enum.join(validate_value!(assigns.value), ",")
        end,
      "data-value" =>
        if assigns.controlled do
          Enum.join(validate_value!(assigns.value), ",")
        else
          nil
        end,
      "data-disabled" => data_attr(assigns.disabled),
      "data-controlled" => data_attr(assigns.controlled),
      "data-multiple" => data_attr(assigns.multiple),
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-focus-change" => assigns.on_focus_change,
      "data-on-focus-change-client" => assigns.on_focus_change_client,
      "data-dir" => assigns.dir
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "accordion",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "data-orientation" => assigns.orientation,
          "id" => "accordion:#{assigns.id}"
        })
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    value = assigns.value
    data_state = if(value in assigns.values, do: "open", else: "closed")

    base = %{
      "data-scope" => "accordion",
      "data-part" => "item",
      "data-value" => value,
      "data-disabled" => assigns.disabled_root || assigns.disabled
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "data-state" => data_state,
          "id" => "accordion:#{assigns.id}:item:#{value}"
        })
  end

  @spec trigger(Item.t()) :: map()
  def trigger(assigns) do
    expanded = assigns.value in assigns.values
    data_state = if expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "accordion",
      "data-part" => "item-trigger"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "type" => "button",
          "tabindex" => if(assigns.disabled, do: -1, else: 0),
          "aria-expanded" => if(expanded, do: "true", else: "false"),
          "aria-disabled" => if(assigns.disabled, do: "true", else: "false"),
          "data-disabled" => assigns.disabled,
          "disabled" => assigns.disabled,
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "data-state" => data_state,
          "id" => "accordion:#{assigns.id}:trigger:#{assigns.value}",
          "data-controls" => "accordion:#{assigns.id}:content:#{assigns.value}",
          "aria-controls" => "accordion:#{assigns.id}:content:#{assigns.value}",
          "data-ownedby" => "accordion:#{assigns.id}"
        })
  end

  @spec content(Item.t()) :: map()
  def content(assigns) do
    expanded = assigns.value in assigns.values
    data_state = if expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "accordion",
      "data-part" => "item-content"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "role" => "region",
          "data-state" => data_state,
          "data-disabled" => assigns.disabled,
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "aria-labelledby" => "accordion:#{assigns.id}:trigger:#{assigns.value}",
          "hidden" => !expanded,
          "id" => "accordion:#{assigns.id}:content:#{assigns.value}"
        })
  end

  @spec indicator(Item.t()) :: map()
  def indicator(assigns) do
    expanded = assigns.value in assigns.values
    data_state = if expanded, do: "open", else: "closed"

    base = %{
      "data-scope" => "accordion",
      "data-part" => "item-indicator"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "aria-hidden" => true,
          "data-state" => data_state,
          "data-disabled" => assigns.disabled,
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir
        })
  end
end
