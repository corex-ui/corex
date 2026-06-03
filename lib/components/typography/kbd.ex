defmodule Corex.Typography.Kbd do
  @moduledoc ~S'''
  Styled keyboard hint.

  ```heex
  <.kbd>⌘ K</.kbd>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "kbd",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      text: :text,
      semantic: :semantic,
      weight: :weight
    ],
    defaults: [
      width: "fit",
      max_width: "none",
      height: "auto",
      max_height: "none"
    ]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def kbd(assigns) do
    ~H"""
    <kbd class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </kbd>
    """
  end
end
