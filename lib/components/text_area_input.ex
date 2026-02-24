defmodule Corex.TextAreaInput do
  @moduledoc ~S'''
  Textarea component with Corex design and form field support.

  ## Examples

  ### Basic

  ```heex
  <.text_area_input id="bio" name="user[bio]" class="text-area-input">
    <:label>Bio</:label>
  </.text_area_input>
  ```

  ### With form field

  ```heex
  <.text_area_input field={@form[:bio]} class="text-area-input">
    <:label>Bio</:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.text_area_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="text-area-input"][data-part="root"] {}
  [data-scope="text-area-input"][data-part="label"] {}
  [data-scope="text-area-input"][data-part="input"] {}
  [data-scope="text-area-input"][data-part="error"] {}
  ```

  Use the class `text-area-input` on the component for default Corex styling.
  '''

  @doc type: :component
  use Phoenix.Component

  attr(:id, :string, required: false)
  attr(:name, :string, required: false)
  attr(:value, :any, default: nil)
  attr(:form, :string, required: false)
  attr(:errors, :list, default: [], doc: "List of error messages to display")
  attr(:class, :any, default: nil)

  attr(:field, Phoenix.HTML.FormField, doc: "A form field struct from the form, e.g. @form[:bio]")

  attr(:rest, :global,
    include: ~w(cols disabled form maxlength minlength placeholder readonly required rows)
  )

  slot(:label, required: false)

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def text_area_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    text_area_input(assigns)
  end

  def text_area_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "text-area-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={@class}>
      <div data-scope="text-area-input" data-part="root">
        <label :if={@label != []} data-scope="text-area-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(@label)}
        </label>
        <textarea
          id={"#{@id}-input"}
          name={@name}
          data-scope="text-area-input"
          data-part="input"
          {@rest}
        >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="text-area-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end
end
