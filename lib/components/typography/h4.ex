defmodule Corex.Typography.H4 do
  @moduledoc ~S'''
  Styled heading level 4.

  ```heex
  <.h4>Minor heading</.h4>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "h4",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

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
