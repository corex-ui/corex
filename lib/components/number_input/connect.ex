defmodule Corex.NumberInput.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

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

  defp num_attr(nil), do: nil
  defp num_attr(n) when is_number(n), do: to_string(n)

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  defp value_str(nil), do: nil
  defp value_str(v), do: to_string(v)

  @spec props(Props.t()) :: map()
  def props(assigns) do
    value_dataset = FormField.default_value_dataset(assigns, value_str(assigns.value))

    %{
      "id" => assigns.id,
      "data-value" => nil,
      "data-default-value" => value_dataset,
      "data-min" => num_attr(assigns.min),
      "data-max" => num_attr(assigns.max),
      "data-step" => num_attr(assigns.step),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-readonly" => presence_attr(assigns.read_only),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-required" => presence_attr(assigns.required),
      "data-allow-mouse-wheel" => presence_attr(assigns.allow_mouse_wheel),
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
      "data-readonly" => presence_attr(Map.get(assigns, :read_only, false))
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
      "id" =>
        case Map.get(assigns, :id) do
          id when is_binary(id) and id != "" -> "number-input:#{id}:trigger-group"
          _ -> nil
        end,
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns)
    }
    |> Map.reject(fn {_k, v} -> is_nil(v) end)
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "input",
      "disabled" => presence_attr(assigns.disabled),
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
      "required" => presence_attr(assigns.required)
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
