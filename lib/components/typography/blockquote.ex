defmodule Corex.Typography.Blockquote do
  @moduledoc ~S'''
  Styled block quotation.

  ```heex
  <.blockquote>A short quote</.blockquote>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "blockquote",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def blockquote(assigns) do
    ~H"""
    <blockquote class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </blockquote>
    """
  end
end
