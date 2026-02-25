defmodule Corex.UrlInput do
  @moduledoc ~S'''
  URL input component based on [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents).

  ## Examples

  ### Basic

  ```heex
  <.url_input id="website" name="user[website]" class="url-input">
    <:label>Website</:label>
  </.url_input>
  ```

  ### With icon

  ```heex
  <.url_input id="website" name="user[website]" class="url-input">
    <:label>Website</:label>
    <:icon><.icon name="hero-link" class="icon" /></:icon>
  </.url_input>
  ```

  ### With form field

  ```heex
  <.url_input field={@form[:website]} class="url-input">
    <:label>Website</:label>
    <:error :let={msg}>
      <.icon name="hero-exclamation-circle" class="icon" />
      {msg}
    </:error>
  </.url_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="url-input"][data-part="root"] {}
  [data-scope="url-input"][data-part="label"] {}
  [data-scope="url-input"][data-part="control"] {}
  [data-scope="url-input"][data-part="icon"] {}
  [data-scope="url-input"][data-part="input"] {}
  [data-scope="url-input"][data-part="error"] {}
  ```

  Use `data-no-icon` on the root when the icon slot is not provided for proper border radius styling.

  If you wish to use the default Corex styling, you can use the class `url-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/url-input.css";
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
    doc: "A form field struct from the form, e.g. @form[:website]"
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

  def url_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    url_input(assigns)
  end

  def url_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "url-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={@class} data-no-icon={if @icon == [], do: "", else: nil}>
      <div data-scope="url-input" data-part="root">
        <label :if={@label != []} data-scope="url-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(@label)}
        </label>
        <div data-scope="url-input" data-part="control">
          <span :if={@icon != []} data-scope="url-input" data-part="icon" aria-hidden="true">
            {render_slot(@icon)}
          </span>
          <input
            type="url"
            id={"#{@id}-input"}
            name={@name}
            value={Phoenix.HTML.Form.normalize_value("url", @value)}
            data-scope="url-input"
            data-part="input"
            {@rest}
          />
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="url-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end
end
