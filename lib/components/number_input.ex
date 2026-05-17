defmodule Corex.NumberInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Number Input](https://zagjs.com/components/react/number-input).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.number_input id="number-input-anatomy-minimal" class="number-input">
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ### Min, max, step

  ```heex
  <.number_input
    id="number-input-anatomy-bounds"
    class="number-input"
    min={0.0}
    max={100.0}
    step={5.0}
    default_value="10"
  >
    <:label>Amount</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  <!-- tabs-close -->

  Slots `:decrement_trigger` and `:increment_trigger` are required.

  ## API

  Number input has no imperative setters. Use `controlled` with `value` and `on_value_change`, or `field` inside a Phoenix form.

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
    id="number-input-events-server"
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

  <!-- tabs-open -->

  ### Controlled

  Without `field`, set `controlled`, bind `value`, and handle `on_value_change`.

  ```heex
  <.number_input
    id="number-input-patterns-controlled"
    class="number-input"
    controlled
    value={@quantity}
    on_value_change="quantity_changed"
  >
    <:label>Quantity</:label>
    <:decrement_trigger><.heroicon name="hero-chevron-down" class="icon" /></:decrement_trigger>
    <:increment_trigger><.heroicon name="hero-chevron-up" class="icon" /></:increment_trigger>
  </.number_input>
  ```

  ```elixir
  def handle_event("quantity_changed", %{"value" => value}, socket) do
    {:noreply, assign(socket, :quantity, value)}
  end
  ```

  <!-- tabs-close -->

  ## Form

  Use `field={f[:value]}` inside `<.form>`. With a form field, increment and decrement stay local; the hidden input updates for submit.

  ```heex
  <.form for={@form} id={@form.id} phx-change="validate">
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
  @import "../corex/components/number-input.css";
  ```

  Stack modifiers on the host (`class` on `<.number_input>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `number-input` |
  | Accent | `number-input number-input--accent` |
  | Brand | `number-input number-input--brand` |
  | Alert | `number-input number-input--alert` |
  | Info | `number-input number-input--info` |
  | Success | `number-input number-input--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `number-input number-input--sm` |
  | MD | `number-input number-input--md` |
  | LG | `number-input number-input--lg` |
  | XL | `number-input number-input--xl` |

  <!-- tabs-close -->

  '''

  defmodule Translation do
    @moduledoc """
    Translatable strings for the number input (Zag trigger `aria-label`s).

    Pass `translation={%Corex.NumberInput.Translation{}}` to override any field. Omitted fields use gettext defaults (see table).

    | Field | Default | Used for |
    | ----- | ------- | -------- |
    | `decrease` | Decrease value | Decrement trigger `aria-label` |
    | `increase` | Increase value | Increment trigger `aria-label` |
    """

    alias Corex.Gettext

    defstruct [:decrease, :increase]

    @type t :: %__MODULE__{decrease: String.t(), increase: String.t()}

    @doc false
    def resolve(nil), do: default()

    def resolve(%__MODULE__{} = partial), do: merge(partial, default())

    defp default do
      %__MODULE__{
        decrease: Gettext.gettext("Decrease value"),
        increase: Gettext.gettext("Increase value")
      }
    end

    defp merge(%__MODULE__{} = partial, %__MODULE__{} = default) do
      %__MODULE__{
        decrease: Corex.Translation.take(partial.decrease, default.decrease),
        increase: Corex.Translation.take(partial.increase, default.increase)
      }
    end
  end

  @doc type: :component
  use Phoenix.Component

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

  attr(:controlled, :boolean,
    default: false,
    doc:
      "Server-driven value; use with value and on_value_change. Ignored when field is set (forms stay uncontrolled for working steppers)."
  )

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
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil)
    |> assign(:errors, Enum.map(errors, &Corex.Gettext.translate_error(&1)))
    |> assign(:id, field.id)
    |> assign(:name, field.name)
    |> assign(:form, field.form.id)
    |> assign(:value, value_to_string(Form.normalize_value("number", field.value)))
    |> assign(:controlled, false)
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
      |> assign(:translation, translation)
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
        controlled: @controlled,
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
        id={"number-input:#{@id}:value-input"}
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
          <input value={@value || ""} phx-mounted={Connect.ignore_input(%Input{id: @id, disabled: @disabled, required: @required, dir: @dir, orientation: @orientation})} {Connect.input(%Input{id: @id, disabled: @disabled, required: @required, dir: @dir, orientation: @orientation})} />
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
end
