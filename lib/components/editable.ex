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

  @doc type: :component
  use Phoenix.Component

  alias Corex.Editable.Anatomy.{
    Props,
    Root,
    Area,
    Label,
    Input,
    Preview,
    EditTrigger,
    Triggers,
    SubmitTrigger,
    CancelTrigger
  }

  alias Corex.Editable.Connect

  attr(:id, :string, required: false)
  attr(:value, :string, default: "")
  attr(:controlled, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:edit, :boolean, default: false)
  attr(:controlled_edit, :boolean, default: false)
  attr(:default_edit, :boolean, default: false)
  attr(:placeholder, :string, default: nil)
  attr(:activation_mode, :string, default: nil, values: [nil, "dblclick", "focus"])
  attr(:select_on_focus, :boolean, default: true)
  attr(:on_value_change, :string, default: nil)
  attr(:on_value_change_client, :string, default: nil)
  attr(:rest, :global)

  slot(:label, required: true)
  slot(:edit_trigger, required: true)
  slot(:submit_trigger, required: true)
  slot(:cancel_trigger, required: true)

  def editable(assigns) do
    empty = String.trim(assigns[:value] || "") == ""
    editing = assigns[:default_edit] || false
    value_text = if(empty, do: assigns[:placeholder] || "", else: assigns[:value] || "")

    assigns =
      assigns
      |> assign_new(:id, fn -> "editable-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)
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
          <div {Connect.area(%Area{id: @id, dir: @dir, empty: @empty, editing: @editing, auto_resize: true})}>
            <input type="text" {Connect.input(%Input{id: @id, disabled: @disabled, value: @value, placeholder: @placeholder, name: @name, form: @form, required: @required, read_only: @read_only, editing: @editing, aria_label: "editable input"})} />
            <span {Connect.preview(%Preview{id: @id, dir: @dir, value_text: @value_text, empty: @empty, editing: @editing})}>
              {@value_text}
            </span>
          </div>
          <div {Connect.triggers(%Triggers{})}>
            <button type="button" {Connect.edit_trigger(%EditTrigger{id: @id, dir: @dir, editing: @editing})}>
              {render_slot(@edit_trigger)}
            </button>
            <button type="button" {Connect.submit_trigger(%SubmitTrigger{id: @id, dir: @dir, editing: @editing})}>
              {render_slot(@submit_trigger)}
            </button>
            <button type="button" {Connect.cancel_trigger(%CancelTrigger{id: @id, dir: @dir, editing: @editing})}>
              {render_slot(@cancel_trigger)}
            </button>
        </div>
        </div>

      </div>
    </div>
    """
  end
end
