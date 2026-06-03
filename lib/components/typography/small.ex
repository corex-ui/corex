defmodule Corex.Typography.Small do
  @moduledoc ~S'''
  Styled small print.

  ```heex
  <.small>Fine print</.small>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "small",
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
  def small(assigns) do
    ~H"""
    <small class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </small>
    """
  end
end
