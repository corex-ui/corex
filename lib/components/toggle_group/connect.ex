defmodule Corex.ToggleGroup.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.ToggleGroup.Anatomy.{Item, Props, Root}

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1, maybe_put_data_dir_from: 2, maybe_put_dir_from: 2]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-deselectable" => get_boolean(assigns.deselectable),
      "data-loop-focus" => get_boolean(assigns.loopFocus),
      "data-roving-focus" => get_boolean(assigns.rovingFocus),
      "data-default-value" =>
        if !assigns.controlled and assigns.value != [] do
          Enum.join(assigns.value, ",")
        end,
      "data-value" =>
        if assigns.controlled and assigns.value != [] do
          Enum.join(assigns.value, ",")
        end,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-multiple" => get_boolean(assigns.multiple),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
    |> maybe_put_data_dir_from(assigns)
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
      |> maybe_put_dir_from(assigns)

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
    |> maybe_put_dir_from(assigns)
  end

  def ignore_item(assigns) do
    value = assigns.value

    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("toggle-group:#{assigns.id}:#{value}")
    )
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
end
