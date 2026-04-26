defmodule Corex.Checkbox.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.Checkbox.Anatomy.{
    Control,
    HiddenInput,
    Indeterminate,
    Indicator,
    Label,
    Props,
    Root
  }

  import Corex.Helpers,
    only: [
      get_boolean: 1,
      checkbox_checked_controlled_attr: 2,
      checkbox_checked_default_attr: 2,
      checkbox_native_checked: 1,
      checkbox_visual_state: 1
    ]

  alias Phoenix.LiveView.JS

  @spec props(Props.t()) :: map()
  def props(assigns) do
    %{
      "id" => assigns.id,
      "data-default-checked" =>
        checkbox_checked_default_attr(assigns.controlled, assigns.checked),
      "data-checked" => checkbox_checked_controlled_attr(assigns.controlled, assigns.checked),
      "data-controlled" => get_boolean(assigns.controlled),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-value" => assigns.value,
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => assigns.dir,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
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
    state = checkbox_visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

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

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "checkbox",
      "data-part" => "hidden-input",
      "id" => "checkbox:#{assigns.id}:input",
      "type" => "checkbox",
      "checked" => checkbox_native_checked(assigns.checked),
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

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    state = checkbox_visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

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

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:control")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = checkbox_visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "label",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:label",
      "data-state" => state
    }
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:label")
    )
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    state = checkbox_visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "indicator",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:indicator",
      "data-state" => state
    }
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:indicator")
    )
  end

  @spec indeterminate(Indeterminate.t()) :: map()
  def indeterminate(assigns) do
    state = checkbox_visual_state(assigns.checked)
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "checkbox",
      "data-part" => "indeterminate",
      "data-orientation" => orientation,
      "dir" => assigns.dir,
      "id" => "checkbox:#{assigns.id}:indeterminate",
      "data-state" => state
    }
  end

  def ignore_indeterminate(assigns) do
    JS.ignore_attributes(Indeterminate.ignored_attrs(),
      to: Selectors.css_id("checkbox:#{assigns.id}:indeterminate")
    )
  end
end
