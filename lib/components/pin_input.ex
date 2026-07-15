defmodule Corex.PinInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Pin Input](https://zagjs.com/components/react/pin-input).

  ## Anatomy

  ### Basic

  ```heex
  <.pin_input count={4} class="pin-input">
    <:label>Code</:label>
  </.pin_input>
  ```

  ## API

  Set a stable `id` when using imperative API helpers or `on_*` events. With `field={@form[:code]}`, the field id is used automatically.

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
  <.pin_input count={4} class="pin-input" on_value_change="pin_changed">
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

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:code])}` when you want alert borders after validation.

  ```heex
  <.form for={@form} phx-change="validate">
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
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.pin_input>`). Combine axes, for example `pin-input ui-accent ui-size-lg` or `pin-input ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on each cell input. Variant modifiers control input surface treatment. Default is subtle; add `pin-input ui-solid` for filled cells. Complete and invalid states keep their dedicated styling.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for pin input ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `pin-input` |
  | Accent | `pin-input ui-accent` |
  | Brand | `pin-input ui-brand` |
  | Alert | `pin-input ui-alert` |
  | Info | `pin-input ui-info` |
  | Success | `pin-input ui-success` |

  ### Variant

  Visual treatment of each cell input surface. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `pin-input` or `pin-input ui-accent` |
  | Solid | `pin-input ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `pin-input ui-size-sm` |
  | MD | `pin-input ui-size-md` |
  | LG | `pin-input ui-size-lg` |
  | XL | `pin-input ui-size-xl` |

  ### Radius

  | Modifier | Classes |
  | -------- | ------- |
  | None | `pin-input ui-rounded-none` |
  | SM | `pin-input ui-rounded-sm` |
  | MD | `pin-input ui-rounded-md` |
  | LG | `pin-input ui-rounded-lg` |
  | XL | `pin-input ui-rounded-xl` |
  | Full | `pin-input ui-rounded-full` |

  <!-- tabs-close -->

  The `value` assign is the initial cell contents via `data-default-value`.

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.PinInput.Anatomy.{Control, HiddenInput, Input, Label, Props, Root}
  alias Corex.PinInput.Connect
  alias Corex.PinInput.Translation
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS
  import Corex.Helpers, only: [validate_value!: 1, respond_to_fields: 1]

  attr(:id, :string, required: false)

  attr(:value, :list,
    default: [],
    doc: "Initial value (list of single-character strings). Padded to `count` for the hook."
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
  attr(:on_value_complete_client, :string, default: nil)

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
    value = form_field_to_pin_list(field)
    value_str = Enum.join(value)

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value)
    |> assign(:value_str, value_str)
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
      |> assign_new(:id, fn -> "pin-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form_field, fn -> false end)
      |> assign_new(:errors, fn -> [] end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign(:translation, translation)
      |> assign(:value, validate_value!(value || []))

    assigns =
      assigns
      |> assign(:value_str, Enum.join(assigns.value))
      |> Corex.FormField.assign_list_submit()

    ~H"""
    <div
      id={@id}
      phx-hook="PinInput"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
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
        on_value_complete: @on_value_complete,
        on_value_complete_client: @on_value_complete_client,
        submit_name: @submit_name
      })}
    >
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </label>
        <div
          :if={@submit_name}
          data-scope="pin-input"
          data-part="array-inputs"
          phx-update="ignore"
          id={"pin-input:#{@id}:array-inputs"}
        >
          <input
            :for={digit <- padded_pin_digits(@value, @count)}
            type="hidden"
            data-scope="pin-input"
            data-part="array-input"
            name={@submit_name}
            value={digit}
          />
        </div>
        <input phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: if(@submit_name, do: nil, else: @name), value: @value_str})} {Connect.hidden_input(%HiddenInput{id: @id, name: if(@submit_name, do: nil, else: @name), value: @value_str})} />
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

  defp padded_pin_digits(value, count) when is_list(value) do
    digits = Enum.map(value, &to_string/1)
    missing = max(0, count - length(digits))
    (digits ++ List.duplicate("", missing)) |> Enum.take(count)
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

  api_doc(~S"""
  Replace cell values from `phx-click`. Dispatches `corex:pin-input:set-value`; `value` accepts a nonempty string list, a comma string, graphemes string, etc. (normalized like the form helper).

  ```heex
  <.action phx-click={Corex.PinInput.set_value("my-pin", ["1", "2", "", ""])}>Prefill</.action>
  <.pin_input id="my-pin" count={4} class="pin-input" />
  ```

  ```javascript
  document.getElementById("my-pin")?.dispatchEvent(
    new CustomEvent("corex:pin-input:set-value", {
      bubbles: false,
      detail: { value: ["1", "2", "", ""] },
    })
  );
  ```
  """)

  def set_value(pin_input_id, value) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:set-value",
      to: "##{pin_input_id}",
      detail: %{value: Corex.Helpers.normalize_string_list_value!(value, graphemes: true)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Replace cell values from `handle_event` (`pin_input_set_value`).

  ```elixir
  def handle_event("fill_pin", _, socket) do
    {:noreply, Corex.PinInput.set_value(socket, "my-pin", ["0", "0", "0", "0"])}
  end
  ```
  """)

  def set_value(socket, pin_input_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) do
    LiveView.push_event(socket, "pin_input_set_value", %{
      id: pin_input_id,
      value: Corex.Helpers.normalize_string_list_value!(value, graphemes: true)
    })
  end

  api_doc(~S"""
  Clear all cells from `phx-click`. Dispatches `corex:pin-input:clear`.

  ```heex
  <.action phx-click={Corex.PinInput.clear("my-pin")}>Clear</.action>
  <.pin_input id="my-pin" count={4} class="pin-input" />
  ```
  """)

  def clear(pin_input_id) when is_binary(pin_input_id) do
    JS.dispatch("corex:pin-input:clear", to: "##{pin_input_id}", bubbles: false)
  end

  api_doc(~S"""
  Clear all cells from `handle_event` (`pin_input_clear`).

  ```elixir
  def handle_event("clear_pin", _, socket) do
    {:noreply, Corex.PinInput.clear(socket, "my-pin")}
  end
  ```
  """)

  def clear(socket, pin_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(pin_input_id) do
    LiveView.push_event(socket, "pin_input_clear", %{id: pin_input_id})
  end

  api_doc(~S"""
  Read the current value from `phx-click`. Dispatches `corex:pin-input:value`. Optional `respond_to:` `:server`, `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `pin_input_value_response` | `%{"id" => id, "value" => cells, "valueAsString" => str}` |
  | Client | `pin-input-value` on the host | same fields in `detail` |

  ```heex
  <.action phx-click={Corex.PinInput.value("my-pin")}>Read</.action>
  <.pin_input id="my-pin" count={4} class="pin-input" />
  ```

  ```elixir
  def handle_event("pin_input_value_response", %{"id" => _, "valueAsString" => s}, socket) do
    {:noreply, assign(socket, :otp, s)}
  end
  ```
  """)

  def value(pin_input_id, opts) when is_binary(pin_input_id) and is_list(opts) do
    JS.dispatch("corex:pin-input:value",
      to: "##{pin_input_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  api_doc_short("Same as [`value/2`](#value/2) with default `respond_to:`.")
  def value(pin_input_id) when is_binary(pin_input_id), do: value(pin_input_id, [])

  api_doc(~S"""
  Read the current value from `handle_event` (`pin_input_value`). Same replies as [`value/2`](#value/2).

  | Reply | Payload |
  | ----- | ------- |
  | `pin_input_value_response` | `%{"id" => id, "value" => cells, "valueAsString" => str}` |

  ```elixir
  def handle_event("read_pin", _, socket) do
    {:noreply, Corex.PinInput.value(socket, "my-pin", respond_to: :server)}
  end
  ```
  """)

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
