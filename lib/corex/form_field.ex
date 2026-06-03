defmodule Corex.FormField do
  @moduledoc """
  Helpers for Corex form field wiring.

  Components that accept `field={@form[:name]}` wire id, name, form, errors, and
  `field_used` internally. They do **not** set `invalid` from changeset errors
  automatically. Pass `invalid` when you want alert styling after validation:

      <.select field={@form[:country]} invalid={Corex.FormField.invalid?(@form[:country])} />

  Error messages still come from each component's `:error` slot.
  """

  import Phoenix.Component

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  @doc false
  def assign_errors(assigns, %Phoenix.HTML.FormField{} = field) do
    errors =
      if field_errors_visible?(field) do
        Enum.map(field.errors, &Corex.Gettext.translate_error/1)
      else
        []
      end

    assign(assigns, :errors, errors)
  end

  @doc """
  Returns whether a form field should render invalid styling.

  Uses `Phoenix.Component.used_input?/1`, so errors show after the user interacts
  with the field on LiveView forms with `phx-change`, not on the initial render.
  """
  def invalid?(%Phoenix.HTML.FormField{} = field), do: field_errors_visible?(field)

  defp field_errors_visible?(%Phoenix.HTML.FormField{errors: []}), do: false

  defp field_errors_visible?(field), do: Phoenix.Component.used_input?(field)

  @doc false
  def assign_ids(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
  end

  @doc false
  def assign_form_field(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:form_field, true)
      |> assign(:field_used, used_input?(field))
      |> assign_ids(field)
      |> assign_errors(field)

    assign(assigns, :invalid, Map.get(assigns, :invalid, false))
  end

  @doc false
  def dataset_default_boolean(checked) do
    CheckableHelpers.checked_form_field_default_attr(checked)
  end

  @doc false
  def dataset_default_string(value) when is_binary(value), do: value
  def dataset_default_string(nil), do: ""

  @doc false
  def dataset_default_list([]), do: ""

  def dataset_default_list(list) when is_list(list) do
    Corex.Helpers.joined_csv_values(list) || ""
  end

  @doc false
  def dataset_default_json(list) when is_list(list) do
    Corex.Dataset.encode_json(list) || "[]"
  end

  @doc false
  def dataset_default_paths([]), do: ""

  def dataset_default_paths(paths) when is_list(paths) do
    Enum.join(paths, "\n")
  end

  @doc false
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

  @doc false
  def default_value_dataset(assigns, value) do
    if Map.get(assigns, :form_field, false) do
      dataset_default_string(value)
    else
      value
    end
  end

  @doc false
  def list_submit_name(nil), do: nil
  def list_submit_name(name) when is_binary(name), do: name <> "[]"

  @doc false
  def unused_input_name(nil), do: nil

  def unused_input_name(name) when is_binary(name) do
    case Regex.run(~r/^(.*)\[([^\]]+)\]$/, name) do
      [_, prefix, field] -> "#{prefix}[_unused_#{field}]"
      _ -> nil
    end
  end

  @doc false
  def assign_list_submit(assigns) do
    assign(assigns, :submit_name, list_submit_name(assigns[:name]))
  end
end
