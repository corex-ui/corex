defmodule Corex.Editable do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Editable](https://zagjs.com/components/react/editable).

  ## Anatomy

  ### Basic

  ```heex
  <.editable value="Click to edit">
    <:label>Name</:label>
    <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
    <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
    <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
  </.editable>
  ```

  Required slots: `:label`, `:edit_trigger`, `:submit_trigger`, `:cancel_trigger`. Preview value is managed by the component and the Editable TS hook.

  ## Styling

  Style attrs and BEM classes are equivalent. See [Unstyled](unstyled.html). Axes: `semantic`, `size`, `radius`.

  <!-- tabs-open -->

  ### With attributes

  ```heex
  <.editable semantic="accent" size="md" class="editable" value="Click to edit">
    <:label>Name</:label>
    <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
    <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
    <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
  </.editable>
  ```

  ### With classes

  ```heex
  <.editable class="editable editable--accent editable--md" value="Click to edit">
    <:label>Name</:label>
    <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
    <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
    <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
  </.editable>
  ```

  <!-- tabs-close -->

  ## API

  Requires a stable `id` on `<.editable>`.

  | Function | Action | Returns |
  | -------- | ------ | ------- |
  | [`set_value/2`](#set_value/2) | Set preview value (client) | `%Phoenix.LiveView.JS{}` |
  | [`set_value/3`](#set_value/3) | Set preview value (server) | `socket` |

  ## Events

  Pick an event name and pass it to `on_*` on `<.editable>`.

  ### Server events

  | Event | When | Payload |
  | ----- | ---- | ------- |
  | `on_value_change="editable_changed"` | Value committed or cancelled | `%{"id" => id, "value" => string}` |

  <!-- tabs-open -->

  ### on_value_change

  ```heex
  <.editable
    value="Click to edit"
    on_value_change="editable_changed"
  >
    <:label>Name</:label>
    <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
    <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
    <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
  </.editable>
  ```

  ```elixir
  def handle_event("editable_changed", %{"id" => _id, "value" => value}, socket) do
    {:noreply, assign(socket, :name, value)}
  end
  ```

  <!-- tabs-close -->

  ### Client events

  | Event | When | `event.detail` |
  | ----- | ---- | -------------- |
  | `on_value_change_client="editable-changed"` | Value changes | `id`, `value` |

  ## Form

  Use `field={f[:name]}` inside `<.form>` for changeset-backed forms.

  For cross-cutting invalid styling and error presentation, see the [Forms](forms.html) guide. Pass `invalid={Corex.FormField.invalid?(@form[:name])}` when you want alert borders after validation.

  ```heex
  <.form for={@form} phx-change="validate">
    <.editable field={@form[:name]}>
      <:label>Name</:label>
      <:error :let={msg}>
        <.heroicon name="hero-exclamation-circle" />
        {msg}
      </:error>
      <:edit_trigger><.heroicon name="hero-pencil-square" /></:edit_trigger>
      <:submit_trigger><.heroicon name="hero-check" /></:submit_trigger>
      <:cancel_trigger><.heroicon name="hero-x-mark" /></:cancel_trigger>
    </.editable>
  </.form>
  ```

  ## Style

  Target parts with `data-scope` and `data-part`, or use [Corex Design](styled.html): `@import "./corex.tailwind.css"` in `app.css`.

  ```css
  [data-scope="editable"][data-part="root"] {}
  [data-scope="editable"][data-part="area"] {}
  [data-scope="editable"][data-part="label"] {}
  [data-scope="editable"][data-part="input"] {}
  [data-scope="editable"][data-part="preview"] {}
  [data-scope="editable"][data-part="edit-trigger"] {}
  [data-scope="editable"][data-part="control"] {}
  [data-scope="editable"][data-part="submit-trigger"] {}
  [data-scope="editable"][data-part="cancel-trigger"] {}
  [data-scope="editable"][data-part="error"] {}
  ```

  Stack modifiers on the host (`class` on `<.editable>`).

  <!-- tabs-open -->

  ### Color

  | Modifier | Classes |
  | -------- | ------- |
  | Default | `editable` |
  | Accent | `editable editable--accent` |
  | Brand | `editable editable--brand` |
  | Alert | `editable editable--alert` |
  | Info | `editable editable--info` |
  | Success | `editable editable--success` |

  ### Size

  | Modifier | Classes |
  | -------- | ------- |
  | SM | `editable editable--sm` |
  | MD | `editable editable--md` |
  | LG | `editable editable--lg` |
  | XL | `editable editable--xl` |

  <!-- tabs-close -->

  '''

  @doc type: :component
  use Phoenix.Component

  use Corex.Variants,
    base: "editable",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      size: :size,
      radius: :radius
    ],
    defaults: [
      width: "fit",
      max_width: "none",
      height: "auto",
      max_height: "none",
      size: "md"
    ]

  import Corex.Api.Doc

  alias Phoenix.HTML.Form
  alias Phoenix.LiveView
  alias Phoenix.LiveView.JS

  alias Corex.Editable.Anatomy.{
    Area,
    CancelTrigger,
    Control,
    EditTrigger,
    FormValue,
    Input,
    Label,
    Preview,
    Props,
    Root,
    SubmitTrigger,
    Triggers
  }

  alias Corex.Editable.Connect
  alias Corex.Editable.Translation

  attr(:id, :string, required: false, doc: "The id of the editable component")

  attr(:value, :string, default: "", doc: "Initial preview text (Zag defaultValue)")

  attr(:disabled, :boolean, default: false, doc: "Whether the editable is disabled")
  attr(:read_only, :boolean, default: false, doc: "Whether the editable is read-only")
  attr(:required, :boolean, default: false, doc: "Whether the input is required")
  attr(:invalid, :boolean, default: false, doc: "Whether the editable is in invalid state")
  attr(:name, :string, default: nil, doc: "The name attribute for form submission")
  attr(:form, :string, default: nil, doc: "The id of the form this input belongs to")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")
  attr(:orientation, :string, default: "vertical", values: ["horizontal", "vertical"])
  attr(:default_edit, :boolean, default: false, doc: "Initial edit state")
  attr(:placeholder, :string, default: nil, doc: "Placeholder text when value is empty")

  attr(:activation_mode, :string,
    default: nil,
    values: [nil, "dblclick", "focus"],
    doc: "How to activate edit mode"
  )

  attr(:select_on_focus, :boolean, default: true, doc: "Whether to select all text on focus")
  attr(:on_value_change, :string, default: nil, doc: "Server event name when value changes")

  attr(:on_value_change_client, :string,
    default: nil,
    doc: "Client event name when value changes"
  )

  attr(:translation, Corex.Editable.Translation,
    default: nil,
    doc: "Override translatable strings"
  )

  attr(:field, Phoenix.HTML.FormField,
    default: nil,
    doc: "A form field struct, e.g. f[:text] or @form[:text]"
  )

  attr(:errors, :list, default: [], doc: "List of error messages to display")

  attr(:rest, :global)

  slot :label, required: true do
    attr(:class, :string, required: false)
  end

  slot :edit_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :submit_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :cancel_trigger, required: true do
    attr(:class, :string, required: false)
  end

  slot :error, required: false do
    attr(:class, :string, required: false)
  end

  def editable(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> Corex.FormField.assign_form_field(field)
    |> assign(:value, value_to_string(Form.normalize_value("text", field.value)))
    |> editable()
  end

  def editable(assigns) do
    translation = Translation.resolve(assigns.translation)

    value_s = value_to_string(Form.normalize_value("text", assigns[:value]))
    content_value = value_s || ""

    empty = String.trim(content_value) == ""
    editing = assigns[:default_edit] || false
    value_text = if(empty, do: assigns[:placeholder] || "", else: content_value)

    assigns =
      assigns
      |> assign_new(:id, fn -> "editable-#{System.unique_integer([:positive])}" end)
      |> assign_new(:form_field, fn -> false end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:orientation, fn -> "horizontal" end)
      |> assign(:translation, translation)
      |> assign(:value, value_s)
      |> assign(:content_value, content_value)
      |> assign(:empty, empty)
      |> assign(:editing, editing)
      |> assign(:value_text, value_text)

    ~H"""
    <div
      id={@id}
      phx-hook="Editable"
      class={corex_style_class(assigns)}
     
      data-loading
      phx-mounted={Phoenix.LiveView.JS.ignore_attributes(["data-loading"])}
      {@rest}
      {Connect.props(%Props{
        id: @id,
        form_field: @form_field,
        value: @value,
        disabled: @disabled,
        read_only: @read_only,
        required: @required,
        invalid: @invalid,
        name: @name,
        form: @form,
        dir: @dir,
        orientation: @orientation,
        default_edit: @default_edit,
        placeholder: @placeholder,
        activation_mode: @activation_mode,
        select_on_focus: @select_on_focus,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <input
        :if={@name}
        phx-mounted={Connect.ignore_form_value(%FormValue{id: @id, name: @name, value: @content_value, form: @form})}
        {Connect.form_value(%FormValue{id: @id, name: @name, value: @content_value, form: @form})}
      />
      <div phx-mounted={Connect.ignore_root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})} {Connect.root(%Root{id: @id, dir: @dir, orientation: @orientation, read_only: @read_only})}>
      <label
        class={Map.get(Enum.at(@label, 0), :class, nil)}
        phx-mounted={Connect.ignore_label(%Label{id: @id, dir: @dir, orientation: @orientation})}
        {Connect.label(%Label{id: @id, dir: @dir, orientation: @orientation})}
      >
        {render_slot(@label)}
      </label>
        <div phx-mounted={Connect.ignore_control(%Control{id: @id, dir: @dir, orientation: @orientation})} {Connect.control(%Control{id: @id, dir: @dir, orientation: @orientation})}>
          <div phx-mounted={Connect.ignore_area(%Area{id: @id, dir: @dir, empty: @empty, editing: @editing, auto_resize: false, orientation: @orientation})} {Connect.area(%Area{id: @id, dir: @dir, empty: @empty, editing: @editing, auto_resize: false, orientation: @orientation})}>
            <input type="text" phx-mounted={Connect.ignore_input(%Input{id: @id, disabled: @disabled, value: @content_value, placeholder: @placeholder, name: if(@name, do: nil, else: @name), form: if(@name, do: nil, else: @form), required: @required, read_only: @read_only, editing: @editing, aria_label: @translation.input, dir: @dir, orientation: @orientation})} {Connect.input(%Input{id: @id, disabled: @disabled, value: @content_value, placeholder: @placeholder, name: if(@name, do: nil, else: @name), form: if(@name, do: nil, else: @form), required: @required, read_only: @read_only, editing: @editing, aria_label: @translation.input, dir: @dir, orientation: @orientation})} />
            <span phx-mounted={Connect.ignore_preview(%Preview{id: @id, dir: @dir, value_text: @value_text, empty: @empty, editing: @editing, aria_label: @translation.edit, orientation: @orientation})} {Connect.preview(%Preview{id: @id, dir: @dir, value_text: @value_text, empty: @empty, editing: @editing, aria_label: @translation.edit, orientation: @orientation})}>
              {@value_text}
            </span>
          </div>
          <div {Connect.triggers(%Triggers{})}>
            <button type="button" phx-mounted={Connect.ignore_edit_trigger(%EditTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.edit, orientation: @orientation})} {Connect.edit_trigger(%EditTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.edit, orientation: @orientation})}>
              {render_slot(@edit_trigger)}
            </button>
            <button type="button" phx-mounted={Connect.ignore_submit_trigger(%SubmitTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.submit, orientation: @orientation})} {Connect.submit_trigger(%SubmitTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.submit, orientation: @orientation})}>
              {render_slot(@submit_trigger)}
            </button>
            <button type="button" phx-mounted={Connect.ignore_cancel_trigger(%CancelTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.cancel, orientation: @orientation})} {Connect.cancel_trigger(%CancelTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.cancel, orientation: @orientation})}>
              {render_slot(@cancel_trigger)}
            </button>
        </div>
        </div>

      </div>
      <div :if={@error != []} :for={msg <- @errors} data-scope="editable" data-part="error">
        {render_slot(@error, msg)}
      </div>
    </div>
    """
  end

  defp value_to_string(nil), do: ""

  defp value_to_string(v), do: to_string(v)

  api_doc(~S"""
  Set the visible text value from a control (`phx-click`).

  ```heex
  <.action phx-click={Corex.Editable.set_value("my-editable", "Hello")}>Reset</.action>
  <.editable id="my-editable" class="editable" name="title" value="Hi">
    <:label>Title</:label>
    <:edit_trigger>Edit</:edit_trigger>
    <:submit_trigger>Save</:submit_trigger>
    <:cancel_trigger>Cancel</:cancel_trigger>
  </.editable>
  ```

  ```javascript
  document.getElementById("my-editable")?.dispatchEvent(
    new CustomEvent("corex:editable:set-value", {
      bubbles: false,
      detail: { value: "Hello" },
    })
  );
  ```
  """)

  def set_value(editable_id, value)
      when is_binary(editable_id) and is_binary(value) do
    JS.dispatch("corex:editable:set-value",
      to: "##{editable_id}",
      detail: %{value: value},
      bubbles: false
    )
  end

  api_doc(~S"""
  Set the value from `handle_event`.

  ```heex
  <.action phx-click="reset_title" phx-value-value="Hello">Reset</.action>
  <.editable id="my-editable" class="editable" name="title" value="Hi">
    <:label>Title</:label>
    <:edit_trigger>Edit</:edit_trigger>
    <:submit_trigger>Save</:submit_trigger>
    <:cancel_trigger>Cancel</:cancel_trigger>
  </.editable>
  ```

  ```elixir
  def handle_event("reset_title", %{"value" => v}, socket) do
    {:noreply, Corex.Editable.set_value(socket, "my-editable", v)}
  end
  ```
  """)

  def set_value(socket, editable_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(editable_id) and
             is_binary(value) do
    LiveView.push_event(socket, "editable_set_value", %{
      id: editable_id,
      value: value
    })
  end
end
