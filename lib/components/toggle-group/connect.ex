defmodule Corex.ToggleGroup.Connect do
  @moduledoc false
  alias Corex.ToggleGroup.Anatomy.{Props, Root, Item}

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-deselectable" => data_attr(assigns.deselectable),
      "data-loop-focus" => data_attr(assigns.loopFocus),
      "data-roving-focus" => data_attr(assigns.rovingFocus),
      "data-default-value" =>
        if !assigns.controlled and assigns.value != [] do
          Enum.join(assigns.value, ",")
        end,
      "data-value" =>
        if assigns.controlled and assigns.value != [] do
          Enum.join(assigns.value, ",")
        end,
      "data-disabled" => data_attr(assigns.disabled),
      "data-multiple" => data_attr(assigns.multiple),
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-dir" => assigns.dir
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "toggle-group",
      "data-part" => "root"
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "dir" => assigns.dir,
          "data-orientation" => assigns.orientation,
          "id" => "toggle-group:#{assigns.id}",
          "data-disabled" => assigns.disabled,
          "style" => "outline: none;"
        })
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    value = assigns.value
    data_state = if(value in assigns.values, do: "on", else: "off")

    base = %{
      "data-scope" => "toggle-group",
      "data-part" => "item",
      "data-value" => value
    }

    if assigns.changed,
      do: base,
      else:
        Map.merge(base, %{
          "data-orientation" => assigns.orientation,
          "dir" => assigns.dir,
          "type" => "button",
          "data-disabled" => assigns.disabled_root || assigns.disabled,
          "data-ownedby" => "toggle-group:#{assigns.id}",
          "disabled" => assigns.disabled_root || assigns.disabled,
          "data-state" => data_state,
          "id" => "toggle-group:#{assigns.id}:#{value}"
        })
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
