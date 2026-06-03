defmodule Corex.Typography.H3 do
  @moduledoc ~S'''
  Styled heading level 3.

  ```heex
  <.h3>Subsection</.h3>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "h3",
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
  def h3(assigns) do
    ~H"""
    <h3 class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end
end
