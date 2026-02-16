defmodule Corex.Editable do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Editable](https://zagjs.com/components/react/editable).

  ## Examples

  ### Basic

  ```heex
  <.editable id="edit" value="Click to edit" class="editable">
    <:label>Name</:label>
  </.editable>
  ```

  ## Styling

  Use data attributes: `[data-scope="editable"][data-part="root"]`, `area`, `label`, `input`, `preview`, `edit-trigger`, `control`, `submit-trigger`, `cancel-trigger`.
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

  slot(:label, required: false)
  slot(:preview, required: false)
  slot(:edit_trigger, required: false)
  slot(:submit_trigger, required: false)
  slot(:cancel_trigger, required: false)

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
      <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
      {render_slot(@label)}
    </label>
        <div data-scope="editable" data-part="control">
          <div {Connect.area(%Area{id: @id, dir: @dir, empty: @empty, editing: @editing, auto_resize: true})}>
            <input type="text" {Connect.input(%Input{id: @id, disabled: @disabled, value: @value, placeholder: @placeholder, name: @name, form: @form, required: @required, read_only: @read_only, editing: @editing, aria_label: "editable input"})} />
            <span {Connect.preview(%Preview{id: @id, dir: @dir, value_text: @value_text, empty: @empty, editing: @editing})}>
              <%= if @preview != [] do %>
                {render_slot(@preview)}
              <% else %>
                {@value_text}
              <% end %>
            </span>
          </div>
          <div {Connect.triggers(%Triggers{})}>
            <button type="button" {Connect.edit_trigger(%EditTrigger{id: @id, dir: @dir, editing: @editing})}>
            <%= if @edit_trigger != [] do %>
              {render_slot(@edit_trigger)}
            <% else %>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L6.832 19.82a4.5 4.5 0 0 1-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 0 1 1.13-1.897L16.863 4.487Zm0 0L19.5 7.125" />
              </svg>
            <% end %>
            </button>
            <button type="button" {Connect.submit_trigger(%SubmitTrigger{id: @id, dir: @dir, editing: @editing})}>
              <%= if @submit_trigger != [] do %>
              {render_slot(@submit_trigger)}
            <% else %>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
              </svg>
            <% end %>
            </button>
            <button type="button" {Connect.cancel_trigger(%CancelTrigger{id: @id, dir: @dir, editing: @editing})}>
              <%= if @cancel_trigger != [] do %>
              {render_slot(@cancel_trigger)}
            <% else %>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
              </svg>
            <% end %>
          </button>
        </div>
        </div>

      </div>
    </div>
    """
  end
end
