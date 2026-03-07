defmodule Corex.HiddenInput do
  @moduledoc ~S'''
  Hidden input component based on [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents).

  ## Examples

  ### Basic

  ```heex
  <.hidden_input id="id" name="user[id]" value={@user.id} />
  ```

  ### With form field

  ```heex
  <.hidden_input field={@form[:id]} />
  ```

  '''

  @doc type: :component
  use Phoenix.Component

  attr(:id, :string, required: false, doc: "The id of the hidden input")
  attr(:name, :string, required: false, doc: "The name attribute for form submission")
  attr(:value, :any, default: nil, doc: "The value of the hidden input")
  attr(:form, :string, required: false, doc: "The id of the form this input belongs to")

  attr(:field, Phoenix.HTML.FormField, doc: "A form field struct from the form, e.g. @form[:id]")

  attr(:rest, :global)

  def hidden_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> assign(field: nil)
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    hidden_input(assigns)
  end

  def hidden_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "hidden-input-#{System.unique_integer([:positive])}" end)

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
