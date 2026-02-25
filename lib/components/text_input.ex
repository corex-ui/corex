defmodule Corex.TextInput do
  @moduledoc ~S'''
  Text input component based on [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents).

  ## Examples

  ### Basic

  ```heex
  <.text_input id="name" name="user[name]" class="text-input">
    <:label>Name</:label>
  </.text_input>
  ```

  ### With form field

  ```heex
  <.text_input field={@form[:name]} class="text-input">
    <:label>Name</:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.text_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="text-input"][data-part="root"] {}
  [data-scope="text-input"][data-part="label"] {}
  [data-scope="text-input"][data-part="input"] {}
  [data-scope="text-input"][data-part="error"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `text-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/text-input.css";
  ```
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
    doc: "A form field struct from the form, e.g. @form[:name]"
  )

  attr(:rest, :global,
    include: ~w(autocomplete disabled maxlength minlength pattern placeholder readonly required
         cols list form)
  )

  slot(:label, required: false)

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def text_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    text_input(assigns)
  end

  def text_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "text-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={@class}>
      <div data-scope="text-input" data-part="root">
        <label :if={@label != []} data-scope="text-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(@label)}
        </label>
        <input
          type="text"
          id={"#{@id}-input"}
          name={@name}
          value={Phoenix.HTML.Form.normalize_value("text", @value)}
          data-scope="text-input"
          data-part="input"
          {@rest}
        />
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="text-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end
end
