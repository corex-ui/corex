defmodule Corex.Layout.Container do
  @moduledoc ~S'''
  A centered, width-constrained wrapper for page content.

  ```heex
  <.container size="lg">
    <h1>FAQ</h1>
  </.container>
  ```

  The `size` vocabulary (`xs`-`4xl`) and default come from the `:container`
  layout recipe.
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    kind: :layout,
    base: "container",
    axes: [:size]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def container(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
