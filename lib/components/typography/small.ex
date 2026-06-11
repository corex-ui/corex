defmodule Corex.Typography.Small do
  @moduledoc ~S'''
  Styled small print.

  ```heex
  <.small>Fine print</.small>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "small",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def small(assigns) do
    ~H"""
    <small class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </small>
    """
  end
end
