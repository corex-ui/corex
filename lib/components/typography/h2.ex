defmodule Corex.Typography.H2 do
  @moduledoc ~S'''
  Styled heading level 2.

  ```heex
  <.h2>Section title</.h2>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "h2",
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
  def h2(assigns) do
    ~H"""
    <h2 class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end
end
