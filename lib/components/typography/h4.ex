defmodule Corex.Typography.H4 do
  @moduledoc ~S'''
  Styled heading level 4.

  ```heex
  <.h4>Minor heading</.h4>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "h4",
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
  def h4(assigns) do
    ~H"""
    <h4 class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </h4>
    """
  end
end
