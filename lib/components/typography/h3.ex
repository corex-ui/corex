defmodule Corex.Typography.H3 do
  @moduledoc ~S'''
  Styled heading level 3.

  ```heex
  <.h3>Subsection</.h3>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "h3",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def h3(assigns) do
    ~H"""
    <h3 class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end
end
