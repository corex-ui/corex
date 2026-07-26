defmodule Corex.Checkable.Connect do
  @moduledoc false
  use Corex.Connect.Mounted

  use Corex.Component, :connect

  import Corex.Checkable.Helpers,
    only: [
      checked_attr_value: 1,
      checked_default_attr: 2,
      native_checked: 1,
      normalize_checked: 1
    ]

  alias Corex.FormField

  @spec props(map(), String.t()) :: map()
  def props(assigns, _scope) do
    form_field = Map.get(assigns, :form_field, false)
    controlled = Map.get(assigns, :controlled, false)
    checked_val = checked_attr_value(normalize_checked(assigns.checked))

    default_checked_out =
      if form_field do
        FormField.dataset_default_boolean(assigns.checked)
      else
        checked_default_attr(false, assigns.checked)
      end

    {checked_attr, default_checked_attr} =
      if controlled do
        {checked_val, nil}
      else
        {nil, default_checked_out}
      end

    %{
      "id" => assigns.id,
      "data-default-checked" => default_checked_attr,
      "data-checked" => checked_attr,
      "data-controlled" => presence_attr(controlled),
      "data-disabled" => presence_attr(assigns.disabled),
      "data-value" => assigns.value,
      "data-name" => assigns.name,
      "data-form" => assigns.form,
      "data-orientation" => Map.get(assigns, :orientation, "horizontal"),
      "data-label" => assigns.label,
      "data-readonly" => presence_attr(assigns.read_only),
      "data-invalid" => presence_attr(assigns.invalid),
      "data-required" => presence_attr(assigns.required),
      "data-on-checked-change" => assigns.on_checked_change,
      "data-on-checked-change-client" => assigns.on_checked_change_client
    }
    |> put_data_dir_attr(assigns.dir)
    |> FormField.put_form_field_attrs(assigns)
  end

  @spec hidden_input(map(), String.t(), keyword()) :: map()
  def hidden_input(assigns, scope, opts \\ []) do
    input_value = Keyword.get(opts, :input_value, assigns.value)

    %{
      "data-scope" => scope,
      "data-part" => "hidden-input",
      "id" => "#{scope}:#{assigns.id}:input",
      "type" => "checkbox",
      "checked" => native_checked(assigns.checked),
      "value" => input_value,
      "name" => assigns.name,
      "required" => presence_attr(assigns.required),
      "disabled" => presence_attr(assigns.disabled),
      "aria-labelledby" => "#{scope}:#{assigns.id}:label",
      "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
      "style" => visually_hidden_style()
    }
  end
end
