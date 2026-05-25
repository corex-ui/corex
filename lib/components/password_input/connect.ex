defmodule Corex.PasswordInput.Connect do
  @moduledoc false
  alias Corex.Selectors

  alias Corex.PasswordInput.Anatomy.{
    Control,
    Indicator,
    Input,
    Label,
    Props,
    Root,
    VisibilityTrigger
  }

  alias Corex.FormField
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [get_boolean: 1]

  defp orientation(assigns), do: Map.get(assigns, :orientation, "horizontal")

  @spec props(Props.t()) :: map()
  def props(assigns) do
    form_field = Map.get(assigns, :form_field, false)
    controlled = Map.get(assigns, :controlled, false)
    zag_controlled = form_field || controlled
    value_dataset = FormField.default_value_dataset(assigns, Map.get(assigns, :value))

    {value_attr, default_attr} =
      if zag_controlled do
        {value_dataset, nil}
      else
        {nil, value_dataset}
      end

    %{
      "id" => assigns.id,
      "data-controlled" => get_boolean(zag_controlled),
      "data-value" => value_attr,
      "data-default-value" => default_attr,
      "data-default-visible" => get_boolean(assigns.visible),
      "data-disabled" => get_boolean(assigns.disabled),
      "data-invalid" => get_boolean(assigns.invalid),
      "data-readonly" => get_boolean(assigns.read_only),
      "data-required" => get_boolean(assigns.required),
      "data-ignore-password-managers" => get_boolean(assigns.ignore_password_managers),
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns),
      "data-auto-complete" => assigns.auto_complete,
      "data-on-visibility-change" => assigns.on_visibility_change,
      "data-on-visibility-change-client" => assigns.on_visibility_change_client
    }
    |> FormField.put_form_field_attrs(assigns)
  end

  def ignore_root(assigns) do
    JS.ignore_attributes(Root.ignored_attrs(),
      to: Selectors.css_id("password-input:#{assigns.id}")
    )
  end

  def ignore_label(assigns) do
    JS.ignore_attributes(Label.ignored_attrs(),
      to: Selectors.css_id("password-input:#{assigns.id}:label")
    )
  end

  def ignore_control(assigns) do
    JS.ignore_attributes(Control.ignored_attrs(),
      to: Selectors.css_id("password-input:#{assigns.id}:control")
    )
  end

  def ignore_input(assigns) do
    JS.ignore_attributes(Input.ignored_attrs(),
      to: Selectors.css_id("p-input-#{assigns.id}-input")
    )
  end

  def ignore_visibility_trigger(assigns) do
    JS.ignore_attributes(VisibilityTrigger.ignored_attrs(),
      to: Selectors.css_id("password-input:#{assigns.id}:visibility-trigger")
    )
  end

  def ignore_indicator(assigns) do
    JS.ignore_attributes(Indicator.ignored_attrs(),
      to: Selectors.css_id("password-input:#{assigns.id}:indicator")
    )
  end

  @spec root(Root.t()) :: map()
  def root(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "root",
      "dir" => Map.get(assigns, :dir),
      "data-orientation" => orientation(assigns),
      "id" => "password-input:#{assigns.id}",
      "data-readonly" => get_boolean(Map.get(assigns, :read_only, false))
    }
  end

  @spec label(Label.t()) :: map()
  def label(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "label",
      "data-orientation" => orientation(assigns),
      "id" => "password-input:#{assigns.id}:label",
      "for" => "p-input-#{assigns.id}-input"
    }
  end

  @spec control(Control.t()) :: map()
  def control(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "control",
      "data-orientation" => orientation(assigns),
      "id" => "password-input:#{assigns.id}:control"
    }
  end

  @spec input(Input.t()) :: map()
  def input(assigns) do
    base = %{
      "data-scope" => "password-input",
      "data-part" => "input",
      "disabled" => get_boolean(assigns.disabled),
      "id" => "p-input-#{assigns.id}-input",
      "name" => Map.get(assigns, :name),
      "form" => if(Map.get(assigns, :form_field, false), do: nil, else: Map.get(assigns, :form)),
      "autocomplete" => Map.get(assigns, :auto_complete),
      "data-orientation" => orientation(assigns)
    }

    Map.reject(base, fn {_k, v} -> is_nil(v) end)
  end

  @spec visibility_trigger(VisibilityTrigger.t()) :: map()
  def visibility_trigger(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "visibility-trigger",
      "type" => "button",
      "id" => "password-input:#{assigns.id}:visibility-trigger",
      "data-orientation" => orientation(assigns),
      "aria-label" => assigns.aria_label
    }
  end

  @spec indicator(Indicator.t()) :: map()
  def indicator(assigns) do
    %{
      "data-scope" => "password-input",
      "data-part" => "indicator",
      "id" => "password-input:#{assigns.id}:indicator",
      "data-orientation" => orientation(assigns),
      "aria-hidden" => "true",
      "data-state" => if(Map.get(assigns, :visible, false), do: "visible", else: "hidden")
    }
  end
end
