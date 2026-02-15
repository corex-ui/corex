defmodule Corex.NumberInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Number Input](https://zagjs.com/components/react/number-input).

  ## Examples

  ### Basic

  ```heex
  <.number_input id="num" class="number-input">
    <:label>Quantity</:label>
  </.number_input>
  ```

  ## Styling

  Use data attributes: `[data-scope="number-input"][data-part="root"]`, `control`, `input`, `decrement-trigger`, `increment-trigger`, `value-text`, `scrubber`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.NumberInput.Anatomy.{
    Props,
    Root,
    Label,
    Control,
    ValueText,
    Input,
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
  attr(:rest, :global)

  slot(:label, required: false)

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
          <span {Connect.value_text(%ValueText{id: @id})} />
          <input type="text" inputmode="decimal" {Connect.input(%Input{id: @id, disabled: @disabled})} />
          <button type="button" {Connect.decrement_trigger(%DecrementTrigger{id: @id})}>−</button>
          <button type="button" {Connect.increment_trigger(%IncrementTrigger{id: @id})}>+</button>
          <div {Connect.scrubber(%Scrubber{id: @id})} />
        </div>
      </div>
    </div>
    """
  end
end
