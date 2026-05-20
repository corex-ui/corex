defmodule Corex.Switch.Connect do
  @moduledoc false
  alias Corex.Selectors
  alias Corex.Switch.Anatomy.{Control, HiddenInput, Label, Props, Root, Thumb}

  import Corex.Helpers,
    only: [
      get_boolean: 1,
      checkbox_checked_controlled_attr: 2,
      checkbox_checked_default_attr: 2,
      checkbox_native_checked: 1,
      data_state: 3,
      maybe_put_data_dir: 2,
      maybe_put_dir: 2
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
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "data-label" => assigns.label,
      "data-readonly" => get_boolean(assigns.read_only),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-required" => get_boolean(assigns.required),
      "data-on-checked-change" => assigns.on_checked_change,
      "data-on-checked-change-client" => assigns.on_checked_change_client
    }
    |> maybe_put_data_dir(assigns.dir)
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "root",
      "data-orientation" => orientation,
      "id" => "switch:#{assigns.id}",
      "htmlFor" => "switch:#{assigns.id}:input",
      "for" => "switch:#{assigns.id}:input",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}")
    )
  end

  @spec hidden_input(HiddenInput.t()) :: map()
  def hidden_input(assigns) do
    %{
      "data-scope" => "switch",
      "data-part" => "hidden-input",
      "type" => "checkbox",
      "id" => "switch:#{assigns.id}:input",
      "name" => assigns.name,
      "required" => get_boolean(assigns.required),
      "disabled" => get_boolean(assigns.disabled),
      "aria-labelledby" => "switch:#{assigns.id}:label",
      "value" => assigns.value,
      "checked" => checkbox_native_checked(assigns.checked),
      "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
      "style" =>
        "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
    }
  end

  def ignore_hidden_input(assigns) do
    JS.ignore_attributes(HiddenInput.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:input")
    )
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "control",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:control",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:control")
    )
  end

  @spec thumb(Thumb.t()) :: map()
  def thumb(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "thumb",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:thumb",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_thumb(assigns) do
    JS.ignore_attributes(Thumb.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:thumb")
    )
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    state = data_state(assigns.checked, "checked", "unchecked")
    orientation = Map.get(assigns, :orientation, "horizontal")

    %{
      "data-scope" => "switch",
      "data-part" => "label",
      "data-orientation" => orientation,
      "aria-hidden" => "true",
      "id" => "switch:#{assigns.id}:label",
      "data-state" => state
    }
    |> maybe_put_dir(assigns.dir)
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("switch:#{assigns.id}:label")
    )
  end
end
