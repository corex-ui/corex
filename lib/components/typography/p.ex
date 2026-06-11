defmodule Corex.Typography.P do
  @moduledoc ~S'''
  Styled paragraph.

  ```heex
  <.p>Body copy with Corex typography tokens.</.p>
  <.p text="sm">Smaller paragraph</.p>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "p",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def p(assigns) do
    ~H"""
    <p class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
