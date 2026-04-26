defmodule Corex.PinInput.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label, Props, Root}
  import Corex.Helpers, only: [validate_value!: 1, get_boolean: 1]

  alias Phoenix.LiveView.JS

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  @spec props(Props.t()) :: map()
  def props(assigns) do
    value_list = if is_list(assigns.value), do: validate_value!(assigns.value), else: []
    data_default_value_str = Enum.join(value_list, ",")

    %{
      "id" => assigns.id,
      "data-default-value" => data_default_value_str,
      "data-count" => to_string(assigns.count),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-read-only" => get_boolean(assigns.read_only),
      "data-mask" => get_boolean(assigns.mask),
      "data-otp" => get_boolean(assigns.otp),
      "data-blur-on-complete" => get_boolean(assigns.blur_on_complete),
      "data-select-on-focus" => get_boolean(assigns.select_on_focus),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "data-type" => assigns.type,
      "data-placeholder" => assigns.placeholder,
      "data-on-value-change" => assigns.on_value_change,
      "data-on-value-change-client" => assigns.on_value_change_client,
      "data-on-value-complete" => assigns.on_value_complete
    }
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("pin-input:#{assigns.id}")
    )
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("pin-input:#{assigns.id}:label")
    )
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("pin-input:#{assigns.id}:hidden-input")
    )
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("pin-input:#{assigns.id}:control")
    )
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("pin-input:#{assigns.id}:input:#{assigns.index}")
    )
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "root",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
      "id" => "pin-input:#{assigns.id}"
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "label",
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns),
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
      "data-orientation" => orientation(assigns),
      "id" => "pin-input:#{assigns.id}:control"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    %{
      "data-scope" => "pin-input",
      "data-part" => "input",
      "data-index" => to_string(assigns.index),
      "id" => "pin-input:#{assigns.id}:input:#{assigns.index}",
      "aria-label" => assigns.aria_label,
      "dir" => assigns.dir,
      "data-orientation" => orientation(assigns)
    }
  end
end
