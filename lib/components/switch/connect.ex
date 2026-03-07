defmodule Corex.Switch.Connect do
  @moduledoc false
  alias Corex.Switch.Anatomy.{Control, HiddenInput, Label, Props, Root, Thumb}

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
      "data-scope" => "switch",
      "data-part" => "root",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "switch:#{assigns.id}",
      "htmlFor" => "switch:#{assigns.id}:input",
      "for" => "switch:#{assigns.id}:input",
      "data-state" => state
    }
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    checked =
      if assigns.controlled do
        if assigns.checked, do: "", else: "false"
      else
        nil
      end

    %{
      "data-scope" => "switch",
      "data-part" => "hidden-input",
      "type" => "checkbox",
      "id" => "switch:#{assigns.id}:input",
      "checked" => checked,
      "name" => assigns.name,
      "required" => get_boolean(assigns.required),
      "disabled" => get_boolean(assigns.disabled),
      "aria-labelledby" => "switch:#{assigns.id}:label",
      "value" => assigns.value,
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
      "data-scope" => "switch",
      "data-part" => "control",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "dir" => assigns.dir,
      "id" => "switch:#{assigns.id}:control",
      "data-state" => state
    }
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "switch",
      "data-part" => "thumb",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "dir" => assigns.dir,
      "id" => "switch:#{assigns.id}:thumb",
      "data-state" => state
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "vertical")

    %{
      "data-scope" => "switch",
      "data-part" => "label",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "dir" => assigns.dir,
      "id" => "switch:#{assigns.id}:label",
      "data-state" => state
    }
  end
end
