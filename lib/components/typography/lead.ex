defmodule Corex.Typography.Lead do
  @moduledoc ~S'''
  Display lead paragraph.

  ```heex
  <.lead>Opening line with display scale</.lead>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "lead",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      text: :text,
      semantic: :semantic,
      weight: :weight
    ]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def lead(assigns) do
    ~H"""
    <p class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
