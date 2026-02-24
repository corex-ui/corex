defmodule Corex.EmailInput do
  @moduledoc ~S'''
  Email input component with Corex design and form field support.

  ## Examples

  ### Basic

  ```heex
  <.email_input id="email" name="user[email]" class="email-input">
    <:label>Email</:label>
  </.email_input>
  ```

  ### With icon

  ```heex
  <.email_input id="email" name="user[email]" class="email-input">
    <:label>Email</:label>
    <:icon><.icon name="hero-envelope" class="icon" /></:icon>
  </.email_input>
  ```

  ### With form field

  ```heex
  <.email_input field={@form[:email]} class="email-input">
    <:label>Email</:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.email_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="email-input"][data-part="root"] {}
  [data-scope="email-input"][data-part="label"] {}
  [data-scope="email-input"][data-part="control"] {}
  [data-scope="email-input"][data-part="icon"] {}
  [data-scope="email-input"][data-part="input"] {}
  [data-scope="email-input"][data-part="error"] {}
  ```

  Use `data-no-icon` on the root when the icon slot is not provided for proper border radius styling.

  Use the class `email-input` on the component for default Corex styling.
  '''

  @doc type: :component
  use Phoenix.Component

  attr(:id, :string, required: false)
  attr(:name, :string, required: false)
  attr(:value, :any, default: nil)
  attr(:form, :string, required: false)
  attr(:errors, :list, default: [], doc: "List of error messages to display")
  attr(:class, :any, default: nil)

  attr(:field, Phoenix.HTML.FormField,
    doc: "A form field struct from the form, e.g. @form[:email]"
  )

  attr(:rest, :global,
    include: ~w(autocomplete disabled maxlength minlength pattern placeholder readonly required
         cols list form)
  )

  slot(:label, required: false)
  slot(:icon, required: false)

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def email_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    email_input(assigns)
  end

  def email_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "email-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={@class} data-no-icon={if @icon == [], do: "", else: nil}>
      <div data-scope="email-input" data-part="root">
        <label :if={@label != []} data-scope="email-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(@label)}
        </label>
        <div data-scope="email-input" data-part="control">
          <span :if={@icon != []} data-scope="email-input" data-part="icon" aria-hidden="true">
            {render_slot(@icon)}
          </span>
          <input
            type="email"
            id={"#{@id}-input"}
            name={@name}
            value={Phoenix.HTML.Form.normalize_value("email", @value)}
            data-scope="email-input"
            data-part="input"
            {@rest}
          />
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="email-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end
end
