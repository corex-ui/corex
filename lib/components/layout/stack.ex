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

  use Corex.Variants,
    kind: :layout,
    base: "stack",
    axes: [
      padding: :space,
      padding_inline: :space,
      padding_block: :space,
      gap: :space,
      align: :align,
      justify: :justify,
      width: [:none, :full],
      min_height: :min_height,
      grow: :grow,
      shrink: :shrink,
      direction: :direction,
      variant: [:none, :layer],
      radius: [:none, :sm, :md, :lg, :xl, :"2xl", :full]
    ],
    defaults: [
      padding: "none",
      padding_inline: "none",
      padding_block: "none",
      gap: "none",
      align: "stretch",
      justify: "start",
      width: "none",
      grow: "none",
      shrink: "none",
      direction: "column",
      variant: "none",
      radius: "none"
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
