defmodule Corex.FormField do
  @moduledoc """
  Use `invalid?/1` when you need an explicit `invalid={...}` from visible
  changeset errors. Prefer `auto_invalid` on the component for the common case.
  Explicit `invalid` wins over `auto_invalid`.

  See the [Forms](forms.html) guide.
  """

  import Phoenix.Component

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  @doc false
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

  @doc """
  Returns true when the field has visible errors (`used_input?/1`).

      <.select field={@form[:country]} invalid={Corex.FormField.invalid?(@form[:country])} />
  """
  @spec invalid?(Phoenix.HTML.FormField.t()) :: boolean()
  def invalid?(%Phoenix.HTML.FormField{} = field), do: field_errors_visible?(field)

  defp field_errors_visible?(%Phoenix.HTML.FormField{errors: []}), do: false

  defp field_errors_visible?(field), do: Phoenix.Component.used_input?(field)

  @doc false
  @spec assign_ids(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_ids(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
  end

  @doc false
  @spec assign_form_field(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_form_field(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:form_field, true)
      |> assign(:field_used, used_input?(field))
      |> assign_ids(field)
      |> assign_errors(field)

    assign(assigns, :invalid, resolve_invalid(assigns, field))
  end

  defp resolve_invalid(assigns, field) do
    case Map.get(assigns, :invalid) do
      nil ->
        if Map.get(assigns, :auto_invalid, false), do: invalid?(field), else: false

      invalid ->
        invalid
    end
  end

  @doc false
  @spec dataset_default_boolean(boolean() | :indeterminate) :: String.t()
  def dataset_default_boolean(checked) do
    CheckableHelpers.checked_form_field_default_attr(checked)
  end

  @doc false
  @spec dataset_default_string(String.t() | nil) :: String.t()
  def dataset_default_string(value) when is_binary(value), do: value
  def dataset_default_string(nil), do: ""

  @doc false
  @spec dataset_default_list(list()) :: String.t()
  def dataset_default_list([]), do: "[]"

  def dataset_default_list(list) when is_list(list) do
    Corex.ValueBinding.encode_list(list) || "[]"
  end

  @doc false
  @spec dataset_default_json(list()) :: String.t()
  def dataset_default_json(list) when is_list(list) do
    Corex.ValueBinding.encode_list(list) || "[]"
  end

  @doc false
  @spec dataset_default_paths(list()) :: String.t()
  def dataset_default_paths([]), do: ""

  def dataset_default_paths(paths) when is_list(paths) do
    Enum.join(paths, "\n")
  end

  @doc false
  @spec put_form_field_attrs(map(), map() | struct()) :: map()
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
  @spec default_value_dataset(map(), String.t() | nil) :: String.t() | nil
  def default_value_dataset(assigns, value) do
    if Map.get(assigns, :form_field, false) do
      dataset_default_string(value)
    else
      value
    end
  end

  @doc false
  @spec list_submit_name(String.t() | nil) :: String.t() | nil
  def list_submit_name(nil), do: nil
  def list_submit_name(name) when is_binary(name), do: name <> "[]"

  @doc false
  @spec assign_list_submit(map()) :: map()
  def assign_list_submit(assigns) do
    assign(assigns, :submit_name, list_submit_name(assigns[:name]))
  end

  @doc false
  @spec require_id!(map(), String.t()) :: map()
  def require_id!(assigns, component_name) when is_binary(component_name) do
    case assigns[:id] do
      id when is_binary(id) and id != "" ->
        assigns

      _ ->
        raise ArgumentError, """
        #{component_name} requires a stable :id (or :field) for its LiveView hook host.

        Pass id explicitly, or use field={@form[:name]} so Phoenix FormField.id is used
        (Ecto changesets with to_form/1 provide stable ids automatically).
        """
    end
  end
end
