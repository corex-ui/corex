defmodule Corex.Layout.Row do
  @moduledoc ~S'''
  A horizontal flex container (the row preset of `Corex.Layout.Stack`).

  Layout attr values are Corex design shorthand per axis (for example `justify="between"`,
  `shrink="0"`), not Tailwind classes or raw CSS. The axis vocabulary and defaults
  come from the `:row` layout recipe; see [Unstyled](unstyled.html).

  ```heex
  <.row gap="md" justify="between" width="full" grow="fill" shrink="0">
    <div>Left</div>
    <div>Right</div>
  </.row>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    kind: :layout,
    base: "row",
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
      :wrap
    ]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def row(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag tag_name={@tag} class={@design.class} {@rest}>
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
