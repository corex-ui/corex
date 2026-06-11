defmodule Corex.Typography.Kbd do
  @moduledoc ~S'''
  Styled keyboard hint.

  ```heex
  <.kbd>⌘ K</.kbd>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "kbd",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

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
