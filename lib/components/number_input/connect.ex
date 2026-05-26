defmodule Corex.NumberInput.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.NumberInput.Anatomy.{
    Control,
    DecrementTrigger,
    IncrementTrigger,
    Input,
    Label,
    Props,
    Root,
    TriggerGroup
  }

  alias Corex.FormField
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  defp num_attr(nil), do: nil
  defp num_attr(n) when is_number(n), do: to_string(n)

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  defp value_str(nil), do: nil
  defp value_str(v), do: to_string(v)

  @spec props(Props.t()) :: map()
  def props(assigns) do
    form_field = Map.get(assigns, :form_field, false)
    controlled = Map.get(assigns, :controlled, false)
    value_dataset = FormField.default_value_dataset(assigns, value_str(assigns.value))

    {value_attr, default_attr} =
      cond do
        controlled -> {value_dataset, nil}
        form_field -> {value_dataset, nil}
        true -> {nil, value_dataset}
      end

    %{
      "id" => assigns.id,
      "data-controlled" => get_boolean(controlled),
      "data-value" => value_attr,
      "data-default-value" => default_attr,
      "data-min" => num_attr(assigns.min),
      "data-max" => num_attr(assigns.max),
      "data-step" => num_attr(assigns.step),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-allow-mouse-wheel" => get_boolean(assigns.allow_mouse_wheel),
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
    |> FormField.put_form_field_attrs(assigns)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}")
    )
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}:label")
    )
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}:control")
    )
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}:input")
    )
  end

  def ignore_increment_trigger(assigns) do
    JS.ignore_attributes(IncrementTrigger.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}:inc")
    )
  end

  def ignore_decrement_trigger(assigns) do
    JS.ignore_attributes(DecrementTrigger.ignored_attrs(),
      to: Selectors.css_id("number-input:#{assigns.id}:dec")
    )
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "root",
      "id" => "number-input:#{assigns.id}",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns),
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "label",
      "id" => "number-input:#{assigns.id}:label",
      "for" => "number-input:#{assigns.id}:input",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "control",
      "id" => "number-input:#{assigns.id}:control",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns),
      "role" => "group"
    }
  end

  @spec trigger_group(TriggerGroup.t()) :: map()
  def trigger_group(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "trigger-group",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "input",
      "disabled" => get_boolean(assigns.disabled),
      "id" => "number-input:#{assigns.id}:input",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns),
      "type" => "text",
      "inputmode" => "decimal",
      "role" => "spinbutton",
      "autocomplete" => "off",
      "autocorrect" => "off",
      "spellcheck" => "false",
      "pattern" => "-?[0-9]*(.[0-9]+)?",
      "required" => get_boolean(assigns.required)
    }
  end

  @spec decrement_trigger(DecrementTrigger.t()) :: map()
  def decrement_trigger(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "decrement-trigger",
      "type" => "button",
      "id" => "number-input:#{assigns.id}:dec",
      "aria-label" => assigns.aria_label,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
  end

  @spec increment_trigger(IncrementTrigger.t()) :: map()
  def increment_trigger(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "increment-trigger",
      "type" => "button",
      "id" => "number-input:#{assigns.id}:inc",
      "aria-label" => assigns.aria_label,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
  end
end
