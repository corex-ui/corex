defmodule Corex.RadioGroup.Connect do
  @moduledoc false
  alias Corex.RadioGroup.Anatomy.{
    Props,
    Root,
    Label,
    Indicator,
    Item,
    ItemText,
    ItemControl,
    ItemHiddenInput
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-value" => if(assigns.controlled, do: assigns.value, else: nil),
      "data-default-value" => if(assigns.controlled, do: nil, else: assigns.value),
      "data-controlled" => data_attr(assigns.controlled),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "data-required" => data_attr(assigns.required),
      "data-read-only" => data_attr(assigns.read_only),
      "data-dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "root",
      "role" => "radiogroup",
      "dir" => assigns.dir,
      "data-orientation" => assigns.orientation,
      "id" => "radio-group:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "radio-group:#{assigns.id}:label"
    }
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "indicator",
      "dir" => assigns.dir,
      "id" => "radio-group:#{assigns.id}:indicator"
    }
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "data-state" => if(assigns.checked, do: "checked", else: "unchecked"),
      "id" => "radio-group:#{assigns.id}:item:#{assigns.value}"
    }
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-text",
      "data-value" => assigns.value,
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "id" => "radio-group:#{assigns.id}:item-text:#{assigns.value}"
    }
  end

  @spec item_control(ItemControl.t()) :: map()
  def item_control(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-control",
      "data-value" => assigns.value,
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "id" => "radio-group:#{assigns.id}:item-control:#{assigns.value}"
    }
  end

  @spec item_hidden_input(ItemHiddenInput.t()) :: map()
  def item_hidden_input(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-hidden-input",
      "type" => "radio",
      "name" => assigns.name,
      "form" => assigns.form,
      "value" => assigns.value,
      "checked" => data_attr(assigns.checked),
      "disabled" => data_attr(assigns.disabled),
      "data-value" => assigns.value,
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "id" => "radio-group:#{assigns.id}:item-hidden-input:#{assigns.value}"
    }
  end
end
