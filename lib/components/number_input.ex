defmodule Corex.NumberInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Number Input](https://zagjs.com/components/react/number-input).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.number_input class="number-input">
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ### Min, max, step

  ```heex
  <.number_input
    class="number-input"
    min={0.0}
    max={100.0}
    step={5.0}
    value="10"
  >
    <:label>Amount</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  `min`, `max`, and `step` are floats. Use `step` for granularity: `step={1}` for whole-number steps (display omits `.0`), `step={0.01}` for two decimal places. The visible value is formatted on the server to match Zag after hydration.

  <!-- tabs-close -->

  Slots `:decrement_trigger` and `:increment_trigger` are required.

  ## API

  Requires a stable `id` on `<.number_input>`. For forms, use `field`; use the API for imperative updates and reading machine state.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set value (server) | `socket` |
  | [`clear_value/1`](#clear_value/1) | Clear value (client) | `%Phoenix.LiveView.JS{}` |
  | [`clear_value/2`](#clear_value/2) | Clear value (server) | `socket` |
  | [`increment/1`](#increment/1) | Increment by step (client) | `%Phoenix.LiveView.JS{}` |
  | [`increment/2`](#increment/2) | Increment by step (server) | `socket` |
  | [`decrement/1`](#decrement/1) | Decrement by step (client) | `%Phoenix.LiveView.JS{}` |
  | [`decrement/2`](#decrement/2) | Decrement by step (server) | `socket` |
  | [`set_to_min/1`](#set_to_min/1) | Set to `min` (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_to_min/2`](#set_to_min/2) | Set to `min` (server) | `socket` |
  | [`set_to_max/1`](#set_to_max/1) | Set to `max` (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_to_max/2`](#set_to_max/2) | Set to `max` (server) | `socket` |
  | [`focus/1`](#focus/1) | Focus input (client) | `%Phoenix.LiveView.JS{}` |
  | [`focus/2`](#focus/2) | Focus input (server) | `socket` |
  | [`state/1`](#state/1) | Read machine state (client) | `%Phoenix.LiveView.JS{}` |
  | [`state/2`](#state/2) | Read machine state (client, opts) | `%Phoenix.LiveView.JS{}` |
  | [`state/3`](#state/3) | Read machine state (server) | `socket` |

  ### Machine state (`state/2`, `state/3`)

  Replies with `number_input_state_response` (server) or `number-input-state` on the host (client). Payload includes Zag machine fields:

  | Field | Type | Meaning |
  | ----- | ---- | ------- |
  | `focused` | boolean | Input is focused |
  | `invalid` | boolean | Input is invalid |
  | `empty` | boolean | Value is empty |
  | `value` | string | Formatted value |
  | `valueAsNumber` | number | Numeric value |

  ## Events

  Pick an event name and pass it to `on_*` on `<.number_input>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="number_input_changed"` | Value changes | `%{"id" => id, "value" => string, "valueAsNumber" => number}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.number_input
    class="number-input"
    on_value_change="number_input_changed"
  >
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ```elixir
  def handle_event("number_input_changed", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :quantity, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="number-input-changed"` | Value changes | `id`, `value`, `valueAsNumber` |

  ## Patterns

  Pass `value` for the initial number on mount. The machine owns updates after that unless you use [`set_value/2`](#set_value/2) or form `field`.

  ## Form

  Use `field={f[:value]}` inside `<.form>`. With a form field, increment and decrement stay local; the hidden input updates for submit.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:value])}` when you want alert borders after validation.

  ```heex
  <.form for={@form} phx-change="validate">
    <.number_input field={@form[:value]} class="number-input">
      <:label>Quantity</:label>
      <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
      <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" class="icon" />
        {msg}
      </:error>
    </.number_input>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use Corex Design: import tokens and `number-input.css`, then set `class="number-input"` on `<.number_input>`.

  ```css
  [data-scope="number-input"][data-part="root"] {}
  [data-scope="number-input"][data-part="control"] {}
  [data-scope="number-input"][data-part="input"] {}
  [data-scope="number-input"][data-part="trigger-group"] {}
  [data-scope="number-input"][data-part="decrement-trigger"] {}
  [data-scope="number-input"][data-part="increment-trigger"] {}
  ```

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components.css";
  ```

  Stack modifiers on the host (`class` on `<.number_input>`). Combine axes, for example `number-input ui-accent ui-size-lg` or `number-input ui-info ui-solid`.

  Axes: **Semantic** (`ui-accent`, `ui-brand`, `ui-alert`, `ui-info`, `ui-success`), **Variant** (`ui-solid`), **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). See the [modifier guide](modifiers.html).

  Semantic modifiers set palette variables on the input and stepper triggers. Variant modifiers control field surface treatment. Default is subtle; add `number-input ui-solid` for a filled control.

  <!-- tabs-open -->

  ### Semantic

  Palette variables for number input ink and fill. Does not change surface treatment by itself.

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `number-input` |
  | Accent | `number-input ui-accent` |
  | Brand | `number-input ui-brand` |
  | Alert | `number-input ui-alert` |
  | Info | `number-input ui-info` |
  | Success | `number-input ui-success` |

  ### Variant

  Visual treatment of the input and stepper trigger surfaces. Combine with a semantic modifier for palette-driven ink and fill.

  | Modifier | Classes |
  | -------- | ------- |
  | Subtle (default) | `number-input` or `number-input ui-accent` |
  | Solid | `number-input ui-accent ui-solid` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `number-input ui-size-sm` |
  | MD | `number-input ui-size-md` |
  | LG | `number-input ui-size-lg` |
  | XL | `number-input ui-size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

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
  alias Corex.NumberInput.Format
  alias Corex.NumberInput.Translation
  alias Corex.Selectors
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  import Corex.Helpers, only: [respond_to_fields: 1]

  attr(:id, :string, required: false)
  attr(:value, :string, default: nil)
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
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
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
    step = Map.get(assigns, :step, 1.0)

    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, Form.normalize_value("number", field.value))
    |> assign_value_formats(step)
    |> number_input()
  end

  def number_input(assigns) do
    validate_triggers!(assigns)

    translation = Translation.resolve(assigns.translation)

    assigns =
      assigns
      |> assign_new(:id, fn -> "number-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign_new(:form_field, fn -> false end)
      |> assign(:translation, translation)
      |> assign(:value, Form.normalize_value("number", assigns[:value]))
      |> assign_value_formats(assigns.step)

    ~H"""
    <div
      id={@id}
      phx-hook="NumberInput"
      data-loading
      phx-mounted={JS.ignore_attributes(["data-loading"])}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
        value: @value,
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
        id={"number-input:#{@id}:value-input"}
        type="text"
        hidden
        aria-hidden="true"
        autocomplete="off"
        tabindex="-1"
        name={@name}
        value={@submit_value || ""}
        data-scope="number-input"
        data-part="value-input"
        phx-mounted={JS.ignore_attributes(["value"], to: Selectors.css_id("number-input:#{@id}:value-input"))}
      />
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})}>
        <label :if={@label != []} phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})} {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}>
          {render_slot(@label)}
        </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
          <input value={@display_value || ""} phx-mounted={Connect.ignore_input(%Input{id: @id, disabled: @disabled, required: @required, dir: @dir, orientation: @orientation})} {Connect.input(%Input{id: @id, disabled: @disabled, required: @required, dir: @dir, orientation: @orientation})} />
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

  defp assign_value_formats(assigns, step) do
    raw = Map.get(assigns, :value)

    display =
      case formatted_string(raw, &Format.format_display(&1, step)) do
        "" -> nil
        s -> s
      end

    submit =
      case formatted_string(raw, &Format.format_submit(&1, step)) do
        "" -> nil
        s -> s
      end

    assigns
    |> assign(:display_value, display)
    |> assign(:submit_value, submit)
    |> assign(:value, submit)
  end

  defp formatted_string(nil, _formatter), do: ""
  defp formatted_string("", _formatter), do: ""

  defp formatted_string(raw, formatter), do: formatter.(raw)

  api_doc(~S"""
  Replace the formatted value from `phx-click`. Dispatches `corex:number-input:set-value` with a numeric `value`.

  ```heex
  <.action phx-click={Corex.NumberInput.set_value("my-num", 42)}>42</.action>
  <.number_input id="my-num" value={40} step={1} class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```

  ```javascript
  document.getElementById("my-num")?.dispatchEvent(
    new CustomEvent("corex:number-input:set-value", {
      bubbles: false,
      detail: { value: 42 },
    })
  );
  ```
  """)

  def set_value(number_input_id, value)
      when is_binary(number_input_id) and (is_number(value) or is_binary(value)) do
    JS.dispatch("corex:number-input:set-value",
      to: "##{number_input_id}",
      detail: %{value: normalize_api_number!(value)},
      bubbles: false
    )
  end

  api_doc(~S"""
  Replace the formatted value from `handle_event` (`number_input_set_value`).

  ```elixir
  def handle_event("set_answer", _, socket) do
    {:noreply, Corex.NumberInput.set_value(socket, "my-num", 7)}
  end
  ```
  """)

  def set_value(socket, number_input_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) and
             (is_number(value) or is_binary(value)) do
    LiveView.push_event(socket, "number_input_set_value", %{
      id: number_input_id,
      value: normalize_api_number!(value)
    })
  end

  api_doc(~S"""
  Clear the value from `phx-click`. Dispatches `corex:number-input:clear-value`.

  ```heex
  <.action phx-click={Corex.NumberInput.clear_value("my-num")}>Clear</.action>
  <.number_input id="my-num" class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def clear_value(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:clear-value",
      to: "##{number_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Clear the value from `handle_event` (`number_input_clear_value`).

  ```elixir
  def handle_event("clear", _, socket) do
    {:noreply, Corex.NumberInput.clear_value(socket, "my-num")}
  end
  ```
  """)

  def clear_value(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_clear_value", %{id: number_input_id})
  end

  api_doc(~S"""
  Increment from `phx-click`. Dispatches `corex:number-input:increment`.

  ```heex
  <.action phx-click={Corex.NumberInput.increment("my-num")}>Increment</.action>
  <.number_input id="my-num" class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def increment(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:increment",
      to: "##{number_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Increment from `handle_event` (`number_input_increment`).

  ```elixir
  def handle_event("inc", _, socket) do
    {:noreply, Corex.NumberInput.increment(socket, "my-num")}
  end
  ```
  """)

  def increment(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_increment", %{id: number_input_id})
  end

  api_doc(~S"""
  Decrement from `phx-click`. Dispatches `corex:number-input:decrement`.

  ```heex
  <.action phx-click={Corex.NumberInput.decrement("my-num")}>Decrement</.action>
  <.number_input id="my-num" class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def decrement(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:decrement",
      to: "##{number_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Decrement from `handle_event` (`number_input_decrement`).

  ```elixir
  def handle_event("dec", _, socket) do
    {:noreply, Corex.NumberInput.decrement(socket, "my-num")}
  end
  ```
  """)

  def decrement(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_decrement", %{id: number_input_id})
  end

  api_doc(~S"""
  Snap to minimum from `phx-click`. Dispatches `corex:number-input:set-to-min`.

  ```heex
  <.action phx-click={Corex.NumberInput.set_to_min("my-num")}>Min</.action>
  <.number_input id="my-num" min={0} class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def set_to_min(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:set-to-min",
      to: "##{number_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Snap to minimum from `handle_event` (`number_input_set_to_min`).

  ```elixir
  def handle_event("min", _, socket) do
    {:noreply, Corex.NumberInput.set_to_min(socket, "my-num")}
  end
  ```
  """)

  def set_to_min(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_set_to_min", %{id: number_input_id})
  end

  api_doc(~S"""
  Snap to maximum from `phx-click`. Dispatches `corex:number-input:set-to-max`.

  ```heex
  <.action phx-click={Corex.NumberInput.set_to_max("my-num")}>Max</.action>
  <.number_input id="my-num" max={100} class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def set_to_max(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:set-to-max",
      to: "##{number_input_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Snap to maximum from `handle_event` (`number_input_set_to_max`).

  ```elixir
  def handle_event("max", _, socket) do
    {:noreply, Corex.NumberInput.set_to_max(socket, "my-num")}
  end
  ```
  """)

  def set_to_max(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_set_to_max", %{id: number_input_id})
  end

  api_doc(~S"""
  Focus the value field from `phx-click`. Dispatches `corex:number-input:focus`.

  ```heex
  <.action phx-click={Corex.NumberInput.focus("my-num")}>Focus</.action>
  <.number_input id="my-num" class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```
  """)

  def focus(number_input_id) when is_binary(number_input_id) do
    JS.dispatch("corex:number-input:focus", to: "##{number_input_id}", bubbles: false)
  end

  api_doc(~S"""
  Focus the value field from `handle_event` (`number_input_focus`).

  ```elixir
  def handle_event("focus", _, socket) do
    {:noreply, Corex.NumberInput.focus(socket, "my-num")}
  end
  ```
  """)

  def focus(socket, number_input_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) do
    LiveView.push_event(socket, "number_input_focus", %{id: number_input_id})
  end

  api_doc(~S"""
  Read machine state from `phx-click`. Dispatches `corex:number-input:state`. Optional `respond_to:` `:server`, `:client`, or `:both`.

  | | Reply | Payload |
  | - | ----- | ------- |
  | Server | `number_input_state_response` | `%{"id" => id, "focused" => bool, "invalid" => bool, "empty" => bool, "value" => str, "valueAsNumber" => num}` |
  | Client | `number-input-state` on the input root | same fields in `detail` |

  ```heex
  <.action phx-click={Corex.NumberInput.state("my-num")}>Snapshot</.action>
  <.number_input id="my-num" class="number-input">
    <:increment_trigger><span>+</span></:increment_trigger>
    <:decrement_trigger><span>-</span></:decrement_trigger>
  </.number_input>
  ```

  ```elixir
  def handle_event("number_input_state_response", %{"id" => _, "valueAsNumber" => n}, socket) do
    {:noreply, assign(socket, :n, n)}
  end
  ```
  """)

  def state(number_input_id, opts) when is_binary(number_input_id) and is_list(opts) do
    JS.dispatch("corex:number-input:state",
      to: "##{number_input_id}",
      detail: respond_to_fields(opts),
      bubbles: false
    )
  end

  api_doc_short("Same as [`state/2`](#state/2) with default `respond_to:`.")
  def state(number_input_id) when is_binary(number_input_id), do: state(number_input_id, [])

  api_doc(~S"""
  Read machine state from `handle_event` (`number_input_state`). Same replies as [`state/2`](#state/2); server-only unless you also use [`state/2`](#state/2) for a DOM reply.

  | Reply | Payload |
  | ----- | ------- |
  | `number_input_state_response` | `%{"id" => id}` plus focused/invalid/value fields |

  ```elixir
  def handle_event("snapshot", _, socket) do
    {:noreply, Corex.NumberInput.state(socket, "my-num", respond_to: :server)}
  end
  ```
  """)

  def state(socket, number_input_id, opts \\ [])
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(number_input_id) and
             is_list(opts) do
    LiveView.push_event(
      socket,
      "number_input_state",
      Map.merge(%{id: number_input_id}, respond_to_fields(opts))
    )
  end

  defp normalize_api_number!(value) when is_integer(value), do: value * 1.0
  defp normalize_api_number!(value) when is_float(value), do: value

  defp normalize_api_number!(value) when is_binary(value) do
    trimmed = String.trim(value)

    case Float.parse(trimmed) do
      {n, _} -> n
      :error -> raise ArgumentError, "expected a number, got: #{inspect(value)}"
    end
  end
end
