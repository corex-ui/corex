defmodule Corex.NativeInput do
  @moduledoc ~S'''
  Unified native input component based on  [Phoenix Core Components](https://hexdocs.pm/phoenix/components.html#corecomponents)
  Used for text, textarea, date, datetime-local, time, month, week, email, url, tel, search, color, number, password, checkbox, radio, and select.
  Optional icon slot and shared styling via data-scope="native-input".
  Uses same data-part structure as Corex components (root, label, control, input, error) for consistency.

  The icon slot is ignored for textarea, date/time types, color, number, checkbox, radio, and select.

  For text, email, url, tel, search, and password the icon slot is shown when provided.

  ## Examples

  ### Basic

  ```heex
  <.native_input type="text" id="name" name="user[name]" class="native-input">
    <:label>Name</:label>
  </.native_input>
  ```

  ### With icon

  ```heex
  <.native_input type="email" id="email" name="user[email]" class="native-input">
    <:label>Email</:label>
    <:icon><.icon name="hero-envelope" class="icon" /></:icon>
  </.native_input>
  ```

  ### Textarea (icon slot ignored)

  ```heex
  <.native_input type="textarea" id="bio" name="user[bio]" class="native-input">
    <:label>Bio</:label>
  </.native_input>
  ```

  ### Checkbox, select, radio

  ```heex
  <.native_input type="checkbox" name="user[agree]" class="native-input">
    <:label>I agree</:label>
  </.native_input>
  <.native_input type="select" name="user[role]" options={["Admin": "admin", "User": "user"]} prompt="Choose..." class="native-input">
    <:label>Role</:label>
  </.native_input>
  <.native_input type="radio" name="user[size]" options={["Small": "s", "Medium": "m", "Large": "l"]} value="m" class="native-input">
    <:label>Size</:label>
  </.native_input>
  ```

  ### With form field

  ```heex
  <.native_input type="email" field={@form[:email]} class="native-input">
    <:label>Email</:label>
    <:error :let={msg}>{msg}</:error>
  </.native_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="native-input"][data-part="root"] {}
  [data-scope="native-input"][data-part="label"] {}
  [data-scope="native-input"][data-part="control"] {}
  [data-scope="native-input"][data-part="icon"] {}
  [data-scope="native-input"][data-part="input"] {}
  [data-scope="native-input"][data-part="error"] {}
  ```

  The root has `data-no-icon` when no icon is shown (icon slot empty or type is textarea/date/time), so the input uses full-width padding. Use the class `native-input` for default Corex styling.

  If you wish to use the default Corex styling, you can use the class `native-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/native-input.css";
  ```
  '''

  @doc type: :component
  use Phoenix.Component

  @types ~w(text textarea date datetime-local time month week email url tel search color number password checkbox radio select)

  attr(:type, :string, required: true, values: @types)
  attr(:id, :string, required: false)
  attr(:name, :string, required: false)
  attr(:value, :any, default: nil)
  attr(:form, :string, required: false)
  attr(:errors, :list, default: [], doc: "List of error messages to display")
  attr(:class, :any, default: nil)
  attr(:prompt, :string, default: nil, doc: "Prompt for select inputs")

  attr(:options, :list,
    default: nil,
    doc: "Options for select and radio. Same format as options_for_select."
  )

  attr(:multiple, :boolean, default: false, doc: "Multiple flag for select inputs")
  attr(:checked, :boolean, default: nil, doc: "Checked flag for checkbox. Defaults from value.")

  attr(:field, Phoenix.HTML.FormField,
    doc: "A form field struct from the form, e.g. @form[:email]"
  )

  attr(:rest, :global,
    include:
      ~w(autocomplete disabled maxlength minlength pattern placeholder readonly required cols rows list form min max step accept)
  )

  slot(:label, required: false)

  slot(:icon,
    required: false,
    doc:
      "Optional. Ignored for textarea, date, datetime-local, time, month, week, color, number, checkbox, radio, select."
  )

  slot(:error, required: false) do
    attr(:class, :string, required: false)
  end

  def native_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns =
      assigns
      |> assign(field: nil)
      |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
      |> assign_new(:id, fn -> field.id end)
      |> assign_new(:name, fn -> field.name end)
      |> assign_new(:value, fn -> field.value end)
      |> assign_new(:form, fn -> field.form.id end)

    native_input(assigns)
  end

  @types_ignoring_icon ~w(textarea date datetime-local time month week color number checkbox radio select)

  def native_input(%{type: "checkbox"} = assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div id={@id} class={@class} data-scope="native-input" data-part="root">
      <div data-scope="native-input" data-part="control">
        <input
          type="hidden"
          name={@name}
          value="false"
          disabled={@rest[:disabled]}
          form={@rest[:form]}
        />
        <label data-scope="native-input" data-part="label" for={"#{@id}-input"}>
          <input
            type="checkbox"
            id={"#{@id}-input"}
            name={@name}
            value="true"
            checked={@checked}
            data-scope="native-input"
            data-part="input"
            {@rest}
          />
          <span :if={@label != []}>{render_slot(@label)}</span>
        </label>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="native-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  def native_input(%{type: "select"} = assigns) do
    assigns =
      assign_new(assigns, :id, fn -> "native-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div id={@id} class={@class} data-scope="native-input" data-part="root">
      <label :if={@label != []} data-scope="native-input" data-part="label" for={"#{@id}-input"}>
        {render_slot(@label)}
      </label>
      <div data-scope="native-input" data-part="control">
        <select
          id={"#{@id}-input"}
          name={@name}
          multiple={@multiple}
          data-scope="native-input"
          data-part="input"
          {@rest}
        >
          <option :if={@prompt} value="">{@prompt}</option>
          {Phoenix.HTML.Form.options_for_select(@options || [], @value)}
        </select>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="native-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  def native_input(%{type: "radio"} = assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign(:options, assigns[:options] || [])

    ~H"""
    <div id={@id} class={@class} data-scope="native-input" data-part="root">
      <div :if={@label != []} data-scope="native-input" data-part="label">
        {render_slot(@label)}
      </div>
      <div data-scope="native-input" data-part="control" data-has-items>
        <div :for={{opt_label, opt_value} <- @options} data-scope="native-input" data-part="item">
          <input
            type="radio"
            id={"#{@id}-input-#{opt_value}"}
            name={@name}
            value={opt_value}
            checked={to_string(@value || "") == to_string(opt_value)}
            data-scope="native-input"
            data-part="input"
            {@rest}
          />
          <label for={"#{@id}-input-#{opt_value}"}>{opt_label}</label>
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="native-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  def native_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "native-input-#{System.unique_integer([:positive])}" end)
      |> assign(:show_icon, show_icon?(assigns))

    ~H"""
    <div id={@id} class={@class} data-no-icon={if @show_icon, do: nil, else: ""}>
      <div data-scope="native-input" data-part="root">
        <label :if={@label != []} data-scope="native-input" data-part="label" for={"#{@id}-input"}>
          {render_slot(@label)}
        </label>
        <div data-scope="native-input" data-part="control">
          <span :if={@show_icon} data-scope="native-input" data-part="icon" aria-hidden="true">
            {render_slot(@icon)}
          </span>
          <%= if @type == "textarea" do %>
            <textarea
              id={"#{@id}-input"}
              name={@name}
              data-scope="native-input"
              data-part="input"
              {@rest}
            >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
          <% else %>
            <input
              type={@type}
              id={"#{@id}-input"}
              name={@name}
              value={Phoenix.HTML.Form.normalize_value(@type, @value)}
              data-scope="native-input"
              data-part="input"
              {@rest}
            />
          <% end %>
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="native-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp show_icon?(%{type: type, icon: icon}) do
    icon != [] and type not in @types_ignoring_icon
  end
end
