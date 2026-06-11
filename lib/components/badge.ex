defmodule Corex.Badge do
  @moduledoc ~S'''
  Compact label for tags, status, and counts.

  ```heex
  <.badge semantic="accent" size="sm">New</.badge>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "badge",
    axes: [:width, :max_width, :height, :max_height, :semantic, :size, :shape]

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
