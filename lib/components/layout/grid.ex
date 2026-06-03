defmodule Corex.Layout.Grid do
  @moduledoc ~S'''
  A CSS grid container with a fixed column count and token-based gap.

  ```heex
  <.grid columns="3" gap="lg">
    <div>1</div>
    <div>2</div>
    <div>3</div>
  </.grid>
  ```

  The axis vocabulary (`columns` `1`-`6`, `gap`) and defaults come from the
  `:grid` layout recipe.
  '''
  use Phoenix.Component

  use Corex.Variants,
    kind: :layout,
    base: "grid",
    axes: [gap: :space, columns: :columns],
    defaults: [gap: "none"]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def grid(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
