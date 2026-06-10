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

  use Corex.Variants,
    kind: :layout,
    base: "row",
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
      wrap: :wrap
    ],
    defaults: [
      padding: "none",
      padding_inline: "none",
      padding_block: "none",
      gap: "none",
      align: "center",
      justify: "start",
      width: "none",
      grow: "none",
      shrink: "none",
      wrap: "wrap"
    ]

  attr(:tag, :string, default: "div", doc: "The host HTML element.")
  slot(:inner_block, required: true)

  @doc type: :component
  def row(assigns) do
    assigns = assign(assigns, design: corex_layout_design(assigns))

    ~H"""
    <.dynamic_tag
      tag_name={@tag}
      class={@design.class}
      data-hide-below={@hide_below}
      data-hide-from={@hide_from}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.dynamic_tag>
    """
  end
end
