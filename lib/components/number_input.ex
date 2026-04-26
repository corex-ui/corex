defmodule Corex.NumberInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Number Input](https://zagjs.com/components/react/number-input).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.number_input id="num" class="number-input">
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  <!-- tabs-close -->

  Slots `:decrement_trigger` and `:increment_trigger` are required and render the button content (e.g. icons).

  ## Phoenix Form Integration

  Use `field={f[:key]}` or `field={@form[:key]}` with a form built from an Ecto changeset. Set the form id with `Corex.Form.get_form_id/1`.

  ### Controller

  Build the form from a changeset and pass it to the template:

  ```elixir
  def form_page(conn, _params) do
    form =
      %MyApp.Form.Quantity{}
      |> MyApp.Form.Quantity.changeset(%{})
      |> Phoenix.Component.to_form(as: :quantity, id: "quantity-form")
    render(conn, :form_page, form: form)
  end
  ```

  ```heex
  <.form :let={f} for={@form} id={Corex.Form.get_form_id(@form)} action={@action} method="post">
    <.number_input field={f[:value]} class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.number_input>
    <button type="submit">Submit</button>
  </.form>
  ```

  ### Live View with Ecto changeset

  Use a changeset and standard form events; the field value is submitted with the form.

  ```elixir
  def mount(_params, _session, socket) do
    form =
      %MyApp.Form.Quantity{}
      |> MyApp.Form.Quantity.changeset(%{})
      |> Phoenix.Component.to_form(as: :quantity, id: "quantity-form")
    {:ok, assign(socket, :form, form)}
  end

  def handle_event("validate", %{"quantity" => params}, socket) do
    changeset =
      %MyApp.Form.Quantity{}
      |> MyApp.Form.Quantity.changeset(params)
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :form, Phoenix.Component.to_form(changeset, as: :quantity, id: "quantity-form"))}
  end
  ```

  ```heex
  <.form for={@form} id={Corex.Form.get_form_id(@form)} phx-change="validate" phx-submit="save">
    <.number_input field={@form[:value]} class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.number_input>
    <button type="submit">Submit</button>
  </.form>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="number-input"][data-part="root"] {}
  [data-scope="number-input"][data-part="control"] {}
  [data-scope="number-input"][data-part="input"] {}
  [data-scope="number-input"][data-part="trigger-group"] {}
  [data-scope="number-input"][data-part="decrement-trigger"] {}
  [data-scope="number-input"][data-part="increment-trigger"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `number-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/number-input.css";
  ```

  You can then use modifiers

  ```heex
  <.number_input class="number-input number-input--accent number-input--lg">
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for NumberInput component strings.

    Without gettext: `translation={%NumberInput.Translation{ decrease: "Decrease value" }}`

    With gettext: `translation={%NumberInput.Translation{ decrease: gettext("Decrease value") }}`
    """
    defstruct [:decrease, :increase]
  end

  @doc type: :component
  use Phoenix.Component

  import Corex.Gettext, only: [gettext: 1]

  alias Phoenix.HTML.Form

  alias Corex.NumberInput.Anatomy.{
    Control,
    DecrementTrigger,
    IncrementTrigger,
    Input,
    Label,
    Props,
    Root,
    TriggerGroup
  }

  alias Corex.NumberInput.Connect

  attr(:id, :string, required: false)
  attr(:value, :string, default: nil)
  attr(:default_value, :string, default: nil)
  attr(:min, :float, default: nil)
  attr(:max, :float, default: nil)
  attr(:step, :float, default: 1.0)
  attr(:disabled, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:allow_mouse_wheel, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])

  attr(:translation, Corex.NumberInput.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:errors, :list, default: [], doc: "List of error messages to display")
  attr(:field, Phoenix.HTML.FormField, doc: "A form field struct, e.g. f[:age] or @form[:age]")
  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :decrement_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :increment_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def number_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
    |> assign(:value, value_to_string(Form.normalize_value("number", field.value)))
    |> assign(:invalid, errors != [])
    |> number_input()
  end

  def number_input(assigns) do
    validate_triggers!(assigns)

    default_translation = %Translation{
      decrease: gettext("Decrease value"),
      increase: gettext("Increase value")
    }

    assigns =
      assigns
      |> assign_new(:id, fn -> "number-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:value, value_to_string(Form.normalize_value("number", assigns[:value])))
      |> assign(
        :default_value,
        value_to_string(Form.normalize_value("number", assigns[:default_value]))
      )

    ~H"""
    <div
      id={@id}
      phx-hook="NumberInput"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        default_value: @default_value,
        min: @min,
        max: @max,
        step: @step,
        disabled: @disabled,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        allow_mouse_wheel: @allow_mouse_wheel,
        name: @name,
        form: @form,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        dir: @dir,
        orientation: @orientation
      })}
      {@rest}
    >
      <input
        :if={@name}
        type="hidden"
        name={@name}
        form={@form}
        value={@value || ""}
        data-scope="number-input"
        data-part="value-input"
      />
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
          <input type="text" inputmode="decimal" phx-mounted={Connect.ignore_input(%Input{id: @id, disabled: @disabled, dir: @dir, orientation: @orientation})} {Connect.input(%Input{id: @id, disabled: @disabled, dir: @dir, orientation: @orientation})} />
          <div {Connect.trigger_group(%TriggerGroup{dir: @dir, orientation: @orientation})}>
            <button type="button" phx-mounted={Connect.ignore_increment_trigger(%IncrementTrigger{id: @id, aria_label: @translation.increase, dir: @dir, orientation: @orientation})} {Connect.increment_trigger(%IncrementTrigger{id: @id, aria_label: @translation.increase, dir: @dir, orientation: @orientation})}>
              {render_slot(@increment_trigger)}
            </button>
            <button type="button" phx-mounted={Connect.ignore_decrement_trigger(%DecrementTrigger{id: @id, aria_label: @translation.decrease, dir: @dir, orientation: @orientation})} {Connect.decrement_trigger(%DecrementTrigger{id: @id, aria_label: @translation.decrease, dir: @dir, orientation: @orientation})}>
              {render_slot(@decrement_trigger)}
            </button>
          </div>
        </div>
      </div>
      <div :if={@error != []} :for={msg <- @errors} data-scope="number-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp validate_triggers!(assigns) do
    inc = Map.get(assigns, :increment_trigger, [])
    dec = Map.get(assigns, :decrement_trigger, [])

    if inc == [] or dec == [] do
      raise ArgumentError,
            "Corex.NumberInput requires non-empty :increment_trigger and :decrement_trigger slots"
    end
  end

  defp value_to_string(nil), do: nil
  defp value_to_string(value), do: to_string(value)

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      decrease: partial.decrease || default.decrease,
      increase: partial.increase || default.increase
    }
  end
end
