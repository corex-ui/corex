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
    <:decrement_trigger><.icon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.icon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ### With scrubber

  ```heex
  <.number_input id="num" scrubber class="number-input">
    <:label>Quantity</:label>
    <:scrubber_trigger><.icon name="hero-arrows-up-down" class="icon rotate-90" /></:scrubber_trigger>
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

  @doc type: :component
  use Phoenix.Component

  alias Corex.NumberInput.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    Input,
    TriggerGroup,
    DecrementTrigger,
    IncrementTrigger,
    Scrubber
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

  attr(:rest, :global)

  slot(:label, required: false)
  slot(:decrement_trigger, required: false)
  slot(:increment_trigger, required: false)
  slot(:scrubber_trigger, required: false)

  def number_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "number-input-#{System.unique_integer([:positive])}" end)

    ~H"""
    <div
      id={@id}
      phx-hook="NumberInput"
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
      <div phx-update="ignore" {Connect.root(%Root{id: @id})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id})}>
          <input type="text" inputmode="decimal" {Connect.input(%Input{id: @id, disabled: @disabled})} />
          <div {Connect.trigger_group(%TriggerGroup{})}>
            <button :if={!@scrubber} type="button" {Connect.increment_trigger(%IncrementTrigger{id: @id})}>
              {render_slot(@increment_trigger)}
            </button>
            <button :if={!@scrubber} type="button" {Connect.decrement_trigger(%DecrementTrigger{id: @id})}>
            {render_slot(@decrement_trigger)}
          </button>
            <button :if={@scrubber} type="button" {Connect.scrubber(%Scrubber{id: @id})}>
              {render_slot(@scrubber_trigger)}
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
