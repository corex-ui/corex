defmodule Corex.FormField do
  @moduledoc false

  import Phoenix.Component

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  @spec assign_errors(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_errors(assigns, %Phoenix.HTML.FormField{} = field) do
    errors =
      if field_errors_visible?(field) do
        Enum.map(field.errors, &Corex.Gettext.translate_error/1)
      else
        []
      end

    assign(assigns, :errors, errors)
  end

  defp field_errors_visible?(%Phoenix.HTML.FormField{errors: []}), do: false

  defp field_errors_visible?(field), do: Phoenix.Component.used_input?(field)

  @spec assign_ids(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_ids(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
  end

  @spec assign_form_field(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_form_field(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:form_field, true)
      |> assign(:field_used, used_input?(field))
      |> assign_ids(field)
      |> assign_errors(field)

    invalid = assigns.errors != [] || Map.get(assigns, :invalid, false)

    assign(assigns, :invalid, invalid)
  end

  @spec dataset_default_boolean(boolean() | :indeterminate) :: String.t()
  def dataset_default_boolean(checked) do
    CheckableHelpers.checked_form_field_default_attr(checked)
  end

  @spec dataset_default_string(String.t() | nil) :: String.t()
  def dataset_default_string(value) when is_binary(value), do: value
  def dataset_default_string(nil), do: ""

  @spec dataset_default_list(list()) :: String.t()
  def dataset_default_list([]), do: ""

  def dataset_default_list(list) when is_list(list) do
    Corex.Helpers.joined_csv_values(list) || ""
  end

  @spec dataset_default_json(list()) :: String.t()
  def dataset_default_json(list) when is_list(list) do
    Corex.Dataset.encode_json(list) || "[]"
  end

  @spec dataset_default_paths(list()) :: String.t()
  def dataset_default_paths([]), do: ""

  def dataset_default_paths(paths) when is_list(paths) do
    Enum.join(paths, "\n")
  end

  @spec put_form_field_attrs(map(), map()) :: map()
  def put_form_field_attrs(attrs, assigns) do
    attrs =
      if Map.get(assigns, :form_field, false) do
        Map.put(attrs, "data-form-field", "true")
      else
        attrs
      end

    if Map.get(assigns, :field_used, false) do
      Map.put(attrs, "data-field-used", "true")
    else
      attrs
    end
  end

  @spec default_value_dataset(map(), String.t() | nil) :: String.t() | nil
  def default_value_dataset(assigns, value) do
    if Map.get(assigns, :form_field, false) do
      dataset_default_string(value)
    else
      value
    end
  end

  @spec list_submit_name(String.t() | nil) :: String.t() | nil
  def list_submit_name(nil), do: nil
  def list_submit_name(name) when is_binary(name), do: name <> "[]"

  @spec unused_input_name(String.t() | nil) :: String.t() | nil
  def unused_input_name(nil), do: nil

  def unused_input_name(name) when is_binary(name) do
    case Regex.run(~r/^(.*)\[([^\]]+)\]$/, name) do
      [_, prefix, field] -> "#{prefix}[_unused_#{field}]"
      _ -> nil
    end
  end

  @spec assign_list_submit(map()) :: map()
  def assign_list_submit(assigns) do
    assign(assigns, :submit_name, list_submit_name(assigns[:name]))
  end
end
