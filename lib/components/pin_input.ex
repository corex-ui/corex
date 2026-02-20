defmodule Corex.PinInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Pin Input](https://zagjs.com/components/react/pin-input).

  ## Examples

  ### Basic

  ```heex
  <.pin_input id="pin" count={4} class="pin-input">
    <:label>Code</:label>
  </.pin_input>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="pin-input"][data-part="root"] {}
  [data-scope="pin-input"][data-part="label"] {}
  [data-scope="pin-input"][data-part="control"] {}
  [data-scope="pin-input"][data-part="input"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `pin-input` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/pin-input.css";
  ```

  You can then use modifiers

  ```heex
  <.pin_input class="pin-input pin-input--accent pin-input--lg" count={4}>
    <:label>Code</:label>
  </.pin_input>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/pin-input#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.PinInput.Anatomy.{Props, Root, Label, HiddenInput, Control, Input}
  alias Corex.PinInput.Connect
  import Corex.Helpers, only: [validate_value!: 1]

  attr(:id, :string, required: false)
  attr(:value, :list, default: [], doc: "Controlled value (list of single chars)")
  attr(:default_value, :list, default: [], doc: "Uncontrolled initial value")
  attr(:controlled, :boolean, default: false)
  attr(:count, :integer, default: 4, doc: "Number of input boxes")
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:mask, :boolean, default: false)
  attr(:otp, :boolean, default: false)
  attr(:blur_on_complete, :boolean, default: false)
  attr(:select_on_focus, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:type, :string, default: "numeric", values: ["alphanumeric", "numeric", "alphabetic"])
  attr(:placeholder, :string, default: "○")
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:on_value_complete, :string, default: nil)
  attr(:rest, :global)

  slot(:label, required: false)

  def pin_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "pin-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign(:value, validate_value!(assigns[:value] || []))
      |> assign(:default_value, validate_value!(assigns[:default_value] || []))

    value_str = Enum.join(assigns.value, "")
    default_value_str = Enum.join(assigns.default_value, "")

    ~H"""
    <div
      id={@id}
      phx-hook="PinInput"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        controlled: @controlled,
        count: @count,
        disabled: @disabled,
        invalid: @invalid,
        required: @required,
        read_only: @read_only,
        mask: @mask,
        otp: @otp,
        blur_on_complete: @blur_on_complete,
        select_on_focus: @select_on_focus,
        name: @name,
        form: @form,
        dir: @dir,
        type: @type,
        placeholder: @placeholder,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_value_complete: @on_value_complete
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <input {Connect.hidden_input(%HiddenInput{id: @id, name: @name, value: if(@controlled, do: value_str, else: default_value_str)})} />
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <input
            :for={i <- 0..(@count - 1)}
            type="text"
            inputmode={@type}
            maxlength="1"
            autocomplete={if(@otp, do: "one-time-code", else: "off")}
            {Connect.input(%Input{id: @id, index: i})}
          />
        </div>
      </div>
    </div>
    """
  end
end
