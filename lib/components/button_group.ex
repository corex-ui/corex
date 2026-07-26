defmodule Corex.ButtonGroup do
  @moduledoc ~S'''
  Groups related action buttons into a segmented control.

  Presentational only (no Zag machine). Put `<.action class="button">` children in the default slot.

  ## Anatomy

  ```heex
  <.button_group id="toolbar-actions" class="button-group" aria_label="Document actions">
    <.action type="button" class="button">Edit</.action>
    <.action type="button" class="button">Duplicate</.action>
    <.action type="button" class="button ui-alert">Delete</.action>
  </.button_group>
  ```

  Primary + secondary weight on children:

  ```heex
  <.button_group id="form-actions" class="button-group ui-size-sm">
    <.action type="button" class="button">Cancel</.action>
    <.action type="submit" class="button ui-accent ui-solid">Save</.action>
  </.button_group>
  ```

  ## Style

  Import tokens and `button-group.css` (via `corex.css`), then set `class="button-group"` on the host.

  Axes: **Size** (`ui-size-sm` … `ui-size-xl`), **Radius** (`ui-rounded-*`). Semantic and solid belong on child `.button` hosts, not the group. See the [modifier guide](modifiers.html).

  Editable / floating-panel action slots should use `<.action class="button …">` the same way; do not put `ui-solid` on the compound host.
  '''
  @doc type: :component
  use Phoenix.Component

  attr(:id, :string, required: true, doc: "Unique DOM id for the group.")

  attr(:aria_label, :string,
    default: nil,
    doc: "Accessible name for the group when there is no visible label."
  )

  attr(:rest, :global,
    include: ~W(class),
    doc: "HTML attributes on the group root. Include `class=\"button-group\"`."
  )

  slot(:inner_block, required: true)

  def button_group(assigns) do
    ~H"""
    <div
      id={@id}
      role="group"
      aria-label={@aria_label}
      data-scope="button-group"
      data-part="root"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
