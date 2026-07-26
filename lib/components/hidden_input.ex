defmodule Corex.HiddenInput do
  @moduledoc ~S'''
  Hidden input component based on [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents).

  ## Anatomy

  ### Basic

  ```heex
  <.hidden_input name="user[id]" value={@user.id} />
  ```

  ### With form field

  ```heex
  <.hidden_input field={@form[:id]} />
  ```

  '''

  @doc type: :component
  use Phoenix.Component
  use Corex.Component, :form

  alias Corex.FormField

  form_control_attrs(
    except: [:invalid, :auto_invalid, :controlled, :disabled, :read_only, :required],
    docs: [
      id: "The id of the hidden input",
      field: "A form field struct from the form, e.g. @form[:id]",
      name: "The name attribute for form submission",
      form: "The id of the form this input belongs to"
    ]
  )

  attr(:value, :any, default: nil, doc: "The value of the hidden input")
  attr(:rest, :global)

  def hidden_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> assign(field: nil)
      |> FormField.assign_unless_given(:id, field.id)
      |> FormField.assign_unless_given(:name, field.name)
      |> FormField.assign_unless_given(:value, field.value)
      |> FormField.assign_unless_given(:form, field.form.id)

    hidden_input(assigns)
  end

  def hidden_input(assigns) do
    assigns = FormField.require_id!(assigns, "Corex component (hidden-input)")

    ~H"""
    <input
      type="hidden"
      id={@id}
      name={@name}
      value={Phoenix.HTML.Form.normalize_value("hidden", @value)}
      {@rest}
    />
    """
  end
end
