defmodule Corex.NumberInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Number Input](https://zagjs.com/components/react/number-input).

  ## Examples

  <!-- tabs-open -->

  ### Basic

  ```heex
  <.number_input id="num" class="number-input">
    <:label>Quantity</:label>
  </.number_input>
  ```

  ### With triggers

  ```heex
  <.number_input id="num" class="number-input">
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ### With scrubber

  ```heex
  <.number_input id="num" scrubber class="number-input">
    <:label>Quantity</:label>
    <:scrubber_trigger><.heroicon name="hero-arrows-up-down" class="icon rotate-90" /></:scrubber_trigger>
  </.number_input>
  ```

  <!-- tabs-close -->

  Optional slots `:decrement_trigger`, `:increment_trigger`, and `:scrubber_trigger` render the button content (e.g. icons). When omitted, no content is shown.

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="number-input"][data-part="root"] {}
  [data-scope="number-input"][data-part="control"] {}
  [data-scope="number-input"][data-part="input"] {}
  [data-scope="number-input"][data-part="trigger-group"] {}
  [data-scope="number-input"][data-part="decrement-trigger"] {}
  [data-scope="number-input"][data-part="increment-trigger"] {}
  [data-scope="number-input"][data-part="scrubber"] {}
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
  <.number_input class="number-input number-input--accent number-input--lg" />
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/number-input#modifiers)
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for NumberInput component strings.

    Without gettext: `translation={%NumberInput.Translation{ decrease: "Decrease value" }}`

    With gettext: `translation={%NumberInput.Translation{ decrease: gettext("Decrease value") }}`
    """
    defstruct [:decrease, :increase, :scrub]
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
    Scrubber,
    TriggerGroup
  }

  alias Corex.NumberInput.Connect

  attr(:id, :string, required: false)
  attr(:value, :string, default: nil)
  attr(:default_value, :string, default: nil)
  attr(:controlled, :boolean, default: false)
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

  attr(:scrubber, :boolean,
    default: false,
    doc: "When true, show scrubber instead of increment/decrement buttons"
  )

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

  slot :decrement_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :increment_trigger, required: false do
    attr(:class, :string, required: false)
  end

  slot :scrubber_trigger, required: false do
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
    |> assign(:invalid, length(errors) > 0)
    |> number_input()
  end

  def number_input(assigns) do
    default_translation = %Translation{
      decrease: gettext("Decrease value"),
      increase: gettext("Increase value"),
      scrub: gettext("Scrub to adjust value")
    }

    assigns =
      assigns
      |> assign_new(:id, fn -> "number-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:value, value_to_string(Form.normalize_value("number", assigns[:value])))
      |> assign(:default_value, value_to_string(Form.normalize_value("number", assigns[:default_value])))

    ~H"""
    <div
      id={@id}
      phx-hook="NumberInput"
      data-value={if @controlled, do: @value, else: nil}
      data-default-value={unless @controlled, do: (@default_value || @value), else: nil}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        default_value: @default_value,
        controlled: @controlled,
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
        on_value_change_client: @on_value_change_client
      })}
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
      <div phx-update="ignore" {Connect.root(%Root{id: @id})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id})}>
          <input type="text" inputmode="decimal" {Connect.input(%Input{id: @id, disabled: @disabled})} />
          <div {Connect.trigger_group(%TriggerGroup{})}>
            <button :if={!@scrubber} type="button" {Connect.increment_trigger(%IncrementTrigger{id: @id, aria_label: @translation.increase})}>
              {render_slot(@increment_trigger)}
            </button>
            <button :if={!@scrubber} type="button" {Connect.decrement_trigger(%DecrementTrigger{id: @id, aria_label: @translation.decrease})}>
            {render_slot(@decrement_trigger)}
          </button>
            <button :if={@scrubber} type="button" {Connect.scrubber(%Scrubber{id: @id, aria_label: @translation.scrub})}>
              {render_slot(@scrubber_trigger)}
            </button>
          </div>
        </div>
      </div>
      <div :if={@error} :for={msg <- @errors} data-scope="number-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp value_to_string(nil), do: nil
  defp value_to_string(value), do: to_string(value)

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      decrease: partial.decrease || default.decrease,
      increase: partial.increase || default.increase,
      scrub: partial.scrub || default.scrub
    }
  end
end
