defmodule Corex.Switch do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Switch](https://zagjs.com/components/react/switch).

  ## Anatomy

  <!-- tabs-open -->

  ### Minimal

  ```heex
  <.switch aria_label="Enable notifications" />
  ```

  ### With label

  ```heex
  <.switch>
    <:label>Enable</:label>
  </.switch>
  ```

  <!-- tabs-close -->

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `size`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.switch semantic="accent" size="md" class="switch" aria_label="Enable notifications">
    <:label>Enable</:label>
  </.switch>
  ```

  ### With classes

  ```heex
  <.switch class="switch switch--semantic-accent switch--size-md" aria_label="Enable notifications">
    <:label>Enable</:label>
  </.switch>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.switch>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_checked/2`](#set_checked/2) | Set checked state (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_checked/3`](#set_checked/3) | Set checked state (server) | `socket` |
  | [`toggle_checked/2`](#toggle_checked/2) | Toggle checked (client) | `%Phoenix.LiveView.JS{}` |
  | [`toggle_checked/3`](#toggle_checked/3) | Toggle checked (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.switch>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_checked_change="switch_changed"` | Checked state changes | `%{"id" => id, "checked" => boolean}` |

  <!-- tabs-open -->

  ### on_checked_change

  ```heex
  <.switch on_checked_change="switch_changed">
    <:label>Subscribe</:label>
  </.switch>
  ```

  ```elixir
  def handle_event("switch_changed", %{"id" => id, "checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_checked_change_client="switch-changed"` | Checked state changes | `id`, `checked` |

  <!-- tabs-open -->

  ### on_checked_change_client

  ```heex
  <.switch id="switch-on-checked-change-client" on_checked_change_client="switch-changed">
    <:label>Subscribe</:label>
  </.switch>
  ```

  ```javascript
  const el = document.getElementById("switch-on-checked-change-client");
  el?.addEventListener("switch-changed", (event) => console.log(event.detail));
  ```

  <!-- tabs-close -->

  ## Patterns

  <!-- tabs-open -->

  ### Controlled

  For server-owned checked state, set `controlled`, bind `checked`, and handle `on_checked_change` in LiveView.

  ```heex
  <.switch
    controlled
    checked={@checked}
    on_checked_change="patterns_checked"
  >
    <:label>Enable</:label>
  </.switch>
  ```

  ```elixir
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checked, false)}
  end

  def handle_event("patterns_checked", %{"checked" => checked}, socket) do
    {:noreply, assign(socket, :checked, checked == true or checked == "true")}
  end
  ```

  <!-- tabs-close -->

  ## Form

  Set the form `id` in `to_form/2` and use `<.form for={@form}>`. Use `field={@form[:notifications]}` so the switch name matches the form. For Ecto validation in LiveView, add `phx-change` on the form so params stay in sync.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:notifications])}` when you want alert borders after validation.

  ```heex
  <.form for={@form} phx-change="validate">
    <.switch field={@form[:notifications]}>
      <:label>Enable notifications</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
    </.switch>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="switch"][data-part="root"] {}
  [data-scope="switch"][data-part="control"] {}
  [data-scope="switch"][data-part="thumb"] {}
  [data-scope="switch"][data-part="label"] {}
  [data-scope="switch"][data-part="input"] {}
  [data-scope="switch"][data-part="error"] {}
  ```

  Stack modifiers on the host (`class` on `<.switch>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `switch` |
  | Accent | `switch switch--semantic-accent` |
  | Brand | `switch switch--semantic-brand` |
  | Alert | `switch switch--semantic-alert` |
  | Info | `switch switch--semantic-info` |
  | Success | `switch switch--semantic-success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `switch switch--size-sm` |
  | MD | `switch switch--size-md` |
  | LG | `switch switch--size-lg` |
  | XL | `switch switch--size-xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  import Corex.Api.Doc

  alias Corex.Checkable.Helpers, as: CheckableHelpers
  alias Corex.Switch.Anatomy.{Control, HiddenInput, Label, Props, Root, Thumb}
  alias Corex.Switch.Connect
  alias Phoenix.HTML.Form
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  use Corex.Variants,
    base: "switch",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      size: :size,
      radius: [:none]
    ],
    defaults: [
      width: "full",
      max_width: "4xl",
      height: "auto",
      max_height: "none",
      size: "md"
    ]

  @doc """
  Renders a switch component.
  """

  attr(:id, :string,
    required: false,
    doc: "The id of the switch, useful for API to identify the switch"
  )

  attr(:checked, :boolean,
    default: false,
    doc: "The initial checked state or the controlled checked state"
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the switch is controlled"
  )

  attr(:name, :string, doc: "The name of the switch input for form submission")

  attr(:form, :string, doc: "The form id to associate the switch with")

  attr(:aria_label, :string,
    default: "Label",
    doc: "The accessible label for the switch"
  )

  attr(:disabled, :boolean,
    default: false,
    doc: "Whether the switch is disabled"
  )

  attr(:value, :string,
    default: "true",
    doc: "The value of the switch when checked"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc:
      "The direction of the switch. When nil, derived from document (html lang + config :rtl_locales)"
  )

  attr(:orientation, :string,
    default: "horizontal",
    values: ["vertical", "horizontal"],
    doc: "Layout orientation for CSS (vertical or horizontal)"
  )

  attr(:read_only, :boolean,
    default: false,
    doc: "Whether the switch is read-only"
  )

  attr(:invalid, :boolean,
    default: false,
    doc: "Whether the switch has validation errors"
  )

  attr(:required, :boolean,
    default: false,
    doc: "Whether the switch is required"
  )

  attr(:on_checked_change, :string,
    default: nil,
    doc: "The server event name when the checked state changes"
  )

  attr(:on_checked_change_client, :string,
    default: nil,
    doc: "The client event name when the checked state changes"
  )

  attr(:errors, :list,
    default: [],
    doc: "List of error messages to display"
  )

  attr(:field, Phoenix.HTML.FormField,
    doc:
      "A form field struct retrieved from the form, for example: @form[:email]. Automatically sets id, name, checked state, and errors from the form field"
  )

  attr(:rest, :global)

  slot :label, required: false do
    attr(:class, :string, required: false)

    attr(:position, :atom,
      required: false,
      values: [:pre, :post],
      doc:
        "Place the label before (:pre) or after (:post) the control. Defaults to :post when omitted."
    )
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def switch(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> Corex.FormField.assign_form_field(field)
      |> assign(:checked, Form.normalize_value("checkbox", field.value))

    switch(assigns)
  end

  def switch(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "switch-#{System.unique_integer([:positive])}" end)
      |> assign_new(:name, fn -> "name-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:form_field, fn -> false end)
      |> assign(:checked, CheckableHelpers.normalize_checked(assigns.checked))

    ~H"""
    <div
      id={@id}
      phx-hook="Switch"
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      class={corex_style_class(assigns)}
     
      {@rest}
      {Connect.props(%Props{
        id: @id,
        controlled: @controlled,
        form_field: @form_field,
        checked: @checked,
        name: @name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        read_only: @read_only,
        invalid: @invalid,
        required: @required,
        on_checked_change: @on_checked_change,
        on_checked_change_client: @on_checked_change_client,
        label: @aria_label,
        disabled: @disabled,
        value: @value
      })}
    >
      <input type="hidden" name={@name} value="false" disabled={@disabled} />

      <label phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, checked: @checked, orientation: @orientation, read_only: @read_only})}>
        <input
          phx-mounted={Connect.ignore_hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
          {Connect.hidden_input(%HiddenInput{id: @id, name: @name, checked: @checked, disabled: @disabled, required: @required, invalid: @invalid, value: @value, controlled: @controlled})}
        />
        <span
          :for={label <- @label}
          :if={Map.get(label, :position, :post) == :pre}
          class={Map.get(label, :class, nil)}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        >
          {render_slot(@label)}
        </span>
        <span phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}>
          <span phx-mounted={Connect.ignore_thumb(%Thumb{id: @id, dir: @dir, checked: @checked, orientation: @orientation})} {Connect.thumb(%Thumb{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}></span>
        </span>
        <span
          :for={label <- @label}
          :if={Map.get(label, :position, :post) == :post}
          class={Map.get(label, :class, nil)}
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        >
          {render_slot(@label)}
        </span>
        <span
          :if={@label == [] and @aria_label}
          class="sr-only"
          phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
          {Connect.label(%Label{id: @id, dir: @dir, checked: @checked, orientation: @orientation})}
        >
          {@aria_label}
        </span>
      </label>
      <div
        :if={@error != [] and !Enum.empty?(@errors)}
        :for={msg <- @errors}
        class={Map.get(Enum.at(@error, 0), :class, nil)}
        data-scope="switch"
        data-part="error"
      >
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  api_doc(~S"""
  Set checked state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Switch.set_checked("my-switch", true)}>On</.action>
  <.switch id="my-switch" name="s" value="on">
    <:label>Notify</:label>
  </.switch>
  ```

  ```javascript
  document.getElementById("my-switch")?.dispatchEvent(
    new CustomEvent("corex:switch:set-checked", {
      bubbles: false,
      detail: { checked: true },
    })
  );
  ```
  """)

  def set_checked(switch_id, checked) when is_binary(switch_id) and is_boolean(checked) do
    JS.dispatch("corex:switch:set-checked",
      to: "##{switch_id}",
      detail: %{checked: checked},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set checked state from `handle_event`.

  ```heex
  <.action phx-click="switch_on">On</.action>
  <.switch id="my-switch" name="s" value="on">
    <:label>Notify</:label>
  </.switch>
  ```

  ```elixir
  def handle_event("switch_on", _, socket) do
    {:noreply, Corex.Switch.set_checked(socket, "my-switch", true)}
  end
  ```
  """)

  def set_checked(socket, switch_id, checked)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(switch_id) and
             is_boolean(checked) do
    LiveView.push_event(socket, "switch_set_checked", %{
      id: switch_id,
      checked: checked
    })
  end

  api_doc(~S"""
  Toggle checked state from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Switch.toggle_checked("my-switch")}>Toggle</.action>
  <.switch id="my-switch" name="s" value="on">
    <:label>Notify</:label>
  </.switch>
  ```

  ```javascript
  document.getElementById("my-switch")?.dispatchEvent(
    new CustomEvent("corex:switch:toggle-checked", { bubbles: false })
  );
  ```
  """)

  def toggle_checked(switch_id) when is_binary(switch_id) do
    JS.dispatch("corex:switch:toggle-checked",
      to: "##{switch_id}",
      bubbles: false
    )
  end

  api_doc(~S"""
  Toggle checked state from `handle_event`.

  ```heex
  <.action phx-click="flip_switch">Toggle</.action>
  <.switch id="my-switch" name="s" value="on">
    <:label>Notify</:label>
  </.switch>
  ```

  ```elixir
  def handle_event("flip_switch", _, socket) do
    {:noreply, Corex.Switch.toggle_checked(socket, "my-switch")}
  end
  ```
  """)

  def toggle_checked(socket, switch_id)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(switch_id) do
    LiveView.push_event(socket, "switch_toggle_checked", %{
      id: switch_id
    })
  end
end
