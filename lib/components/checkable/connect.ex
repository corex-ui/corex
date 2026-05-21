defmodule Corex.Checkable.Connect do
  @moduledoc false

  import Corex.Helpers, only: [get_boolean: 1, maybe_put_data_dir: 2]

  import Corex.Checkable.Helpers,
    only: [
      checked_controlled_attr: 2,
      checked_default_attr: 2,
      native_checked: 1
    ]

  @spec props(map(), String.t()) :: map()
  def props(assigns, _scope) do
    %{
      "id" => assigns.id,
      "data-default-checked" => checked_default_attr(assigns.controlled, assigns.checked),
      "data-checked" => checked_controlled_attr(assigns.controlled, assigns.checked),
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
      "required" => get_boolean(assigns.required),
      "disabled" => get_boolean(assigns.disabled),
      "aria-labelledby" => "#{scope}:#{assigns.id}:label",
      "aria-invalid" => if(assigns.invalid, do: "true", else: "false"),
      "style" =>
        "border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px;white-space:nowrap;word-wrap:normal;"
    }
  end
end
