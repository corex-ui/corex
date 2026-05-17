defmodule Corex.PinInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Pin Input](https://zagjs.com/components/react/pin-input).

  ## Anatomy

  ### Basic

  ```heex
  <.pin_input id="pin-input-anatomy" count={4} class="pin-input">
    <:label>Code</:label>
  </.pin_input>
  ```

  ## API

  Requires a stable `id` on `<.pin_input>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set cell values (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set cell values (server) | `socket` |
  | [`clear/1`](#clear/1) | Clear all cells (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear/2`](#clear/2) | Clear all cells (server) | `socket` |
  | [`value/1`](#value/1) | Read values (client) | `%Phoenix.LiveView.JS{}` |
  | [`value/2`](#value/2) | Read values (client, opts) | `%Phoenix.LiveView.JS{}` |
  | [`value/3`](#value/3) | Read values (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.pin_input>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="pin_changed"` | Any cell changes | `%{"id" => id, "value" => list}` |
  | `on_value_complete="pin_complete"` | All cells filled | `%{"id" => id, "value" => list}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.pin_input id="pin-events" count={4} class="pin-input" on_value_change="pin_changed">
    <:label>Code</:label>
  </.pin_input>
  ```

  ```elixir
  def handle_event("pin_changed", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :pin, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="pin-changed"` | Any cell changes | `id`, `value` |
  | `on_value_complete_client="pin-complete"` | All cells filled | `id`, `value` |

  ## Form

  Use `field={f[:code]}` inside `<.form>` so the hidden input name and validation align with Phoenix forms.

  ```heex
  <.form for={@form} id={@form.id} phx-change="validate">
    <.pin_input field={@form[:code]} count={4} class="pin-input">
      <:label>Verification code</:label>
    </.pin_input>
  </.form>
  ```

  ## Style

  Use data attributes to target elements:

  ```css
  [data-scope="pin-input"][data-part="root"] {}
  [data-scope="pin-input"][data-part="label"] {}
  [data-scope="pin-input"][data-part="control"] {}
  [data-scope="pin-input"][data-part="input"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/pin-input.css";
  ```

  Stack modifiers on the host (`class` on `<.pin_input>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pin-input` |
  | Accent | `pin-input pin-input--accent` |
  | Brand | `pin-input pin-input--brand` |
  | Alert | `pin-input pin-input--alert` |
  | Info | `pin-input pin-input--info` |
  | Success | `pin-input pin-input--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `pin-input pin-input--sm` |
  | MD | `pin-input pin-input--md` |
  | LG | `pin-input pin-input--lg` |
  | XL | `pin-input pin-input--xl` |

  <!-- tabs-close -->

  The `value` assign is the initial cell contents; it is serialized to `data-default-value` for Zag’s uncontrolled `defaultValue`.

  '''

  defmodule Translation do
    @moduledoc """
    Translatable strings for the pin input.

    Pass `translation={%Corex.PinInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

    | Field | Default | Used for |
    | ----- | ------- | -------- |
    | `digit` | Digit %{digit} | Per-cell `aria-label` (`%{digit}` is the 1-based index at render) |
    """

    alias Corex.Gettext

    defstruct [:digit]

    @type t :: %__MODULE__{digit: String.t()}

    @doc false
    def resolve(nil), do: default()

    def resolve(%__MODULE__{} = partial), do: merge(partial, default())

    defp default do
      %__MODULE__{digit: Gettext.gettext("Digit %{digit}", digit: "%{digit}")}
    end


    defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
      %__MODULE__{digit: Corex.Translation.take(partial.digit, default.digit)}
    end
  end

  @doc type: :component
  use Phoenix.Component

  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label, Props, Root}
  alias Corex.PinInput.Connect
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS
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
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
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

  attr(:errors, :list, default: [], doc: "Error messages to display (non-field API)")
  attr(:field, Phoenix.HTML.FormField, doc: "A form field, e.g. f[:code] or @form[:code]")

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def pin_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    value = form_field_to_pin_list(field)
    value_str = Enum.join(value)

    assigns
    |> assign(:field, nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error/1))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
    |> assign(:value, value)
    |> assign(:value_str, value_str)
    |> assign(:invalid, errors != [])
    |> pin_input()
  end

  def pin_input(assigns) do
    translation = Translation.resolve(assigns.translation)

    value =
      case assigns[:value] do
        v when is_binary(v) -> String.graphemes(v)
        v -> v
      end

    assigns =
      assigns
      |> assign_new(:errors, fn -> [] end)
      |> assign_new(:id, fn -> "pin-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign(:translation, translation)
      |> assign(:value, validate_value!(value || []))

    assigns = assign(assigns, :value_str, Enum.join(assigns.value))

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
            phx-mounted={Connect.ignore_input(%Input{id: @id, index: i, aria_label: Corex.Gettext.gettext(@translation.digit, digit: i + 1), dir: @dir, orientation: @orientation})}
            {Connect.input(%Input{id: @id, index: i, aria_label: Corex.Gettext.gettext(@translation.digit, digit: i + 1), dir: @dir, orientation: @orientation})}
          />
        </div>
      </div>
      <div :if={@error != []} :for={msg <- @errors} data-scope="pin-input" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp form_field_to_pin_list(%Phoenix.HTML.FormField{} = field) do
    case field.value do
      nil ->
        []

      v when is_list(v) ->
        validate_value!(v)

      v when is_binary(v) ->
        v |> String.graphemes() |> validate_value!()

      v ->
        v |> to_string() |> String.graphemes() |> validate_value!()
    end
  end

  @doc type: :api
  def set_value(pin_input_id, value) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:set-value",
      to: "##{pin_input_id}",
      detail: %{value: normalize_pin_set_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
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
  def clear(pin_input_id) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:clear", to: "##{pin_input_id}", bubbles: false)
  end

  @doc type: :api
  def clear(socket, pin_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) do
    LiveView.push_event(socket, "pin_input_clear", %{id: pin_input_id})
  end

  @doc type: :api
  def value(pin_input_id) when is_binary(pin_input_id), do: value(pin_input_id, [])

  def value(pin_input_id, opts) when is_binary(pin_input_id) and is_list(opts) do
    JS.dispatch("corex:pin-input:value",
      to: "##{pin_input_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  @doc type: :api
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
