defmodule Corex.Editable do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Editable](https://zagjs.com/components/react/editable).

  ## Examples

  ### Basic

  ```heex
  <.editable id="edit" value="Click to edit" class="editable">
    <:label>Name</:label>
    <:edit_trigger><.icon name="hero-pencil-square" class="icon" /></:edit_trigger>
    <:submit_trigger><.icon name="hero-check" class="icon" /></:submit_trigger>
    <:cancel_trigger><.icon name="hero-x-mark" class="icon" /></:cancel_trigger>
  </.editable>
  ```

  Required slots: `:label`, `:edit_trigger`, `:submit_trigger`, `:cancel_trigger`. Preview value is managed by the component and the Editable TS hook.

  ## Styling

  Use data attributes to target elements:

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
  ```

  If you wish to use the default Corex styling, you can use the class `editable` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/editable.css";
  ```

  You can then use modifiers

  ```heex
  <.editable class="editable editable--accent editable--lg" value="">
    <:label>Label</:label>
    <:edit_trigger>Edit</:edit_trigger>
    <:submit_trigger>Save</:submit_trigger>
    <:cancel_trigger>Cancel</:cancel_trigger>
  </.editable>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/editable#modifiers)
  '''

  defmodule Translation do
    @moduledoc """
    Translation struct for Editable component strings.

    Without gettext: `translation={%Editable.Translation{ input: "Edit this field" }}`

    With gettext: `translation={%Editable.Translation{ input: gettext("editable input") }}`
    """
    defstruct [:input, :edit, :submit, :cancel]
  end

  @doc type: :component
  use Phoenix.Component

  import Corex.Gettext, only: [gettext: 1]

  alias Corex.Editable.Anatomy.{
    Area,
    CancelTrigger,
    EditTrigger,
    Input,
    Label,
    Preview,
    Props,
    Root,
    SubmitTrigger,
    Triggers
  }

  alias Corex.Editable.Connect

  attr(:id, :string, required: false, doc: "The id of the editable component")
  attr(:value, :string, default: "", doc: "The current or initial value")
  attr(:controlled, :boolean, default: false, doc: "Whether the value is controlled externally")
  attr(:disabled, :boolean, default: false, doc: "Whether the editable is disabled")
  attr(:read_only, :boolean, default: false, doc: "Whether the editable is read-only")
  attr(:required, :boolean, default: false, doc: "Whether the input is required")
  attr(:invalid, :boolean, default: false, doc: "Whether the editable is in invalid state")
  attr(:name, :string, default: nil, doc: "The name attribute for form submission")
  attr(:form, :string, default: nil, doc: "The id of the form this input belongs to")
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"], doc: "Text direction")
  attr(:edit, :boolean, default: false, doc: "Controlled edit state when controlled_edit is true")

  attr(:controlled_edit, :boolean,
    default: false,
    doc: "Whether edit state is controlled externally"
  )

  attr(:default_edit, :boolean, default: false, doc: "Initial edit state when uncontrolled")
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

  def editable(assigns) do
    empty = String.trim(assigns[:value] || "") == ""
    editing = assigns[:default_edit] || false
    value_text = if(empty, do: assigns[:placeholder] || "", else: assigns[:value] || "")

    default_translation = %Translation{
      input: gettext("editable input"),
      edit: gettext("edit"),
      submit: gettext("submit"),
      cancel: gettext("cancel")
    }

    assigns =
      assigns
      |> assign_new(:id, fn -> "editable-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
      |> assign_new(:translation, fn -> default_translation end)
      |> assign(:translation, merge_translation(assigns.translation, default_translation))
      |> assign(:empty, empty)
      |> assign(:editing, editing)
      |> assign(:value_text, value_text)

    ~H"""
    <div
      id={@id}
      phx-hook="Editable"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        value: @value,
        controlled: @controlled,
        disabled: @disabled,
        read_only: @read_only,
        required: @required,
        invalid: @invalid,
        name: @name,
        form: @form,
        dir: @dir,
        edit: @edit,
        controlled_edit: @controlled_edit,
        default_edit: @default_edit,
        placeholder: @placeholder,
        activation_mode: @activation_mode,
        select_on_focus: @select_on_focus,
        on_value_change: @on_value_change,
        on_value_change_client: @on_value_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
      <label {Connect.label(%Label{id: @id, dir: @dir})}>
        {render_slot(@label)}
      </label>
        <div data-scope="editable" data-part="control">
          <div {Connect.area(%Area{id: @id, dir: @dir, empty: @empty, editing: @editing, auto_resize: false})}>
            <input type="text" {Connect.input(%Input{id: @id, disabled: @disabled, value: @value, placeholder: @placeholder, name: @name, form: @form, required: @required, read_only: @read_only, editing: @editing, aria_label: @translation.input})} />
            <span {Connect.preview(%Preview{id: @id, dir: @dir, value_text: @value_text, empty: @empty, editing: @editing, aria_label: @translation.edit})}>
              {@value_text}
            </span>
          </div>
          <div {Connect.triggers(%Triggers{})}>
            <button type="button" {Connect.edit_trigger(%EditTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.edit})}>
              {render_slot(@edit_trigger)}
            </button>
            <button type="button" {Connect.submit_trigger(%SubmitTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.submit})}>
              {render_slot(@submit_trigger)}
            </button>
            <button type="button" {Connect.cancel_trigger(%CancelTrigger{id: @id, dir: @dir, editing: @editing, aria_label: @translation.cancel})}>
              {render_slot(@cancel_trigger)}
            </button>
        </div>
        </div>

      </div>
    </div>
    """
  end

  defp merge_translation(nil, default), do: default

  defp merge_translation(partial, default) do
    %Translation{
      input: partial.input || default.input,
      edit: partial.edit || default.edit,
      submit: partial.submit || default.submit,
      cancel: partial.cancel || default.cancel
    }
  end
end
