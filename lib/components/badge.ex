defmodule Corex.Badge do
  @moduledoc ~S'''
  Compact label for tags, status, and counts.

  ```heex
  <.badge semantic="accent" size="sm">New</.badge>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "badge",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      semantic: :semantic,
      size: :size,
      shape: :shape
    ]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def badge(assigns) do
    ~H"""
    <span class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
