defmodule Corex.PasswordInput do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Password Input](https://zagjs.com/components/react/password-input).

  ## Examples

  ### Basic

  ```heex
  <.password_input id="pwd" class="password-input">
    <:label>Password</:label>
    <:visibility_trigger>Show</:visibility_trigger>
  </.password_input>
  ```

  ## Styling

  Use data attributes: `[data-scope="password-input"][data-part="root"]`, `label`, `control`, `input`, `visibility-trigger`, `indicator`.
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.PasswordInput.Anatomy.{Props, Root, Label, Control, Input, VisibilityTrigger, Indicator}
  alias Corex.PasswordInput.Connect

  attr(:id, :string, required: false)
  attr(:visible, :boolean, default: false)
  attr(:controlled_visible, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:invalid, :boolean, default: false)
  attr(:read_only, :boolean, default: false)
  attr(:required, :boolean, default: false)
  attr(:ignore_password_managers, :boolean, default: false)
  attr(:name, :string, default: nil)
  attr(:form, :string, default: nil)
  attr(:dir, :string, default: nil, values: [nil, "ltr", "rtl"])
  attr(:auto_complete, :string, default: "current-password", values: ["current-password", "new-password"])
  attr(:on_visibility_change, :string, default: nil)
  attr(:on_visibility_change_client, :string, default: nil)
  attr(:rest, :global)

  slot(:label, required: false)
  slot(:visibility_trigger, required: false)

  def password_input(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "password-input-#{System.unique_integer([:positive])}" end)
      |> assign_new(:dir, fn -> "ltr" end)

    ~H"""
    <div
      id={@id}
      phx-hook="PasswordInput"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        visible: @visible,
        controlled_visible: @controlled_visible,
        disabled: @disabled,
        invalid: @invalid,
        read_only: @read_only,
        required: @required,
        ignore_password_managers: @ignore_password_managers,
        name: @name,
        form: @form,
        dir: @dir,
        auto_complete: @auto_complete,
        on_visibility_change: @on_visibility_change,
        on_visibility_change_client: @on_visibility_change_client
      })}
    >
      <div phx-update="ignore" {Connect.root(%Root{id: @id, dir: @dir})}>
        <label :if={@label != []} {Connect.label(%Label{id: @id, dir: @dir})}>
          {render_slot(@label)}
        </label>
        <div {Connect.control(%Control{id: @id, dir: @dir})}>
          <input type="password" {Connect.input(%Input{id: @id, disabled: @disabled})} />
          <button :if={@visibility_trigger != []} type="button" {Connect.visibility_trigger(%VisibilityTrigger{id: @id, dir: @dir})}>
            {render_slot(@visibility_trigger)}
          </button>
          <span {Connect.indicator(%Indicator{id: @id, dir: @dir})} />
        </div>
      </div>
    </div>
    """
  end
end
