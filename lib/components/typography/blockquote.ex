defmodule Corex.Typography.Blockquote do
  @moduledoc ~S'''
  Styled block quotation.

  ```heex
  <.blockquote>A short quote</.blockquote>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "blockquote",
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
  def blockquote(assigns) do
    ~H"""
    <blockquote class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </blockquote>
    """
  end
end
