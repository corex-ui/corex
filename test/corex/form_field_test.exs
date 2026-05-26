defmodule Corex.FormFieldTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Ecto.Changeset

  alias Corex.FormField

  defp name_field(params, action) do
    changeset =
      {%{}, %{name: :string}}
      |> cast(params, [:name])
      |> validate_required([:name])

    form = to_form(changeset, as: :user, action: action)
    form[:name]
  end

  defp render_errors(field) do
    render_component(
      fn assigns ->
        assigns = FormField.assign_errors(assigns, assigns.field)

        ~H"""
        {Enum.join(@errors, "|")}
        """
      end,
      %{field: field, invalid: false}
    )
  end

  test "assign_errors shows errors only when used_input?" do
    field = name_field(%{"name" => ""}, :validate)

    assert used_input?(field)
    assert render_errors(field) =~ "blank"
  end

  test "assign_errors hides errors when field not used" do
    field = name_field(%{}, :validate)

    refute used_input?(field)
    assert render_errors(field) == ""
  end

  test "assign_form_field does not set invalid from visible errors" do
    field = name_field(%{"name" => ""}, :validate)

    result = FormField.assign_form_field(%{invalid: false, __changed__: %{}}, field)

    assert result.errors != []
    assert result.invalid == false
  end

  test "invalid? is true when field has visible errors" do
    field = name_field(%{"name" => ""}, :validate)

    assert FormField.invalid?(field)
    refute FormField.invalid?(name_field(%{}, :validate))
  end

  test "assign_form_field keeps invalid false when errors are hidden" do
    field = name_field(%{}, :validate)

    result = FormField.assign_form_field(%{invalid: false, __changed__: %{}}, field)

    assert result.errors == []
    assert result.invalid == false
  end

  test "assign_form_field preserves explicit invalid when there are no errors" do
    field = name_field(%{"name" => "ok"}, :validate)

    result = FormField.assign_form_field(%{invalid: true, __changed__: %{}}, field)

    assert result.errors == []
    assert result.invalid == true
  end

  test "assign_errors does not show all errors on insert action alone" do
    field = name_field(%{}, :insert)

    refute used_input?(field)
    assert render_errors(field) == ""
  end

  test "list_submit_name appends []" do
    assert FormField.list_submit_name("admin[tags]") == "admin[tags][]"
    assert FormField.list_submit_name(nil) == nil
  end

  test "unused_input_name for nested form fields" do
    assert FormField.unused_input_name("admin[tags]") == "admin[_unused_tags]"
    assert FormField.unused_input_name("admin[signature]") == "admin[_unused_signature]"
    assert FormField.unused_input_name(nil) == nil
  end

  test "assign_form_field sets field_used from used_input?" do
    field = name_field(%{"name" => ""}, :validate)

    result = FormField.assign_form_field(%{invalid: false, __changed__: %{}}, field)

    assert result.field_used == true
    assert result.errors != []
  end

  test "put_form_field_attrs adds data-field-used when field was used" do
    attrs = FormField.put_form_field_attrs(%{}, %{form_field: true, field_used: true})
    assert attrs["data-field-used"] == "true"
  end

  test "assign_form_field overwrites nil name from attr default" do
    field = name_field(%{"name" => "x"}, :validate)

    result =
      FormField.assign_form_field(%{name: nil, invalid: false, __changed__: %{}}, field)

    assert result.name == field.name
    assert FormField.list_submit_name(result.name) == field.name <> "[]"
  end
end
