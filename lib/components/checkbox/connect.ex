defmodule Corex.Checkbox.Connect do
  @moduledoc false
  alias Corex.Checkbox.Anatomy.{Control, HiddenInput, Indicator, Label, Props, Root}

  import Corex.Helpers,
    only: [get_boolean: 1, get_boolean: 2, get_default_boolean: 2, data_state: 3]

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-checked" => get_default_boolean(assigns.controlled, assigns.checked),
      "data-checked" => get_boolean(assigns.controlled, assigns.checked),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-value" => assigns.value,
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-label" => assigns.label,
      "data-read-only" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-on-checked-change" => assigns.on_checked_change,
      "data-on-checked-change-client" => assigns.on_checked_change_client
    }
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "checkbox",
      "data-part" => "root",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}",
      "htmlFor" => "checkbox:#{assigns.id}:input",
      "for" => "checkbox:#{assigns.id}:input",
      "data-state" => state
    }
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "checkbox",
      "data-part" => "hidden-input",
      "id" => "checkbox:#{assigns.id}:input",
      "type" => "checkbox",
      "checked" => get_boolean(assigns.checked),
      "value" => "true",
      "name" => assigns.name,
      "required" => get_boolean(assigns.required),
      "disabled" => get_boolean(assigns.disabled),
      "aria-labelledby" => "checkbox:#{assigns.id}:label",
      "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
      "style" =>
        "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "checkbox",
      "data-part" => "control",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:control",
      "data-state" => state
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "checkbox",
      "data-part" => "label",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:label",
      "data-state" => state
    }
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "checkbox",
      "data-part" => "indicator",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:indicator",
      "data-state" => state
    }
  end
end
