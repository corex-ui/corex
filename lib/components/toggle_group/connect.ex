defmodule Corex.ToggleGroup.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  alias Corex.Selectors

  alias Corex.ToggleGroup.Anatomy.{Item, Props, Root}

  alias Phoenix.LiveView.JS

  alias Corex.ValueBinding

  @spec props(Props.t()) :: map()
  def props(assigns) do
    {value_str, default_value_str} =
      ValueBinding.list_pair(assigns.value || [], assigns.controlled)

    %{
      "id" => assigns.id,
      "data-deselectable" => presence_attr(assigns.deselectable),
      "data-loop-focus" => presence_attr(assigns.loopFocus),
      "data-roving-focus" => presence_attr(assigns.rovingFocus),
      "data-controlled" => presence_attr(assigns.controlled),
      "data-value" => value_str,
      "data-default-value" => default_value_str,
      "data-disabled" => presence_attr(assigns.disabled),
      "data-multiple" => presence_attr(assigns.multiple),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
    |> put_data_dir_attr_from_assigns(assigns)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base =
      %{
        "data-scope" => "toggle-group",
        "data-part" => "root",
        "data-orientation" => Map.get(assigns, :orientation, "vertical"),
        "id" => "toggle-group:#{assigns.id}",
        "data-disabled" => assigns.disabled,
        "style" => "outline: none;"
      }
      |> put_dir_attr_from_assigns(assigns)

    case Map.get(assigns, :aria_labelledby) do
      id when is_binary(id) -> Map.put(base, "aria-labelledby", id)
      _ -> base
    end
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("toggle-group:#{assigns.id}")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    value = assigns.value
    data_state = if(value in assigns.values, do: "on", else: "off")
    aria_label = assigns.aria_label || value

    %{
      "data-scope" => "toggle-group",
      "data-part" => "item",
      "data-value" => value,
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "type" => "button",
      "data-disabled" => assigns.disabled_root || assigns.disabled,
      "data-ownedby" => "toggle-group:#{assigns.id}",
      "disabled" => assigns.disabled_root || assigns.disabled,
      "data-state" => data_state,
      "id" => "toggle-group:#{assigns.id}:#{value}",
      "aria-label" => aria_label
    }
    |> put_dir_attr_from_assigns(assigns)
  end

  def ignore_item(assigns) do
    value = assigns.value

    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("toggle-group:#{assigns.id}:#{value}")
    )
  end
end
