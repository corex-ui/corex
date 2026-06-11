defmodule Corex.Typography.H1 do
  @moduledoc ~S'''
  Styled heading level 1.

  ```heex
  <.h1>Page title</.h1>
  <.h1 semantic="accent" text="3xl">Hero title</.h1>
  ```
  '''
  use Phoenix.Component

  use Corex.Bem.Variants,
    base: "h1",
    axes: [:width, :max_width, :height, :max_height, :text, :semantic, :weight]

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @doc type: :component
  def h1(assigns) do
    ~H"""
    <h1 class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </h1>
    """
  end
end
