defmodule Corex.FormField do
  @moduledoc """
  Use `invalid?/1` when you need an explicit `invalid={...}` from visible
  changeset errors. Prefer `auto_invalid` on the component for the common case.
  Explicit `invalid` wins over `auto_invalid`.

  See the [Forms](forms.html) guide.
  """

  import Phoenix.Component

  alias Corex.Checkable.Helpers, as: CheckableHelpers

  @spec assign_errors(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_errors(assigns, %Phoenix.HTML.FormField{} = field) do
    assign(assigns, :errors, visible_errors(field))
  end

  defp visible_errors(field), do: translate_errors(field_errors_visible?(field), field)

  defp translate_errors(true, field), do: Enum.map(field.errors, &Corex.Gettext.translate_error/1)
  defp translate_errors(false, _field), do: []

  @doc """
  Returns true when the field has visible errors (`used_input?/1`).

      <.select field={@form[:country]} invalid={Corex.FormField.invalid?(@form[:country])} />
  """
  @spec invalid?(Phoenix.HTML.FormField.t()) :: boolean()
  def invalid?(%Phoenix.HTML.FormField{} = field), do: field_errors_visible?(field)

  defp field_errors_visible?(%Phoenix.HTML.FormField{errors: []}), do: false

  defp field_errors_visible?(field), do: Phoenix.Component.used_input?(field)

  @spec assign_ids(map(), Phoenix.HTML.FormField.t()) :: map()
  def assign_ids(assigns, %Phoenix.HTML.FormField{} = field) do
    assigns
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
  end

  @doc """
  Fills an assign from the form field only when the caller left it blank.

  `assign_new/3` cannot serve here: `form_control_attrs/1` declares these attrs
  with `default: nil`, so the key is always present and `assign_new/3` would
  never run. Blank means `nil` or `""`, both of which mean "not given".
  """
  @spec assign_unless_given(map(), atom(), term()) :: map()
  def assign_unless_given(assigns, key, value) when is_atom(key) do
    case Map.get(assigns, key) do
      given when given in [nil, ""] -> assign(assigns, key, value)
      _given -> assigns
    end
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

  @spec dataset_default_boolean(boolean() | :indeterminate) :: String.t()
  def dataset_default_boolean(checked) do
    CheckableHelpers.checked_form_field_default_attr(checked)
  end

  @spec dataset_default_string(String.t() | nil) :: String.t()
  def dataset_default_string(value) when is_binary(value), do: value
  def dataset_default_string(nil), do: ""

  @spec dataset_default_json(list()) :: String.t()
  def dataset_default_json(list) when is_list(list) do
    case Corex.ValueBinding.encode_list(list) do
      nil -> "[]"
      json -> json
    end
  end

  @spec dataset_default_paths(list()) :: String.t()
  def dataset_default_paths([]), do: ""

  def dataset_default_paths(paths) when is_list(paths) do
    Enum.join(paths, "\n")
  end

  @spec put_form_field_attrs(map(), map() | struct()) :: map()
  def put_form_field_attrs(attrs, assigns) do
    attrs
    |> put_flag("data-form-field", Map.get(assigns, :form_field, false))
    |> put_flag("data-field-used", Map.get(assigns, :field_used, false))
  end

  defp put_flag(attrs, key, flag) when flag not in [nil, false], do: Map.put(attrs, key, "true")
  defp put_flag(attrs, _key, _flag), do: attrs

  @spec default_value_dataset(map(), String.t() | nil) :: String.t() | nil
  def default_value_dataset(%{form_field: form_field}, value) when form_field not in [nil, false],
    do: dataset_default_string(value)

  def default_value_dataset(_assigns, value), do: value

  @spec list_submit_name(String.t() | nil) :: String.t() | nil
  def list_submit_name(nil), do: nil
  def list_submit_name(name) when is_binary(name), do: name <> "[]"

  @spec assign_list_submit(map()) :: map()
  def assign_list_submit(assigns) do
    assign(assigns, :submit_name, list_submit_name(Map.get(assigns, :name)))
  end

  @spec require_id!(map(), String.t()) :: map()
  def require_id!(assigns, component_name) when is_binary(component_name) do
    case Map.get(assigns, :id) do
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

  @doc """
  Assigns a stable optional `:id` for hook hosts.

  Derivation order:

  1. Explicit `:id` when present and non-empty
  2. Prefixed `:name` when present (e.g. `"accordion-country"`)
  3. Prefixed random id for static usage

  Emits a `Logger.warning` in non-prod when the random fallback is used with
  server-driven updates (`controlled` or a server `on_*` handler), because a
  regenerated id remounts the LiveView hook on the next patch.
  """
  @spec assign_stable_id(map(), String.t()) :: map()
  def assign_stable_id(assigns, prefix) when is_binary(prefix) do
    case Map.get(assigns, :id) do
      id when is_binary(id) and id != "" ->
        assigns

      _ ->
        case derive_stable_id(assigns, prefix) do
          {:ok, id} ->
            assign(assigns, :id, id)

          :random ->
            maybe_warn_unstable_id(assigns, prefix)
            assign(assigns, :id, "#{prefix}-#{System.unique_integer([:positive])}")
        end
    end
  end

  defp derive_stable_id(assigns, prefix) do
    case Map.get(assigns, :name) do
      name when is_binary(name) and name != "" ->
        {:ok, "#{prefix}-#{sanitize_id_fragment(name)}"}

      _ ->
        :random
    end
  end

  defp sanitize_id_fragment(value) when is_binary(value) do
    value
    |> String.replace(~r/[^A-Za-z0-9_-]+/, "-")
    |> String.trim("-")
    |> case do
      "" -> "name"
      fragment -> fragment
    end
  end

  defp maybe_warn_unstable_id(assigns, prefix) do
    if server_driven_updates?(assigns) and not production_env?() do
      require Logger

      Logger.warning("""
      Corex.#{prefix_to_component(prefix)} generated a random id (#{prefix}-…). \
      Pass a stable :id when using controlled={true} or server on_* handlers so \
      LiveView patches do not remount the hook.
      """)
    end

    :ok
  end

  defp production_env? do
    case Code.ensure_loaded(Mix) do
      {:module, Mix} -> Mix.env() == :prod
      _ -> true
    end
  end

  defp server_driven_updates?(assigns) do
    Map.get(assigns, :controlled) in [true, :all] or
      Enum.any?(assigns, fn
        {key, value} when is_atom(key) ->
          key_str = Atom.to_string(key)

          String.starts_with?(key_str, "on_") and not String.ends_with?(key_str, "_client") and
            is_binary(value) and value != ""

        _ ->
          false
      end)
  end

  defp prefix_to_component(prefix) do
    prefix
    |> String.split("-")
    |> Enum.map_join(".", &String.capitalize/1)
  end
end
