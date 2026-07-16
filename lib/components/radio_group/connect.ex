defmodule Corex.RadioGroup.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.FormField

  alias Corex.RadioGroup.Anatomy.{
    Indicator,
    Item,
    ItemControl,
    ItemHiddenInput,
    ItemText,
    Label,
    Props,
    Root,
    ValueInput
  }

  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1, controlled_string_value: 2, maybe_put: 3]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    form_field = Map.get(assigns, :form_field, false)
    controlled = Map.get(assigns, :controlled, false)
    value_dataset = FormField.dataset_default_string(assigns.value)

    default_value_str =
      if form_field do
        value_dataset
      else
        assigns.value
      end

    {value_str, default_value_str} =
      if controlled do
        controlled_string_value(true, assigns.value)
      else
        {nil, default_value_str}
      end

    %{
      "id" => assigns.id,
      "data-value" => value_str,
      "data-default-value" => default_value_str,
      "data-controlled" => get_boolean(controlled),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
    |> FormField.put_form_field_attrs(assigns)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    base = %{
      "data-scope" => "radio-group",
      "data-part" => "root",
      "role" => "radiogroup",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}",
      "style" => "position:relative;",
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }

    if assigns.has_label do
      Map.put(base, "aria-labelledby", "radio-group:#{assigns.id}:label")
    else
      base
    end
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "label",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:label"
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:label")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "indicator",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:indicator",
      "hidden" => "",
      "style" =>
        "position:absolute;width:0;height:0;overflow:hidden;clip:rect(0,0,0,0);margin:-1px;padding:0;border:0;"
    }
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:indicator")
    )
  end

  @spec item(Item.t()) :: map()
  def item(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item",
      "data-value" => assigns.value,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-state" => if(assigns.checked, do: "checked", else: "unchecked"),
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:item:#{assigns.value}"
    }
  end

  def ignore_item(assigns) do
    JS.ignore_attributes(Item.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:item:#{assigns.value}")
    )
  end

  @spec item_text(ItemText.t()) :: map()
  def item_text(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-text",
      "data-value" => assigns.value,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:item-text:#{assigns.value}"
    }
  end

  def ignore_item_text(assigns) do
    JS.ignore_attributes(ItemText.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:item-text:#{assigns.value}")
    )
  end

  @spec item_control(ItemControl.t()) :: map()
  def item_control(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-control",
      "aria-hidden" => "true",
      "data-value" => assigns.value,
      "data-state" => if(assigns.checked, do: "checked", else: "unchecked"),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:item-control:#{assigns.value}"
    }
  end

  def ignore_item_control(assigns) do
    JS.ignore_attributes(ItemControl.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:item-control:#{assigns.value}")
    )
  end

  @spec value_input(ValueInput.t()) :: map()
  def value_input(assigns) do
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "type" => "hidden",
      "hidden" => "true",
      "aria-hidden" => "true",
      "tabindex" => "-1",
      "data-scope" => "radio-group",
      "data-part" => "value-input",
      "dir" => assigns.dir,
      "data-orientation" => orientation,
      "id" => "radio-group:#{assigns.id}:value-input"
    }
  end

  def ignore_value_input(assigns) do
    JS.ignore_attributes(ValueInput.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:value-input")
    )
  end

  @spec item_hidden_input(ItemHiddenInput.t()) :: map()
  def item_hidden_input(assigns) do
    %{
      "data-scope" => "radio-group",
      "data-part" => "item-hidden-input",
      "type" => "radio",
      "form" => assigns.form,
      "value" => assigns.value,
      "checked" => get_boolean(assigns.checked),
      "disabled" => get_boolean(assigns.disabled),
      "data-value" => assigns.value,
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => Map.get(assigns, :orientation, "vertical"),
      "id" => "radio-group:#{assigns.id}:item-hidden-input:#{assigns.value}",
      "style" =>
        "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
    }
    |> maybe_put("name", assigns.name)
  end

  def ignore_item_hidden_input(assigns) do
    JS.ignore_attributes(ItemHiddenInput.ignored_attrs(),
      to: Selectors.css_id("radio-group:#{assigns.id}:item-hidden-input:#{assigns.value}")
    )
  end
end
