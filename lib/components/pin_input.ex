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

  The `value` assign is the initial cell contents; it is serialized to `data-default-value` for Zag’s uncontrolled `defaultValue`.

  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for PinInput component strings.

    Without gettext: `translation={%PinInput.Translation{ digit: "Box %{digit}" }}`

    With gettext: `translation={%PinInput.Translation{ digit: "Digit %{digit}" }}` (add to catalog; component calls gettext at render)
    """
    defstruct [:digit]
  end

  @doc type: :component
  use Phoenix.Component

  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label, Props, Root}
  alias Corex.PinInput.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS
  import Corex.Gettext, only: [gettext: 2]
  import Corex.Helpers, only: [validate_value!: 1, respond_to_fields: 1]

  attr(:id, :string, required: false)

  attr(:value, :list,
    default: [],
    doc:
      "Initial value (list of single-character strings). Sent as `data-default-value` for Zag `defaultValue`."
  )

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
  attr(:dir, :string, default: "ltr", values: ["ltr", "rtl"])
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])
  attr(:type, :string, default: "numeric", values: ["alphanumeric", "numeric", "alphabetic"])
  attr(:placeholder, :string, default: "○")
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:on_value_complete, :string, default: nil)

  attr(:translation, Corex.PinInput.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  def pin_input(assigns) do
    default_translation = %Translation{digit: "Digit %{digit}"}

    value =
      case assigns[:value] do
        v when is_binary(v) -> String.graphemes(v)
        v -> v
      end

    assigns =
      assigns
      |> assign_new(:id, fn -> "pin-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:value, validate_value!(value || []))

    assigns = assign(assigns, :value_str, Enum.join(assigns.value, ""))

    ~H"""
    <div
      id={@id}
      phx-hook="PinInput"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
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
        orientation: @orientation,
        type: @type,
        placeholder: @placeholder,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client,
        on_value_complete: @on_value_complete
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </label>
        <input phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name, value: @value_str})} {Connect.hidden_input(%HiddenInput{id: @id, name: @name, value: @value_str})} />
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
          <input
            :for={i <- 0..(@count - 1)}
            type="text"
            inputmode={@type}
            maxlength="1"
            autocomplete={if(@otp, do: "one-time-code", else: "off")}
            phx-mounted={Connect.ignore_input(%Input{id: @id, index: i, aria_label: gettext(@translation.digit, digit: i + 1), dir: @dir, orientation: @orientation})}
            {Connect.input(%Input{id: @id, index: i, aria_label: gettext(@translation.digit, digit: i + 1), dir: @dir, orientation: @orientation})}
          />
        </div>
      </div>
    </div>
    """
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      digit: partial.digit || default.digit
    }
  end

  @doc type: :api
  @doc """
  Sets the pin input value from client-side. Returns a `Phoenix.LiveView.JS` command.

  Pass a list of single-character strings, or a binary: comma-separated cells (e.g. `"1,2,,4"`) or a continuous string whose graphemes fill the fields (e.g. `"1234"`).

  #### From Client JS

      ```javascript
      const el = document.getElementById("my-pin");
      el?.dispatchEvent(
        new CustomEvent("corex:pin-input:set-value", {
          bubbles: false,
          detail: { value: ["1", "2", "3", "4"] },
        })
      );
      ```
  """
  def set_value(pin_input_id, value) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:set-value",
      to: "##{pin_input_id}",
      detail: %{value: normalize_pin_set_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Sets the pin value from the server. Pushes a LiveView event handled by the hook.

      def handle_event("fill_pin", _params, socket) do
        {:noreply, Corex.PinInput.set_value(socket, "my-pin", ["1", "2", "3", "4"])}
      end
  """
  def set_value(socket, pin_input_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) do
    LiveView.push_event(socket, "pin_input_set_value", %{
      id: pin_input_id,
      value: normalize_pin_set_value!(value)
    })
  end

  defp normalize_pin_set_value!(value) when is_list(value), do: validate_value!(value)

  defp normalize_pin_set_value!(value) when is_binary(value) do
    trimmed = String.trim(value)

    if String.contains?(trimmed, ",") do
      trimmed |> String.split(",", trim: true) |> validate_value!()
    else
      trimmed |> String.graphemes() |> validate_value!()
    end
  end

  @doc type: :api
  @doc """
  Clears the pin input from client-side.

      ```javascript
      document.getElementById("my-pin")?.dispatchEvent(
        new CustomEvent("corex:pin-input:clear", { bubbles: false })
      );
      ```
  """
  def clear(pin_input_id) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:clear", to: "##{pin_input_id}", bubbles: false)
  end

  @doc type: :api
  @doc """
  Clears the pin from the server via a LiveView push.

      def handle_event("clear_pin", _params, socket) do
        {:noreply, Corex.PinInput.clear(socket, "my-pin")}
      end
  """
  def clear(socket, pin_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) do
    LiveView.push_event(socket, "pin_input_clear", %{id: pin_input_id})
  end

  @doc type: :api
  @doc """
  Requests the current value from the browser. Returns `Phoenix.LiveView.JS`.

  Options: `:respond_to` — `:server` (default, `pin_input_value_response` only), `:both`, or `:client` (DOM `pin-input-value` only).

      <.action phx-click={Corex.PinInput.value("my-pin")} class="button button--sm">Value</.action>

      ```javascript
      const el = document.getElementById("my-pin");
      el?.addEventListener("pin-input-value", (e) => console.log(e.detail));
      ```
  """
  def value(pin_input_id) when is_binary(pin_input_id), do: value(pin_input_id, [])

  def value(pin_input_id, opts) when is_binary(pin_input_id) and is_list(opts) do
    JS.dispatch("corex:pin-input:value",
      to: "##{pin_input_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
  @doc """
  Requests the current value from the client. Pushes `pin_input_value` for the hook.

      def handle_event("pin_input_value_response", %{"id" => id, "value" => value, "valueAsString" => s}, socket) do
        {:noreply, assign(socket, :pin, {id, value, s})}
      end
  """
  def value(socket, pin_input_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "pin_input_value",
      Map.merge(%{id: pin_input_id}, respond_to_fields(opts))
    )
  end
end
