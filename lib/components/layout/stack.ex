defmodule Corex.Layout.Stack do
  @moduledoc ~S'''
  A flex container that stacks children in a single direction (column by default).

  Layout attr values are Corex design shorthand per axis (for example `gap="md"`,
  `shrink="0"`), not Tailwind classes or raw CSS. The axis vocabulary and defaults
  come from the `:stack` layout recipe; see [Unstyled](unstyled.html).

  ```heex
  <.stack gap="lg" align="center">
    <div>One</div>
    <div>Two</div>
  </.stack>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    kind: :layout,
    base: "stack",
    axes: [
      :padding,
      :padding_inline,
      :padding_block,
      :gap,
      :align,
      :justify,
      :width,
      :min_height,
      :grow,
      :shrink,
      :direction,
      :variant,
      :radius
    ]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def stack(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
