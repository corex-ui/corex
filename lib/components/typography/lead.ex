defmodule Corex.Typography.Lead do
  @moduledoc ~S'''
  Display lead paragraph.

  ```heex
  <.lead>Opening line with display scale</.lead>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "lead",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

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
