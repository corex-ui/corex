defmodule Corex.Typography.ListBox do
  @moduledoc ~S'''
  Styled list container (table-like rows).

  ```heex
  <.list>
    <li>One</li>
    <li>Two</li>
  </.list>
  ```
  '''
  use Phoenix.Component

  use Corex.Variants,
    base: "list",
    axes: [
      width: :width,
      max_width: :max_width,
      height: :height,
      max_height: :max_height,
      text: :text,
      semantic: :semantic
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
  def list(assigns) do
    ~H"""
    <ul class={corex_style_class(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end
end
