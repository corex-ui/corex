defmodule Corex.NumberInput.Connect do
  @moduledoc false
  alias Corex.NumberInput.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Input,
    TriggerGroup,
    DecrementTrigger,
    IncrementTrigger,
    Scrubber
  }

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  defp num_attr(nil), do: nil
  defp num_attr(n) when is_number(n), do: to_string(n)

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-value" => if(assigns.controlled, do: assigns.value, else: nil),
      "data-default-value" => if(assigns.controlled, do: nil, else: assigns.default_value),
      "data-controlled" => data_attr(assigns.controlled),
      "data-min" => num_attr(assigns.min),
      "data-max" => num_attr(assigns.max),
      "data-step" => num_attr(assigns.step),
      "data-disabled" => data_attr(assigns.disabled),
      "data-read-only" => data_attr(assigns.read_only),
      "data-invalid" => data_attr(assigns.invalid),
      "data-required" => data_attr(assigns.required),
      "data-allow-mouse-wheel" => data_attr(assigns.allow_mouse_wheel),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "root",
      "id" => "number-input:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "label",
      "id" => "number-input:#{assigns.id}:label",
      "for" => "number-input:#{assigns.id}:input"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "control",
      "id" => "number-input:#{assigns.id}:control"
    }
  end

  @spec trigger_group(TriggerGroup.t()) :: map()
  def trigger_group(_assigns) do
    %{
      "data-part" => "trigger-group"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "input",
      "disabled" => data_attr(assigns.disabled),
      "id" => "number-input:#{assigns.id}:input"
    }
  end

  @spec decrement_trigger(DecrementTrigger.t()) :: map()
  def decrement_trigger(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "decrement-trigger",
      "type" => "button",
      "id" => "number-input:#{assigns.id}:dec",
      "aria-label" => "Decrease value"
    }
  end

  @spec increment_trigger(IncrementTrigger.t()) :: map()
  def increment_trigger(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "increment-trigger",
      "type" => "button",
      "id" => "number-input:#{assigns.id}:inc",
      "aria-label" => "Increase value"
    }
  end

  @spec scrubber(Scrubber.t()) :: map()
  def scrubber(assigns) do
    %{
      "data-scope" => "number-input",
      "data-part" => "scrubber",
      "type" => "button",
      "id" => "number-input:#{assigns.id}:scrubber",
      "aria-label" => "Scrub to adjust value"
    }
  end
end
