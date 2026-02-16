defmodule Corex.PinInput.Connect do
  @moduledoc false
  alias Corex.PinInput.Anatomy.{Props, Root, Label, HiddenInput, Control, Input}
  import Corex.Helpers, only: [validate_value!: 1]

  defp data_attr(true), do: ""
  defp data_attr(false), do: nil
  defp data_attr(nil), do: nil

  @spec props(Props.t()) :: map()
  def props(assigns) do
    value_str =
      if is_list(assigns.value), do: Enum.join(validate_value!(assigns.value), ","), else: ""

    default_value_str = if assigns.controlled, do: nil, else: value_str

    %{
      "id" => assigns.id,
      "data-value" => if(assigns.controlled, do: value_str, else: nil),
      "data-default-value" => default_value_str,
      "data-controlled" => data_attr(assigns.controlled),
      "data-count" => to_string(assigns.count),
      "data-disabled" => data_attr(assigns.disabled),
      "data-invalid" => data_attr(assigns.invalid),
      "data-required" => data_attr(assigns.required),
      "data-read-only" => data_attr(assigns.read_only),
      "data-mask" => data_attr(assigns.mask),
      "data-otp" => data_attr(assigns.otp),
      "data-blur-on-complete" => data_attr(assigns.blur_on_complete),
      "data-select-on-focus" => data_attr(assigns.select_on_focus),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-type" => assigns.type,
      "data-placeholder" => assigns.placeholder,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-value-complete" => assigns.on_value_complete
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "root",
      "dir" => assigns.dir,
      "id" => "pin-input:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "label",
      "dir" => assigns.dir,
      "id" => "pin-input:#{assigns.id}:label"
    }
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "hidden-input",
      "type" => "hidden",
      "name" => assigns.name,
      "value" => assigns.value,
      "id" => "pin-input:#{assigns.id}:hidden-input"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "control",
      "dir" => assigns.dir,
      "id" => "pin-input:#{assigns.id}:control"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "input",
      "data-index" => to_string(assigns.index),
      "id" => "pin-input:#{assigns.id}:input:#{assigns.index}"
    }
  end
end
